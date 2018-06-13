unit MSDOMView1;

{
  A generic viewer for XML documents.
  Based on DOM interfaces using Microsoft XML parser.
  Requires MSXML v3/v4 package from Microsoft.

  Copyright © Keith Wood (kbwood@iprimus.com.au)
  Written 22 February, 2000.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, Grids,
{$IFDEF VER120}  { Delphi 4 }
  ImgList,
{$ENDIF}
  ActiveX, MSXML2_tlb;

type
  TfrmXMLViewer = class(TForm)
    pgcMain: TPageControl;
      tshStructure: TTabSheet;
        trvXML: TTreeView;
        pgcDetails: TPageControl;
          tshDocument: TTabSheet;
            Label1: TLabel;
            edtDocType: TEdit;
            cbxStandAlone: TCheckBox;
            Label2: TLabel;
            edtPublicId: TEdit;
            Label3: TLabel;
            edtSystemId: TEdit;
            Label4: TLabel;
            edtVersion: TEdit;
            Label5: TLabel;
            edtEncoding: TEdit;
            Label6: TLabel;
            stgEntities: TStringGrid;
            Label7: TLabel;
            stgNotations: TStringGrid;
          tshElement: TTabSheet;
            pnlNames: TPanel;
              Label8: TLabel;
              edtURI: TEdit;
              Label9: TLabel;
              edtLocalName: TEdit;
            stgAttributes: TStringGrid;
          tshText: TTabSheet;
            lblNodeType: TLabel;
            memText: TMemo;
      tshSource: TTabSheet;
        memSource: TRichEdit;
    mnuMain: TMainMenu;
      mniFile: TMenuItem;
        mniOpen: TMenuItem;
        mniSep1: TMenuItem;
        mniPreserveWhitespace: TMenuItem;
        mniResolveExternals: TMenuItem;
        mniValidateOnParse: TMenuItem;
        mniSep2: TMenuItem;
        mniExit: TMenuItem;
      mniView: TMenuItem;
        mniExpandAll: TMenuItem;
        mniCollapseAll: TMenuItem;
        mniSep3: TMenuItem;
        mniViewSource: TMenuItem;
    imlXML: TImageList;
    dlgOpen: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniOpenClick(Sender: TObject);
    procedure mniPreserveWhitespaceClick(Sender: TObject);
    procedure mniResolveExternalsClick(Sender: TObject);
    procedure mniValidateOnParseClick(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure mniExpandAllClick(Sender: TObject);
    procedure mniCollapseAllClick(Sender: TObject);
    procedure mniViewSourceClick(Sender: TObject);
    procedure trvXMLChange(Sender: TObject; Node: TTreeNode);
  private
    FList: TList;
    procedure ClearTree;
    procedure LoadDoc(const Filename: string);
  public
  end;

var
  frmXMLViewer: TfrmXMLViewer;

implementation

{$R *.DFM}

resourcestring
  AttributeDesc   = 'Attribute';
  CommentDesc     = 'Comment';
  DTDDesc         = 'DTD';
  EncodingAttr    = 'encoding';
  EntityRefDesc   = 'Entity Reference';
  InstructionDesc = 'Processing Instruction';
  NameDesc        = 'Name';
  NoDOMError      = 'Couldn''t create the DOM';
  NoLoadError     = 'Couldn''t load the document:'#13 +
                    'Line: %d  Column: %d'#13 +
                    '%s';
  NotationDesc    = 'Notation';
  PublicDesc      = 'Public Id';
  StandAloneAttr  = 'standalone';
  SystemDesc      = 'System Id';
  TextDesc        = 'Text/CDATA Section';
  ValueDesc       = 'Value';
  VersionAttr     = 'version';
  XMLValue        = 'XML';
  XMLDocDesc      = 'XML Document';
  YesValue        = 'YES';

type
  { XML node types }
  TNodeType = (ntDocument, ntElement, ntComment, ntInstruction,
    ntText, ntCData, ntEntityRef);

{ TNodeInfo -------------------------------------------------------------------}

  { XML Node

    Elements have a name and/or a value depending on their type.
    Attributes are name=value pairs in a string list.
  }
  TNodeInfo = class(TObject)
  private
    FAttributes: TStringList;
    FLocalName: string;
    FName: string;
    FNamespaceURI: string;
    FNodeType: TNodeType;
    FValue: string;
  public
    constructor Create(NodeType: TNodeType;
      const Name, NamespaceURI, LocalName, Value: string; Attributes: TStrings);
    destructor Destroy; override;
    property Attributes: TStringList read FAttributes write FAttributes;
    property LocalName: string read FLocalName write FLocalName;
    property Name: string read FName write FName;
    property NamespaceURI: string read FNamespaceURI write FNamespaceURI;
    property NodeType: TNodeType read FNodeType write FNodeType;
    property Value: string read FValue write FValue;
  end;

{ Initialisation }
constructor TNodeInfo.Create(NodeType: TNodeType;
  const Name, NamespaceURI, LocalName, Value: string; Attributes: TStrings);
begin
  inherited Create;
  FLocalName    := LocalName;
  FName         := Name;
  FNamespaceURI := NamespaceURI;
  FNodeType     := NodeType;
  FValue        := Value;
  FAttributes   := TStringList.Create;
  if Assigned(Attributes) then
    FAttributes.Assign(Attributes);
end;

{Release resources }
destructor TNodeInfo.Destroy;
begin
  Attributes.Free;
  inherited Destroy;
end;

{ TfrmXMLViewer ---------------------------------------------------------------}

{ Initialisation - try to load an XML document on start up }
procedure TfrmXMLViewer.FormCreate(Sender: TObject);
begin
  FList              := TList.Create;
  dlgOpen.InitialDir := ExtractFilePath(Application.ExeName);
  with stgEntities do
  begin
    Cells[0, 0] := NameDesc;
    Cells[1, 0] := PublicDesc;
    Cells[2, 0] := SystemDesc;
    Cells[3, 0] := NotationDesc;
  end;
  with stgNotations do
  begin
    Cells[0, 0] := NameDesc;
    Cells[1, 0] := PublicDesc;
    Cells[2, 0] := SystemDesc;
  end;
  with stgAttributes do
  begin
    Cells[0, 0] := AttributeDesc;
    Cells[1, 0] := ValueDesc;
  end;
  if ParamStr(1) <> '' then
    LoadDoc(ParamStr(1));
end;

{ Release resources }
procedure TfrmXMLViewer.FormDestroy(Sender: TObject);
begin
  ClearTree;
  FList.Free;
end;

{ Release resources }
procedure TfrmXMLViewer.ClearTree;
var
  Index: Integer;
begin
  for Index := 0 to FList.Count - 1 do
    TNodeInfo(FList[Index]).Free;
  FList.Clear;
  trvXML.OnChange := nil;
  trvXML.Items.Clear;
  trvXML.OnChange := trvXMLChange;
end;

{ Load an XML document }
procedure TfrmXMLViewer.LoadDoc(const Filename: string);
var
  XMLDoc: IXMLDOMDocument;

  { Initialise document-wide details for display }
  procedure InitDocumentDetails;
  begin
    { Clear entries }
    edtDocType.Text       := '';
    edtPublicId.Text      := '';
    edtSystemId.Text      := '';
    edtVersion.Text       := '';
    edtEncoding.Text      := '';
    cbxStandAlone.Checked := False;
    with stgEntities do
    begin
      RowCount := 2;
      Rows[1].Clear;
    end;
    with stgNotations do
    begin
      RowCount := 2;
      Rows[1].Clear;
    end;
    ClearTree;
  end;

  { Add a TNodeInfo to the tree view }
  function AddNodeInfo(Parent: TTreeNode; const Name: string;
    NodeInfo: TNodeInfo): TTreeNode;
  begin
    FList.Add(NodeInfo);
    Result := trvXML.Items.AddChildObject(Parent, Name, NodeInfo);
    with Result do
    begin
      ImageIndex    := Ord(NodeInfo.NodeType);
      SelectedIndex := ImageIndex;
    end;
  end;

  { Add current node to the treeview and then recurse through children }
  procedure AddNodeToTree(Node: IXMLDOMNode; TreeParent: TTreeNode);
  var
    Index: Integer;
    DisplayName: string;
    NewNode: TTreeNode;
    Attribs: TStringList;
    Attrib: IXMLDOMAttribute;
  begin
    { Generate name for display in the tree }
    if Node.nodeType in [NODE_TEXT, NODE_COMMENT, NODE_CDATA_SECTION] then
    begin
      if Length(Node.nodeValue) > 20 then
        DisplayName := Copy(Node.nodeValue, 1, 17) + '...'
      else
        DisplayName := Node.nodeValue;
    end
    else
      DisplayName := Node.nodeName;
    { Create storage for later display of node values }
    case Node.NodeType of
      NODE_ELEMENT:
        begin
          Attribs := TStringList.Create;
          try
            for Index := 0 to Node.attributes.length - 1 do
              with Node.attributes[Index] do
                Attribs.Values[nodeName] := nodeValue;
            NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(ntElement,
              Node.nodeName, Node.namespaceURI, Node.baseName, '', Attribs));
          finally
            Attribs.Free;
          end;
        end;
      NODE_TEXT:
        with Node as IXMLDOMText do
          NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(
            ntText, '', '', '', data, nil));
      NODE_CDATA_SECTION:
        with Node as IXMLDOMCDATASection do
          NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(
            ntCData, '', '', '', data, nil));
      NODE_ENTITY_REFERENCE:
        NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(
          ntEntityRef, Node.nodeName, '', '', '', nil));
      NODE_PROCESSING_INSTRUCTION:
        with Node as IXMLDOMProcessingInstruction do
        begin
          NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(
            ntInstruction, target, '', '', data, nil));
          if UpperCase(target) = XMLValue then
          begin
            { Special handling for the XML declaration }
            edtVersion.Text :=
              Node.attributes.getNamedItem(VersionAttr).nodeValue;
            Attrib :=
              Node.attributes.getNamedItem(EncodingAttr) as IXMLDOMAttribute;
            if Assigned(Attrib) then
              edtEncoding.Text := Attrib.nodeValue;
            Attrib :=
              Node.attributes.getNamedItem(StandAloneAttr) as IXMLDOMAttribute;
            if Assigned(Attrib) then
              cbxStandAlone.Checked := (UpperCase(Attrib.nodeValue) = YesValue);
            Attrib := nil;
          end;
        end;
      NODE_COMMENT:
        with Node as IXMLDOMComment do
          NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(
            ntComment, '', '', '', data, nil));
      NODE_DOCUMENT:
        NewNode := AddNodeInfo(TreeParent, XMLDocDesc, TNodeInfo.Create(
          ntDocument, XMLDocDesc, '', '', '', nil));
      NODE_DOCUMENT_TYPE:
        with Node as IXMLDOMDocumentType do
        begin
          edtDocType.Text := name;
          NewNode := AddNodeInfo(TreeParent, DTDDesc, TNodeInfo.Create(
            ntEntityRef, DTDDesc, '', '', '', nil));
        end;
      NODE_ENTITY:
        with (Node as IXMLDOMEntity), stgEntities do
          if notationName <> '' then
          begin
            { Unparsed entity }
            if Cells[0, RowCount - 1] <> '' then
              RowCount := RowCount + 1;
            Cells[0, RowCount - 1] := nodeName;
            Cells[1, RowCount - 1] := publicId;
            Cells[2, RowCount - 1] := systemId;
            Cells[3, RowCount - 1] := notationName;
          end
          else
            { Parsed entity }
            NewNode := AddNodeInfo(TreeParent, DisplayName, TNodeInfo.Create(
              ntEntityRef, nodeName, '', '', '', nil));
      NODE_NOTATION:
        with (Node as IXMLDOMNotation), stgNotations do
        begin
          if Cells[0, RowCount - 1] <> '' then
            RowCount := RowCount + 1;
          Cells[0, RowCount - 1] := nodeName;
          Cells[1, RowCount - 1] := publicId;
          Cells[2, RowCount - 1] := systemId;
        end;
    end;
    { And recurse through any children }
    if Node.hasChildNodes then
      for Index := 0 to Node.childNodes.length - 1 do
        AddNodeToTree(Node.childNodes[Index], NewNode);
  end;

begin
  Screen.Cursor := crHourGlass;
  try
    pgcDetails.ActivePage := tshDocument;
    { Initialise document-wide details for display }
    InitDocumentDetails;
    { Load the source document }
    memSource.Lines.LoadFromFile(Filename);
    dlgOpen.Filename := Filename;
    { Instantiate the DOM }
    XMLDoc := CoDOMDocument.Create;
    trvXML.Items.BeginUpdate;
    try
      { Parse the document }
      XMLDoc.preserveWhiteSpace := mniPreserveWhitespace.Checked;
      XMLDoc.resolveExternals   := mniResolveExternals.Checked;
      XMLDoc.validateOnParse    := mniValidateOnParse.Checked;
      if not XMLDoc.load(Filename) then
        raise Exception.Create(Format(NoLoadError, [XMLDoc.parseError.line,
          XMLDoc.parseError.linePos, XMLDoc.parseError.reason]));
      edtSystemId.Text := XMLDoc.url;

      { Add the structure to the tree view }
      AddNodeToTree(XMLDoc, nil);
      { Release the DOM }
      XMLDoc := nil;
      trvXML.Items[0].Expand(False);
    finally
      trvXML.Items.EndUpdate;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ Select a file to open }
procedure TfrmXMLViewer.mniOpenClick(Sender: TObject);
begin
  with dlgOpen do
    if Execute then
      LoadDoc(Filename);
end;

{ Toggle parser property }
procedure TfrmXMLViewer.mniPreserveWhitespaceClick(Sender: TObject);
begin
  mniPreserveWhitespace.Checked := not mniPreserveWhitespace.Checked;
end;

{ Toggle parser property }
procedure TfrmXMLViewer.mniResolveExternalsClick(Sender: TObject);
begin
  mniResolveExternals.Checked := not mniResolveExternals.Checked;
end;

{ Toggle parser property }
procedure TfrmXMLViewer.mniValidateOnParseClick(Sender: TObject);
begin
  mniValidateOnParse.Checked := not mniValidateOnParse.Checked;
end;

{ Exit the application }
procedure TfrmXMLViewer.mniExitClick(Sender: TObject);
begin
  Close;
end;

{ Expand all nodes below the current one }
procedure TfrmXMLViewer.mniExpandAllClick(Sender: TObject);
begin
  if Assigned(trvXML.Selected) then
    trvXML.Selected.Expand(True);
end;

{ Collapse all nodes below the current one }
procedure TfrmXMLViewer.mniCollapseAllClick(Sender: TObject);
begin
  if Assigned(trvXML.Selected) then
    trvXML.Selected.Collapse(True);
end;

{ Toggle between structure and source }
procedure TfrmXMLViewer.mniViewSourceClick(Sender: TObject);
begin
  mniViewSource.Checked := not mniViewSource.Checked;
  if mniViewSource.Checked then
    pgcMain.ActivePage := tshSource
  else
    pgcMain.ActivePage := tshStructure;
end;

{ Display details for the selected XML element }
procedure TfrmXMLViewer.trvXMLChange(Sender: TObject; Node: TTreeNode);
var
  Index: Integer;
begin
  with TNodeInfo(trvXML.Selected.Data) do
    case NodeType of
      ntDocument:
        { Show document details, including entities and notations }
        pgcDetails.ActivePage := tshDocument;
      ntElement:
        begin
          { Show element details, including attributes }
          pgcDetails.ActivePage := tshElement;
          edtURI.Text           := NamespaceURI;
          edtLocalName.Text     := LocalName;
          with stgAttributes do
          begin
            if Attributes.Count = 0 then
              RowCount := 2
            else
              RowCount := Attributes.Count + 1;
            Rows[1].Clear;
            for Index := 0 to Attributes.Count - 1 do
            begin
              Cells[0, Index + 1] := Attributes.Names[Index];
              Cells[1, Index + 1] := Attributes.Values[Attributes.Names[Index]];
            end;
          end;
        end;
      else
        begin
          { Show details for other nodes - text type }
          pgcDetails.ActivePage := tshText;
          memText.Lines.Text    := Value;
          case NodeType of
            ntComment:     lblNodeType.Caption := CommentDesc;
            ntInstruction: lblNodeType.Caption := InstructionDesc;
            ntEntityRef:   lblNodeType.Caption := EntityRefDesc;
            else           lblNodeType.Caption := TextDesc;
          end;
        end;
    end;
end;

initialization
  CoInitialize(nil);
finalization
  CoUninitialize;
end.

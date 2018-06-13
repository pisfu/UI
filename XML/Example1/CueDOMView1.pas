unit CueDOMView1;

{
  A generic viewer for XML documents.
  Based on DOM interfaces using CUESoft's XML object model.
  Requires CUEXml v2 package from CUESoft.

  Copyright © Keith Wood (kbwood@iprimus.com.au)
  Written 24 September, 2000.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, Grids,
{$IFDEF VER120}  { Delphi 4 }
  ImgList,
{$ENDIF}
  XmlObjModel;

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
        mniSuppressWhitespace: TMenuItem;
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
    procedure mniSuppressWhitespaceClick(Sender: TObject);
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
  NoLoadError     = 'Couldn''t load the document:'#13 +
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
  TNodeType = (xtDocument, xtElement, xtComment, xtInstruction,
    xtText, xtCData, xtEntityRef);

{ TNode -----------------------------------------------------------------------}

  { XML Node

    Elements have a name and/or a value depending on their type.
    Attributes are name=value pairs in a string list.
  }
  TNode = class(TObject)
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
constructor TNode.Create(NOdeType: TNodeType;
  const Name, NamespaceURI, LocalName, Value: string; Attributes: TStrings);
begin
  inherited Create;
  FNodeType     := NodeType;
  FLocalName    := LocalName;
  FName         := Name;
  FNamespaceURI := NamespaceURI;
  FValue        := Value;
  FAttributes   := TStringList.Create;
  if Assigned(Attributes) then
    FAttributes.Assign(Attributes);
end;

{Release resources }
destructor TNode.Destroy;
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
    TNode(FList[Index]).Free;
  FList.Clear;
  trvXML.OnChange := nil;
  trvXML.Items.Clear;
  trvXML.OnChange := trvXMLChange;
end;

{ Load an XML document }
procedure TfrmXMLViewer.LoadDoc(const Filename: string);
var
  XMLDOM: TXmlObjModel;

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

  { Add a TNode to the tree view }
  function AddElement(Parent: TTreeNode; Name: string;
    Node: TNode): TTreeNode;
  begin
    FList.Add(Node);
    Result := trvXML.Items.AddChildObject(Parent, Name, Node);
    with Result do
    begin
      ImageIndex    := Ord(Node.NodeType);
      SelectedIndex := ImageIndex;
    end;
  end;

  { Add current element to the treeview and then recurse through children }
  procedure AddElementToTree(Node: TXmlNode; TreeParent: TTreeNode);
  var
    Index: Integer;
    DisplayName: string;
    NewNode: TTreeNode;
    Attribs: TStringList;

    { Extract an attribute value from a string }
    function GetPseudoAttr(const Name, Data: string): string;
    var
      PosStart, PosEnd: Integer;
    begin
      Result   := '';
      PosStart := Pos(Name, Data);
      if PosStart = 0 then
        Exit;

      PosStart := PosStart + Length(Name) + 1;
      PosEnd   := Pos(Data[PosStart], Copy(Data, PosStart + 1, Length(Data)));
      if PosEnd = 0 then
        Result := ''
      else
        Result := Copy(Data, PosStart + 1, PosEnd - 1);
    end;

  begin
    { Generate name for display in the tree }
    if Node.NodeType in [TEXT_NODE, COMMENT_NODE, CDATA_SECTION_NODE] then
    begin
      DisplayName := Copy(Node.NodeValue, 1, 20);
      if Length(Node.NodeValue) > 20 then
        DisplayName := Copy(DisplayName, 1, 17) + '...';
    end
    else
      DisplayName := Node.NodeName;
    { Create storage for later display of node values }
    case Node.NodeType of
      ELEMENT_NODE:
        with Node as XmlObjModel.TXmlElement do
        begin
          Attribs := TStringList.Create;
          try
            if HasAttributes then
              for Index := 0 to Attributes.Length - 1 do
                with Attributes.Item(Index) do
                  Attribs.Values[NodeName] := NodeValue;
            NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
              xtElement, NodeName, Namespace, BaseName, '', Attribs));
          finally
            Attribs.Free;
          end;
        end;
      TEXT_NODE:
        with Node as TXmlText do
          NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
            xtText, '', '', '', Data, nil));
      CDATA_SECTION_NODE:
        with Node as TXmlCDATASection do
          NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
            xtCData, '', '', '', Data, nil));
      ENTITY_REFERENCE_NODE:
        NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
          xtEntityRef, Node.NodeName, '', '', '', nil));
      PROCESSING_INSTRUCTION_NODE:
        with Node as TXmlProcessingInstruction do
        begin
          NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
            xtInstruction, Target, '', '', Data, nil));
          if UpperCase(Target) = XMLValue then
          begin
            { Special handling for the XML declaration }
            edtVersion.Text       := GetPseudoAttr(VersionAttr, Data);
            edtEncoding.Text      := GetPseudoAttr(EncodingAttr, Data);
            cbxStandAlone.Checked :=
              (UpperCase(GetPseudoAttr(StandAloneAttr, Data)) = YesValue);
          end;
        end;
      COMMENT_NODE:
        with Node as TXmlComment do
          NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
            xtComment, '', '', '', Data, nil));
      DOCUMENT_NODE:
        with Node as TXmlDocument do
        begin
          NewNode := AddElement(TreeParent, XMLDocDesc, TNode.Create(
            xtDocument, XMLDocDesc, '', '', '', nil));
          if Assigned(DocType) then
            AddElementToTree(DocType, NewNode);
        end;
      DOCUMENT_TYPE_NODE:
        with Node as TXmlDocumentType do
        begin
          edtDocType.Text := Name;
          NewNode := AddElement(TreeParent, DTDDesc, TNode.Create(
            xtEntityRef, DTDDesc, '', '', '', nil));
          for Index := 0 to Entities.Length - 1 do
            AddElementToTree(Entities.Item(Index), NewNode);
          for Index := 0 to Notations.Length - 1 do
            AddElementToTree(Notations.Item(Index), NewNode);
        end;
      ENTITY_NODE:
        with (Node as TXmlEntity), stgEntities do
          if NotationName <> '' then
          begin
            { Unparsed entity }
            if Cells[0, RowCount - 1] <> '' then
              RowCount := RowCount + 1;
            Cells[0, RowCount - 1] := NodeName;
            Cells[1, RowCount - 1] := PublicId;
            Cells[2, RowCount - 1] := SystemId;
            Cells[3, RowCount - 1] := NotationName;
          end
          else
            { Parsed entity }
            NewNode := AddElement(TreeParent, DisplayName, TNode.Create(
              xtEntityRef, NodeName, '', '', '', nil));
      NOTATION_NODE:
        with (Node as TXmlNotation), stgNotations do
        begin
          if Cells[0, RowCount - 1] <> '' then
            RowCount := RowCount + 1;
          Cells[0, RowCount - 1] := NodeName;
          Cells[1, RowCount - 1] := PublicId;
          Cells[2, RowCount - 1] := SystemId;
        end;
    end;
    { And recurse through any children }
    if Node.HasChildNodes then
      for Index := 0 to Node.ChildNodes.Length - 1 do
        AddElementToTree(Node.ChildNodes.Item(Index), NewNode);
  end;

begin
  pgcDetails.ActivePage := tshDocument;
  { Initialise document-wide details for display }
  InitDocumentDetails;
  { Load the source document }
  memSource.Lines.LoadFromFile(Filename);
  dlgOpen.Filename := Filename;
  { Instantiate the DOM }
  XMLDOM := TXmlObjModel.Create(nil);
  trvXML.Items.BeginUpdate;
  try
    { Suppress white space? }
    XMLDOM.NormalizeData := mniSuppressWhitespace.Checked;
    { Parse the document }
    if not XMLDOM.LoadDataSource(Filename) then
      raise Exception.Create(Format(NoLoadError, [XMLDOM.Errors.Text]));

    edtSystemId.Text := Filename;
    { Add the structure to the tree view }
    AddElementToTree(XMLDOM.Document, nil);
    trvXML.Items[0].Expand(False);
  finally
    trvXML.Items.EndUpdate;
    { Release the DOM }
    XMLDOM.Free;
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
procedure TfrmXMLViewer.mniSuppressWhitespaceClick(Sender: TObject);
begin
  mniSuppressWhitespace.Checked := not mniSuppressWhitespace.Checked;
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
  with TNode(trvXML.Selected.Data) do
    case NodeType of
      xtDocument:
        { Show document details, including entities and notations }
        pgcDetails.ActivePage := tshDocument;
      xtElement:
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
            xtComment:     lblNodeType.Caption := CommentDesc;
            xtInstruction: lblNodeType.Caption := InstructionDesc;
            xtEntityRef:   lblNodeType.Caption := EntityRefDesc;
            else           lblNodeType.Caption := TextDesc;
          end;
        end;
    end;
end;

end.

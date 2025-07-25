(* C2PP
  ***************************************************************************

  FMX Tools Starter Kit

  Copyright 2024-2025 Patrick Prémartin under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  A starter kit for your FireMonkey projects in Delphi.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://fmxtoolsstarterkit.developpeur-pascal.fr/

  Project site :
  https://github.com/DeveloppeurPascal/FMX-Tools-Starter-Kit

  ***************************************************************************
  File last update : 2025-05-24T20:31:55.364+02:00
  Signature : 13c3771067c1180f047edd7f75b763c71ba1c1da
  ***************************************************************************
*)

unit fMainForm;

interface

// TODO : ajouter un enregistrement de la taille de la fenêtre et un paramètre autorisant son enregistrement (peut-être au niveau du starter kit)
// TODO : si on utilise le splitter, enregistrer le prorata des 2 layouts pour le restituer à l'affichage suivant
// TODO : impacter la barre de titre du programme selon l'ouverture ou la fermeture d'un groupe
// TODO : impacter la barre de titre du programme selon le changement d'état (modifié ou pas) du groupe en cours

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  _MainFormAncestor,
  System.Actions,
  FMX.ActnList,
  FMX.Menus,
  uDocumentsAncestor,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.TabControl,
  FMX.Edit,
  FMX.ListBox,
  Olf.FMX.SelectDirectory,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.XMLDoc;

type
  TMainForm = class(T__MainFormAncestor)
    TabControl1: TTabControl;
    tiOpenCreate: TTabItem;
    GridPanelLayout1: TGridPanelLayout;
    btnNewGroup: TButton;
    btnOpenGroup: TButton;
    tiEdit: TTabItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    tbMain: TToolBar;
    lblCurrentProjectsGroup: TLabel;
    edtCurrentProjectsGroup: TEdit;
    lblProjectsInGroup: TLabel;
    lbProjectsInGroup: TListBox;
    lblProjectsRootFolder: TLabel;
    edtProjectsRootFolder: TEdit;
    btnSelectProjectsRootFolder: TEditButton;
    lblFoundProjects: TLabel;
    lbFoundProjects: TListBox;
    lProjectsGroup: TLayout;
    lProjectsFound: TLayout;
    Splitter1: TSplitter;
    tbFoundProjects: TToolBar;
    btnSave: TButton;
    btnClose: TButton;
    btnQuit: TButton;
    btnSelectAllFoundProjects: TButton;
    btnAddProjectsToGroup: TButton;
    btnUnselectAllFoundProjects: TButton;
    btnSelectCBuilderFoundProjects: TButton;
    btnSelectDelphiFoundProjects: TButton;
    tbProjectsGroup: TToolBar;
    btnSelectAllProjectsFromGroup: TButton;
    btnSelectDelphiProjectsFromGroup: TButton;
    btnSelectCBuilderProjectsFromGroup: TButton;
    btnUnselectAllProjectsFromGroup: TButton;
    btnRemoveProjectFromGroup: TButton;
    OlfSelectDirectoryDialog1: TOlfSelectDirectoryDialog;
    btnCancel: TButton;
    XMLDocument1: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure btnNewGroupClick(Sender: TObject);
    procedure btnOpenGroupClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnSelectAllProjectsFromGroupClick(Sender: TObject);
    procedure btnSelectDelphiProjectsFromGroupClick(Sender: TObject);
    procedure btnSelectCBuilderProjectsFromGroupClick(Sender: TObject);
    procedure btnUnselectAllProjectsFromGroupClick(Sender: TObject);
    procedure btnRemoveProjectFromGroupClick(Sender: TObject);
    procedure btnSelectAllFoundProjectsClick(Sender: TObject);
    procedure btnSelectDelphiFoundProjectsClick(Sender: TObject);
    procedure btnSelectCBuilderFoundProjectsClick(Sender: TObject);
    procedure btnUnselectAllFoundProjectsClick(Sender: TObject);
    procedure btnAddProjectsToGroupClick(Sender: TObject);
    procedure btnSelectProjectsRootFolderClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
  private
  protected
    FGroupHasChanged: Boolean;
    FProjectGroupGuid: string;
    function GetNewDoc(const FileName: string = ''): TDocumentAncestor;
      override;
    procedure OpenGroupProj(const AFileName: string);
    procedure CreateGroupProj(const AFileName: string);
    procedure EditGroupProj;
    procedure SelectItemsFromList(const AListBox: TListBox;
      const Delphi, CBuilder: Boolean);
    procedure UnselectAllItemsFromList(const AListBox: TListBox);
    procedure MoveItemsToList(const AFromListBox, AToListBox: TListBox;
      const ARootFolder: string);
    function DefaultEmbarcaderoProjectsDirectory: string;
    procedure SearchProjectsInFolder(const AFolderPath: string);
    procedure ExportProjectsGroup(const AFromList: TListBox;
      const AToFileName: string);
  public
    procedure TranslateTexts(const Language: string); override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.IOUtils;

// TODO : remplacer GetRelativePath() par la version de DeveloppeurPascal/Librairies
function GetRelativePath(const ForPath, CurrentPath: string): string;
var
  i, j: integer;
begin
  i := 0;
  j := 0;
  while (i < length(ForPath)) and (i < length(CurrentPath)) and
    (ForPath.Chars[i] = CurrentPath.Chars[i]) do
  begin
    if ForPath.Chars[i] = tpath.DirectorySeparatorChar then
      j := i;
    inc(i);
  end;
  if (i < length(ForPath)) or ((i < length(CurrentPath)) and
    (CurrentPath.Chars[i] <> tpath.DirectorySeparatorChar)) then
  begin
    result := ForPath.Substring(j + 1);
    i := j + 1;
  end
  else
    result := '';
  while (i < length(CurrentPath)) do
  begin
    if CurrentPath.Chars[i] = tpath.DirectorySeparatorChar then
      if result.IsEmpty then
        result := '.' + tpath.DirectorySeparatorChar
      else if result = '.' + tpath.DirectorySeparatorChar then
        result := '.' + result
      else
        result := '..' + tpath.DirectorySeparatorChar + result;
    inc(i);
  end;
end;

procedure TMainForm.btnAddProjectsToGroupClick(Sender: TObject);
begin
  MoveItemsToList(lbFoundProjects, lbProjectsInGroup, '');
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  if tfile.Exists(edtCurrentProjectsGroup.Text) then
    OpenGroupProj(edtCurrentProjectsGroup.Text)
  else
    CreateGroupProj(edtCurrentProjectsGroup.Text);
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  if FGroupHasChanged then
  begin
    ShowMessage('Group changed, please save or cancel it before closing.');
    // TODO : à remplacer par un OUI/NON
    abort;
  end
  else
    TabControl1.ActiveTab := tiOpenCreate;
end;

procedure TMainForm.btnNewGroupClick(Sender: TObject);
var
  InitialDir: String;
begin
  if SaveDialog1.InitialDir.IsEmpty then
  begin
    InitialDir := DefaultEmbarcaderoProjectsDirectory;

    if TDirectory.Exists(InitialDir) then
      SaveDialog1.InitialDir := InitialDir
    else
      SaveDialog1.InitialDir := tpath.GetDocumentsPath;
  end;

  if SaveDialog1.Execute and (not string(SaveDialog1.FileName).IsEmpty) then
    if tfile.Exists(SaveDialog1.FileName) then
      OpenGroupProj(SaveDialog1.FileName)
    else
      CreateGroupProj(SaveDialog1.FileName);
end;

procedure TMainForm.btnOpenGroupClick(Sender: TObject);
var
  InitialDir: String;
begin
  if OpenDialog1.InitialDir.IsEmpty then
  begin
    InitialDir := DefaultEmbarcaderoProjectsDirectory;

    if TDirectory.Exists(InitialDir) then
      OpenDialog1.InitialDir := InitialDir
    else
      OpenDialog1.InitialDir := tpath.GetDocumentsPath;
  end;

  if OpenDialog1.Execute and (not string(OpenDialog1.FileName).IsEmpty) then
    if tfile.Exists(OpenDialog1.FileName) then
      OpenGroupProj(OpenDialog1.FileName)
    else
      CreateGroupProj(OpenDialog1.FileName);
end;

procedure TMainForm.btnQuitClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.btnRemoveProjectFromGroupClick(Sender: TObject);
begin
  MoveItemsToList(lbProjectsInGroup, lbFoundProjects, edtProjectsRootFolder.Text
    + tpath.DirectorySeparatorChar);
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
begin
  // TODO : contrôler l'unicité des noms de projets avant export
  ExportProjectsGroup(lbProjectsInGroup, edtCurrentProjectsGroup.Text);
  FGroupHasChanged := false;
end;

procedure TMainForm.btnSelectAllFoundProjectsClick(Sender: TObject);
begin
  SelectItemsFromList(lbFoundProjects, true, true);
end;

procedure TMainForm.btnSelectAllProjectsFromGroupClick(Sender: TObject);
begin
  SelectItemsFromList(lbProjectsInGroup, true, true);
end;

procedure TMainForm.btnSelectCBuilderFoundProjectsClick(Sender: TObject);
begin
  SelectItemsFromList(lbFoundProjects, false, true);
end;

procedure TMainForm.btnSelectCBuilderProjectsFromGroupClick(Sender: TObject);
begin
  SelectItemsFromList(lbProjectsInGroup, false, true);
end;

procedure TMainForm.btnSelectDelphiFoundProjectsClick(Sender: TObject);
begin
  SelectItemsFromList(lbFoundProjects, true, false);
end;

procedure TMainForm.btnSelectDelphiProjectsFromGroupClick(Sender: TObject);
begin
  SelectItemsFromList(lbProjectsInGroup, true, false);
end;

procedure TMainForm.btnSelectProjectsRootFolderClick(Sender: TObject);
begin
  if not edtProjectsRootFolder.Text.IsEmpty then
    OlfSelectDirectoryDialog1.Directory := edtProjectsRootFolder.Text
  else if (not edtCurrentProjectsGroup.Text.IsEmpty) then
    OlfSelectDirectoryDialog1.Directory :=
      tpath.GetDirectoryName(edtCurrentProjectsGroup.Text)
  else
    OlfSelectDirectoryDialog1.Directory := DefaultEmbarcaderoProjectsDirectory;

  if OlfSelectDirectoryDialog1.Execute and
    (not OlfSelectDirectoryDialog1.Directory.IsEmpty) and
    TDirectory.Exists(OlfSelectDirectoryDialog1.Directory) then
  begin
    edtProjectsRootFolder.Text := OlfSelectDirectoryDialog1.Directory;
    SearchProjectsInFolder(OlfSelectDirectoryDialog1.Directory);
  end;
end;

procedure TMainForm.btnUnselectAllFoundProjectsClick(Sender: TObject);
begin
  UnselectAllItemsFromList(lbFoundProjects);
end;

procedure TMainForm.btnUnselectAllProjectsFromGroupClick(Sender: TObject);
begin
  UnselectAllItemsFromList(lbProjectsInGroup);
end;

procedure TMainForm.MoveItemsToList(const AFromListBox, AToListBox: TListBox;
  const ARootFolder: string);
var
  i: integer;
  item: TListBoxItem;
  GroupProjectPath: string;
begin
  GroupProjectPath := tpath.GetDirectoryName(edtCurrentProjectsGroup.Text) +
    tpath.DirectorySeparatorChar;

  for i := AFromListBox.count - 1 downto 0 do
    if AFromListBox.ListItems[i].IsChecked then
    begin
      item := AFromListBox.ListItems[i];
      AFromListBox.RemoveObject(item);

      if ARootFolder.IsEmpty or item.TagString.StartsWith(ARootFolder) then
      begin
        item.IsChecked := false;
        if ARootFolder.IsEmpty then
          item.Text := GetRelativePath(item.TagString, GroupProjectPath)
        else
          item.Text := GetRelativePath(item.TagString, ARootFolder);
        AToListBox.AddObject(item);
      end;
      FGroupHasChanged := true;
    end;
end;

procedure TMainForm.CreateGroupProj(const AFileName: string);
begin
  EditGroupProj;

  edtCurrentProjectsGroup.Text := AFileName;
  FProjectGroupGuid := tguid.NewGuid.ToString;

  edtProjectsRootFolder.Text := tpath.GetDirectoryName(AFileName);
  SearchProjectsInFolder(edtProjectsRootFolder.Text);
end;

function TMainForm.DefaultEmbarcaderoProjectsDirectory: string;
begin
{$IF Defined(MSWINDOWS)}
  // TODO : récupérer le dossier des projets par défaut depuis BDSPROJECTSDIR dans la clé "Ordinateur\HKEY_CURRENT_USER\Software\Embarcadero\BDS\23.0\Environment Variables" de la base de registres de Windows
{$ENDIF}
  result := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero', 'Studio',
    'Projects');
  if not TDirectory.Exists(result) then
    result := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero', 'Studio',
      'Projets');
  // TODO : tester les autres versions traduites de "Projects"
  if not TDirectory.Exists(result) then
    result := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero', 'Studio');
end;

procedure TMainForm.EditGroupProj;
begin
  edtCurrentProjectsGroup.Text := '';
  edtProjectsRootFolder.Text := '';
  lbProjectsInGroup.Clear;
  lbFoundProjects.Clear;

  lProjectsGroup.Height := TabControl1.Height / 2 - tbMain.Height;

  FGroupHasChanged := false;

  TabControl1.ActiveTab := tiEdit;
end;

procedure TMainForm.ExportProjectsGroup(const AFromList: TListBox;
  const AToFileName: string);
  function Space(const Nb: integer): string;
  var
    i: integer;
  begin
    result := '';
    for i := 1 to Nb do
      result := result + ' ';
  end;

var
  GroupProj: TStringList;
  i: integer;
  ProjectPath, ProjectRelPath, ProjectName: string;
  Targets, CleanTargets, MakeTargets: string;
begin
  GroupProj := TStringList.Create;
  try
    GroupProj.Add
      ('<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">');
    GroupProj.Add(Space(4) + '<PropertyGroup>');
    GroupProj.Add(Space(8) + '<ProjectGuid>' + FProjectGroupGuid +
      '</ProjectGuid>');
    GroupProj.Add(Space(4) + '</PropertyGroup>');
    GroupProj.Add(Space(4) + '<ItemGroup>');
    for i := 0 to AFromList.count - 1 do
    begin
      ProjectPath := AFromList.ListItems[i].TagString;
      ProjectRelPath := AFromList.ListItems[i].Text;
      if (not ProjectPath.IsEmpty) and tfile.Exists(ProjectPath) then
      begin
        GroupProj.Add(Space(8) + '<Projects Include="' + ProjectRelPath + '">');
        GroupProj.Add(Space(12) + '<Dependencies/>');
        GroupProj.Add(Space(8) + '</Projects>');
      end;
    end;
    GroupProj.Add(Space(4) + '</ItemGroup>');
    GroupProj.Add(Space(4) + '<ProjectExtensions>');
    GroupProj.Add(Space(8) +
      '<Borland.Personality>Default.Personality.12</Borland.Personality>');
    GroupProj.Add(Space(8) + '<Borland.ProjectType/>');
    GroupProj.Add(Space(8) + '<BorlandProject>');
    GroupProj.Add(Space(12) + '<Default.Personality/>');
    GroupProj.Add(Space(8) + '</BorlandProject>');
    GroupProj.Add(Space(4) + '</ProjectExtensions>');
    Targets := '';
    for i := 0 to AFromList.count - 1 do
    begin
      ProjectPath := AFromList.ListItems[i].TagString;
      ProjectRelPath := AFromList.ListItems[i].Text;
      if (not ProjectPath.IsEmpty) and tfile.Exists(ProjectPath) then
      begin
        ProjectName := tpath.GetFileNameWithoutExtension(ProjectPath);
        // TODO : check if the name is already in targets list
        GroupProj.Add(Space(4) + '<Target Name="' + ProjectName + '">');
        GroupProj.Add(Space(8) + '<MSBuild Projects="' + ProjectRelPath
          + '"/>');
        GroupProj.Add(Space(4) + '</Target>');
        GroupProj.Add(Space(4) + '<Target Name="' + ProjectName + ':Clean">');
        GroupProj.Add(Space(8) + '<MSBuild Projects="' + ProjectRelPath +
          '" Targets="Clean"/>');
        GroupProj.Add(Space(4) + '</Target>');
        GroupProj.Add(Space(4) + '<Target Name="' + ProjectName + ':Make">');
        GroupProj.Add(Space(8) + '<MSBuild Projects="' + ProjectRelPath +
          '" Targets="Make"/>');
        GroupProj.Add(Space(4) + '</Target>');
        if Targets.IsEmpty then
        begin
          Targets := ProjectName;
          CleanTargets := ProjectName + ':Clean';
          MakeTargets := ProjectName + ':Make';
        end
        else
        begin
          Targets := Targets + ';' + ProjectName;
          CleanTargets := CleanTargets + ';' + ProjectName + ':Clean';
          MakeTargets := MakeTargets + ';' + ProjectName + ':Make';
        end;
      end;
    end;
    GroupProj.Add(Space(4) + '<Target Name="Build">');
    GroupProj.Add(Space(8) + '<CallTarget Targets="' + Targets + '"/>');
    GroupProj.Add(Space(4) + '</Target>');
    GroupProj.Add(Space(4) + '<Target Name="Clean">');
    GroupProj.Add(Space(8) + '<CallTarget Targets="' + CleanTargets + '"/>');
    GroupProj.Add(Space(4) + '</Target>');
    GroupProj.Add(Space(4) + '<Target Name="Make">');
    GroupProj.Add(Space(8) + '<CallTarget Targets="' + MakeTargets + '"/>');
    GroupProj.Add(Space(4) + '</Target>');
    GroupProj.Add(Space(4) +
      '<Import Project="$(BDS)\Bin\CodeGear.Group.Targets" Condition="Exists(''$(BDS)\Bin\CodeGear.Group.Targets'')"/>');
    GroupProj.Add('</Project>');

    GroupProj.savetofile(AToFileName);
  finally
    GroupProj.free;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FGroupHasChanged then
  begin
    CanClose := false;
    btnCloseClick(Sender)
  end;
  CanClose := true;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := tiOpenCreate;
end;

function TMainForm.GetNewDoc(const FileName: string): TDocumentAncestor;
begin
  result := nil;
end;

procedure TMainForm.OpenGroupProj(const AFileName: string);
var
  Projects: IXMLNodeList;
  i: integer;
  item: TListBoxItem;
  GroupProjPath: string;
begin
  try
    EditGroupProj;

    edtCurrentProjectsGroup.Text := AFileName;

    GroupProjPath := tpath.GetDirectoryName(AFileName);

    XMLDocument1.LoadFromFile(AFileName);
    FProjectGroupGuid := XMLDocument1.ChildNodes.FindNode('Project')
      .ChildNodes.FindNode('PropertyGroup').ChildNodes.FindNode('ProjectGuid')
      .NodeValue;
    Projects := XMLDocument1.ChildNodes.FindNode('Project')
      .ChildNodes.FindNode('ItemGroup').ChildNodes;
    for i := 0 to Projects.count - 1 do
      if (comparetext(Projects[i].NodeName, 'Projects') = 0) and
        Projects[i].HasAttribute('Include') then
      begin
        item := TListBoxItem.Create(self);
        item.Text := Projects[i].Attributes['Include'];
        item.TagString := tpath.combine(GroupProjPath, item.Text);
        lbProjectsInGroup.AddObject(item);
      end;

    edtProjectsRootFolder.Text := tpath.GetDirectoryName(AFileName);
    SearchProjectsInFolder(edtProjectsRootFolder.Text);
  except
    TabControl1.ActiveTab := tiOpenCreate;
    raise;
  end;
end;

procedure TMainForm.SearchProjectsInFolder(const AFolderPath: string);
  procedure FindProjectsIn(const Path: string; var ProjList: TStringList);
  var
    lst: TStringDynArray;
    i: integer;
  begin
    lst := TDirectory.GetFiles(Path);
    for i := 0 to length(lst) - 1 do
      if lst[i].ToLower.EndsWith('.dproj', true) or
        lst[i].ToLower.EndsWith('.cbproj', true) then
        ProjList.Add(lst[i]);
    lst := TDirectory.GetDirectories(Path);
    for i := 0 to length(lst) - 1 do
      if TDirectory.Exists(lst[i]) then
        FindProjectsIn(lst[i], ProjList);
  end;

var
  sl: TStringList;
  item: TListBoxItem;
  i, j: integer;
  Found: Boolean;
begin
  if AFolderPath.IsEmpty or not TDirectory.Exists(AFolderPath) then
    exit;

  sl := TStringList.Create;
  try
    FindProjectsIn(AFolderPath, sl);

    lbFoundProjects.Clear;
    for i := 0 to sl.count - 1 do
    begin
      Found := false;
      for j := 0 to lbProjectsInGroup.count - 1 do
        if sl[i] = lbProjectsInGroup.ListItems[j].TagString then
        begin
          Found := true;
          break;
        end;
      if not Found then
      begin
        item := TListBoxItem.Create(self);
        item.TagString := sl[i];
        item.Text := sl[i].Substring(AFolderPath.length + 1);
        lbFoundProjects.AddObject(item);
      end;
    end;
  finally
    sl.free;
  end;
end;

procedure TMainForm.SelectItemsFromList(const AListBox: TListBox;
  const Delphi, CBuilder: Boolean);
var
  i: integer;
begin
  for i := 0 to AListBox.count - 1 do
    if Delphi and AListBox.Items[i].EndsWith('.dproj', true) then
      AListBox.ListItems[i].IsChecked := true
    else if CBuilder and AListBox.Items[i].EndsWith('.cbproj', true) then
      AListBox.ListItems[i].IsChecked := true;
end;

procedure TMainForm.TranslateTexts(const Language: string);
begin
  inherited;
  if Language = 'fr' then
  begin
    btnNewGroup.Text := 'Nouveau groupe de projets';
    btnOpenGroup.Text := 'Ouvrir un groupe de projets';
    btnSave.Text := 'Enregistrer';
    btnCancel.Text := 'Annuler';
    btnClose.Text := 'Fermer';
    btnQuit.Text := 'Quitter';
    lblCurrentProjectsGroup.Text := 'Groupe de projets';
    lblProjectsInGroup.Text := 'Projets du groupe';
    btnSelectAllProjectsFromGroup.Text := 'Tout sélectionner';
    btnSelectDelphiProjectsFromGroup.Text := 'Delphi';
    btnSelectCBuilderProjectsFromGroup.Text := 'C++Builder';
    btnUnselectAllProjectsFromGroup.Text := 'Désélectionner tout';
    btnRemoveProjectFromGroup.Text := 'Retirer du groupe';
    lblProjectsRootFolder.Text := 'Dossier des projets';
    btnSelectProjectsRootFolder.Text := '...';
    btnSelectProjectsRootFolder.Hint := 'Choisir un dossier';
    OlfSelectDirectoryDialog1.Text := btnSelectProjectsRootFolder.Hint;
    lblFoundProjects.Text := 'Projets trouvés';
    btnSelectAllFoundProjects.Text := btnSelectAllProjectsFromGroup.Text;
    btnSelectDelphiFoundProjects.Text := btnSelectDelphiProjectsFromGroup.Text;
    btnSelectCBuilderFoundProjects.Text :=
      btnSelectCBuilderProjectsFromGroup.Text;
    btnUnselectAllFoundProjects.Text := btnUnselectAllProjectsFromGroup.Text;
    btnAddProjectsToGroup.Text := 'Ajouter au groupe';
  end
  else
  begin
    btnNewGroup.Text := 'New projects group';
    btnOpenGroup.Text := 'Open a projects group';
    btnSave.Text := 'Save';
    btnCancel.Text := 'Cancel';
    btnClose.Text := 'Close';
    btnQuit.Text := 'Quit';
    lblCurrentProjectsGroup.Text := 'Projects group';
    lblProjectsInGroup.Text := 'Projects in the group';
    btnSelectAllProjectsFromGroup.Text := 'Select all';
    btnSelectDelphiProjectsFromGroup.Text := 'Delphi';
    btnSelectCBuilderProjectsFromGroup.Text := 'C++Builder';
    btnUnselectAllProjectsFromGroup.Text := 'Unselect all';
    btnRemoveProjectFromGroup.Text := 'Remove from group';
    lblProjectsRootFolder.Text := 'Projects folder';
    btnSelectProjectsRootFolder.Text := '...';
    btnSelectProjectsRootFolder.Hint := 'Choose a folder';
    OlfSelectDirectoryDialog1.Text := btnSelectProjectsRootFolder.Hint;
    lblFoundProjects.Text := 'Found projects';
    btnSelectAllFoundProjects.Text := btnSelectAllProjectsFromGroup.Text;
    btnSelectDelphiFoundProjects.Text := btnSelectDelphiProjectsFromGroup.Text;
    btnSelectCBuilderFoundProjects.Text :=
      btnSelectCBuilderProjectsFromGroup.Text;
    btnUnselectAllFoundProjects.Text := btnUnselectAllProjectsFromGroup.Text;
    btnAddProjectsToGroup.Text := 'Add to group';
  end;
end;

procedure TMainForm.UnselectAllItemsFromList(const AListBox: TListBox);
var
  i: integer;
begin
  for i := 0 to AListBox.count - 1 do
    AListBox.ListItems[i].IsChecked := false;
end;

end.

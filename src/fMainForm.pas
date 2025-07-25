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

{$MESSAGE WARN 'Save this file to your project directory. It''s your main form.'}
// TODO : Save this file to your project directory. It's your main form.

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
  Olf.FMX.SelectDirectory;

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
  private
  protected
    function GetNewDoc(const FileName: string = ''): TDocumentAncestor;
      override;
    procedure OpenGroupProj(const AFileName: string);
    procedure CreateGroupProj(const AFileName: string);
    procedure EditGroupProj;
  public
    procedure TranslateTexts(const Language: string); override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TMainForm.btnAddProjectsToGroupClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnNewGroupClick(Sender: TObject);
var
  InitialDir: String;
begin
  if SaveDialog1.InitialDir.IsEmpty then
  begin
{$IF Defined(MSWINDOWS)}
    // TODO : récupérer le dossier des projets par défaut depuis BDSPROJECTSDIR dans la clé "Ordinateur\HKEY_CURRENT_USER\Software\Embarcadero\BDS\23.0\Environment Variables" de la base de registres de Windows
{$ENDIF}
    InitialDir := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero', 'Studio',
      'Projects');
    if not TDirectory.Exists(InitialDir) then
      InitialDir := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero',
        'Studio', 'Projets');
    // TODO : tester les autres versions traduites de "Projects"
    if not TDirectory.Exists(InitialDir) then
      InitialDir := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero',
        'Studio');

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
{$IF Defined(MSWINDOWS)}
    // TODO : récupérer le dossier des projets par défaut depuis BDSPROJECTSDIR dans la clé "Ordinateur\HKEY_CURRENT_USER\Software\Embarcadero\BDS\23.0\Environment Variables" de la base de registres de Windows
{$ENDIF}
    InitialDir := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero', 'Studio',
      'Projects');
    if not TDirectory.Exists(InitialDir) then
      InitialDir := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero',
        'Studio', 'Projets');
    // TODO : tester les autres versions traduites de "Projects"
    if not TDirectory.Exists(InitialDir) then
      InitialDir := tpath.combine(tpath.GetDocumentsPath, 'Embarcadero',
        'Studio');

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
  // TODO : à compléter
end;

procedure TMainForm.btnRemoveProjectFromGroupClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectAllFoundProjectsClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectAllProjectsFromGroupClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectCBuilderFoundProjectsClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectCBuilderProjectsFromGroupClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectDelphiFoundProjectsClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectDelphiProjectsFromGroupClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnSelectProjectsRootFolderClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnUnselectAllFoundProjectsClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.btnUnselectAllProjectsFromGroupClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TMainForm.CreateGroupProj(const AFileName: string);
begin
  EditGroupProj;
  // TODO : à compléter
end;

procedure TMainForm.EditGroupProj;
begin
  // TODO : init fields
    // TODO : adapter la taille des 2 layouts
  TabControl1.ActiveTab := tiEdit;
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
begin
  EditGroupProj;
  // TODO : à compléter
end;

procedure TMainForm.TranslateTexts(const Language: string);
begin
  inherited;
  if Language = 'fr' then
  begin
    btnNewGroup.Text := 'Nouveau groupe de projets';
    btnOpenGroup.Text := 'Ouvrir un groupe de projets';
    btnSave.Text := 'Enregistrer';
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
    lblFoundProjects.Text := 'Found projects';
    btnSelectAllFoundProjects.Text := btnSelectAllProjectsFromGroup.Text;
    btnSelectDelphiFoundProjects.Text := btnSelectDelphiProjectsFromGroup.Text;
    btnSelectCBuilderFoundProjects.Text :=
      btnSelectCBuilderProjectsFromGroup.Text;
    btnUnselectAllFoundProjects.Text := btnUnselectAllProjectsFromGroup.Text;
    btnAddProjectsToGroup.Text := 'Add to group';
  end;
end;

end.

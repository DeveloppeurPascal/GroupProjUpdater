(* C2PP
  ***************************************************************************

  GroupProj Updater

  Copyright 2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://groupprojupdater.olfsoftware.fr/

  Project site :
  https://github.com/DeveloppeurPascal/GroupProjUpdater

  ***************************************************************************
  File last update : 2025-07-25T16:04:02.000+02:00
  Signature : 0c3bda9dbcadd7b0eb3b5c2043d58ca17dde4162
  ***************************************************************************
*)

unit uDMAboutBoxLogoStorrage;

interface

{$MESSAGE WARN 'Save uDMAboutBoxLogoStorrage.pas in your project folder and to customize it in your project. Don''t change the template version if you want to be able to update it.'}
// TODO : Save uDMAboutBoxLogoStorrage.pas in your project folder and to customize it in your project. Don't change the template version if you want to be able to update it.

// TODO : when you'll have a logo or icon for your project, don't forget to replace default one by yours in the TImageList
uses
  System.SysUtils,
  System.Classes,
  System.ImageList,
  FMX.ImgList;

type
  TdmAboutBoxLogo = class(TDataModule)
    imgLogo: TImageList;
  private
  public
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

end.

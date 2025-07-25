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

unit uTxtAboutLicense;

interface

function GetTxtAboutLicense(const Language: string;
  const Recursif: boolean = false): string;

implementation

// For the languages codes, please use 2 letters ISO codes
// https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes

uses
  System.SysUtils,
  uConsts;

const
  CTxtEN = '''
This program is distributed as shareware. If you use it (especially for commercial or income-generating purposes), please remember the author and contribute to its development by purchasing a license.

This software is supplied as is, with or without bugs. No warranty is offered as to its operation or the data processed. Make backups!

''';
  CTxtFR = '''
Ce programme est distribué en tant que shareware. Si vous l'utilisez (en particulier à des fins commerciales ou rémunératrices), merci de vous souvenir de l'auteur et de contribuer à son développement en achetant une licence.

Ce logiciel est fourni tel quel, avec ou sans bogues. Aucune garantie n'est offerte quant à son fonctionnement ou aux données traitées. Faites des sauvegardes !

''';
  // CTxtIT = '';
  // CTxtDE = '';
  // CTxtJP = '';
  // CTxtPT = '';
  // CTxtES = '';

function GetTxtAboutLicense(const Language: string;
  const Recursif: boolean): string;
var
  lng: string;
begin
  lng := Language.tolower;
  if (lng = 'en') then
    result := CTxtEN
  else if (lng = 'fr') then // France
    result := CTxtFR
  else if not Recursif then
    result := GetTxtAboutLicense(CDefaultLanguage, true)
  else
    raise Exception.Create('Unknow license for language "' + Language + '".');
end;

end.

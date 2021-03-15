unit InetOrg;

interface

uses PropertyObject, LdapClasses, Jpeg;

const
     eCitty                         = 00;
     eCountry                       = 01;
     eFacsimileTelephoneNumber      = 02;
     eHomePostalAddress             = 03;
     eHomePhone                     = 04;
     eIPPhone                       = 05;
     eJPegPhoto                     = 06;
     eMobile                        = 07;
     eOrganization                  = 08;
     ePager                         = 09;
     ePhysicalDeliveryOfficeName    = 10;
     ePostalAddress                 = 11;
     ePostalCode                    = 12;
     eState                         = 13;
     eTelephoneNumber               = 14;
     eTitle                         = 15;

   PropAttrNames: array [eCitty..eTitle] of string = (
     'l',
     'c',
     'facsimileTelephoneNumber',
     'homePostalAddress',
     'homePhone',
     'IPPhone',
     'jpegPhoto',
     'mobile',
     'o',
     'pager',
     'physicalDeliveryOfficeName',
     'postalAddress',
     'postalCode',
     'st',
     'telephoneNumber',
     'title'
   );

type
  TInetOrgPerson = class(TPropertyObject)
  private
    fJpegImage: TJpegImage;
    function GetJPegImage: TJpegImage;
    procedure SetJPegImage(const Image: TJpegImage);
  public
    constructor Create(const Entry: TLdapEntry); override;
    property Pager: string index ePager read GetString write SetString;
    property PostalAddress: string index ePostalAddress read GetString write SetString;
    property State: string index eState read GetString write SetString;
    property IPPhone: string index eIPPhone read GetString write SetString;
    property TelephoneNumber: string index eTelephoneNumber read GetString write SetString;
    property PostalCode: string index ePostalCode read GetString write SetString;
    property PhysicalDeliveryOfficeName: string index ePhysicalDeliveryOfficeName read GetString write SetString;
    property Title: string index eTitle read GetString write SetString;
    property Organization: string index eOrganization read GetString write SetString;
    property FacsimileTelephoneNumber: string index eFacsimileTelephoneNumber read GetString write SetString;
    property Citty: string index eCitty read GetString write SetString;
    property Country: string index eCountry read GetString write SetString;
    property HomePostalAddress: string index eHomePostalAddress read GetString write SetString;
    property HomePhone: string index eHomePhone read GetString write SetString;
    property Mobile: string index eMobile read GetString write SetString;
    property JPegPhoto: TJPegImage read GetJPegImage write SetJPegImage;
  end;

implementation

uses Misc;

constructor TInetOrgPerson.Create(const Entry: TLdapEntry);
begin
  inherited Create(Entry, 'inetOrgPerson', @PropAttrNames);
end;

function TInetOrgPerson.GetJPegImage: TJpegImage;
var
  Value: TLdapAttributeData;
begin
  Value := Attributes[eJpegPhoto].Values[0];
  if Assigned(Value) then
  begin
    if not Assigned(fJpegImage) then
      fJpegImage := TJPEGImage.Create;
    StreamCopy(Value.SaveToStream, fJpegImage.LoadFromStream);      
  end;
  Result := fJPegImage;
end;

procedure TInetOrgPerson.SetJPegImage(const Image: TJpegImage);
var
  Attribute: TLdapAttribute;
begin
  Attribute := Attributes[eJpegPhoto];
  if not Assigned(Image) then
    Attribute.Delete
  else
  begin
    if Attribute.ValueCount = 0 then
      Attribute.AddValue;
    StreamCopy(Image.SaveToStream, Attributes[eJpegPhoto].Values[0].LoadFromStream);
  end;
end;

end.

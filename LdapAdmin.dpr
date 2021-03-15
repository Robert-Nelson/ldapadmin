program LdapAdmin;

uses
  Forms,
  Main in 'Main.pas' {MainFrm},
  User in 'User.pas' {UserDlg},
  WinLDAP in 'WinLDAP.pas',
  LDAPClasses in 'LDAPClasses.pas',
  EditEntry in 'EditEntry.pas' {EditEntryFrm},
  Input in 'Input.pas' {InputDlg},
  Constant in 'Constant.pas',
  Pickup in 'Pickup.pas' {PickupDlg},
  ConnProp in 'ConnProp.pas' {ConnPropDlg},
  PassDlg in 'PassDlg.pas' {PasswordDlg},
  base64 in 'base64.pas',
  smbdes in 'smbdes.pas',
  ConnList in 'ConnList.pas' {ConnListFrm},
  Group in 'Group.pas' {GroupDlg},
  Computer in 'Computer.pas' {ComputerDlg},
  Transport in 'Transport.pas' {TransportDlg},
  Search in 'Search.pas' {SearchFrm},
  Ou in 'Ou.pas' {OuDlg},
  Export in 'Export.pas' {ExportDlg},
  RegAccnt in 'RegAccnt.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.

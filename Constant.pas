unit Constant;

interface

const

// Registry strings

  REG_KEY = 'Software\LdapAdmin\';
  REG_ACCOUNT = 'Accounts';

// System

  SAMBA_VERSION2 = 2;
  SAMBA_VERSION3 = 3;
  FIRST_UID      = 1000;
  LAST_UID       = 65534;
  FIRST_GID      = 1000;
  LAST_GID       = 65534;

  START_UID         = 1000;
  START_GID         = 1000;
  NO_GROUP          = 65534;
  COMPUTER_GROUP    = NO_GROUP; // nogroup

type
  TEditMode = (EM_ADD, EM_MODIFY);

resourcestring

// Search filters

  sANYCLASS     = '(objectclass=*)';
  sSAMBAACCNT   = '(objectclass=sambaAccount)';
  sPOSIXACCNT   = '(objectclass=posixAccount)';
  sGROUPS       = '(objectclass=posixGroup)';
  sMY_GROUP     = '(&(objectclass=posixGroup)(memberUid=%s))';
  sGROUPBYGID  = '(&(objectclass=posixGroup)(gidNumber=%d))';
  //sGROUPBYsGID  = '(&(objectclass=posixGroup)(gidNumber=%s))';
  sACCNTBYUID   = '(&(objectclass=posixAccount)(uid=%s))';

// Captions

  cDescription  = 'Description';
  cPickGroups   = 'Choose Groups';
  cPickAccounts = 'Choose Accounts';
  cNewResource  = 'New Resource';
  cEditResource = 'Edit Resource';
  cResource     = 'Resource:';
  cPropertiesOf = 'Properties of %s';
  cAddAddress   = 'Add Address';
  cEditAddress  = 'Edit Address';
  cSmtpAddress  = 'SMTP Address:';
  cConfirmDel   = 'Confirm';
  cEditEntry    = 'Edit entry:';
  cNewEntry     = 'New entry';
  cSurname      = 'Second name';
  cHomeDir      = 'Home Directory';
  cMaildrop     = 'Maildrop';
  cSamba2Accnt  = '-Samba2 Account-';
  cAddConn      = 'New connection';

// Messages

  stReqAttr      = 'Attribute %s may not be empty!';
  stReqNoEmpty   = '%s must have a value!';
  stReqMail      = 'At least one E-Mail address must be defined!';
  stPassDiff     = 'Passwords do not match!';
  stAccntNameReq = 'Enter a name for this connection!';
  stGroupNameReq = 'Enter a name for this group!';
  stConfirmDel   = 'Do you want to delete entry "%s"?';
  stCntObjects   = '%d object(s) found.';
  stRegAccntErr  = 'Could not read account data!';
  stNoMoreNums   = 'No more available numbers for %s!';
  stUnclosedStr  = 'Unclosed string!';
  stObjnRetrvd   = 'Object not yet retrieved!';
  stSmbDomainReq = 'You have to select samba domain to which this group should be mapped!';

{// Captions

  cDescription  = 'Beschreibung';
  cPickGroups   = 'Gruppen auswählen';
  cPickAccounts = 'Benutzer auswählen';
  cNewResource  = 'Neue Resource';
  cEditResource = 'Resource Bearbeiten';
  cResource     = 'Resource:';
  cPropertiesOf = 'Eigenschaften von %s';
  cAddAddress   = 'Adresse Hinzüfugen';
  cEditAddress  = 'Adresse Bearbeiten';
  cSmtpAddress  = 'SMTP Adresse:';
  cConfirmDel   = 'Löschen von Einträgen bestätigen';

// Messages

  stReqAttr      = 'Attribute %s ist erforderlich!';
  stReqNoEmpty   = 'Eingabe erforderlich: %s!';
  stReqMail      = 'Es ist midestens eine E-Mail Adresse erforderlich!';
  sPassDiff      = 'Die eingegebene Kennwörter sind unterschiedlich.';
  sAccntNameReq  = 'Bitte geben Sie einen Namen für diese Verbindung ein!';
  stGroupNameReq = 'Bitte geben Sie einen Namen für diese Gruppe ein!';
  stConfirmDel   = 'Möchten Sie Eintrag "%s" wirklich löschen?';
  stCntObjects   = '%d Objekt(e) gefunden.';}

implementation

end.

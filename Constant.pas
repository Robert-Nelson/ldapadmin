unit Constant;

interface

const
  bmRoot           =  0;
  bmRootSel        =  1;
  bmEntry          =  2;
  bmEntrySel       =  3;
  bmPosixUser      =  4;
  bmPosixUserSel   =  4;
  bmSamba3User     =  5;
  bmSamba3UserSel  =  5;
  bmGroup          =  6;
  bmGroupSel       =  6;
  bmComputer       =  7;
  bmComputerSel    =  7;
  bmMailGroup      =  9;
  bmMailGroupSel   =  9;
  bmOu             = 13;
  bmOuSel          = 13;
  bmTransport      = 15;
  bmTransportSel   = 15;
  bmSamba2User     = 19;
  bmSamba2UserSel  = 19;
  bmSudoer         = 21;
  bmSudoerSel      = 21;
  bmHost           = 22;
  bmHostSel        = 22;
  bmNetwork        = 23;
  bmNetworkSel     = 23;
  bmLocality       = 24;
  bmLocalitySel    = 24;
  bmSambaDomain    = 25;
  bmSambaDomainSel = 25;
  bmIdPool         = 26;
  bmIdPoolSel      = 26;

  ncDummyNode      = -1;

// Registry strings

  REG_KEY = 'Software\LdapAdmin\';
  REG_ACCOUNT = 'Accounts';

// System

  SAMBA_VERSION2    = 2;
  SAMBA_VERSION3    = 3;
  FIRST_UID         = 1000;
  LAST_UID          = 65534;
  FIRST_GID         = 1000;
  LAST_GID          = 65534;

  START_UID         = 1000;
  START_GID         = 1000;
  NO_GROUP          = 65534;
  COMPUTER_GROUP    = NO_GROUP; // nogroup

type
  TEditMode = (EM_ADD, EM_MODIFY);

resourcestring

// Search filters

  sANYCLASS         = '(objectclass=*)';
  sSAMBAACCNT       = '(objectclass=sambaAccount)';
  sPOSIXACCNT       = '(objectclass=posixAccount)';
  sMAILACCNT        = '(objectclass=mailUser)';
  sGROUPS           = '(objectclass=posixGroup)';
  sMAILGROUPS       = '(objectclass=mailGroup)';
  sMY_GROUP         = '(&(objectclass=posixGroup)(memberUid=%s))';
  sMY_MAILGROUP     = '(&(objectclass=mailGroup)(member=%s))';
  sGROUPBYGID       = '(&(objectclass=posixGroup)(gidNumber=%d))';
  sACCNTBYUID       = '(&(objectclass=posixAccount)(uid=%s))';

// Captions

  cAppName          = 'LDAP Admin';
  cDescription      = 'Description';
  cPickGroups       = 'Choose Groups';
  cPickAccounts     = 'Choose Accounts';
  cNewResource      = 'New Resource';
  cEditResource     = 'Edit Resource';
  cResource         = 'Resource:';
  cPropertiesOf     = 'Properties of %s';
  cAddAddress       = 'Add Address';
  cEditAddress      = 'Edit Address';
  cSmtpAddress      = 'SMTP Address:';
  cConfirm          = 'Confirmation';
  cEditEntry        = 'Edit entry:';
  cNewEntry         = 'New entry';
  cSurname          = 'Second name';
  cHomeDir          = 'Home Directory';
  cMaildrop         = 'Maildrop';
  cSamba2Accnt      = '-Samba2 Account-';
  cAddConn          = 'New connection';
  cRename           = 'Rename';
  cNewName          = 'New name:';
  cDeleting         = 'Deleting:';
  cCopyTo           = 'Copy %s to...';
  cMoveTo           = 'Move %s to...';
  cMoving           = 'Moving...';
  cCopying          = 'Copying...';
  cAddHost          = 'Add Host';
  cEditHost         = 'Edit Host';
  cHostName         = 'Host Name:';


// Messages

  stReqAttr         = 'Attribute %s may not be empty!';
  stReqNoEmpty      = '%s must have a value!';
  stReqMail         = 'At least one E-Mail address must be defined!';
  stPassDiff        = 'Passwords do not match!';
  stAccntNameReq    = 'You have to enter a name for this connection!';
  stGroupNameReq    = 'You have to enter a name for this group!';
  stGroupMailReq    = 'You have to enter at least one mail address for this group!';
  stConfirmDel      = 'Delete entry "%s"?';
  stCntObjects      = '%d object(s) found.';
  stRegAccntErr     = 'Could not read account data!';
  stNoMoreNums      = 'No more available numbers for %s!';
  stUnclosedStr     = 'Unclosed string!';
  stObjnRetrvd      = 'Object not yet retrieved!';
  stSmbDomainReq    = 'You have to select samba domain to which this group should be mapped!';
  stDeleteAll       = 'This directory entry is not empty (it contains further leaves). Delete all recursively?';
  stMoveOverlap     = 'Cannot move: Source and destination paths overlap!';
  stAskTreeCopy     = 'Copy %s to %s?';
  stAskTreeMove     = 'Move %s to %s?';
  stFileReadOnly    = 'File opened in read only mode!';
  stLdifEVer        = 'Invalid version value: %s!';
  stLdifEFold       = 'Line %d: Empty line may not be folded!';
  stLdifENoCol      = 'Line %d: Missing ":".';
  stLdifENoDn       = 'Line %d: dn expected but %s found!';
  stLdifSuccess     = '%d Object(s) succesfully imported!';
  stLdifFailure     = '%d Object(s) could not be imported!';
  stLdifEof         = 'End of file reached!';
  stInvalidLdapOp   = 'Invalid Ldap operation!';
  stSkipRecord      = '%s'#10#13'Skip this record?';

implementation

end.

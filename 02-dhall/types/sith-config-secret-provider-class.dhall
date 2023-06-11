--- sith-config-secret-provider-class.dhall
{
  Type =
  { 
    name: Text,
    objects: Text,
    roleName : Text,
    vaultAddress : Text
  },
  default=
  {
    roleName = "csi",
    vaultAddress = "http://vault.vault:8200"
  }
}

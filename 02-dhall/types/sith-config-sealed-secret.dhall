--- ConfigSealedSecret
{
  Type =
  { 
    name: Text,
    app: Text,
    encryptSecret: Text,
    annotations: Optional (List { mapKey : Text, mapValue : Text }),
    namespace: Optional Text,
  },
  default =
  {
    annotations = (./sith-config-sealed-secret-type.dhall).clusterWide,
    namespace = None Text
  }
}
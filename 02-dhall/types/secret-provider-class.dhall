-- secret-provider-class.dhall
{ Type =
    { apiVersion : Text
      , kind : Text
      , metadata :
          { name : Text
          }
      , spec :
          { 
          , parameters :
              { objects :  Text
                , roleName : Text
                , vaultAddress : Text
              }
          , provider : Text
          }
     },
  default = { 
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
  , kind = "SecretProviderClass"
   }
}
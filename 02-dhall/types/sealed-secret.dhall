-- sealed-secret.dhall
{ Type =
    { apiVersion : Text
      , kind : Text
      , metadata :
          { annotations : Optional (List { mapKey : Text, mapValue : Text })
          , labels : List { mapKey : Text, mapValue : Text }
          , name : Text
          , namespace : Optional Text
          }
      , spec :
          { encryptedData : { secret : Text }
          , template :
              { metadata :
                  { annotations : Optional (List { mapKey : Text, mapValue : Text })
                  , labels : List { mapKey : Text, mapValue : Text }
                  , name : Text
                  , namespace : Optional Text
                  }
              }
          }
     },
  default = { 
    apiVersion = "bitnami.com/v1alpha1"
  , kind = "SealedSecret"
   }
}
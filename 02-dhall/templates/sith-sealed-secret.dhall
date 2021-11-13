-- sith-sealed-secret.dhall

let ConfigSealedSecret = ../types/sith-config-sealed-secret.dhall
let SealedSecret = ../types/sealed-secret.dhall

let sealedSecret =
  λ(config : ConfigSealedSecret.Type) →
  SealedSecret::{ 
  , metadata =
    { annotations = config.annotations
    , name = config.name
    , labels = toMap { app = config.app }
    , namespace = config.namespace
    }
  , spec =
    { encryptedData.secret = config.encryptSecret
    , template =
      { 
      , metadata =
        { annotations = config.annotations
        , name = config.name
        , labels = toMap { app = config.app }
        , namespace = config.namespace
        }
      }
    }
  }

in sealedSecret
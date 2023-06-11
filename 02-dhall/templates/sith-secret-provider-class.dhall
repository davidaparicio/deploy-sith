-- sith-vault-csi.dhall


let ConfigSecretProviderClass = ../types/sith-config-secret-provider-class.dhall
let SecretProviderClass = ../types/secret-provider-class.dhall

let secretProviderClass =
  λ(config : ConfigSecretProviderClass.Type) →
  SecretProviderClass::{ 
  , metadata =
    { 
      name = config.name
    }
     , spec =
    { parameters =
      { 
        objects = config.objects
        , roleName = config.roleName
        , vaultAddress = config.vaultAddress
      }
      , provider = "vault"
    }
 
  }

in secretProviderClass

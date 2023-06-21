-- sith-secret-template.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a

let ConfigSecret = ../types/sith-config-secret.dhall

let secret =
  λ(config : ConfigSecret.Type) →
  kubernetes.Secret::{
    , metadata = kubernetes.ObjectMeta::{ 
      name = Some config.name, labels = Some (toMap { app = config.app }), annotations = config.annotations
      }
    , data = config.data
  }

in secret

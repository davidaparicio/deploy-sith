let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a

let SealedSecret = ./sealed-secret.dhall

let SecretProviderClass = ./secret-provider-class.dhall

let ManifestUnion : Type = < Svc : kubernetes.Service.Type | Deploy : kubernetes.Deployment.Type | Ing : kubernetes.Ingress.Type | Sec: kubernetes.Secret.Type | Sealed : SealedSecret.Type | SPC : SecretProviderClass.Type>

in ManifestUnion
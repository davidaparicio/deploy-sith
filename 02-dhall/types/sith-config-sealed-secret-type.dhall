--- sith-config-sealed-secret-type.dhall
let clusterWide = 
  Some (toMap { `sealedsecrets.bitnami.com/cluster-wide` = "true" })


let namespaceWide =
  Some (toMap { `sealedsecrets.bitnami.com/namespace-wide` = "true" })

let strict = 
  None (List { mapKey : Text, mapValue : Text })

in {
  clusterWide,
  namespaceWide,
  strict
}


-- sith-deploy-template.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall sha256:9d07ad4eff6d388aaf7c4715d3b83812a7eee8a6281a5e64098aaddb3551ce6a

let null = https://prelude.dhall-lang.org/v21.1.0/Optional/null.dhall sha256:3871180b87ecaba8b53fffb2a8b52d3fce98098fab09a6f759358b9e8042eedc

let ConfigDeploy = ../types/sith-config-deploy.dhall


let deployment =
  λ(config : ConfigDeploy.Type) → 
  kubernetes.Deployment::{
  , metadata = kubernetes.ObjectMeta::{ name = Some config.name, labels = Some (toMap { app = config.app }) }
  , spec = Some kubernetes.DeploymentSpec::{
    , selector = kubernetes.LabelSelector::{
      , matchLabels = Some (toMap { app = config.app })
      }
    , replicas = Some config.replicas
    , template = kubernetes.PodTemplateSpec::{
      , metadata = Some kubernetes.ObjectMeta::{ 
        name = Some config.name,
        labels = Some (toMap { app = config.app })
      }
      , spec = Some kubernetes.PodSpec::{
        , containers =
          [ kubernetes.Container::{
            , name = config.name
            , image = Some config.image
            , env = if null Text (config.environnement)
              then None (List kubernetes.EnvVar.Type)
              else Some [ kubernetes.EnvVar::{ name = "ENV", value = config.environnement }, 
                kubernetes.EnvVar::{ name = "NS", valueFrom = Some kubernetes.EnvVarSource::{ fieldRef = Some kubernetes.ObjectFieldSelector::{ fieldPath = "metadata.namespace" } } }  ] 
            , ports = Some [ kubernetes.ContainerPort::{ 
              containerPort = config.containerPort,
              name = config.portName,
              } ]
            , resources = Some { 
                requests = Some (toMap { cpu = config.resources.requests.cpu, memory = config.resources.requests.memory }) 
              , limits = Some (toMap { cpu = config.resources.limits.cpu, memory = config.resources.limits.memory }) 
              }
            , livenessProbe = Some kubernetes.Probe::{ 
              httpGet = Some kubernetes.HTTPGetAction::{ path = Some config.livenessProbe.path, port = config.livenessProbe.port  } 
            }
            , volumeMounts = if null Text (config.secretName)
              then None (List kubernetes.VolumeMount.Type)
              else Some [ kubernetes.VolumeMount::{mountPath = "/etc/sith", name = "secret-volume", readOnly = Some True } ]
            }
          ]
        , volumes = if null Text (config.secretName)
          then None (List kubernetes.Volume.Type)
          else Some [ kubernetes.Volume::{ name = "secret-volume", secret = Some kubernetes.SecretVolumeSource::{ secretName = config.secretName } } ]
        }
      }
      
    }
  }

in deployment

-- Some fieldRef.fieldPath::{"metadata.namespace"} 
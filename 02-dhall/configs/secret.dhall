-- staging.dhall
-- config for staging env

-- schemas
let ConfigDeploy = ../types/sith-config-deploy.dhall

let ConfigSvc = ../types/sith-config-svc.dhall
let Port : Type = < Int : Integer | String : Text >

let ConfigSealedSecret = ../types/sith-config-sealed-secret.dhall
let ConfigSealedSecretType = ../types/sith-config-sealed-secret-type.dhall


let Config = ../types/sith-config.dhall

-- create ingress from svc
let Converters = ../tools/converters.dhall 

-- common
let common = {
  name = "hello",
  app = "hello",
  secretName = "james-secrets",
}

-- deployment
let deployment = ConfigDeploy::{
  name = common.name,
  app = common.app,
  replicas = +1,
  image = "registry.gitlab.com/gitops-heros/sith:1.3",
  containerPort = +8080,
  portName = Some "web",
  environnement = Some "secret",
  resources = {
    requests = { cpu = "0.2", memory = "8Mi" },
    limits = { cpu = "0.5", memory = "16Mi" }
  },
  livenessProbe = { path = "/", port = Port.String "web" },
  secretName = Some common.secretName
}

-- svc
let service = ConfigSvc::{
  name = common.name,
  app = common.app,
  port = +80,
  portName = Some "front",
  targetPort = Some (Port.String "web")
}

-- ingress (from svc)
let ingress = Converters.configServiceToconfigIngress service "secret.127.0.0.1.sslip.io"


-- sealed secret
let sealedSecret = ConfigSealedSecret::{
  name = common.secretName,
  app = "hello",
  encryptSecret =
      "AgApYm07yDTE7wM4KwtgcrXKXVLzHIB07R+2n6gDC4sHwIuKuaOauNQib1QCOvI9eOnWO1MdmtRHWlvq9JrIqFyfHJx+IShO5VuGVkxoZ0bCjuRFRjER9w+nekQoruNaSbh/iVgDl4aOGm4BZYKdhWztB9AU5Tc8OGftogZjdi/BDpE95LFrjpjt18hANl0JCaJoclX0tUaEpodh5OBa1xZxnmK0HldwK5ieEwtAYU7EvUR8HgZj71/i/epLCKxtA3iVaoEn2O9OCFViBo1t6uSf8rHbjy2dBu6CgGJNoBknWVRmCBu3wekUgxygMcEwS0Jqt1TwmmIB+RD9MRsQPyoAK0cGYY8ajq0PkKo9UNlZZTxGRDSZreWCm7AvviEYNpYzqZV7VIIEB8qeoRxsCgdj/379j+7NVkQdLGWkJSwzmSDUrkE8mE27ujfbSEkGYU7/sfznb4cCKvRdoQtJq1fJmgLvCRobMp/vCY13BetQhtrsMiNCkhdRn5b2kUN/S46bFTb5Pq+SY9f3lfsmaO+jsDW/s5IqPllVdqso0vhEEpri3ltPIUoOGrGvxjnPSY3/8gg6lXiO83/TP3NG+dJODxYKht5pqEEm9OqBWt4F3kB/Q64d6WUq+Tz6JxoxDaDAbYA38FrjVJlqs6iRctwPzup7145s9V7yr/9uP6B55aWsPkhciRjo6oZR8IS0WnwIy3erXOnz+pLm6w==",
  -- annotations = ConfigSealedSecretType.namespaceWide,
  -- namespace = Some "namespace"
}

let config : Config ={deploy = deployment, svc = service, ing = ingress}
--, sealed = sealedSecret}

in config ∧ { sealed = sealedSecret}

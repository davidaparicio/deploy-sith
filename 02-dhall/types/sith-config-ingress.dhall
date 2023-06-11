--- sith-config-ingress.dhall
{
  Type =
  { 
    name: Text,
    app: Text,
    -- TODO use a lists of rule instead of this basic only one rule
    rule : (./sith-config-ingress-rule.dhall).Type ,
    },
  default = {=}
}

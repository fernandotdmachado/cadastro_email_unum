connection: "etusbg_connector"

datagroup: email_cadastros_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: email_cadastros_default_datagroup

include: "/view/*.view"

explore: cadastros_unum {
  label: "Cadastros Email UNUM"
}

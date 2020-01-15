view: cadastros_unum {
  derived_table: {
    sql: SELECT CAST(date_time AS DATE) AS DATA,
          CASE WHEN active_subscriptions_1_ IS NULL THEN 'NOVO' ELSE 'RECADASTRO' END AS TIPO_CADASTRO,
          CASE WHEN contact_tags_ LIKE '%youtube_quiz_lead%' THEN 'GOOGLE'
          WHEN contact_tags_ LIKE '%quiz_cartao_lead%' THEN 'FACEBOOK'
          ELSE 'NÃO IDENTIFICADO' END AS REDE,
          CASE WHEN contact_tags_ LIKE '%limite%' THEN 'LIMITE'
          WHEN contact_tags_ LIKE '%milhas%' THEN 'MILHAS'
          WHEN contact_tags_ LIKE '%negativ%' THEN 'NEGATIVADO'
          WHEN contact_tags_ LIKE '%anuidade%' THEN 'ANUIDADE'
          WHEN contact_tags_ LIKE '%serv%' THEN 'ANUIDADE' END AS LISTA_ENTROU,
          COUNT(DISTINCT contact_id_) AS QTDE
          FROM `etusbg.webhooks.raw_activecampaign`
          WHERE TYPE = 'subscribe'
          AND CAST(date_time AS DATE) >= '2020-01-01'
          AND unsubscribe_reason_ IS NULL
          GROUP BY DATA,
          TIPO_CADASTRO,
          REDE,
          LISTA_ENTROU
          ORDER BY DATA DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: data {
    type: date
    sql: ${TABLE}.DATA ;;
  }

  dimension: tipo_cadastro {
    type: string
    sql: ${TABLE}.TIPO_CADASTRO ;;
  }

  dimension: lista_entrou {
    type: string
    sql: ${TABLE}.LISTA_ENTROU ;;
  }

  dimension: rede {
    type: string
    sql: ${TABLE}.REDE ;;
  }

  measure: qtde {
    type: sum
    sql: ${TABLE}.QTDE ;;
  }

  set: detail {
    fields: [data, tipo_cadastro, rede, qtde]
  }
}

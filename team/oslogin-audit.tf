# OS Login-inloggningar -> audit-logg -> sink -> Pub/Sub -> Falco (gcpaudit).
#
# OBS: tre delar hanteras INTE här, eftersom CI-kontets roles/editor saknar
# rättigheterna (resourcemanager.projects.setIamPolicy, logging.sinks.create
# respektive pubsub.topics.setIamPolicy). editor har bara logging.sinks.get och
# .list; create finns i roles/logging.configWriter, som på projektnivå skulle
# låta CI ändra andra teams sinks. Instruktören ombeds sätta dem för hand:
#
# resource "google_project_iam_audit_config" "oslogin" {
#   project = var.project_id
#   service = "oslogin.googleapis.com"
#   audit_log_config { log_type = "ADMIN_READ" }
#   audit_log_config { log_type = "DATA_READ" }
# }
#
# resource "google_pubsub_topic_iam_member" "oslogin_sink_publisher" {
#   topic  = google_pubsub_topic.oslogin_audit.name
#   role   = "roles/pubsub.publisher"
#   # Sinkens writer identity, fylls i när sinken finns.
#   member = google_logging_project_sink.oslogin_audit.writer_identity
# }
#
# resource "google_logging_project_sink" "oslogin_audit" {
#   name        = "team${var.team_id}-oslogin-audit"
#   destination = "pubsub.googleapis.com/${google_pubsub_topic.oslogin_audit.id}"
#   filter      = <<-EOT
#     protoPayload.serviceName="oslogin.googleapis.com"
#     protoPayload.methodName:"CheckPolicy"
#   EOT
#
#   unique_writer_identity = true
# }
#
# TODO: begränsa sinkfiltret till team 4:s instanser när en riktig post setts
# i Logs Explorer.

# pubsub.googleapis.com slås på centralt av Comerit i itsx25-comerit. CI-kontot
# saknar serviceusage.services.enable, så API:et hanteras inte här.
#
# Topic och prenumeration är parkerade: i itsx25-comerit saknar team4-cicd
# pubsub.topics.create (403 i deployen 2026-10-15). Aktiveras igen när Comerit
# gett kontot Pub/Sub-rättigheter, eller när punkt 6 tas upp igen.
#
# resource "google_pubsub_topic" "oslogin_audit" {
#   name = "team${var.team_id}-oslogin-audit"
# }
#
# resource "google_pubsub_subscription" "falco" {
#   name  = "team${var.team_id}-oslogin-audit-falco"
#   topic = google_pubsub_topic.oslogin_audit.id
#
#   message_retention_duration = "86400s"
#
#   expiration_policy {
#     ttl = ""
#   }
# }
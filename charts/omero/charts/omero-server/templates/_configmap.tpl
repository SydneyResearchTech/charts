---
# charts/omero-server/templates/configmap.yaml
# https://docs.openmicroscopy.org/omero/5.6.3/sysadmins/config.html
#
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "omero-server.fullname" . }}
  labels:
    {{- include "omero-server.labels" . | nindent 4 }}
data:
  00kubernetes-configmap.omero: |
{{- with .Values.omero }}
    omero.checksum.supported={{.checksum.supported}}
    omero.data.dir={{.data.dir}}
{{- with .fs.repo }}
    omero.fs.repo.path={{.path}}
    omero.fs.repo.path_rules={{.path_rules}}
{{- end }}
    omero.managed.dir={{.managed.dir}}
{{- with .client }}
    omero.client.browser.thumb_default_size={{.browser.thumb_default_size}}
    omero.client.download_as.max_size={{.download_as.max_size|toJson}}
    omero.client.icetransports={{.icetransports}}
    omero.client.scripts_to_ignore={{.scripts_to_ignore}}
    omero.client.ui.menu.dropdown.colleagues.enabled={{.ui.menu.dropdown.colleagues.enabled}}
    omero.client.ui.menu.dropdown.colleagues.label={{.ui.menu.dropdown.colleagues.label}}
    omero.client.ui.menu.dropdown.everyone.enabled={{.ui.menu.dropdown.everyone.enabled}}
    omero.client.ui.menu.dropdown.everyone.label={{.ui.menu.dropdown.everyone.label}}
    omero.client.ui.menu.dropdown.leaders.enabled={{.ui.menu.dropdown.leaders.enabled}}
    omero.client.ui.menu.dropdown.leaders.label={{.ui.menu.dropdown.leaders.label}}
    omero.client.ui.tree.orphans.description={{.ui.tree.orphans.description}}
    omero.client.ui.tree.orphans.enabled={{.ui.tree.orphans.enabled}}
    omero.client.ui.tree.orphans.name={{.ui.tree.orphans.name}}
    omero.client.ui.tree.orphans.type_order={{.ui.tree.orphans.type_order}}
    omero.client.viewer.initial_zoom_level={{.viewer.initial_zoom_level}}
    omero.client.viewer.interpolate_pixels={{.viewer.interpolate_pixels}}
    omero.client.viewer.roi_limit={{.viewer.roi_limit}}
{{- end }}
{{- with .db }}
    omero.db.authority={{.authority}}
    omero.db.dialect={{.dialect}}
    omero.db.driver={{.driver}}
    omero.db.patch={{.patch}}
    omero.db.poolsize={{.poolsize}}
    omero.db.prepared_statement_cache_size={{.prepared_statement_cache_size}}
    omero.db.profile={{.profile}}
    omero.db.sql_action_class={{.sql_action_class}}
    omero.db.statistics={{.statistics}}
    omero.db.version={{.version}}
{{- end }}
{{- with .glacier2.IceSSL }}
    omero.glacier2.IceSSL.CAs={{.CAs}}
    omero.glacier2.IceSSL.CertFile={{.CertFile}}
    omero.glacier2.IceSSL.Ciphers={{.Ciphers}}
    omero.glacier2.IceSSL.DefaultDir={{.DefaultDir}}
    omero.glacier2.IceSSL.Password={{.Password}}
    omero.glacier2.IceSSL.ProtocolVersionMax={{.ProtocolVersionMax}}
    omero.glacier2.IceSSL.Protocols={{.Protocols}}
{{- end }}
{{- end }}

--- NVFlare/nvflare/dashboard/wsgi.py   2025-08-29 11:56:53.722062861 +1000
+++ NVFlare/nvflare/dashboard/wsgi.py-new       2025-08-29 11:38:30.692065366 +1000
@@ -31,4 +31,4 @@
         ssl_context.load_cert_chain(web_crt, web_key)
     else:
         ssl_context = None
-    app.run(host="0.0.0.0", port=port, ssl_context=ssl_context)
+    app.run(host="::", port=port, ssl_context=ssl_context)

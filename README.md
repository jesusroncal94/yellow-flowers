# Flores amarillas para Yomara

Jardín 3D de flores amarillas (Three.js) con un mensaje en seis pasos. Cada paso abre una ola de flores; el último florece todo el campo, cae una lluvia de pétalos y aparece la foto. Tocar el jardín siembra una flor.

## Archivos

| Archivo | Qué es |
| --- | --- |
| `index.html` | Fuente principal. Es la página que se publica como artifact en claude.ai (sin `<html>/<head>/<body>`, el artifact los añade). Aquí se edita todo. |
| `foto.webp` | La foto original. Ya va embebida dentro de `index.html`. |
| `build.sh` | Genera las versiones exportables en `docs/`. |
| `docs/index.html` | Página completa lista para hosting (GitHub Pages, Netlify, Vercel). Carga Three.js y las fuentes desde CDN. |
| `docs/flores-amarillas-offline.html` | Un solo archivo (~1.3 MB) con Three.js, fuentes y foto embebidos. Funciona sin internet: se puede enviar por WhatsApp/Telegram/correo y abrir directamente. |

## Personalizar

Todo el texto está al inicio del script en `index.html`: `NOMBRE`, `APODO` y el arreglo `MENSAJES`. Después de editar, ejecutar:

```bash
bash build.sh
```

## Cómo compartirlo

1. **Enlace del artifact** — el más rápido. Desde el menú *Share* de la página en claude.ai.
2. **GitHub Pages** — subir el repo a GitHub, *Settings → Pages → Deploy from branch → `/docs`*. Queda en `https://<usuario>.github.io/yellow-flowers/`, sin cuenta ni app para quien lo abre.
3. **Netlify Drop / Vercel** — arrastrar la carpeta `docs/` a [app.netlify.com/drop](https://app.netlify.com/drop) y listo, URL pública en segundos.
4. **Archivo offline** — enviar `docs/flores-amarillas-offline.html`. En Android se abre con Chrome; en iPhone, abrir el adjunto y elegir *Abrir en Safari* (o guardarlo en Archivos y tocarlo).

# Hunyuan3D 2.1 — Interfaz Gradio GPU con Docker

Este proyecto es una **adaptación de uso y despliegue de la plataforma Hunyuan3D 2.1**, desarrollada originalmente por el equipo de Tencent, con fines de prueba, investigación y desarrollo local en entorno Docker.

## 🏗️ ¿Qué contiene este repositorio?

- **TODO el código fuente principal pertenece al repositorio oficial [Tencent-Hunyuan/Hunyuan3D-2.1](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1)**
- Se incluye una estructura adaptada para despliegue local en Docker y uso directo de la interfaz Gradio, pensada para facilitar la ejecución en entornos con GPU NVIDIA (CUDA 12.x, PyTorch 2.5.1).
- Se agregan archivos de configuración y exclusión (`.gitignore`, `docker-compose.yml`) para desarrollo reproducible y control de dependencias/pesos.

## 👩‍💻 Créditos y atribución

- **Autores originales:**  
  Todo el trabajo de desarrollo, entrenamiento, investigación y publicación del modelo, scripts, librerías y ejemplos es propiedad de **Tencent y el equipo de Hunyuan3D**.
- **Repositorio original:**  
  https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1
- **Licencia:**  
  El uso, distribución, modificación y redistribución están sujetos a la licencia original de Tencent Hunyuan Non-Commercial License Agreement y las licencias de los terceros involucrados.  
  Consultar `LICENSE` y [TENCENT HUNYUAN COMMUNITY LICENSE AGREEMENT](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1/blob/main/LICENSE).

## ⚙️ Adaptación y cambios en este fork

- **No se realizaron cambios de fondo** en el código de inferencia, arquitectura del modelo, ni scripts principales.
- **Las modificaciones locales** se limitan a:
  - Organización de archivos y carpetas para el entorno Docker.
  - Integración de dependencias vía `requirements.txt` y Dockerfile.
  - Excluidos del control de versiones (`.gitignore`) los archivos de pesos, exportaciones y temporales para cumplir buenas prácticas y evitar conflictos legales o de tamaño de repositorio.
  - Documentación y ejemplos de despliegue para facilitar la ejecución en entornos personales.

## 🚫 Limitaciones de uso

- **Este proyecto NO ES una obra original** ni pretende atribuirse la autoría del modelo, los scripts, ni los assets incluidos en el repositorio base.
- **Toda consulta, issue, bug o pull request sobre el modelo o scripts originales debe dirigirse al repositorio de Tencent**.

## 📦 Cómo utilizar este fork

1. **Cloná este repositorio.**
2. **Descargá los pesos oficiales** desde [HuggingFace Hunyuan3D](https://huggingface.co/tencent/Hunyuan3D-2.1/tree/main/hunyuan3d-dit-v2-1) y ubicálos en la carpeta indicada (`hunyuan3d-dit-v2-1/`).
3. **Construí la imagen Docker** y levantá el entorno:
```bash
   docker compose build
   docker compose up
```
4. Accedé a la interfaz Gradio local en [http://localhost:7860](http://localhost:7860).

---

## 📄 Referencias y documentación

- [Repositorio oficial Hunyuan3D-2.1](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1)
- [Licencia Tencent Hunyuan Non-Commercial](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1/blob/main/LICENSE)
- [Pesos y modelos en HuggingFace](https://huggingface.co/tencent/Hunyuan3D-2.1)

---

**Todo el mérito científico, técnico y creativo corresponde al equipo original de Hunyuan3D/Tencent.  
Este fork solo facilita la integración y despliegue local en ambientes reproducibles.**

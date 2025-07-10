import gradio as gr
import os
import uuid
from main import generar_modelo_3d

DATA_DIR = "/data"

def procesar(inputs, resolucion, vistas, formato, modo_gpu, prompt, tipo_salida):
    # Crear directorio único de trabajo
    run_id = str(uuid.uuid4())
    out_dir = os.path.join(DATA_DIR, run_id)
    os.makedirs(out_dir, exist_ok=True)
    
    # Guardar imágenes recibidas
    image_paths = []
    if isinstance(inputs, list):
        for idx, img in enumerate(inputs):
            img_path = os.path.join(out_dir, f"input_{idx}.png")
            img.save(img_path)
            image_paths.append(img_path)
    else:
        img_path = os.path.join(out_dir, "input_0.png")
        inputs.save(img_path)
        image_paths = [img_path]
    
    # Llama al wrapper principal
    modelo_path = generar_modelo_3d(
        image_paths=image_paths,
        resolucion=resolucion,
        vistas=vistas,
        formato=formato,
        modo_gpu=modo_gpu,
        prompt=prompt,
        tipo_salida=tipo_salida,
        output_dir=out_dir
    )
    # Renderizado web embebido en 3D (solo glb/obj, STL sin textura)
    modelo_render = modelo_path if formato in ["glb", "obj"] else None
    
    # Link de descarga
    return (
        modelo_render,
        modelo_path
    )

with gr.Blocks() as demo:
    gr.Markdown("# Hunyuan 3D 2.1 — Generador 3D GPU")
    
    with gr.Row():
        imagenes = gr.File(label="Subir imágenes", file_count="multiple", file_types=["image"], elem_id="input-img")
        tipo_salida = gr.Radio(["Mesh simple", "Texturizado completo"], label="Modo de salida", value="Mesh simple")
    with gr.Row():
        resolucion = gr.Dropdown([256, 512, 1024], label="Resolución", value=512)
        vistas = gr.Slider(1, 6, value=1, step=1, label="Cantidad de vistas")
        formato = gr.Dropdown(["stl", "obj", "glb"], label="Formato de salida", value="stl")
        modo_gpu = gr.Radio(["normal", "low_vram"], label="Modo GPU", value="normal")
    prompt = gr.Textbox(label="Prompt de estilo (opcional)", placeholder="cartoon, realista, etc.", lines=1)
    btn = gr.Button("Generar Modelo")
    
    modelo_render = gr.Model3D(label="Vista previa 3D")
    descarga = gr.File(label="Descargar archivo")

    btn.click(
        fn=procesar,
        inputs=[imagenes, resolucion, vistas, formato, modo_gpu, prompt, tipo_salida],
        outputs=[modelo_render, descarga]
    )

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860, share=False)

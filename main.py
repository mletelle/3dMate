import subprocess
import os

def generar_modelo_3d(image_paths, resolucion, vistas, formato, modo_gpu, prompt, tipo_salida, output_dir):
    # 1. Ejecutar shape.py para reconstrucción básica (mesh)
    shape_out = os.path.join(output_dir, f"mesh.{formato}")
    shape_cmd = [
        "python3", "shape.py",
        "--input", ",".join(image_paths),
        "--res", str(resolucion),
        "--views", str(vistas),
        "--output", shape_out,
        "--gpu_mode", modo_gpu,
    ]
    if prompt:
        shape_cmd += ["--prompt", prompt]
    subprocess.run(shape_cmd, check=True)

    # 2. (opcional) Si el modo es "Texturizado completo", ejecutar paint.py
    if tipo_salida == "Texturizado completo" and formato in ["glb", "obj"]:
        paint_out = os.path.join(output_dir, f"model_textured.{formato}")
        paint_cmd = [
            "python3", "paint.py",
            "--mesh", shape_out,
            "--output", paint_out,
            "--gpu_mode", modo_gpu,
        ]
        if prompt:
            paint_cmd += ["--prompt", prompt]
        subprocess.run(paint_cmd, check=True)
        return paint_out
    else:
        return shape_out

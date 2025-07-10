# Dockerfile para Hunyuan 3D 2.1 + Gradio + CUDA + PyTorch + Renderizadores

FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Actualizar y utilidades
RUN apt-get update && \
    apt-get install -y git python3 python3-pip python3-venv build-essential \
    libgl1-mesa-glx libglib2.0-0 ffmpeg wget curl && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario no root
RUN useradd -ms /bin/bash hunyuan
USER hunyuan
WORKDIR /home/hunyuan

# Python virtualenv (opcional pero recomendado)
RUN python3 -m venv .venv
ENV PATH="/home/hunyuan/.venv/bin:$PATH"

# Instalar PyTorch 2.5.1 con CUDA 12.1 y dependencias principales
RUN pip install --upgrade pip
RUN pip install torch==2.5.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.2.1 --extra-index-url https://download.pytorch.org/whl/cu121

# Instalar Gradio y otras dependencias generales
RUN pip install gradio==4.28.3 numpy pillow trimesh scikit-image

#  Instalar dependencias específicas de Hunyuan y renderizadores
COPY requirements.txt ./
RUN pip install -r requirements.txt

# Copiar scripts al contenedor
COPY --chown=hunyuan:hunyuan . .

# Precompilar renderizadores diferenciales si es necesario
RUN [ -f renderers/compile.sh ] && bash renderers/compile.sh || true
RUN [ -f custom_rasterizer/setup.py ] && cd custom_rasterizer && python setup.py install || true

# Puerto Gradio y volumen de datos
EXPOSE 7860
VOLUME ["/data"]

ENTRYPOINT ["python3", "gradio_app.py"]

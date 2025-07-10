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

RUN pip install --upgrade pip
# Instalar dependencias principales primero para aprovechar la cache de Docker y evitar reinstalar paquetes grandes
COPY requirements.txt ./
RUN pip install torch==2.3.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.3.1+cu121 --extra-index-url https://download.pytorch.org/whl/cu121
RUN pip install -r requirements.txt
# Copiar el resto del contexto del proyecto al contenedor (ahorra tiempo si requirements.txt no cambia)
COPY --chown=hunyuan:hunyuan . .


# Precompilar renderizadores diferenciales si es necesario
RUN [ -f renderers/compile.sh ] && bash renderers/compile.sh || true
RUN [ -f custom_rasterizer/setup.py ] && cd custom_rasterizer && python setup.py install || true

# Puerto Gradio y volumen de datos
EXPOSE 7860
VOLUME ["/data"]

ENTRYPOINT ["python3", "gradio_app.py", "--server.port=7860", "--server.address=0.0.0.0"]

FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime

RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-venv build-essential \
    ffmpeg wget curl \
    libgl1-mesa-glx libglib2.0-0 \
    libsm6 libxrender1 libxext6 \
    && rm -rf /var/lib/apt/lists/* 

RUN useradd -ms /bin/bash hunyuan
USER hunyuan
WORKDIR /home/hunyuan

RUN python3 -m venv .venv
ENV PATH="/home/hunyuan/.venv/bin:$PATH"

RUN pip install --upgrade pip
COPY --chown=hunyuan:hunyuan . .
RUN pip install -r requirements.txt


RUN [ -f renderers/compile.sh ] && bash renderers/compile.sh || true
RUN [ -f custom_rasterizer/setup.py ] && cd custom_rasterizer && python setup.py install || true

EXPOSE 7860
VOLUME ["/data"]

ENTRYPOINT ["python3", "gradio_app.py", "--port=7860", "--host=0.0.0.0"]

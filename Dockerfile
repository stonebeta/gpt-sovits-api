# ---------- builder stage ----------
FROM python:3.10-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libsox-dev \
    ffmpeg \
    wget \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/RVC-Boss/GPT-SoVITS/archive/refs/heads/main.zip \
    && unzip main.zip \
    && mv GPT-SoVITS-main GPT-SoVITS \
    && rm main.zip

WORKDIR /GPT-SoVITS

RUN pip install --no-cache-dir -r extra-req.txt --no-deps \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir torchcodec


# ---------- runtime stage ----------
FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libsox-dev \
    ffmpeg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /GPT-SoVITS /GPT-SoVITS

WORKDIR /GPT-SoVITS

COPY ./pretrained_models GPT_SoVITS/pretrained_models
COPY ./G2PWModel GPT_SoVITS/text/G2PWModel

ENV CONFIG_PATH=/configs/tts_infer.yaml

EXPOSE 9880

CMD ["sh", "-c", "\
    if [ ! -f \"$CONFIG_PATH\" ]; then \
    echo \"Config not found, copying default...\"; \
    mkdir -p \"$(dirname \"$CONFIG_PATH\")\"; \
    cp GPT_SoVITS/configs/tts_infer.yaml \"$CONFIG_PATH\"; \
    fi && \
    chmod 777 \"$(dirname \"$CONFIG_PATH\")\" && \
    chmod 777 \"$CONFIG_PATH\" && \
    exec python api_v2.py -a 0.0.0.0 -p 9880 -c \"$CONFIG_PATH\""]

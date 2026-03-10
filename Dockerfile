# ---------- builder stage ----------
FROM python:3.10-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libsox-dev \
    wget \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/RVC-Boss/GPT-SoVITS/archive/refs/heads/main.zip \
    && unzip main.zip \
    && mv GPT-SoVITS-main GPT-SoVITS \
    && rm main.zip

WORKDIR /GPT-SoVITS

RUN pip install --no-cache-dir -r requirements.txt \
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

COPY pretrained_models GPT_SoVITS/pretrained_models
COPY G2PWModel GPT_SoVITS/text/G2PWModel
COPY averaged_perceptron_tagger_eng /root/nltk_data/taggers/averaged_perceptron_tagger_eng
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV CONFIG_PATH=/configs/tts_infer.yaml
ENV PUID=1000
ENV PGID=1000

EXPOSE 9880

ENTRYPOINT ["/entrypoint.sh"]
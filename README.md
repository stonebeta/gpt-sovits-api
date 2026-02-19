# GPT-SoVITS Docker API

这是为 [RVC-Boss/GPT-SoVITS](https://github.com/RVC-Boss/GPT-SoVITS) 项目的推理 API 构建的 Docker 镜像。

## 本地构建

要在本地构建，你需要准备以下内容：

1. 从 [GPT-SoVITS Models](https://huggingface.co/lj1995/GPT-SoVITS) 下载预训练模型，并将文件夹重命名为 `pretrained_models`
2. 从以下地址下载 G2PW 模型：  
   [G2PWModel.zip(HF)](https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip)  
   或  
   [G2PWModel.zip(ModelScope)](https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/G2PWModel.zip)  
   解压后将文件夹重命名为 `G2PWModel`
3. 将这些文件夹放置在当前目录下，然后构建 Docker 镜像。

在本地构建 Docker 镜像，运行：

```bash
docker build -t gpt-sovits-api .
```

运行容器：

```bash
docker run -d -p 9880:9880 gpt-sovits-api
```

## Docker Hub 镜像

更方便的方式是直接使用 Docker Hub 上的 blxckstone/gpt-sovits-api 镜像，该镜像已经内置了上述模型，因此无需手动准备模型文件。

拉取并运行 Docker Hub 镜像：

```bash
docker pull blxckstone/gpt-sovits-api
docker run -d -p 9880:9880 blxckstone/gpt-sovits-api
```

仓库中还包含一个 docker-compose.yml 文件，方便快速部署。

使用 Docker Compose 启动服务：

```bash
docker-compose up -d
```

## 注意
目前镜像尚未按照推理所需的依赖进行精简。

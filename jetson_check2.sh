#!/bin/bash

echo "🔍 Sprawdzanie systemu na Jetson Orin NX 16GB..."
echo "---------------------------------------------"

# Sprawdzanie wersji JetPack
echo "➡️ Sprawdzanie wersji JetPack..."
if [ -f "/etc/nv_tegra_release" ]; then
    JETPACK_VERSION=$(head -n 1 /etc/nv_tegra_release)
    echo "✅ JetPack: $JETPACK_VERSION"
else
    echo "❌ JetPack NIE znaleziony! Sprawdź instalację."
fi

# Sprawdzanie CUDA
echo "➡️ Sprawdzanie CUDA..."
if command -v nvcc &> /dev/null; then
    CUDA_VERSION=$(nvcc --version | grep release | awk '{print $6}')
    echo "✅ CUDA: $CUDA_VERSION"
else
    echo "❌ CUDA NIE jest zainstalowana! Sprawdź JetPack SDK."
fi

# Sprawdzanie cuDNN
echo "➡️ Sprawdzanie cuDNN..."
if [ -f "/usr/include/cudnn_version.h" ]; then
    cuDNN_VERSION=$(grep "#define CUDNN_MAJOR" /usr/include/cudnn_version.h | awk '{print $3}')
    echo "✅ cuDNN: v$cuDNN_VERSION"
else
    echo "❌ cuDNN NIE jest zainstalowany!"
fi

# Sprawdzanie TensorRT
echo "➡️ Sprawdzanie TensorRT..."
if command -v tensorrt &> /dev/null || ls /usr/lib/aarch64-linux-gnu/libnvinfer.so* 1>/dev/null 2>&1; then
    echo "✅ TensorRT jest zainstalowany."
else
    echo "❌ TensorRT NIE jest zainstalowany!"
fi

# Sprawdzanie sterowników NVIDIA i GPU
echo "➡️ Sprawdzanie sterowników NVIDIA..."
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
    echo "✅ Sterowniki NVIDIA działają!"
else
    echo "❌ NVIDIA-SMI NIE znalezione! Sprawdź sterowniki."
fi

# Sprawdzanie dostępności GPU
echo "➡️ Sprawdzanie dostępności GPU..."
if command -v tegrastats &> /dev/null; then
    tegrastats --interval 1000 --log-only &
    sleep 2
    pkill tegrastats
    echo "✅ GPU dostępne."
else
    echo "❌ GPU NIE dostępne! Może brakować sterowników."
fi

# Sprawdzanie Docker
echo "➡️ Sprawdzanie Docker..."
if command -v docker &> /dev/null; then
    echo "✅ Docker jest zainstalowany."
else
    echo "❌ Docker NIE jest zainstalowany!"
fi

# Sprawdzanie czy Docker działa
echo "➡️ Sprawdzanie, czy Docker działa..."
if systemctl is-active --quiet docker; then
    echo "✅ Docker działa poprawnie."
else
    echo "❌ Docker NIE działa! Uruchom: sudo systemctl start docker"
fi

# Sprawdzanie kontenerów Docker
echo "➡️ Sprawdzanie kontenerów Docker..."
if docker ps &> /dev/null; then
    if docker ps | grep -q "ollama"; then
        echo "✅ Kontener Ollama działa."
    else
        echo "❌ Kontener Ollama NIE działa! Uruchom: docker start ollama"
    fi

    if docker ps | grep -q "anythingllm"; then
        echo "✅ Kontener AnythingLLM działa."
    else
        echo "❌ Kontener AnythingLLM NIE działa! Uruchom: docker start anythingllm"
    fi
else
    echo "❌ Brak dostępu do Docker! Może być problem z uprawnieniami."
fi

# Sprawdzanie PyTorch
echo "➡️ Sprawdzanie PyTorch..."
PYTORCH_VERSION=$(python3 -c "import torch; print(torch.__version__)" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "✅ PyTorch: v$PYTORCH_VERSION"
else
    echo "❌ PyTorch NIE jest zainstalowany!"
fi

# Sprawdzanie torchvision
echo "➡️ Sprawdzanie torchvision..."
TORCHVISION_VERSION=$(python3 -c "import torchvision; print(torchvision.__version__)" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "✅ torchvision: v$TORCHVISION_VERSION"
else
    echo "❌ torchvision NIE jest zainstalowany!"
fi

# Sprawdzanie torchaudio
echo "➡️ Sprawdzanie torchaudio..."
TORCHAUDIO_VERSION=$(python3 -c "import torchaudio; print(getattr(torchaudio, '__version__', 'BRAK'))" 2>/dev/null)
if [ "$TORCHAUDIO_VERSION" != "BRAK" ]; then
    echo "✅ torchaudio: v$TORCHAUDIO_VERSION"
else
    echo "❌ torchaudio NIE jest zainstalowany!"
fi

# Sprawdzanie modeli w Ollama
echo "➡️ Sprawdzanie modeli w Ollama..."
if docker ps | grep -q "ollama"; then
    docker exec ollama ollama list &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Ollama działa i ładuje modele."
    else
        echo "❌ Ollama NIE odpowiada! Sprawdź kontener: docker logs ollama"
    fi
else
    echo "❌ Kontener Ollama NIE działa! Uruchom: docker start ollama"
fi

echo "✅ Sprawdzanie zakończone!"


#!/bin/bash
set -e

echo "Instalacja brakujących komponentów dla Nvidia Jetson Orin NX 16GB"
echo "-------------------------------------------"

# 1. Instalacja CUDA (nvcc)
echo "Sprawdzanie instalacji CUDA (nvcc)..."
if command -v nvcc >/dev/null 2>&1; then
    echo "CUDA jest już zainstalowane (nvcc dostępne)."
else
    echo "CUDA (nvcc) nie znaleziono."
    # Próba utworzenia symbolicznego linku jeśli katalog /usr/local/cuda-11.4 istnieje
    if [ -d "/usr/local/cuda-11.4" ]; then
        echo "Znaleziono /usr/local/cuda-11.4. Tworzenie symbolicznego linku /usr/local/cuda..."
        sudo ln -s /usr/local/cuda-11.4 /usr/local/cuda || true
        export PATH=/usr/local/cuda/bin:$PATH
        if command -v nvcc >/dev/null 2>&1; then
            echo "CUDA (nvcc) jest teraz dostępne po utworzeniu linku."
        else
            echo "Mimo utworzenia linku, nvcc nadal nie jest dostępne."
            echo "Proszę zainstalować CUDA Toolkit przy użyciu JetPack."
        fi
    else
        echo "Katalog /usr/local/cuda-11.4 nie został znaleziony."
        echo "Proszę zainstalować CUDA Toolkit przy użyciu JetPack."
    fi
fi
echo "-------------------------------------------"

# 2. Instalacja DeepStream
echo "Sprawdzanie instalacji DeepStream..."
if [ -d "/opt/nvidia/deepstream/deepstream" ]; then
    echo "DeepStream jest już zainstalowane."
else
    echo "DeepStream nie jest zainstalowane. Rozpoczynam instalację DeepStream."
    
    # Ustawienie URL do pakietu DeepStream – upewnij się, że wersja i link są aktualne
    DEEPSTREAM_URL="https://developer.download.nvidia.com/assets/Deepstream/DeepStream_6.1/Jetson/deepstream_6.1_6.1.1-1_arm64.deb"
    DEEPSTREAM_DEB="deepstream_6.1_6.1.1-1_arm64.deb"
    
    # Pobranie pakietu, jeśli nie został wcześniej pobrany
    if [ ! -f "$DEEPSTREAM_DEB" ]; then
        echo "Pobieranie DeepStream z $DEEPSTREAM_URL ..."
        wget $DEEPSTREAM_URL -O $DEEPSTREAM_DEB
    else
        echo "Plik $DEEPSTREAM_DEB już istnieje."
    fi
    
    echo "Instalacja DeepStream..."
    sudo dpkg -i $DEEPSTREAM_DEB || sudo apt-get install -f -y
    if [ -d "/opt/nvidia/deepstream/deepstream" ]; then
        echo "DeepStream został zainstalowany pomyślnie."
    else
        echo "Instalacja DeepStream nie powiodła się."
    fi
fi
echo "-------------------------------------------"

echo "Instalacja zakończona."


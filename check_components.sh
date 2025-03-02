#!/bin/bash

echo "Sprawdzanie komponentów dla Nvidia Jetson Orin NX 16GB"
echo "-------------------------------------------"

# 1. Sprawdzenie wersji L4T (Linux for Tegra)
if [ -f /etc/nv_tegra_release ]; then
  echo "L4T (Linux for Tegra):"
  cat /etc/nv_tegra_release
else
  echo "L4T: Nie znaleziono pliku /etc/nv_tegra_release"
fi
echo "-------------------------------------------"

# 2. Sprawdzenie instalacji CUDA
if command -v nvcc >/dev/null 2>&1; then
  echo "CUDA jest zainstalowane. Wersja:"
  nvcc --version
else
  echo "CUDA: nvcc nie jest zainstalowany."
fi
echo "-------------------------------------------"

# 3. Sprawdzenie instalacji cuDNN
CUDNN_LIB="/usr/lib/aarch64-linux-gnu/libcudnn.so"
if [ -f "$CUDNN_LIB" ]; then
  echo "cuDNN jest zainstalowane: $CUDNN_LIB"
  echo "Szczegóły pakietu (dpkg):"
  dpkg -l | grep -i cudnn
else
  echo "cuDNN: Biblioteka $CUDNN_LIB nie została znaleziona."
fi
echo "-------------------------------------------"

# 4. Sprawdzenie instalacji TensorRT
TENSORRT_LIB="/usr/lib/aarch64-linux-gnu/libnvinfer.so"
if [ -f "$TENSORRT_LIB" ]; then
  echo "TensorRT jest zainstalowane: $TENSORRT_LIB"
  echo "Szczegóły pakietu (dpkg):"
  dpkg -l | grep -i tensorrt
else
  echo "TensorRT: Biblioteka $TENSORRT_LIB nie została znaleziona."
fi
echo "-------------------------------------------"

# 5. Sprawdzenie instalacji OpenCV
if pkg-config --exists opencv4; then
  echo "OpenCV jest zainstalowane. Wersja:"
  pkg-config --modversion opencv4
else
  echo "OpenCV: Brak instalacji pkg-config dla OpenCV (opencv4)."
fi
echo "-------------------------------------------"

# 6. Sprawdzenie instalacji DeepStream (opcjonalnie)
if [ -d "/opt/nvidia/deepstream/deepstream" ]; then
  echo "DeepStream jest zainstalowane."
else
  echo "DeepStream: Nie znaleziono katalogu DeepStream."
fi
echo "-------------------------------------------"

echo "Sprawdzanie zakończone."


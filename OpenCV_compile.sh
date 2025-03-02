#!/bin/bash
set -e

# Wersje OpenCV
OPENCV_VERSION="4.7.0"

# Ścieżki instalacji
INSTALL_DIR="$HOME/opencv_build"

# Zainstaluj wymagane zależności
sudo apt update
sudo apt install -y build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev

# Utwórz katalog roboczy
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Pobierz źródła OpenCV i opencv_contrib
if [ ! -d "opencv" ]; then
    git clone -b ${OPENCV_VERSION} https://github.com/opencv/opencv.git
fi

if [ ! -d "opencv_contrib" ]; then
    git clone -b ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git
fi

# Utwórz katalog build i przejdź do niego
mkdir -p opencv/build && cd opencv/build

# Konfiguracja CMake z włączonym CUDA
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN="7.2" \
      -D CUDA_ARCH_PTX="" \
      -D WITH_CUBLAS=ON \
      -D ENABLE_FAST_MATH=1 \
      -D CUDA_FAST_MATH=1 \
      -D WITH_CUFFT=ON \
      -D WITH_NVCUVID=ON \
      -D BUILD_opencv_cudacodec=OFF \
      -D WITH_QT=OFF \
      -D WITH_OPENGL=ON \
      ..

# Budowanie (zależnie od zasobów Jetsona – 8 rdzeni lub więcej)
make -j$(nproc)
sudo make install
sudo ldconfig

echo "OpenCV z włączonym wsparciem CUDA zostało zainstalowane!"


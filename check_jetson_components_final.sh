#!/bin/bash
# Skrypt sprawdzający zainstalowane komponenty na Jetson Orin NX
# Wymagania: NVIDIA JetPack 5.1.2-b104
# Uruchom skrypt jako root lub użyj sudo, aby mieć pełen dostęp do informacji.

echo "--------------------------------------------------------"
echo "Sprawdzanie systemu Jetson Orin NX z NVIDIA JetPack 5.1.2-b104"
echo "--------------------------------------------------------"

# Sprawdzanie wersji L4T
if [ -f /etc/nv_tegra_release ]; then
    echo -n "Wersja L4T: "
    cat /etc/nv_tegra_release
else
    echo "Plik /etc/nv_tegra_release nie istnieje. Problem z instalacją L4T!"
fi

echo "--------------------------------------------------------"
# Sprawdzanie pakietu nvidia-jetpack
JETPACK=$(dpkg -l | grep nvidia-jetpack)
if [ -z "$JETPACK" ]; then
    echo "Pakiet nvidia-jetpack nie jest zainstalowany!"
    echo "Sugestia: Zainstaluj właściwą wersję pakietu: nvidia-jetpack-5.1.2-b104"
else
    echo "Zainstalowany pakiet nvidia-jetpack:"
    echo "$JETPACK"
fi

echo "--------------------------------------------------------"
# Sprawdzanie CUDA
if command -v nvcc &> /dev/null; then
    echo "CUDA jest zainstalowane. Wersja:"
    nvcc --version | grep release
else
    echo "CUDA nie jest zainstalowane!"
    echo "Sugestia: Zainstaluj CUDA zgodnie z wersją wymaganą przez NVIDIA JetPack."
fi

echo "--------------------------------------------------------"
# Sprawdzanie cuDNN
CUDNN=$(dpkg -l | grep libcudnn)
if [ -z "$CUDNN" ]; then
    echo "Pakiet cuDNN nie jest zainstalowany!"
    echo "Sugestia: Zainstaluj libcudnn zgodnie z dokumentacją NVIDIA dla Twojego JetPack."
else
    echo "Zainstalowany pakiet cuDNN:"
    echo "$CUDNN"
fi

echo "--------------------------------------------------------"
# Sprawdzanie TensorRT
TENSORRT=$(dpkg -l | grep tensorrt)
if [ -z "$TENSORRT" ]; then
    echo "Pakiet TensorRT nie jest zainstalowany!"
    echo "Sugestia: Zainstaluj TensorRT zgodnie z zaleceniami NVIDIA JetPack."
else
    echo "Zainstalowany pakiet TensorRT:"
    echo "$TENSORRT"
fi

echo "--------------------------------------------------------"
echo "Sprawdzanie kompatybilności wersji komponentów"

# Przykładowe sprawdzenie kompatybilności wersji CUDA
# Uwaga: Dla JetPack 5.1.2-b104 wersja CUDA może się różnić, sprawdź dokumentację NVIDIA dla dokładnych wymagań.
if command -v nvcc &> /dev/null; then
    CUDA_VERSION=$(nvcc --version 2>/dev/null | grep "release" | awk '{print $6}' | sed 's/,//')
    REQUIRED_CUDA="11.4"  # Przykładowa wymagana wersja; zaktualizuj zgodnie z dokumentacją
    # Pobranie numeru wersji głównej CUDA (pierwsze dwie liczby, np. 11.4)
CUDA_MAIN_VERSION=$(echo "$CUDA_VERSION" | awk -F '.' '{print $1"."$2}')

if [ "$CUDA_MAIN_VERSION" != "$REQUIRED_CUDA" ]; then
    echo "Błąd: Wykryto wersję CUDA $CUDA_VERSION, ale oczekiwana jest wersja $REQUIRED_CUDA."
    echo "Sugestia: Zainstaluj CUDA w wersji $REQUIRED_CUDA lub sprawdź kompatybilność w dokumentacji NVIDIA."
else
    echo "Wersja CUDA ($CUDA_VERSION) jest kompatybilna."
fi

fi

echo "--------------------------------------------------------"
echo "Skanowanie zakończone."


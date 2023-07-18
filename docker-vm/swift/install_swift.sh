# Veja https://github.com/erickweil/aprendendoswift/blob/main/Tutorial/Instalacao.md
# E também https://gist.github.com/Jswizzy/408af5829970f9eb18f9b45f891910bb

# Instalando as dependências como descrito em https://www.swift.org/download/#linux pelas instruções de Ubuntu 22.04
apt-get update
apt-get install \
          binutils \
          git \
          gnupg2 \
          libc6-dev \
          libcurl4-openssl-dev \
          libedit2 \
          libgcc-9-dev \
          libpython3.8 \
          libsqlite3-0 \
          libstdc++-9-dev \
          libxml2-dev \
          libz3-dev \
          pkg-config \
          tzdata \
          unzip \
          zlib1g-dev -y

# Baixando o pacote
wget https://download.swift.org/swift-5.8.1-release/ubuntu2204/swift-5.8.1-RELEASE/swift-5.8.1-RELEASE-ubuntu22.04.tar.gz

# Extraindo (irá extrair um diretório chamado 'usr')
tar xzf swift-5.8.1-RELEASE-ubuntu22.04.tar.gz

# Movendo o diretório extraído para um outro diretório qualquer
mv ./swift-5.8.1-RELEASE-ubuntu22.04 /usr/local/swift

# Adicionando o caminho do /usr/bin que foi extraído ao PATH
echo "export PATH=/usr/local/swift/usr/bin/:\$PATH" >> /etc/profile.d/10-swift.sh
source /etc/profile.d/10-swift.sh

swift -v
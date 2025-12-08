###################################
# Prerequisites

# Update the list of packages ->Actualizar la lista de paquetes.Actualiza la lista de paquetes disponibles desde los repositorios configurados en el sistema.
sudo apt-get update

# Install pre-requisite packages. ->Instalar los paquetes prerequisitos
sudo apt-get install -y wget apt-transport-https software-properties-common

# Get the version of Ubuntu ->Obtener la versión de Ubuntu.Carga las variables del archivo (/etc/os-release), donde está la versión de Ubuntu.
source /etc/os-release

# Download the Microsoft repository keys  ->Descargar las claves del repositorio de Microsoft.Descarga (silenciosamente con -q) el paquete .deb que contiene las claves y configuración del repositorio oficial de Microsoft para esa versión de Ubuntu.
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys ->Registrar las claves del repositorio de Microsoft.Instala el paquete descargado, registrando las claves y agregando el repositorio de Microsoft al sistema
sudo dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository keys file  -> Borrar el archivo de las claves del repositorio de Microsoft.Elimina el archivo .deb descargado, ya que después de instalarlo ya no es necesario.
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com  ->Vuelve a actualizar la lista de paquetes, esta vez incluyendo los paquetes del repositorio de Microsoft recién añadido.
sudo apt-get update

###################################
# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh
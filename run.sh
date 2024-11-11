#!/bin/bash

# Mensaje de ayuda

mostrar_ayuda() {
    echo "Uso: $0 [-s <archivo>] [-h]"
    echo
    echo "Opciones:"
    echo "  -s <archivo>   Especifica un archivo (ejemplo: .bashrc, .zshrc)"
    echo "  -h             Muestra esta ayuda y termina"
    exit 0
}

# Inicializamos las variables
archivo=".bashrc"

# Procesamos las opciones
while getopts "s:h" opt; do
    case $opt in
        s)
            archivo="$OPTARG"
            # Verificamos si el nombre del archivo tiene el formato correcto (empieza con . y tiene extensión)
            if [[ ! "$archivo" =~ ^\.[a-zA-Z0-9]+rc$ ]]; then
                echo "Error: El archivo debe tener un formato válido (ejemplo: .bashrc, .zshrc)"
                exit 1
            fi
            ;;
        h)
            mostrar_ayuda
            ;;
        \?)
            echo "Opción inválida: -$OPTARG" >&2
            mostrar_ayuda
            ;;
        :)
            echo "La opción -$OPTARG requiere un argumento." >&2
            mostrar_ayuda
            ;;
    esac
done

if [ ! -e "$HOME/$archivo" ]; then
    echo "El archivo '~/$archivo' NO existe. Debes indicar un archivo válido con el parámetro -s <file>"
    exit 1
fi

# Comprobamos si existe el directorio ~/.local/bin necesario para oh-my-posh (si no, lo creamos)
# Directorio a comprobar y crear si no existe
binpath="$HOME/.local/bin"

# Comprobamos si el directorio existe
if [ ! -d "$binpath" ]; then
    mkdir -p "$binpath"
fi

# Mensaje de bienvenida
echo "Iniciando Customize-shell"
echo "Descargando archivos necesarios..."

# Descarga e instalación de oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# Descarga de la fuente cascadia code
oh-my-posh font install CascadiaCode

echo "Archivos descargados. Configurando shell..."

# Establecemos la configuración
echo 'eval "$(oh-my-posh init bash --config ~/.customize-shell.theme.json)"' >> ~/$archivo

# Aplicamos la configuración
source  ~/$archivo

# Grabamos la configuración de oh-my-posh
cat <<EOF > ~/.customize-shell.theme.json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "palette": {
    "black": "#262B44",
    "blue": "#4B95E9",
    "green": "#59C9A5",
    "orange": "#F07623",
    "red": "#D81E5B",
    "white": "#E0DEF4",
    "yellow": "#F3AE35",
    "purple": "#B38CC7"
  },
  "secondary_prompt": {
    "template": "<p:yellow,transparent>\ue0b6</><,p:yellow> > </><p:yellow,transparent>\ue0b0</> ",
    "foreground": "p:black",
    "background": "transparent"
  },
  "transient_prompt": {
    "template": "<p:yellow,transparent>\ue0b6</><,p:yellow> {{ .Folder }} </><p:yellow,transparent>\ue0b0</> ",
    "foreground": "p:black",
    "background": "transparent"
  },
  "console_title_template": "{{ .Shell }} in {{ .Folder }}",
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "leading_diamond": "<p:yellow,background>\uf007</>",
          "template": " {{ if .SSHSession }}\ueba9 {{ end }}{{ .UserName }} ",
          "foreground": "p:yellow",
          "background": "transparent",
          "type": "session",
          "style": "diamond"
        },
        {
          "trailing_diamond": " ",
          "leading_diamond": "<>\uf0ac</>",
          "foreground": "p:purple",
          "background": "transparent",
          "type": "command",
          "style": "diamond",
          "properties": {
            "command": "hostname -I | awk '{print $1}'",
            "shell": "bash",
            "display_errors": false
          }
        },
        {
          "properties": {
            "style": "folder"
          },
          "template": " \uea83 {{ path .Path .Location }} ",
          "foreground": "p:blue",
          "powerline_symbol": "\ue0b0",
          "background": "transparent",
          "type": "path",
          "style": "powerline"
        },
        {
          "template": " \uf0e7 ",
          "foreground": "p:yellow",
          "powerline_symbol": "\ue0b0",
          "background": "transparent",
          "type": "root",
          "style": "powerline"
        },
        {
          "properties": {
            "always_enabled": true
          },
          "leading_diamond": "",
          "trailing_diamond": "<> $</>",
          "template": " {{ if gt .Code 0 }}\uf00d{{ else }}\uf00c{{ end }} ",
          "foreground": "p:green",
          "background": "transparent",
          "style": "diamond",
          "type": "status",
          "foreground_templates": [
            "{{ if gt .Code 0 }}p:red{{ end }}"
          ]
        }
      ]
    },
    {
      "type": "rprompt",
      "segments": [
        {
          "properties": {
            "display_mode": "files",
            "fetch_package_manager": false,
            "home_enabled": false
          },
          "template": "\ue718 ",
          "foreground": "p:green",
          "background": "transparent",
          "type": "node",
          "style": "plain"
        },
        {
          "properties": {
            "fetch_version": false
          },
          "template": "\ue626 ",
          "foreground": "p:blue",
          "background": "transparent",
          "type": "go",
          "style": "plain"
        },
        {
          "properties": {
            "display_mode": "files",
            "fetch_version": false,
            "fetch_virtual_env": false
          },
          "template": "\ue235 ",
          "foreground": "p:yellow",
          "background": "transparent",
          "type": "python",
          "style": "plain"
        },
        {
          "template": "in <p:blue><b>{{ .Name }}</b></> ",
          "foreground": "p:white",
          "background": "transparent",
          "type": "shell",
          "style": "plain"
        },
        {
          "template": "at <p:blue><b>{{ .CurrentDate | date \"15:04:05\" }}</b></>",
          "foreground": "p:white",
          "background": "transparent",
          "type": "time",
          "style": "plain"
        }
      ]
    }
  ],
  "tooltips": [
    {
      "properties": {
        "display_default": true
      },
      "leading_diamond": "\ue0b0",
      "trailing_diamond": "\ue0b4",
      "template": " \ue7ad {{ .Profile }}{{ if .Region }}@{{ .Region }}{{ end }} ",
      "foreground": "p:white",
      "background": "p:orange",
      "type": "aws",
      "style": "diamond",
      "tips": [
        "aws"
      ]
    },
    {
      "properties": {
        "display_default": true
      },
      "leading_diamond": "\ue0b0",
      "trailing_diamond": "\ue0b4",
      "template": " \uebd8 {{ .Name }} ",
      "foreground": "p:white",
      "background": "p:blue",
      "type": "az",
      "style": "diamond",
      "tips": [
        "az"
      ]
    }
  ],
  "version": 3,
  "final_space": true
}
EOF

echo "Configuración automática completada" 
echo "Sigue estos pasos para finalizar la configuración:"
echo " 1. Abre las preferencias de la terminal"
echo " 2. Haz clik sobre el perfil activo"
echo " 3. En la pestaña Texto selecciona la tipografía CaskaydiaCove Nerd Font a 12pt"
echo " 4. En la misma pestaña selecciona en la parte de Espaciado entre celdas una altura de 1,50"
echo " 5. En la pestaña Colores desmarca la casilla de Usar colores del tema del sistema"
echo " 6. En esta misma pestaña selecciona el Esquema incluído GNOME oscuro"
#!/bin/bash

if [ -z "$1" ]; then
  echo "Uso: $0 <dominio>"
  exit 1
fi

DOMAIN="$1"
DATA_HORA=$(date '+%Y-%m-%d %H:%M:%S')
OS=$(uname | tr '[:upper:]' '[:lower:]')

# Arquivos de saída
CSV_FILE="ips_${DOMAIN}.csv"
JSON_FILE="ips_${DOMAIN}.json"

# Inicia arquivos
echo "IP,Tipo,Org,Localização" > "$CSV_FILE"
echo "[" > "$JSON_FILE"

echo "📅 Data e Hora: $DATA_HORA"
echo "➡️  Sistema detectado: $OS"
echo

# Localização da máquina local
LOCAL_INFO=$(curl -s https://ipinfo.io)
MEU_IP=$(echo "$LOCAL_INFO" | grep -oP '"ip": *"\K[^"]+')
MEU_ORG=$(echo "$LOCAL_INFO" | grep -oP '"org": *"\K[^"]+')
MEU_CITY=$(echo "$LOCAL_INFO" | grep -oP '"city": *"\K[^"]+')
MEU_REGION=$(echo "$LOCAL_INFO" | grep -oP '"region": *"\K[^"]+')
MEU_COUNTRY=$(echo "$LOCAL_INFO" | grep -oP '"country": *"\K[^"]+')

echo "🌍 Localização da máquina local:"
echo "$LOCAL_INFO"
echo "-----------------------------"
echo

# Resolve IPs
IPV4s=""
IPV6s=""

if [[ "$OS" == "linux" || "$OS" == "darwin" ]]; then
  if command -v dig >/dev/null 2>&1; then
    echo "🌐 Resolvendo IPs usando dig..."
    IPV4s=$(dig +short A "$DOMAIN")
    IPV6s=$(dig +short AAAA "$DOMAIN")
  else
    echo "❌ dig não encontrado. Instale com: sudo apt install dnsutils"
    exit 1
  fi

elif [[ "$OS" == *"mingw"* || "$OS" == *"msys"* || "$OS" == *"cygwin"* ]]; then
  echo "🌐 Resolvendo IPs usando nslookup..."
  NSLOOKUP_RESULT=$(nslookup "$DOMAIN")

  IPV6s=$(echo "$NSLOOKUP_RESULT" | grep -oP '([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4}(:{2})?([0-9a-fA-F]{1,4})?' | sort -u | tr '\n' ' ')
  IPV4s=$(echo "$NSLOOKUP_RESULT" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -vE '127\.0\.0\.1')
else
  echo "❌ Sistema operacional não suportado: $OS"
  exit 1
fi

# Verifica se encontrou algum IP
if [ -z "$IPV4s" ] && [ -z "$IPV6s" ]; then
  echo "❌ Nenhum IP encontrado para $DOMAIN"
  exit 2
fi

# Função para consultar IP
function consulta_ip() {
  IP="$1"
  TIPO="$2"

  INFO=$(curl -s "https://ipinfo.io/$IP")

  ORG=$(echo "$INFO" | grep -oP '"org": *"\K[^"]+' || echo "N/A")
  CITY=$(echo "$INFO" | grep -oP '"city": *"\K[^"]+' || echo "N/A")
  REGION=$(echo "$INFO" | grep -oP '"region": *"\K[^"]+' || echo "N/A")
  COUNTRY=$(echo "$INFO" | grep -oP '"country": *"\K[^"]+' || echo "N/A")
  LOC=$(echo "$INFO" | grep -oP '"loc": *"\K[^"]+' || echo "N/A")
  POSTAL=$(echo "$INFO" | grep -oP '"postal": *"\K[^"]+' || echo "N/A")
  TIMEZONE=$(echo "$INFO" | grep -oP '"timezone": *"\K[^"]+' || echo "N/A")
  ANYCAST=$(echo "$INFO" | grep -oP '"anycast": *\K[^,]+' || echo "false")

  echo "➡️  $TIPO: $IP ($ORG — $CITY, $REGION, $COUNTRY)"

  # CSV
  echo "$IP,$TIPO,\"$ORG\",\"$CITY, $REGION, $COUNTRY\"" >> "$CSV_FILE"

  # JSON
  echo "  {" >> "$JSON_FILE"
  echo "    \"ip\": \"$IP\"," >> "$JSON_FILE"
  echo "    \"tipo\": \"$TIPO\"," >> "$JSON_FILE"
  echo "    \"org\": \"$ORG\"," >> "$JSON_FILE"
  echo "    \"city\": \"$CITY\"," >> "$JSON_FILE"
  echo "    \"region\": \"$REGION\"," >> "$JSON_FILE"
  echo "    \"country\": \"$COUNTRY\"," >> "$JSON_FILE"
  echo "    \"loc\": \"$LOC\"," >> "$JSON_FILE"
  echo "    \"postal\": \"$POSTAL\"," >> "$JSON_FILE"
  echo "    \"timezone\": \"$TIMEZONE\"," >> "$JSON_FILE"
  echo "    \"anycast\": $ANYCAST" >> "$JSON_FILE"
  echo "  }," >> "$JSON_FILE"

  # Se quiser exportar o JSON bruto de cada IP:
  echo "$INFO" > "whois_${IP}.json"
}

# Processa IPv4
if [ ! -z "$IPV4s" ]; then
  echo "🌐 IPv4 encontrados:"
  echo "$IPV4s"
  echo
  for ip in $IPV4s; do
    consulta_ip "$ip" "IPv4"
  done
fi

# Verifica se encontramos IPV6s válidos
if [ -n "$IPV6s" ]; then
  echo "🌐 IPv6 encontrados:"
  echo "$IPV6s"
  echo
  for ip in $IPV6s; do
    # Não modifica o IPv6
    consulta_ip "$ip" "IPv6"
  done
else
  echo "❌ Nenhum endereço IPv6 válido encontrado."
fi

# Remove vírgula extra e fecha JSON
sed -i '$ s/},/}/' "$JSON_FILE"
echo "]" >> "$JSON_FILE"

echo
echo "✅ Exportado:"
echo "  📄 CSV: $CSV_FILE"
echo "  📄 JSON: $JSON_FILE"

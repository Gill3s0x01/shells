# 📜 **Script info.sh**

## **Descrição**

O script `info.sh` resolve endereços IP de um domínio fornecido como argumento e coleta informações detalhadas sobre os endereços encontrados. Ele gera dois arquivos de saída:
- Um arquivo **CSV** com informações sobre os IPs encontrados.
- Um arquivo **JSON** com dados detalhados para cada IP.

Além disso, o script exibe informações sobre a sua máquina local e o resultado da resolução de IPs do domínio especificado.

---

## **Pré-requisitos** ⚙️

- **Sistemas suportados**: Linux, macOS ou Windows com subsistema de Linux (WSL).
- **Ferramenta `dig` ou `nslookup`**: O script utiliza uma dessas ferramentas para resolver os IPs do domínio. Caso esteja no Linux e precise instalar o `dig`, use o comando:

```bash
sudo apt install dnsutils

```

## **Instalação** 🔧

### 1. **Permissões de execução**:
Antes de rodar o script, é necessário garantir que ele tenha permissão de execução. Use o seguinte comando no terminal:

```bash
chmod +x info.sh
```
### 2. **Executando o script**:	
Para executar o script, utilize o seguinte comando no terminal, substituindo `dominio.com` pelo domínio desejado:

```bash	
./info.sh dominio.com
```
### 3. **Saída**:
Após a execução, o script irá gerar dois arquivos:
- `ips.csv`: Contém informações sobre os IPs encontrados.
- `ips.json`: Contém dados detalhados para cada IP.

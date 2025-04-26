# 📜 **Script info.sh**
```
              @@@@@@   @@@@@@           
               @@       @@          
                      @@                 
                   @@@             
T  H  E  (X)  G i l l 3 s 0 x 0 1       
                   @@@         
                 @@   @@     
                @@      @@        
              @@@@@@  @@@@@@ 
```
## **Description**

The info.sh script resolves IP addresses for a domain provided as an argument and collects detailed information about the found addresses. It generates two output files:
- A CSV file with information about the found IPs.
- A JSON file with detailed data for each IP.

Additionally, the script displays information about your local machine and the result of the IP resolution for the specified domain.

---

## **Prerequisites** ⚙️

- **Supported Systems**: Linux, macOS, or Windows with the Linux Subsystem (WSL).
- **`dig` or `nslookup` tool**: The script uses one of these tools to resolve the domain's IPs. If you're on Linux and need to install `dig`, use the following command:

```bash
sudo apt install dnsutils

```

## **Installation** 🔧

### 1. **Execution Permissions**:
Before running the script, you need to ensure it has execution permissions. Use the following command in the terminal:

```bash
chmod +x info.sh
```
### 2. **Running the script**:	
To run the script, use the following command in the terminal, replacing `dominio.com` with the desired domain:

```bash	
./info.sh dominio.com
```
### 3. **Output**:
After execution, the script will generate two files:
- `ips.csv`: Contains information about the found IPs.
- `ips.json`: Contains detailed data for each IP.

#!/usr/bin/env bash

echo -e "\n[vault environment] setup...\n";

sudo mkdir -p /export/appl/pkgs/.vault
sudo mkdir /etc/vault.d


hcl_uname=`python -c "import os;print os.uname()[1]"`
cat << EOF > /vagrant/$hcl_uname-read.hcl
path "secret/svc-accts/$hcl_uname/*" {
  capabilities = ["read"]
}
path "auth/token/lookup-self" {
  policy = "read"
}
path "auth/token/renew-self" {
  policy = "write"
}
EOF

cat << EOF > /tmp/vault.crt
-----BEGIN CERTIFICATE-----
MIIDVTCCAj2gAwIBAgIBCjANBgkqhkiG9w0BAQUFADB6MQswCQYDVQQGEwJVUzER
MA8GA1UECAwITWFyeWxhbmQxEjAQBgNVBAcMCUJhbHRpbW9yZTEVMBMGA1UECgwM
VC5Sb3dlIFByaWNlMQ8wDQYDVQQLDAZEZXZPcHMxHDAaBgNVBAMME2NhLXVidW50
dS0xNDA0LXZib3gwHhcNMTYwOTMwMTYyNTE0WhcNMTcwOTMwMTYyNTE0WjBjMRkw
FwYDVQQDDBB1YnVudHUtMTQwNC12Ym94MREwDwYDVQQIDAhNYXJ5bGFuZDELMAkG
A1UEBhMCVVMxFTATBgNVBAoMDFQuUm93ZSBQcmljZTEPMA0GA1UECwwGRGV2T3Bz
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvxrr2KqRTTeOAvw8/PKjGGA9C
0X7Nnp7Vlo4E3pbfGT0PKaQJhlZzF5dY5qxb0g4qzIbjaYut3ttEWEi6JFMYO4Fs
Y72laj/QAgxCyBoPWWN+KYAZ5KtufWItbuEriiKseCixvwYgxwZHpXZ09J2yeihe
X68x/mN6ijlDDKwjkQIDAQABo4GAMH4wCQYDVR0TBAIwADAdBgNVHQ4EFgQUQj5w
lVsPmEQNBHWBKFN65ra9lzIwHwYDVR0jBBgwFoAU6eMc7uYrtiZJg7q44D5HE+DJ
UdwwDwYDVR0RBAgwBocEfwAAATALBgNVHQ8EBAMCBaAwEwYDVR0lBAwwCgYIKwYB
BQUHAwEwDQYJKoZIhvcNAQEFBQADggEBAKz0hqMcKa1Lo+P7jdK00pWvS9OddQDp
vCWYa/7dGHTy2JRN2iAsssxOVewpOUg98wsLJi54rBzzMvdfbX316cNX5M9+PBqm
6b6FMgpb16eDSpHO/DY4UdB89UKKU4iNzB4nllXqidLuVH5c/SOW33qP5rqJmbDr
cLUF3tCIXhcuqt9z1RgvJQPc0od5FTA5f5BCWCzC2eJDxXI8yGSrrzyi37WmyzF5
f68wmbwsCZi4iQHt2vhVzSCv618LTJyILfoa2u1f5asTPsHsxxkNpspd9GutPI5s
EeNCHUMpdrmIETZej0boIKUffXqSb7ds8uI7BzNpJZA5igMNDr4ONsk=
-----END CERTIFICATE-----
EOF

cat << EOF > /tmp/vault.key
-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK/GuvYqpFNN44C/
Dz88qMYYD0LRfs2entWWjgTelt8ZPQ8ppAmGVnMXl1jmrFvSDirMhuNpi63e20RY
SLokUxg7gWxjvaVqP9ACDELIGg9ZY34pgBnkq259Yi1u4SuKIqx4KLG/BiDHBkel
dnT0nbJ6KF5frzH+Y3qKOUMMrCORAgMBAAECgYAbujuPzVYyldzHWFwtW4I8DVuK
7MUV5mmjw6YPepVOCAsrsyPfJMPKT/Rd37VcnpwBgFXe1a1k9fycoViHlGdO7g0+
kqkE3if5DdXUTsq/rhfyZoyidNtjnBzz0YlEe50XS6Pkg5dmvOjUs37+trNKKG5Z
MaKIAFF8nNEkbMxAAQJBAOjLyuhMohiRvYVjuIj0SSH9s6V7WgFfaSETBHLRY0BY
/+sbtbpEn2HraFwOQD77EKZzHkicCup3wGKRn9lBGgECQQDBS/nwIoaiCjXNwpZQ
zVvQSy7xMqKhbmFkauV38uiCAqftTMUoEe1z+TRD6s0CczboP69TdC7hw30uTCHX
ImmRAkEAq382g9uwrpjvHY1RLNOJ7NiRt58ft1Mqh4sTA+LtU0I9hl5rikVzhRd/
UhHNkpgys+yqqqMKB6EgwXy2Xb5wAQJACMiNCO5os8BHBZyL/Av42hQwg+FLJo6/
ejKpTrQJAK9iNhRA+TsnURfH2jY3Lp9RpWgPbXlgD/40GAB5oS79IQJAC+IchqOT
DM2RRcwthaPYxtI6VwAP9y0P4oxqEipyZdxzGHHzxYuqCWqiLjMNLDWtxzW/D2Hm
0VM+jy1CX0dbSQ==
-----END PRIVATE KEY-----
EOF

cat << EOF > /tmp/root.crt
-----BEGIN CERTIFICATE-----
MIIDxzCCAq+gAwIBAgIJAM6ANo09S1SnMA0GCSqGSIb3DQEBCwUAMHoxCzAJBgNV
BAYTAlVTMREwDwYDVQQIDAhNYXJ5bGFuZDESMBAGA1UEBwwJQmFsdGltb3JlMRUw
EwYDVQQKDAxULlJvd2UgUHJpY2UxDzANBgNVBAsMBkRldk9wczEcMBoGA1UEAwwT
Y2EtdWJ1bnR1LTE0MDQtdmJveDAeFw0xNjA5MzAxNjIzMTRaFw0yNjA5MjgxNjIz
MTRaMHoxCzAJBgNVBAYTAlVTMREwDwYDVQQIDAhNYXJ5bGFuZDESMBAGA1UEBwwJ
QmFsdGltb3JlMRUwEwYDVQQKDAxULlJvd2UgUHJpY2UxDzANBgNVBAsMBkRldk9w
czEcMBoGA1UEAwwTY2EtdWJ1bnR1LTE0MDQtdmJveDCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALz7tCAEhWYYAXwOmihy622P4QFIlD8xH39g4Mh/UuSn
FLyuv51gTD0JkvK5OjpD44lLiWUo71jOKdvBKKtEaVp4ykk8t/e3le3Q6MsTvJpa
LrdqvgpZjKxb5AcWLC0hjCl5+9QFSFqfXwoXqtsWzRRTYnSQnVPqtMmeXZios46h
FiIRmdIkm4GCpUdWTrtruvru/69nKQGuOws98yj+fCXmOZ+t0x1c4S7K+duPnDpR
kc8n+XhxFnkDvYCjJ3kqRqiEdlKo4sbiKSQqINNh4ZwBpfvV0QRRYCebL4fl+vQG
F4RhAwJ+3d+6RdhF+0RgVzzJrfFbhSjqeBc1yR155DsCAwEAAaNQME4wHQYDVR0O
BBYEFOnjHO7mK7YmSYO6uOA+RxPgyVHcMB8GA1UdIwQYMBaAFOnjHO7mK7YmSYO6
uOA+RxPgyVHcMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAHyTTAJs
kGvW2vvEkSFSpzS+3N3Hu0kCcUPrfzb1ljA/Po4XHdyO+hiY8swmuY3TMWfIC0/f
D4YPLinm94v6gefCQERQCLnwjdKBIL0Af0pcRvXQWvTorMxRkU2pRMJntW+EpcxP
O0FX5dW2A9BbBxbDo8kdvOslH6ZAXC6Ls9wUIICaGaFCsXbZeXHvAb0seFDGYSNG
/t2bJKtOasFCRR8DNmmXwfMKimCuOc8knfJaUXprgx1AJmJZFLut+F5YfyxkGVlg
sXgRzL2j5uKIoFKzPeZdLIC+0J/bEq86+0UUnaMLIMHHlsNRqa7rZPNPZTf8yPJD
PIbFGYIonHR99rA=
-----END CERTIFICATE-----
EOF

cat << EOF > /tmp/vault.json
{
  "disable_mlock": true,
  "default_lease_ttl": "24h",
  "max_lease_ttl": "24h",
  "backend": {
    "file":{
      "path":"/tmp"
    }
  },
  "listener": {
    "tcp": {
      "address":"127.0.0.1:8200",
      "tls_cert_file":"/etc/vault.d/vault.crt",
      "tls_key_file":"/etc/vault.d/vault.key"
     }
  }
}
EOF

sudo mv /tmp/vault.* /etc/vault.d
sudo cp /tmp/root.crt /export/appl/pkgs/.vault/
sudo cp /tmp/root.crt /etc/vault.d

cat << EOF > /tmp/cacert.crt
-----BEGIN CERTIFICATE-----
MIIJwDCCB6igAwIBAgITXwAAABnOZvBC8H6Q0wAAAAAAGTANBgkqhkiG9w0BAQUF
ADB0MRMwEQYKCZImiZPyLGQBGRYDbmV0MRowGAYKCZImiZPyLGQBGRYKdHJvd2Vw
cmljZTEUMBIGCgmSJomT8ixkARkWBGNvcnAxKzApBgNVBAMTIlQuIFJvd2UgUHJp
Y2UgSW50ZXJuYWwgUEtJIFJvb3QgQ0EwHhcNMTUwMjA5MTkxNTQwWhcNMjUwMjA5
MTkyNTQwWjBwMRMwEQYKCZImiZPyLGQBGRYDbmV0MRowGAYKCZImiZPyLGQBGRYK
dHJvd2VwcmljZTEUMBIGCgmSJomT8ixkARkWBGNvcnAxJzAlBgNVBAMTHlQuIFJv
d2UgUHJpY2UgSW50ZXJuYWwgUEtJIENBMTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
ADCCAgoCggIBANlxHq2pRQY7v0HgxGbfmip4bREcsiPtf56Ljf5F9H6dbG3ZBOes
WXbxhVccxNKPhuaR1Onkig+iQwwNhp7EqI4Kq22M6PwfX3ri27250Ykeo9VU7IB5
xk4I4x6CyazeJo13f05WZi2DEDlsdMjz0GnhbcMQ+mLdOiVqY1xUOsSBesqnUWKq
65m3ilEOMntZAGiA+3ZYiHKUZNt3bpiAXL5aggjCxnKIFiZ2g2ijEMph7OcIp5FQ
gscB2wqYvTn6ca3ayRaWoAxy8Sq5nEhFFD72N1uOrjAgMXq6HOqKH5ou6NKiq1Nm
1JCT+g/ZHpKk3b+icT7re1NB+snPAaC0gG5YjbbXGwvby2fxabt0PT3nBdBJq9Jl
hACLKi8mazcEzU1PaXx55ob/sp+EYqGriD2wHifxzpbRccXhX3qSlr1sTpzdO3fI
B+zwyczWxjtVvfSoMAb+jegGxcOLcMVlHPOugyH49crDLntN/p76jcfHnhbnS17U
vISCiPpnAk2aPw6mhmvz1VnXxsKkRJmEA8WoGaNJaGY18wJRL65BZrdqiu0BgPiq
0Vo8Q0ON0a2MSD68nbwfKw4F6fmg1TMOHABDHGv8/w/souL/Gk4J80RciB7ltxta
PiTe18enNyi0IVUwuGDNqBlulUbN+YKG+NVw4HfECWHBPdcifcqnCITjAgMBAAGj
ggRNMIIESTAQBgkrBgEEAYI3FQEEAwIBATAjBgkrBgEEAYI3FQIEFgQUR+kzxWR+
jAIiuh/R+z0xV7N4bGMwHQYDVR0OBBYEFAsInzjr6h32arb7n2rdMQu6OvhzMIHO
BgNVHSAEgcYwgcMwgcAGCysGAQQBgoYICgEBMIGwMEoGCCsGAQUFBwICMD4ePABU
AC4AIABSAG8AdwBlACAAUAByAGkAYwBlACAASQBuAHQAZQByAG4AYQBsACAAUABL
AEkAIABDAFAAUzBiBggrBgEFBQcCARZWaHR0cDovL29tdGNwMTAwNzguY29ycC50
cm93ZXByaWNlLm5ldC9DZXJ0RW5yb2xsL1BvbGljaWVzL1RSUF9JbnRlcm5hbF9Q
S0lfQ0FfQ1BTLnBkZgAwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0P
BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQEwHwYDVR0jBBgwFoAUXb/A4y8kY4jw
+jrxfOFmslfy4Y0wggFcBgNVHR8EggFTMIIBTzCCAUugggFHoIIBQ4aB22xkYXA6
Ly8vQ049VC4lMjBSb3dlJTIwUHJpY2UlMjBJbnRlcm5hbCUyMFBLSSUyMFJvb3Ql
MjBDQSxDTj1PTVRDUDEwMDc3LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2
aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXRyb3dlcHJpY2Us
REM9bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFz
cz1jUkxEaXN0cmlidXRpb25Qb2ludIZjaHR0cDovL29tdGNwMTAwNzguY29ycC50
cm93ZXByaWNlLm5ldC9DZXJ0RW5yb2xsL1QuJTIwUm93ZSUyMFByaWNlJTIwSW50
ZXJuYWwlMjBQS0klMjBSb290JTIwQ0EuY3JsMIIBYQYIKwYBBQUHAQEEggFTMIIB
TzCB0AYIKwYBBQUHMAKGgcNsZGFwOi8vL0NOPVQuJTIwUm93ZSUyMFByaWNlJTIw
SW50ZXJuYWwlMjBQS0klMjBSb290JTIwQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtl
eSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9dHJv
d2VwcmljZSxEQz1uZXQ/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNl
cnRpZmljYXRpb25BdXRob3JpdHkwegYIKwYBBQUHMAKGbmh0dHA6Ly9vbXRjcDEw
MDc4LmNvcnAudHJvd2VwcmljZS5uZXQvQ2VydEVucm9sbC9PTVRDUDEwMDc3X1Qu
JTIwUm93ZSUyMFByaWNlJTIwSW50ZXJuYWwlMjBQS0klMjBSb290JTIwQ0EuY3J0
MA0GCSqGSIb3DQEBBQUAA4ICAQAgMqcid+6IEaLZvoofZ9LOm9LkrdMrNFQMDmd9
Bqp66A+DOI0N1E1bpFTVQCcgzeByihObbCm2slQoHYnPHEXv9UU7wNg3zuqN8s1S
Pmx/GX3mw35MMeEvDUCk8aHIk03CBaB3oCcxsdWh2PUSRCd/nIk5aDlU39qN1tqs
+/Tjm/g6mQef4OOaC+sSFcDVdiRF2Yxk9+50GMIWC6/BbjtNYgHmLysey6TKgUSG
PH18DN/5EHAUlBuW0Lz13gSlHDlsME0zdkFfqJmIeKyPZsc1+fXktGALIIlVfOXf
stiASWcxaIzSQRRWKC10oLHpYSW8YHSalVn+sbemWOksT/+RM5MwUIuhIdmcD5es
IMtgpDL0/yPwuPZ45jcejGEmt9ZCcCvFyDK1EPWDGVulREGoINhZ5v4bD0xqAf2w
EU2KZRvjAMDcCP2YNQSuEpPLJeohpV1eQPW48jjCGstxEWdwqEqh8llkwv8k6DB9
QSiChfjoHzMT4d3xiZsZcDs+6VMfAXo9AaaSGYL61KlS5OEEBHZ05ikeMuq4w8OW
B3l85KuDaq2G+jkR8T8jt3fVkAdv6dKGnrz8eOgeElgZsAvQQEElwd40BvIO9yZz
gM7Ell+Y65ez+HvV9PEu7JMh2/8ZQd8mwOmH/oB1bKXcwUnAnO3a4j5FD6BiXX3h
VDYMwg==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIGmjCCBIKgAwIBAgIQCHNATFN05qdNxDo46X9pETANBgkqhkiG9w0BAQUFADB0
MRMwEQYKCZImiZPyLGQBGRYDbmV0MRowGAYKCZImiZPyLGQBGRYKdHJvd2Vwcmlj
ZTEUMBIGCgmSJomT8ixkARkWBGNvcnAxKzApBgNVBAMTIlQuIFJvd2UgUHJpY2Ug
SW50ZXJuYWwgUEtJIFJvb3QgQ0EwHhcNMDkwNzMxMTkxNzQ3WhcNMjkwNzMxMTky
NjQ1WjB0MRMwEQYKCZImiZPyLGQBGRYDbmV0MRowGAYKCZImiZPyLGQBGRYKdHJv
d2VwcmljZTEUMBIGCgmSJomT8ixkARkWBGNvcnAxKzApBgNVBAMTIlQuIFJvd2Ug
UHJpY2UgSW50ZXJuYWwgUEtJIFJvb3QgQ0EwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQCbMg2fd3qEfInKzGU/EqadxBKg2w/ExmyiMs93qJqWxe6QPKKb
V5PenVM/gxHTBrL6+vaOLZj8P9uwklloD3hWHAWCzA9Af9SyZXYiNyVrA5pmmg7j
NpJUvloShLhjpE/a1CHFPeGcgc4Fo4Hb4LUyEF1yJHVPJ4j78HiNAXI5WpG4WH9m
Bf3fpDCAn8BMLuUEG+YW2Cqg5K7XU/Lcl8V4E/HHZtkcXEEtHJrhLNRyFrh4Td3X
xaWOfxsbV+cy0KlfPCsYz3pwS1bnALpcuJKb9nmNC6ST9bXW1tDkD+7D6S26q4c1
RO63xW9U2eNFHIuOqvDYz5jwas9EOAKj8aKO2/T07JCYhjymNw4emd53D5zwY8G6
1bNlurTzOjCuesNgShnIcb1EQfwk2UeiEwR9wHPRBkTVQwxRGFjdCsLE2wFZS1n6
0ocLFgs+kVBJARjBwt4Ikw+HExOcnoNU7LsvU6/hIt9H4OvIoHRK2Pb/tjuJ4C3J
jjAjabBB/wgVqVG8P6w4nUdqJ5vtlky49e0IZqZna3OMjI+dMGI5yZVXhhMRLN1V
5MfnPDxPt0aAdXTxqAl19/BXEdaaZqEGJW5X+70qe9e88rIE1XPCfm3iOFLZhfWH
hygd7pGlLNALC+YieLoYY/faIBc5J3RNOAV1bncmmXBrYlMoEEOoU6emAQIDAQAB
o4IBJjCCASIwCwYDVR0PBAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQQwHQYDVR0O
BBYEFF2/wOMvJGOI8Po68XzhZrJX8uGNMBAGCSsGAQQBgjcVAQQDAgEAMIHNBgNV
HSAEgcUwgcIwgb8GCysGAQQBgoYICgEBMIGvMEoGCCsGAQUFBwICMD4ePABUAC4A
IABSAG8AdwBlACAAUAByAGkAYwBlACAASQBuAHQAZQByAG4AYQBsACAAUABLAEkA
IABDAFAAUzBhBggrBgEFBQcCARZVaHR0cDovL29tdGNwMTAwNzguY29ycC50cm93
ZXByaWNlLm5ldC9DZXJ0RW5yb2xsL1BvbGljaWVzL1RSUF9JbnRlcm5hbF9QS0lf
Q0FfQ1BTLnBkZjANBgkqhkiG9w0BAQUFAAOCAgEAliVU/K8hlrqV+eEpvdmgqFfz
JJ3qosVQTW7cxc3mej6bMbTyNEfYV/AaGHTyTr0CRyCa8szrr3hoa3Agr9JW700G
eGZGiloM+I042ZdYtr0DAH8b9NOnimUX90ogYF7orwTvvWVWKjZx17SCPHalsSpP
rCgmutyh318fuEE+LGCeldF2x6zEECTnB973vDSht1BZkWg2iUrd2CASL84l8Pyh
cXSYQSpDNym7VSkGIDmY5ATWYuIy2/PqDL1NdWhbbEBd6EXutE7jqcuBqIRdvixf
aAwEXUdxGSO544pVQOgy2uO9e7DAIuzdy5E8A4lmjFNjaRYbaTSS00MjC/vhm2Tr
PsEiwftyRNuTbYvZgTk3QpJyYtqbprA4PVvx8EApawqjjeLgz57waX7vDAYkzng/
GGIzVF1va2PeA9SclfynTt2A/e5T8f2IJhYmoQecxS8sZMRniRa5yDXBvqACwo6R
kKt4q9SHRATTmzeWLd2lzz38FMRBSCBNzWp7iYGgAl7wUodEj8x0m6/PJgPncVaJ
QVx4PIvRWr1Qm1bP2rGM1XYzHjSyXARYuKhSQw9RsfcnBHhYPiIKYWjRrXeiQ1G5
G51ETu/Uqm0BwdoDdf+9Ce0DH3j5FB6PkL9rKsCzlCtuev54Nw+6C/GABtGlncUg
tdkhcUbrM1CO4UptzMw=
-----END CERTIFICATE-----
EOF

cat << EOF > /tmp/vault.service
[Unit]
Description=vault server
Requires=network-online.target
#After=network-online.target consul.service

[Service]
EnvironmentFile=-/etc/service/vault
Environment=GOMAXPROCS=`nproc`
Restart=on-failure
ExecStart=/usr/local/bin/vault server $OPTIONS -config=/etc/vault.d >> /var/log/vault.log 2>&1
ExecStartPost=/bin/bash -c "for key in $KEYS; do /usr/local/sbin/vault unseal $CERT $key; done"

[Install]
WantedBy=multi-user.target
EOF

sudo chown root:root /tmp/vault.service
sudo mv /tmp/vault.service /etc/systemd/system/vault.service
sudo chmod 0644 /etc/systemd/system/vault.service
sudo systemctl daemon-reload
sudo systemctl enable vault.service
sudo systemctl start vault.service

sudo cp /tmp/root.crt /usr/local/share/ca-certificates/
sudo cp /tmp/cacert.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

echo -e "\n[vault environment] setup completed ;) \n";

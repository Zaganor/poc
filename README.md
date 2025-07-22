# Ambiente de Datacenter e automação de tarefas

Este projeto propõe a implementação de uma rede de data center baseada na arquitetura CLOS (Spine-Leaf), utilizando tecnologias como EVPN-VXLAN para segmentação de redes virtuais sobre uma infraestrutura L3.

Com foco na automação, a solução recorre ao Ansible, scripts de Python e templates Jinja2 para a orquestração de configurações e ao NetBox como fonte central de informação da infraestrutura de rede. Recorre tambem às ferramentas Prometheus e Grafana para monotorização da rede.

## Configuração

A configuração é dividida em duas partes: Configração do Netbox com os equipamentos e outras informações usadas na rede(Ex.: ASNs, VRFs, etc) e a configuração dos dispositivos do containerLab.

###  Configração do Netbox



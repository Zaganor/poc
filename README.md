# Ambiente de Datacenter e automação de tarefas

Nota: Este Projeto fornece apenas como serviço conectividade entre Hosts, através do uso de EPVN-VXLANs. Foram usados MAC-VRFS estando excluido o uso de IP-VRFs e IRBs.

Este projeto propõe a implementação de uma rede de data center baseada na arquitetura CLOS (Spine-Leaf), utilizando tecnologias como EVPN-VXLAN para segmentação de redes virtuais sobre uma infraestrutura L3.

Com foco na automação, a solução recorre ao Ansible, scripts de Python e templates Jinja2 para a orquestração de configurações e ao NetBox como fonte central de informação da infraestrutura de rede. Recorre tambem às ferramentas Prometheus e Grafana para monotorização da rede.

<img width="2000" height="1031" alt="projeto-arch drawio" src="https://github.com/user-attachments/assets/fd65e6b2-bd25-4dc9-bd2b-92e5ef045b47" />

## Configuração

A configuração é dividida em duas partes: Configração do Netbox com os equipamentos e outras informações usadas na rede(Ex.: ASNs, VRFs, etc) e a configuração dos dispositivos do containerLab.

Primeiramente, para arrancar com a topologia e os serviços a esta associados é necessario correr o comando ```sudo clab deploy -t topologia.clab.yml```

###  Configração do Netbox

A configuração do netbox é feita a partir dos playbooks Ansible disponiveis na diretoria [`Populate`](/Populate). Este playbooks tem de ser alterados manualmente para a a introdução de novos dados, caso por exemplo seja necessario acrescentar um novo router a topologia será necessario ir ao ficheiro device.yml, adicionar esse router novo com as suas informações pretendidas e correr o playbook [`devices.yml`](/Populate/devices.yml).

Para o inicio da topologia temos o ficheiro [`main.yml`](/Populate/main.yml) que faz a população do netbox com 5 equipamentos e as suas informações necessarias.
Este ficheiro é executado através do comando ```sudo ansible-playbook -i netbox_inventory.yml -c ansible.netcommon.httpapi -e "ansible_network_os=nokia.srlinux.srlinux" -e "ansible_user=admin" -e "ansible_password=NokiaSrl1!" main.yml```.

### Configuração dos Dispositivos no containerLab

A configuração da topologia no containerLab é feita a partir das informações fornecidas pelo Netbox.

O acesso do Netbox é feito a partir de playbooks Ansible que acessam ao API da Netbox retirando a informação pretinente, que é usada em conjunto com templates Jinja2 para a criação dos vars_files que contem toda a informação necessaria para a configuração dos dispositivos SR Linux usados na na nossa [`topologia.clab.yml`](topologia.clab.yml).

Os playbooks foram feitos de forma dinamica, ou seja, qualquer alteração no Netbox irá alterar os vars_files.

Para fazer a configuração é usado apenas o ficheiro [`main.yml`](/Automation-srlinux/main.yml) presente na diretoria [`Automation-srlinux`](/Automation-srlinux).
Este ficheiro é executado tambem através do comando ```sudo ansible-playbook -i netbox_inventory.yml -c ansible.netcommon.httpapi -e "ansible_network_os=nokia.srlinux.srlinux" -e "ansible_user=admin" -e "ansible_password=NokiaSrl1!" main.yml```.

### Monitorização da Rede

A monitorização da rede estará disponivel nos seguintes endereços:

**Prometheus** : ```http://localhost:9090/targets?search=```

  Neste link, é possível visualizar os targets (alvos) que o Prometheus está a monitorizar e confirmar se estão ativos. A interface mostra, por exemplo, o endpoint ```http://gnmic:9273/metrics``` com o estado ```UP```, o que indica que o Prometheus está a recolher métricas com sucesso desse serviço.
 [ é fundamental seguir os passos a cima para um bom funcionamento dos _dashboards_ criados no grafana ].
 Para consultar estas métricas pode-se consultar o link ```http://localhost:9273```

**Grafana** : ```http://localhost:3000```
  É necessário fazer um login com as credenciais default do Grafana: ```admin / admin```.
  De seguida, os _dashboards_ podem ser encontrados na página ```http://localhost:3000/dashboards```

## Organização por fases

```mermaid
flowchart TD
  %% Título como nó separado para Day 0
  title0[Day 0: Planeamento e Design]

  subgraph Day_0_subgraph
    A1[Requisitos e Objetivos]
    A2[Design da Topologia CLOS]
    A3[Escolha de Ferramentas: Ansible, NetBox]
    A4[Criação de YAML com topologia]
    A5[População do NetBox via Ansible]
    A6[Testes e PoC]
    A7[Runbooks e Documentação]
    A1 --> A2 --> A3 --> A4 --> A5 --> A6 --> A7
  end

  title0 --> A1

  %% Day 1
  title1[Day 1: Deployment e Configuração Inicial]

  subgraph Day_1_subgraph
    B1[Provisionamento de Infra]
    B2[Leitura de dados do NetBox via API]
    B3[Geração de Configs via Ansible + Templates]
    B4[Deploy automatizado da topologia]
    B5[Validação de conectividade]
    B6[Handover para operações]
    B1 --> B2 --> B3 --> B4 --> B5 --> B6
  end

  A7 --> title1
  title1 --> B1

  %% Day 2
  title2[Day 2: Operação, Manutenção e Otimização]

  subgraph Day_2_subgraph
    C1[Monitorização e Alertas - Grafana, Prometheus]
    C2[Gestão de alterações]
    C3[Refino de automações e pipelines]
    C4[Updates no NetBox]
    C5[Planeamento de expansões]
    C6[Feedback → Day 0]
    C1 --> C2 --> C3 --> C4 --> C5 --> C6
  end

  B6 --> title2
  title2 --> C1
  C6 --> A1

```



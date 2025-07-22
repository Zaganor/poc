# Ambiente de Datacenter e automação de tarefas

Este projeto propõe a implementação de uma rede de data center baseada na arquitetura CLOS (Spine-Leaf), utilizando tecnologias como EVPN-VXLAN para segmentação de redes virtuais sobre uma infraestrutura L3.

Com foco na automação, a solução recorre ao Ansible, scripts de Python e templates Jinja2 para a orquestração de configurações e ao NetBox como fonte central de informação da infraestrutura de rede. Recorre tambem às ferramentas Prometheus e Grafana para monotorização da rede.

![](integraçãodeferramentas.png)

## Configuração

A configuração é dividida em duas partes: Configração do Netbox com os equipamentos e outras informações usadas na rede(Ex.: ASNs, VRFs, etc) e a configuração dos dispositivos do containerLab.

###  Configração do Netbox

A configuração do netbox é feita a partir dos playbooks Ansible disponiveis na diretoria [`Populate`](/Populate). Este playbooks tem de ser alterados manualmente para a a introdução de novos dados, caso por exemplo seja necessario acrescentar um novo router a topologia será necessario ir ao ficheiro device.yml, adicionar esse router novo com as suas informações pretendidas e correr o playbook [`devices.yml`](/Populate/devices.yml).

Para o inicio da topologia temos o ficheiro [`main.yml`](/Populate/main.yml) que faz a população do netbox com 5 equipamentos e as suas informações necessarias.

### Configuração dos Dispositivos no containerLab

A configuração da topologia no containerLab é feita a partir das informações fornecidas pelo Netbox.

O acesso do Netbox é feito a partir de playbooks Ansible que acessam ao API da Netbox retirando a informação pretinente, que é usada em conjunto com templates Jinja2 para a criação dos vars_files que contem toda a infomraçao necessaria para a configuração dos dispositivos SR Linux usados na na nossa [`topologia.clab.yml`](topologia.clab.yml).

Os playbooks foram feitos de forma dinamica, ou seja, qualquer alteração no Netbox irá alterar os vars_files.

Para fazer a configuração é usado apenas o ficheiro [`main.yml`](/Automation-srlinux/main.yml) presente na diretoria [`Automation-srlinux`](/Automation-srlinux).

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



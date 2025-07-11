```mermaid
flowchart TD
  subgraph Day_0[Day 0: Planeamento e Design]
    A1[Requisitos e Objetivos]
    A2[Design da Topologia CLOS]
    A3[Escolha de Ferramentas: Ansible, NetBox]
    A4[Criação de YAML com topologia]
    A5[População do NetBox via Ansible]
    A6[Testes e PoC]
    A7[Runbooks e Documentação]
    A1 --> A2 --> A3 --> A4 --> A5 --> A6 --> A7
  end

  subgraph Day_1[Day 1: Deployment e Configuração Inicial]
    B1[Provisionamento de Infra (ZTP, OS, cablagem)]
    B2[Leitura de dados do NetBox via API]
    B3[Geração de Configs via Ansible + Templates]
    B4[Deploy automatizado da topologia]
    B5[Validação de conectividade]
    B6[Handover para operações]
    A7 --> B1
    B1 --> B2 --> B3 --> B4 --> B5 --> B6
  end

  subgraph Day_2[Day 2: Operação, Manutenção e Otimização]
    C1[Monitorização e Alertas (Zabbix, Prometheus)]
    C2[Gestão de alterações e config drift]
    C3[Refino de automações e pipelines]
    C4[Updates no NetBox]
    C5[Planeamento de expansões]
    C6[Feedback → Day 0]
    B6 --> C1
    C1 --> C2 --> C3 --> C4 --> C5 --> C6 --> A1
  end
```

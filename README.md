# Projet d'Infrastructure Multi-Machines

Ce projet configure une infrastructure multi-machines en utilisant Vagrant et des scripts Bash. Il inclut un répartiteur de charge, des serveurs web et une configuration de base de données en mode maître-esclave.

## Structure du Projet

```
multi-machine-infrastructure
├── scripts
│    ├── setup_lb.sh
│    ├── setup_web.sh
│    └── setup_db_master.sh
|    |___setup_db_slave.sh
|    |___setup_monitoring.sh
|    |___setup_node_exporter.sh
├── Vagrantfile
└── README.md
```

## Machines Virtuelles

Les machines virtuelles suivantes sont configurées dans ce projet :

- lb : Répartiteur de charge avec une IP statique 192.168.56.10
- web1 : Serveur Web 1 avec une IP statique 192.168.56.11
- web2 : Serveur Web 2 avec une IP statique 192.168.56.12 
- db-master : Base de données maître avec une IP statique 192.168.56.13
- db-slave : Base de données esclave avec une IP statique 192.168.56.14
- monitoring : Serveur de monitoring avec une IP statique 192.168.56.15
- client : Machine cliente avec une IP statique  192.168.56.16

## Instructions d'Installation

1. Assurez-vous que Vagrant et VirtualBox sont installés sur votre machine.
2. Clonez ce dépôt sur votre machine locale.
3. Accédez au répertoire du projet :
   ```
   cd multi-machine-infrastructure
   ```
4. Exécutez la commande suivante pour démarrer et provisionner les machines virtuelles :
   ```
   vagrant up
   ```

## Utilisation

Après avoir exécuté `vagrant up`, les services suivants seront disponibles :

- Le répartiteur de charge ( (loadBalanceur nommé lb)) distribuera le trafic entre les serveurs web, un mappage de ports a 
  été fait avec l'hôte, pour avoir le formulaire de saisie il faut taper l'url suivant http://localhost:8083
  le loadbalance contactera ainsi soit le web1 ou web 2, l'adresse ip du serveur web contacté est affiché sur juste à droite
  du formulaire.
- La base de données maitre installée sur db_master  reçoit en premier les donneées du formulaire. Ces données sont automatiquement
  repliquées sur le db_slave.

  -vous pouvez egalement vous connecter à la machine client en tapant la commande : vagrant ssh client
   une fois connecté faites curl http://192.168.56.10 --> le formulaire sera affiché en mode texte montrant ainsi la bonne connectivité entre le
   client et le loadbalancer.
  - Pour egalement la recolte des metrics, prometheus et grafana installé sur la machine monitoring. Ils  sont acccessible via un mappage entre le monitoring
     et le host. Tapez dans votre navigateur l'url suivant pour se connecter à grafana : http://localhost:8085 et prometeus via http://localhost:8084

    cette partie permet la visualisation des metrics.

## Conclusion

Cette infra de 7 machines virtuelles noous a permis de mettre en pratique les connaisance theoriques acquises et ainsi de mieux comprendre l'utilité  de vagrant. Merci à vous

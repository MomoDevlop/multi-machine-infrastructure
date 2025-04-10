# Infrastructure Multi-Machines avec Vagrant

Ce projet configure une infrastructure multi-machines virtualisée à l'aide de **Vagrant** et de **VirtualBox**. L'infrastructure comprend un répartiteur de charge, des serveurs web, une base de données en mode master-slave, un serveur de monitoring, et une machine client.

## Prérequis

Avant de démarrer, assurez-vous d'avoir les outils suivants installés sur votre machine hôte :

1. **Vagrant** : [Télécharger ici](https://www.vagrantup.com/downloads)
2. **VirtualBox** : [Télécharger ici](https://www.virtualbox.org/)
3. **Git** (optionnel) : Pour cloner le dépôt si nécessaire.

---

## Structure de l'Infrastructure

L'infrastructure est composée des machines suivantes :

| Machine        | Rôle                       | IP              | Ports Mappés (Hôte -> VM)                             |
| -------------- | -------------------------- | --------------- | ----------------------------------------------------- |
| **lb**         | Répartiteur de charge      | `192.168.56.10` | `8083 -> 80`                                          |
| **web1**       | Serveur web 1              | `192.168.56.11` | `8081 -> 80`                                          |
| **web2**       | Serveur web 2              | `192.168.56.12` | `8082 -> 80`                                          |
| **db-master**  | Base de données principale | `192.168.56.13` | Aucun                                                 |
| **db-slave**   | Base de données secondaire | `192.168.56.14` | Aucun                                                 |
| **monitoring** | Serveur de monitoring      | `192.168.56.15` | `8084 -> 9090` (Prometheus), `8085 -> 3000` (Grafana) |
| **client**     | Machine client             | `192.168.56.16` | Aucun                                                 |

---

## Étapes pour Démarrer l'Infrastructure

1. **Cloner le Projet** :
   Si ce n'est pas déjà fait, clonez le dépôt contenant ce projet :

   ```bash
   git clone <URL_DU_DEPOT>
   cd multi-machine-infrastructure
   ```

2. **Démarrer les Machines Virtuelles** :
   Exécutez la commande suivante pour démarrer toutes les machines virtuelles :

   ```bash
   vagrant up
   ```

   Cette commande :

   - Crée et démarre les machines virtuelles.
   - Exécute les scripts de provisionnement pour configurer chaque machine.

3. **Vérifier l'État des Machines** :
   Assurez-vous que toutes les machines sont en cours d'exécution :
   ```bash
   vagrant status
   ```

---

## Tests des Fonctionnalités

### 1. **Répartiteur de Charge (Load Balancer)**

- Accédez au répartiteur de charge via votre navigateur à l'adresse suivante :
  ```
  http://localhost:8083
  ```
- Le répartiteur de charge distribue les requêtes entre les serveurs web `web1` et `web2`. Actualisez la page plusieurs fois pour vérifier que les requêtes sont bien réparties.

---

### 2. **Serveurs Web**

- Testez individuellement les serveurs web en accédant à leurs adresses respectives :
  - **web1** : `http://localhost:8081`
  - **web2** : `http://localhost:8082`
- Chaque serveur doit afficher une page HTML simple.

---

### 3. **Base de Données Master-Slave**

#### a. **Tester la Réplication Master-Slave**

1. Connectez-vous à la base de données principale (`db-master`) :

   ```bash
   vagrant ssh db-master
   mysql -u root -p
   ```

   (Le mot de passe par défaut est vide.)

2. Insérez des données dans la base `virtualTp` :

   ```sql
   USE virtualTp;
   INSERT INTO test_table (name) VALUES ('Test');
   ```

3. Connectez-vous à la base de données secondaire (`db-slave`) :

   ```bash
   vagrant ssh db-slave
   mysql -u root -p
   ```

4. Vérifiez que les données ont été répliquées :
   ```sql
   USE virtualTp;
   SELECT * FROM test_table;
   ```

---

### 4. **Monitoring avec Prometheus et Grafana**

#### a. **Accéder à Prometheus**

- Ouvrez votre navigateur et accédez à :
  ```
  http://localhost:8084
  ```
- Cliquez sur **Targets** pour vérifier que toutes les cibles (machines) sont dans l'état `UP`.

#### b. **Accéder à Grafana**

- Ouvrez votre navigateur et accédez à :
  ```
  http://localhost:8085
  ```
- Connectez-vous avec les identifiants par défaut :
  - **Nom d'utilisateur** : `admin`
  - **Mot de passe** : `admin` (vous serez invité à le changer).

#### c. **Importer un Tableau de Bord**

1. Dans Grafana, allez dans **+ > Import**.
2. Utilisez l'ID suivant pour importer un tableau de bord prédéfini pour `node_exporter` :
   - **ID 1860** : [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/).
3. Sélectionnez la source de données Prometheus et cliquez sur **Import**.
4. Visualisez les métriques système (CPU, RAM, disque, réseau) pour toutes les machines.

---

### 5. **Tester la Machine Client**

- Connectez-vous à la machine client :
  ```bash
  vagrant ssh client
  ```
- Effectuez des requêtes HTTP vers le load balancer ou les serveurs web :
  ```bash
  curl http://192.168.56.10
  curl http://192.168.56.11
  curl http://192.168.56.12
  ```

---

## Résolution des Problèmes

1. **Une Machine Ne Démarre Pas** :

   - Vérifiez les logs de Vagrant :
     ```bash
     vagrant up --debug
     ```

2. **Prometheus ou Grafana Ne Fonctionne Pas** :

   - Vérifiez les services sur la machine `monitoring` :
     ```bash
     vagrant ssh monitoring
     sudo systemctl status prometheus
     sudo systemctl status grafana-server
     ```

3. **Les Ports Ne Sont Pas Accessibles** :
   - Vérifiez les règles de pare-feu sur votre machine hôte et ouvrez les ports nécessaires (`8081`, `8082`, `8083`, `8084`, `8085`).

---

## Commandes Utiles

- **Démarrer toutes les machines** :

  ```bash
  vagrant up
  ```

- **Arrêter toutes les machines** :

  ```bash
  vagrant halt
  ```

- **Re-provisionner une machine spécifique** :

  ```bash
  vagrant provision <nom_de_la_machine>
  ```

- **Détruire toutes les machines** :
  ```bash
  vagrant destroy
  ```

---

## Conclusion

Cette infrastructure multi-machines est conçue pour fournir un environnement complet avec un load balancer, des serveurs web, une base de données répliquée, et un système de monitoring. Elle est idéale pour tester et apprendre les concepts d'infrastructure virtualisée.

Si vous avez des questions ou des problèmes, n'hésitez pas à demander de l'aide !

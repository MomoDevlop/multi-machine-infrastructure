-- MySQL dump 10.13  Distrib 5.7.42, for Linux (x86_64)
--
-- Host: localhost    Database: virtualTp
-- ------------------------------------------------------
-- Server version	5.7.42-0ubuntu0.18.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) DEFAULT NULL,
  `prenom` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'SAVADOGO','Mohamed','test@gmail.com'),(2,'Esse facere qui quib','Omnis perspiciatis ','huhuvu@mailinator.com'),(3,'Sequi ut illo consec','Minima dolores id a','kevosolyq@mailinator.com'),(4,'Sequi ut illo consec','Minima dolores id a','ryzelygol@mailinator.com'),(5,'Sequi ut illo consec','Minima dolores id a','ryzelygol@mailinator.com'),(6,'Sequi ut illo consec','Minima dolores id a','ryzelygol@mailinator.com'),(7,'Sequi ut illo consec','Minima dolores id a','ryzelygol@mailinator.com'),(8,'Nam tempora molestia','Officiis qui aliquid','nigaji@mailinator.com'),(9,'Hic pariatur Saepe ','Totam doloribus assu','sewegoja@mailinator.com'),(10,'Ea sequi anim archit','Molestiae ut digniss','nihyla@mailinator.com'),(11,'Excepturi amet inve','Eum voluptate tenetu','qehumunyh@mailinator.com'),(12,'Mollitia excepturi n','Sed cillum recusanda','dapylahyko@mailinator.com'),(13,'Mollitia excepturi n','Sed cillum recusanda','dapylahyko@mailinator.com'),(14,'Mollitia excepturi n','Sed cillum recusanda','dapylahyko@mailinator.com'),(15,'Mollitia excepturi n','Sed cillum recusanda','dapylahyko@mailinator.com'),(16,'Kabre','Naffisatou','kabre@gamil.com'),(17,'Adipisicing dolor vo','In libero eaque magn','rafitovido@mailinator.com');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-28 15:30:51

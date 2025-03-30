#!/bin/bash

# Update package list and install Apache and PHP
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql

# Remove the default Apache welcome page
sudo rm /var/www/html/index.html

# Create the web application
cat <<EOL | sudo tee /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
    <title>Enregistrement d'un utilisateur</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h1 { color: #333; }
        form { max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 10px; }
        label { display: block; margin-bottom: 8px; }
        input[type="text"], input[type="email"] { width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px; }
        input[type="submit"] { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        input[type="submit"]:hover { background-color: #45a049; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        table, th, td { border: 1px solid #ccc; }
        th, td { padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>Enregistrement d'un utilisateur</h1>
    <form action="submit.php" method="post">
        <label for="nom">Nom:</label>
        <input type="text" id="nom" name="nom" required>
        <label for="prenom">Prenom:</label>
        <input type="text" id="prenom" name="prenom" required>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        <input type="submit" value="Soumettre">
    </form>
    <p>Server IP: <?php echo \$_SERVER['SERVER_ADDR']; ?></p>
</body>
</html>
EOL

cat <<EOL | sudo tee /var/www/html/submit.php
<?php
\$servername = "192.168.56.13";
\$username = "momo";
\$password = "momo1234";
\$dbname = "virtualTp";

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}

if (\$_SERVER["REQUEST_METHOD"] == "POST") {
    \$nom = \$_POST['nom'];
    \$prenom = \$_POST['prenom'];
    \$email = \$_POST['email'];

    \$sql = "INSERT INTO users (nom, prenom, email) VALUES ('\$nom', '\$prenom', '\$email')";

    if (\$conn->query(\$sql) === TRUE) {
        echo "Utilisateur enregistré avec succès";
    } else {
        echo "Error: " . \$sql . "<br>" . \$conn->error;
    }

    // Fetch all records from the users table
    \$result = \$conn->query("SELECT * FROM users");

    if (\$result->num_rows > 0) {
        echo "<h2>Liste des utilisateurs</h2>";
        echo "<table border='1' cellpadding='10' style='border-collapse: collapse;' width='60%'>";
        echo "<tr><th>ID</th><th>Nom</th><th>Prenom</th><th>Email</th></tr>";
        while(\$row = \$result->fetch_assoc()) {
            echo "<tr><td>" . \$row["id"]. "</td><td>" . \$row["nom"]. "</td><td>" . \$row["prenom"]. "</td><td>" . \$row["email"]. "</td></tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }

    \$conn->close();
}
?>
EOL

# Restart Apache to apply changes
sudo systemctl restart apache2
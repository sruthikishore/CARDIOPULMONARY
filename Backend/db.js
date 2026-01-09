const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Kamali@06",        // change if you set password
  database: "cardio"   // your database name
});

db.connect(err => {
  if (err) {
    console.error("DB connection failed:", err);
  } else {
    console.log("MySQL Connected");
  }
});

module.exports = db;

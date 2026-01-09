const express = require("express");
const cors = require("cors");
const db = require("./db");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

console.log("SERVER FILE LOADED");

// 🔹 HEALTH CHECK (MOST IMPORTANT)
app.get("/api/health", (req, res) => {
  res.json({ status: "ok" });
});

// 🔹 USERS
app.get("/api/users/:id", (req, res) => {
  const id = req.params.id;
  db.query(
    "SELECT user_id, name, age, gender, condition_type FROM users WHERE user_id = ?",
    [id],
    (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results[0]);
    }
  );
});

// 🔹 DEVICES
app.get("/api/devices/:id", (req, res) => {
  const id = req.params.id;
  db.query(
    "SELECT device_type, registered_at FROM devices WHERE user_id = ?",
    [id],
    (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results);
    }
  );
});

// 🔹 VITALS
app.get("/api/vitals/:id", (req, res) => {
  const id = req.params.id;
  db.query(
    `SELECT heart_rate, spo2, respiratory_rate, body_temperature
     FROM vitals WHERE user_id = ?
     ORDER BY recorded_at DESC LIMIT 1`,
    [id],
    (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results[0]);
    }
  );
});

// 🔹 START SERVER (THIS MUST BE AT BOTTOM)
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

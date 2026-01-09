const express = require("express");
const router = express.Router();
const db = require("../db");

router.get("/latest/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    const [rows] = await db.query(
      `SELECT heart_rate, spo2, respiratory_rate, body_temperature, recorded_at
       FROM vitals
       WHERE user_id = ?
       ORDER BY recorded_at DESC
       LIMIT 1`,
      [userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "No vitals found" });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error" });
  }
});

module.exports = router;

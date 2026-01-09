const express = require("express");
const router = express.Router();
const db = require("../db");

router.get("/latest/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    const [rows] = await db.query(
      `SELECT severity, description, detected_at
       FROM anomalies
       WHERE user_id = ?
       ORDER BY detected_at DESC
       LIMIT 2`,
      [userId]
    );

    // Default safe response (important for demo)
    if (rows.length === 0) {
      return res.json({
        risk: "NORMAL",
        confidence: 0.94,
        alerts: [],
      });
    }

    res.json({
      risk: rows[0].severity.toUpperCase(),
      confidence: 0.94,
      alerts: rows,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error" });
  }
});

module.exports = router;

const { Pool } = require("pg");

const pool = new Pool({
  host: process.env.PGHOST,
  port: Number(process.env.PGPORT || 5432),
  user: process.env.PGUSER,
  password: process.env.PGPASSWORD,
  database: process.env.PGDATABASE,
  ssl: { rejectUnauthorized: false },
});

module.exports.handler = async (event) => {
  try {
    const name = (event.queryStringParameters || {}).name;

    let query = "SELECT * FROM posts ORDER BY created_at DESC";
    let params = [];

    if (name) {
      query = "SELECT * FROM posts WHERE name = $1 ORDER BY created_at DESC";
      params = [name];
    }

    const result = await pool.query(query, params);

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ posts: result.rows }),
    };
  } catch (err) {
    console.error("Query error", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "DB error" }),
    };
  }
};

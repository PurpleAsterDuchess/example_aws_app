const { Pool } = require("pg");

let pool = null;

function getPool() {
  if (!pool) {
    pool = new Pool({
      host: process.env.PGHOST,
      port: Number(process.env.PGPORT || 5432),
      user: process.env.PGUSER,
      password: process.env.PGPASSWORD,
      database: process.env.PGDATABASE,
      ssl: { rejectUnauthorized: false },
    });
  }
  return pool;
}

module.exports.handler = async (event) => {
  try {
    const name = (event.queryStringParameters || {}).name;

    let query = "SELECT * FROM posts ORDER BY created_at DESC";
    let params = [];

    if (name) {
      query = "SELECT * FROM posts WHERE name = $1 ORDER BY created_at DESC";
      params = [name];
    }

    const pool = getPool();
    const result = await pool.query(query, params);

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,POST",
        "Access-Control-Allow-Headers": "Content-Type",
      },
      body: JSON.stringify({ values: result.rows }),
    };
  } catch (err) {
    console.error("Query error", err);
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: JSON.stringify({ message: "DB error" }),
    };
  }
};

const { Pool } = require("pg");

let pool = null;
let initialized = false;

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

async function ensureSchema() {
  if (initialized) return;
  try {
    const pool = getPool();
    await pool.query(`
      CREATE TABLE IF NOT EXISTS posts (
        id serial PRIMARY KEY,
        name text NOT NULL,
        created_at timestamptz NOT NULL DEFAULT now()
      );
    `);
    initialized = true;
  } catch (err) {
    console.error("Schema error", err);
    throw err;
  }
}

module.exports.handler = async (event) => {
  try {
    await ensureSchema();

    const body = event.body ? JSON.parse(event.body) : {};
    const name = body.name || (event.queryStringParameters || {}).Name;
    console.log("Received name:", name);

    if (!name) {
      return {
        statusCode: 400,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET,POST",
          "Access-Control-Allow-Headers": "Content-Type",
        },
        body: JSON.stringify({ message: "name is required" }),
      };
    }

    const pool = getPool();
    await pool.query("INSERT INTO posts(name, created_at) VALUES($1, NOW())", [
      name,
    ]);

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,POST",
        "Access-Control-Allow-Headers": "Content-Type",
      },
      body: JSON.stringify({ message: `Stored '${name}'` }),
    };
  } catch (err) {
    console.error("Insert error", err);
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,POST",
        "Access-Control-Allow-Headers": "Content-Type",
      },
      body: JSON.stringify({ message: "DB error" }),
    };
  }
};

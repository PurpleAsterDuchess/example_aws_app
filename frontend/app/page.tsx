"use client";

import { useState, useEffect } from "react";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL || "https://localhost:3000";

export default function Home() {
  const [name, setName] = useState("");
  const [message, setMessage] = useState("");
  const [values, setValues] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadValues();
  }, []);

  async function loadValues() {
    try {
      const response = await fetch(`${API_BASE_URL}/get`);
      const data = await response.json();
      if (response.ok && data.values) {
        setValues(data.values);
      } else {
        setMessage("Failed to load values");
      }
    } catch (error) {
      setMessage(`Error loading values: ${error}`);
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    
    if (!name.trim()) {
      setMessage("Please enter a name");
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(`${API_BASE_URL}/post`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ name }),
      });

      console.log("Response:", response);

      const data = await response.json();
      
      if (response.ok) {
        setMessage(`Success: ${data.message}`);
        setName("");
        loadValues();
      } else {
        setMessage(`Error: ${data.message}`);
      }
    } catch (error) {
      setMessage(`Error: ${error}`);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-zinc-50 font-sans dark:bg-black p-4">
      <main className="w-full max-w-2xl">
        <h1 className="text-4xl font-bold mb-8 text-center text-black dark:text-white">
          Demo application
        </h1>

        {/* Create Post Form */}
        <div className="bg-white dark:bg-zinc-900 rounded-lg shadow-md p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4 text-black dark:text-white">
            Post request
          </h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Enter name"
              className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-zinc-800 text-black dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
            />
            <button
              type="submit"
              disabled={loading}
              className="w-full flex items-center justify-center gap-2 rounded-lg bg-blue-600 px-6 py-2 text-white font-medium hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
            >
              {loading ? "Posting..." : "Add to database"}
            </button>
          </form>
          {message && (
            <div
              className={`mt-4 p-3 rounded-lg ${
                message.startsWith("Success: ")
                  ? "bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-100"
                  : "bg-red-100 text-red-700 dark:bg-red-900 dark:text-red-100"
              }`}
            >
              {message}
            </div>
          )}
        </div>
        
        {/* Get request*/}
        <div className="bg-white dark:bg-zinc-900 rounded-lg shadow-md p-6" style={{overflowY: 'auto', maxHeight: '500px'}}>
          <h2 className="text-xl font-semibold mb-4 text-black dark:text-white">
            Get values from database
          </h2>
          <button
            onClick={loadValues}
            className="mb-4 px-4 py-2 bg-gray-200 dark:bg-gray-700 text-black dark:text-white rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors"
          >
            Refresh
          </button>

          {values.length === 0 ? (
            <p className="text-gray-500 dark:text-gray-400 text-center py-8">
              No values yet.
            </p>
          ) : (
            <div className="space-y-3">
              {values.map((post) => (
                <div
                  key={post.id}
                  className="border-l-4 border-blue-500 bg-gray-50 dark:bg-zinc-800 p-4 rounded"
                >
                  <p className="text-lg font-semibold text-black dark:text-white">
                    {post.name}
                  </p>
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {new Date(post.created_at).toLocaleString()}
                  </p>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}

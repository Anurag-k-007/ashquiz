export default function handler(req, res) {
  // Only expose public client-side values.
  // Configure these in Vercel Project Settings → Environment Variables
  // or locally in `.env` when using `vercel dev`.
  const { SUPABASE_URL, SUPABASE_ANON_KEY } = process.env;

  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    return res.status(500).json({
      error: "Missing SUPABASE_URL or SUPABASE_ANON_KEY"
    });
  }

  return res.status(200).json({
    SUPABASE_URL,
    SUPABASE_ANON_KEY
  });
}


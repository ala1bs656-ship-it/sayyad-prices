import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const allowedHosts = new Set([
  "amazon.eg", "www.amazon.eg", "amzn.eu",
  "noon.com", "www.noon.com",
  "jumia.com.eg", "www.jumia.com.eg",
  "adidas.com", "www.adidas.com", "adidas.com.eg",
]);

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") {
    return Response.json({ error: "Method not allowed" }, { status: 405, headers: corsHeaders });
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return Response.json({ error: "Sign-in required" }, { status: 401, headers: corsHeaders });
  }

  const url = Deno.env.get("SUPABASE_URL")!;
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
  const supabase = createClient(url, anonKey, {
    global: { headers: { Authorization: authHeader } },
  });

  const { data: { user }, error: userError } = await supabase.auth.getUser();
  if (userError || !user) {
    return Response.json({ error: "Invalid session" }, { status: 401, headers: corsHeaders });
  }

  let body: Record<string, unknown>;
  try {
    body = await req.json();
  } catch {
    return Response.json({ error: "Invalid JSON" }, { status: 400, headers: corsHeaders });
  }

  const productUrl = typeof body.product_url === "string" ? body.product_url.trim() : "";
  if (!productUrl || productUrl.length > 2048) {
    return Response.json({ error: "A valid product_url is required" }, { status: 400, headers: corsHeaders });
  }

  let parsed: URL;
  try {
    parsed = new URL(productUrl);
  } catch {
    return Response.json({ error: "Invalid product URL" }, { status: 400, headers: corsHeaders });
  }

  if (parsed.protocol !== "https:" || !allowedHosts.has(parsed.hostname.toLowerCase())) {
    return Response.json({ error: "This store link is not supported yet" }, { status: 400, headers: corsHeaders });
  }

  const target = body.target_price == null ? null : Number(body.target_price);
  if (target !== null && (!Number.isFinite(target) || target < 0)) {
    return Response.json({ error: "target_price must be a non-negative number" }, { status: 400, headers: corsHeaders });
  }

  const row = {
    user_id: user.id,
    product_url: productUrl,
    product_name: typeof body.product_name === "string" ? body.product_name.slice(0, 180) : null,
    store_name: typeof body.store_name === "string" ? body.store_name.slice(0, 80) : parsed.hostname,
    variant_label: typeof body.variant_label === "string" ? body.variant_label.slice(0, 100) : null,
    target_price: target,
    currency: "EGP",
    tracking_status: "pending",
  };

  const { data, error } = await supabase
    .from("tracked_products")
    .upsert(row, { onConflict: "user_id,product_url" })
    .select("id,product_url,product_name,store_name,target_price,currency,tracking_status,created_at")
    .single();

  if (error) {
    return Response.json({ error: "Could not save product" }, { status: 400, headers: corsHeaders });
  }

  return Response.json({ product: data, note: "Saved. Price monitoring is not active until a store data provider is connected." }, {
    status: 200,
    headers: corsHeaders,
  });
});

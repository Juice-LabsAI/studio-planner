/* Shared database for Juice Studio Planner (Supabase).
   The anon key is meant to be public: row-level security in supabase/schema.sql
   only lets signed-in @juicelabs.ai accounts read or change data.
   Delete this file (or blank the values) to run the planner in browser-only mode. */
window.STUDIO_CONFIG = {
  supabaseUrl: "https://cncuwzfertyourwdqqsi.supabase.co",
  supabaseAnonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuY3V3emZlcnR5b3Vyd2RxcXNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ1Mzg5OTEsImV4cCI6MjEwMDExNDk5MX0.7NQFAz-CiZ9YF5WYQnCd8TcmPO-1Lrrow1i3iHp27Dk",
  allowedDomain: "juicelabs.ai"
};

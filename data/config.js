/* Shared database for Juice Studio Planner (Supabase).
   requireLogin: false means the planner opens without signing in. Anyone who has
   this page's address can read and edit the data, so share the link only with admins.
   Set requireLogin to true (and re-run the member policies) to require an email sign-in again.
   Delete this file (or blank the values) to run the planner in browser-only mode. */
window.STUDIO_CONFIG = {
  supabaseUrl: "https://cncuwzfertyourwdqqsi.supabase.co",
  supabaseAnonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuY3V3emZlcnR5b3Vyd2RxcXNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ1Mzg5OTEsImV4cCI6MjEwMDExNDk5MX0.7NQFAz-CiZ9YF5WYQnCd8TcmPO-1Lrrow1i3iHp27Dk",
  requireLogin: false,
  allowedDomain: "juicelabs.ai"
};

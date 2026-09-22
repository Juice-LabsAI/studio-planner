/* Shared database for Juice Studio Planner (Supabase).
   With requireLogin: false there's no sign-in screen:
   - the plain site address opens the read-only TEAM view (Projects, Schedule, Credits; no prices);
   - the admin link (site address + #key, see the k/ folder) opens the full planner.
   The anon key below only lets the team view read the sp_team_* views
   (see supabase/team-access.sql); it can't change anything.
   Delete this file (or blank the values) to run the planner in browser-only mode. */
window.STUDIO_CONFIG = {
  supabaseUrl: "https://cncuwzfertyourwdqqsi.supabase.co",
  supabaseAnonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuY3V3emZlcnR5b3Vyd2RxcXNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ1Mzg5OTEsImV4cCI6MjEwMDExNDk5MX0.7NQFAz-CiZ9YF5WYQnCd8TcmPO-1Lrrow1i3iHp27Dk",
  requireLogin: false,
  allowedDomain: "juicelabs.ai"
};

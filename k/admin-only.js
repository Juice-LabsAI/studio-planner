/* Admin access for Juice Studio Planner.
   Opening the planner as  <site address>/#admin-only  loads this file and signs in
   silently as the admin user below, with full edit access. Without it, the page is
   the read-only team view. Keep this link to admins.

   One-time setup: in Supabase → Authentication → Users → Add user → Create new user,
   use this email and password and tick "Auto Confirm User".
   To change the admin link, rename this file (the new name is the new #key) and push. */
window.STUDIO_ADMIN = {
  email: "planner-admin@juicelabs.ai",
  password: "je7IKOFZinYhzw9HzLs0MF1omnh0"
};

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApp
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            string connStr = ConfigurationManager.ConnectionStrings["AppDb"].ConnectionString;

            try
            {
                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand("SP_Login", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserName", SqlDbType.VarChar, 100).Value = username;

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            // No matching username
                            lblMessage.Text = "Invalid username or password.";
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                            return;
                        }

                        int userId = (int)reader["UserID"];
                        string storedHash = reader["PasswordHash"].ToString();
                        bool isActive = (bool)reader["IsActive"];

                        if (!isActive)
                        {
                            lblMessage.Text = "This account is inactive. Contact support.";
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                            return;
                        }

                        bool passwordOk = PasswordHelper.VerifyPassword(password, storedHash);

                        if (passwordOk)
                        {
                            // Set up the authenticated session
                            Session["UserID"] = userId;
                            Session["UserName"] = username;

                            Response.Redirect("Dashboard.aspx", false);
                        }
                        else
                        {
                            lblMessage.Text = "Invalid username or password.";
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log ex somewhere in a real app (e.g. via a logging framework)
                lblMessage.Text = "A system error occurred. Please try again later.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApp
{
    public partial class Signup : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string fullName = txtFullName.Text.Trim();
            string userName = txtUserName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string mobile = txtMobile.Text.Trim();
            string address = txtAddress.Text.Trim();
            bool isSalaried = chkIsSalaried.Checked;
            string password = txtPassword.Text;

            // Hash happens here in the app layer -- SP_Signup only ever sees the hash.
            string passwordHash = PasswordHelper.HashPassword(password);

            string connStr = ConfigurationManager.ConnectionStrings["AppDb"].ConnectionString;

            try
            {
                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand("SP_Signup", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@FullName", SqlDbType.VarChar, 150).Value = fullName;
                    cmd.Parameters.Add("@MobileNumber", SqlDbType.VarChar, 15).Value = mobile;
                    cmd.Parameters.Add("@Address", SqlDbType.VarChar, 255).Value =
                        string.IsNullOrEmpty(address) ? (object)DBNull.Value : address;
                    cmd.Parameters.Add("@IsSalaried", SqlDbType.Bit).Value = isSalaried;
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar, 150).Value = email;
                    cmd.Parameters.Add("@CreatedAt", SqlDbType.DateTime).Value = DateTime.UtcNow;
                    cmd.Parameters.Add("@UserName", SqlDbType.VarChar, 100).Value = userName;
                    cmd.Parameters.Add("@PasswordHash", SqlDbType.VarChar, 256).Value = passwordHash;

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int statusCode = Convert.ToInt32(reader["StatusCode"]);
                            string message = reader["Message"].ToString();

                            if (statusCode == 1)
                            {
                                lblMessage.Text = "Account created successfully. You can now log in.";
                                lblMessage.ForeColor = System.Drawing.Color.Green;
                                ClearForm();
                            }
                            else
                            {
                                lblMessage.Text = message;
                                lblMessage.ForeColor = System.Drawing.Color.Red;
                            }
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log ex somewhere in a real app
                lblMessage.Text = "A system error occurred. Please try again later.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtUserName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtAddress.Text = "";
            chkIsSalaried.Checked = false;
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
    }
}

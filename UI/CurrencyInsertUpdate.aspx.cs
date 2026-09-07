using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace FinanceApp
{
    public partial class CurrencyInsertUpdate : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblMessage.Text = string.Empty;
            lblMessage.CssClass = string.Empty;

            try
            {
                using (SqlConnection conn = new SqlConnection(
                           ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
                using (SqlCommand cmd = new SqlCommand("SP_CurrencyInsertUpdate", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CurrencyCode", txtCurrencyCode.Text.Trim().ToUpperInvariant());
                    cmd.Parameters.AddWithValue("@CurrencyName", txtCurrencyName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Symbol", txtSymbol.Text.Trim());

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int statusCode = Convert.ToInt32(reader["StatusCode"]);
                            string message = reader["Message"].ToString();

                            lblMessage.Text = message;
                            lblMessage.CssClass = statusCode == 1 ? "msg-success" : "msg-error";

                            if (statusCode == 1)
                            {
                                ClearForm();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An unexpected error occurred: " + ex.Message;
                lblMessage.CssClass = "msg-error";
            }
        }

        private void ClearForm()
        {
            txtCurrencyCode.Text = string.Empty;
            txtCurrencyName.Text = string.Empty;
            txtSymbol.Text = string.Empty;
        }
    }
}

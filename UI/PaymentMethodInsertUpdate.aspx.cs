using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace FinanceApp
{
    public partial class PaymentMethodInsertUpdate : Page
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
                using (SqlCommand cmd = new SqlCommand("SP_PaymentMethodInsertUpdate", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PaymentMethodName", txtPaymentMethodName.Text.Trim());

                    object descValue = string.IsNullOrWhiteSpace(txtDescription.Text)
                        ? (object)DBNull.Value
                        : txtDescription.Text.Trim();
                    cmd.Parameters.AddWithValue("@Description", descValue);

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
            txtPaymentMethodName.Text = string.Empty;
            txtDescription.Text = string.Empty;
        }
    }
}

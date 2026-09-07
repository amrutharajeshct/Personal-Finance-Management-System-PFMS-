using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace FinanceApp
{
    public partial class CategoryInsertUpdate : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategoryTypes();
                BindParentCategories();
            }
        }

        private string ConnString =>
            ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;

        private void BindCategoryTypes()
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT CategoryTypeID, CategoryTypeName FROM CategoryType WHERE IsActive = 1 ORDER BY CategoryTypeName", conn))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddlCategoryType.DataSource = dt;
                    ddlCategoryType.DataBind();
                }
            }
        }

        private void BindParentCategories()
        {
            // Only top-level, active categories can be a parent (one level only - BR-019)
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(
                @"SELECT CategoryID, CategoryName
                  FROM Category
                  WHERE IsActive = 1 AND ParentCategoryID IS NULL
                  ORDER BY CategoryName", conn))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddlParentCategory.DataSource = dt;
                    ddlParentCategory.DataBind();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblMessage.Text = string.Empty;
            lblMessage.CssClass = string.Empty;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                using (SqlCommand cmd = new SqlCommand("SP_CategoryInsertUpdate", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CategoryName", txtCategoryName.Text.Trim());
                    cmd.Parameters.AddWithValue("@CategoryTypeID", Convert.ToInt32(ddlCategoryType.SelectedValue));

                    object parentValue = string.IsNullOrEmpty(ddlParentCategory.SelectedValue)
                        ? (object)DBNull.Value
                        : Convert.ToInt32(ddlParentCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@ParentCategoryID", parentValue);

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
                                BindParentCategories(); // refresh in case a new top-level category is now eligible
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
            txtCategoryName.Text = string.Empty;
            ddlCategoryType.SelectedIndex = 0;
            ddlParentCategory.SelectedIndex = 0;
        }
    }
}

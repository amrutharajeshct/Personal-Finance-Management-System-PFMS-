<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CategoryInsertUpdate.aspx.cs" Inherits="FinanceApp.CategoryInsertUpdate" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Add Category</title>
    <style>
        body { font-family: Segoe UI, Arial, sans-serif; background: #f4f6f8; margin: 0; }
        .card { max-width: 480px; margin: 60px auto; background: #fff; border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08); padding: 32px; }
        h2 { margin-top: 0; color: #22303f; font-size: 20px; }
        .field { margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #445; margin-bottom: 6px; }
        input[type=text], select { width: 100%; padding: 9px 10px; border: 1px solid #cbd2d9; border-radius: 5px;
                            font-size: 14px; box-sizing: border-box; font-family: inherit; background: #fff; }
        input[type=text]:focus, select:focus { outline: none; border-color: #3b82f6; }
        .btn { background: #2563eb; color: #fff; border: none; padding: 10px 20px; border-radius: 5px;
               font-size: 14px; cursor: pointer; }
        .btn:hover { background: #1d4ed8; }
        .msg-success { display: block; margin-top: 16px; padding: 10px 12px; border-radius: 5px;
                       background: #ecfdf3; color: #067647; font-size: 13px; }
        .msg-error { display: block; margin-top: 16px; padding: 10px 12px; border-radius: 5px;
                     background: #fef3f2; color: #b42318; font-size: 13px; }
        .validator { color: #b42318; font-size: 12px; }
        .hint { font-size: 12px; color: #7a8794; margin-top: 4px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <h2>Add Category</h2>

            <div class="field">
                <label for="txtCategoryName">Category Name</label>
                <asp:TextBox ID="txtCategoryName" runat="server" MaxLength="100" placeholder="e.g. Groceries" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCategoryName"
                    ErrorMessage="Category name is required." CssClass="validator" Display="Dynamic" />
            </div>

            <div class="field">
                <label for="ddlCategoryType">Category Type</label>
                <asp:DropDownList ID="ddlCategoryType" runat="server" DataTextField="CategoryTypeName"
                    DataValueField="CategoryTypeID" AppendDataBoundItems="true">
                    <asp:ListItem Text="-- Select --" Value="" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategoryType"
                    ErrorMessage="Please select a category type." CssClass="validator" Display="Dynamic"
                    InitialValue="" />
            </div>

            <div class="field">
                <label for="ddlParentCategory">Parent Category (optional)</label>
                <asp:DropDownList ID="ddlParentCategory" runat="server" DataTextField="CategoryName"
                    DataValueField="CategoryID" AppendDataBoundItems="true">
                    <asp:ListItem Text="-- None (top-level category) --" Value="" />
                </asp:DropDownList>
                <div class="hint">Only top-level categories may be selected as a parent (one level only).</div>
            </div>

            <asp:Button ID="btnSave" runat="server" Text="Save Category" CssClass="btn" OnClick="btnSave_Click" />

            <asp:Label ID="lblMessage" runat="server" />
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransactionSourceInsertUpdate.aspx.cs" Inherits="FinanceApp.TransactionSourceInsertUpdate" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Add Transaction Source</title>
    <style>
        body { font-family: Segoe UI, Arial, sans-serif; background: #f4f6f8; margin: 0; }
        .card { max-width: 480px; margin: 60px auto; background: #fff; border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08); padding: 32px; }
        h2 { margin-top: 0; color: #22303f; font-size: 20px; }
        .field { margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #445; margin-bottom: 6px; }
        input[type=text] { width: 100%; padding: 9px 10px; border: 1px solid #cbd2d9; border-radius: 5px;
                            font-size: 14px; box-sizing: border-box; }
        input[type=text]:focus { outline: none; border-color: #3b82f6; }
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
            <h2>Add Transaction Source</h2>

            <div class="field">
                <label for="txtTransactionSourceName">Transaction Source Name</label>
                <asp:TextBox ID="txtTransactionSourceName" runat="server" MaxLength="50" placeholder="e.g. Manual" />
                <div class="hint">Typically: Manual, Import, Recurring</div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTransactionSourceName"
                    ErrorMessage="Transaction source name is required." CssClass="validator" Display="Dynamic" />
            </div>

            <asp:Button ID="btnSave" runat="server" Text="Save Transaction Source" CssClass="btn" OnClick="btnSave_Click" />

            <asp:Label ID="lblMessage" runat="server" />
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApp.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="max-width:350px; margin:60px auto; font-family:Arial, sans-serif;">
            <h2>Login</h2>

            <div style="margin-bottom:12px;">
                <asp:Label ID="lblUsername" runat="server" Text="Username" AssociatedControlID="txtUsername" /><br />
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Width="300px" />
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                    ControlToValidate="txtUsername"
                    ErrorMessage="Username is required"
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label ID="lblPassword" runat="server" Text="Password" AssociatedControlID="txtPassword" /><br />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Width="300px" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="Password is required"
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />

            <div style="margin-top:15px;">
                <asp:Label ID="lblMessage" runat="server" Text="" />
            </div>

            <div style="margin-top:10px;">
                <a href="Signup.aspx">Don't have an account? Sign up</a>
            </div>
        </div>
    </form>
</body>
</html>

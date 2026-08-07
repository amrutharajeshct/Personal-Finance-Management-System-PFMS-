<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="WebApp.Signup" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Sign Up</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="max-width:400px; margin:60px auto; font-family:Arial, sans-serif;">
            <h2>Create an Account</h2>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Full Name" AssociatedControlID="txtFullName" /><br />
                <asp:TextBox ID="txtFullName" runat="server" Width="320px" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required" ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Username" AssociatedControlID="txtUserName" /><br />
                <asp:TextBox ID="txtUserName" runat="server" Width="320px" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUserName"
                    ErrorMessage="Username is required" ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Email" AssociatedControlID="txtEmail" /><br />
                <asp:TextBox ID="txtEmail" runat="server" Width="320px" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Enter a valid email" ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Mobile Number" AssociatedControlID="txtMobile" /><br />
                <asp:TextBox ID="txtMobile" runat="server" Width="320px" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMobile"
                    ErrorMessage="Mobile number is required" ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Address" AssociatedControlID="txtAddress" /><br />
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" Width="320px" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:CheckBox ID="chkIsSalaried" runat="server" Text="I am salaried" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Password" AssociatedControlID="txtPassword" /><br />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="320px" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic" />
            </div>

            <div style="margin-bottom:12px;">
                <asp:Label runat="server" Text="Confirm Password" AssociatedControlID="txtConfirmPassword" /><br />
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" Width="320px" />
                <asp:CompareValidator runat="server" ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtPassword" ErrorMessage="Passwords do not match"
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <asp:Button ID="btnSignup" runat="server" Text="Sign Up" OnClick="btnSignup_Click" />

            <div style="margin-top:15px;">
                <asp:Label ID="lblMessage" runat="server" Text="" />
            </div>

            <div style="margin-top:10px;">
                <a href="Login.aspx">Already have an account? Login</a>
            </div>
        </div>
    </form>
</body>
</html>

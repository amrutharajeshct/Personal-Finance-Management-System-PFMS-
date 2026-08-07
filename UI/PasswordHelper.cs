using System;
using System.Security.Cryptography;

/// <summary>
/// Handles password hashing and verification using PBKDF2 (Rfc2898DeriveBytes).
/// This runs in the application layer -- the stored procedures only ever
/// see the resulting hash string, never a plaintext password.
/// </summary>
public static class PasswordHelper
{
    private const int SaltSize = 16;      // 128-bit salt
    private const int HashSize = 32;      // 256-bit derived key
    private const int Iterations = 100000; // PBKDF2 work factor

    /// <summary>
    /// Produces a hash string safe to store in the PasswordHash column.
    /// Format: {iterations}.{saltBase64}.{hashBase64}
    /// </summary>
    public static string HashPassword(string password)
    {
        using (var rfc2898 = new Rfc2898DeriveBytes(password, SaltSize, Iterations, HashAlgorithmName.SHA256))
        {
            byte[] salt = rfc2898.Salt;
            byte[] hash = rfc2898.GetBytes(HashSize);

            return string.Format("{0}.{1}.{2}",
                Iterations,
                Convert.ToBase64String(salt),
                Convert.ToBase64String(hash));
        }
    }

    /// <summary>
    /// Verifies a plaintext password against a stored hash string produced by HashPassword.
    /// </summary>
    public static bool VerifyPassword(string password, string storedHash)
    {
        string[] parts = storedHash.Split('.');
        if (parts.Length != 3)
        {
            return false;
        }

        int iterations = int.Parse(parts[0]);
        byte[] salt = Convert.FromBase64String(parts[1]);
        byte[] hash = Convert.FromBase64String(parts[2]);

        using (var rfc2898 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
        {
            byte[] computedHash = rfc2898.GetBytes(hash.Length);
            return CryptographicOperations_FixedTimeEquals(computedHash, hash);
        }
    }

    // Constant-time comparison to avoid timing attacks.
    // (Wrapping manually since CryptographicOperations.FixedTimeEquals
    // requires .NET Core 2.1+ / .NET Framework may not have it.)
    private static bool CryptographicOperations_FixedTimeEquals(byte[] a, byte[] b)
    {
        if (a.Length != b.Length) return false;

        int diff = 0;
        for (int i = 0; i < a.Length; i++)
        {
            diff |= a[i] ^ b[i];
        }
        return diff == 0;
    }
}

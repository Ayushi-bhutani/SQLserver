using Microsoft.Data.SqlClient;

namespace LeaveManagementApp.DataAccess
{
    public class DatabaseHelper
    {
        private string connectionString =
        "Server=MERA_HAI\\SQLEXPRESS;Database=LeaveManagementDB;Trusted_Connection=True;TrustServerCertificate=True;";

        public SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }
    }
}
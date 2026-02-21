using System;
using Microsoft.Data.SqlClient;
using LeaveManagementApp.DataAccess;

namespace LeaveManagementApp.BusinessLogic
{
    public class LeaveService
    {
        DatabaseHelper db = new DatabaseHelper();

        public void ApplyLeave(int employeeId, DateTime start, DateTime end)
        {
            int totalDays = (end - start).Days + 1;

            using (SqlConnection conn = db.GetConnection())
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1️⃣ Check Leave Balance
                    string balanceQuery =
                    "SELECT LeaveBalance FROM Employees WHERE EmployeeId = @id";

                    SqlCommand balanceCmd =
                    new SqlCommand(balanceQuery, conn, transaction);

                    balanceCmd.Parameters.AddWithValue("@id", employeeId);

                    int balance = (int)balanceCmd.ExecuteScalar();

                    if (balance < totalDays)
                    {
                        throw new Exception("Insufficient Leave Balance");
                    }

                    // 2️⃣ Deduct Leave
                    string updateQuery =
                    "UPDATE Employees SET LeaveBalance = LeaveBalance - @days WHERE EmployeeId = @id";

                    SqlCommand updateCmd =
                    new SqlCommand(updateQuery, conn, transaction);

                    updateCmd.Parameters.AddWithValue("@days", totalDays);
                    updateCmd.Parameters.AddWithValue("@id", employeeId);

                    updateCmd.ExecuteNonQuery();

                    // 3️⃣ Insert Leave Request
                    string insertQuery =
                    @"INSERT INTO LeaveRequests 
                    (EmployeeId, StartDate, EndDate, Days, Status)
                    VALUES (@id, @start, @end, @days, 'Pending')";

                    SqlCommand insertCmd =
                    new SqlCommand(insertQuery, conn, transaction);

                    insertCmd.Parameters.AddWithValue("@id", employeeId);
                    insertCmd.Parameters.AddWithValue("@start", start);
                    insertCmd.Parameters.AddWithValue("@end", end);
                    insertCmd.Parameters.AddWithValue("@days", totalDays);

                    insertCmd.ExecuteNonQuery();

                    transaction.Commit();
                    Console.WriteLine("Leave Applied Successfully ✅");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Console.WriteLine("Error ❌: " + ex.Message);
                }
            }
        }
    }
}
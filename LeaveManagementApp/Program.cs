using System;
using LeaveManagementApp.BusinessLogic;

class Program
{
    static void Main()
    {
        LeaveService service = new LeaveService();

        Console.WriteLine("Enter Employee ID:");
        int id = int.Parse(Console.ReadLine());

        Console.WriteLine("Enter Start Date (yyyy-mm-dd):");
        DateTime start = DateTime.Parse(Console.ReadLine());

        Console.WriteLine("Enter End Date (yyyy-mm-dd):");
        DateTime end = DateTime.Parse(Console.ReadLine());

        service.ApplyLeave(id, start, end);

        Console.ReadLine();
    }
}
package MySQLConnectivity;

import java.sql.*;
import java.util.Scanner;

public class MySQL {
    public static void main(String[] args) throws Exception {
        Scanner in = new Scanner(System.in);
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/[Database]", "[Username]", "[password]");
        Statement stmt = con.createStatement();

        PreparedStatement pstmInsert = con.prepareStatement("INSERT INTO Personal VALUES(?,?,?,?)");
        PreparedStatement pstmDelete = con.prepareStatement("DELETE FROM Personal WHERE sno=?");
        PreparedStatement pstmUpdate = con.prepareStatement("UPDATE Personal SET name=?, telephone=?, gender=? WHERE sno=?");

        // Insertion
        System.out.print("Enter the number of records you want to insert: ");
        int n = in.nextInt();
        for (int i = 0; i < n; i++) {
            System.out.println("\nData " + (i + 1));
            pstmInsert.setInt(1, getIntInput(in, "Enter Sno: "));
            pstmInsert.setString(2, getStringInput(in, "Enter Name: "));
            pstmInsert.setString(3, getStringInput(in, "Enter Telephone: "));
            pstmInsert.setString(4, getStringInput(in, "Enter Gender: "));
            pstmInsert.executeUpdate();
        }

        displayData(stmt, "After Insertion");

        // Search
        System.out.print("Enter Sno to search: ");
        int sno = in.nextInt();
        displaySingleResult(stmt, "SELECT * FROM Personal WHERE sno=" + sno, "Search Result");

        // Update
        System.out.print("Enter Sno to update: ");
        sno = in.nextInt();
        pstmUpdate.setString(1, getStringInput(in, "Enter new Name: "));
        pstmUpdate.setString(2, getStringInput(in, "Enter new Telephone: "));
        pstmUpdate.setString(3, getStringInput(in, "Enter new Gender: "));
        pstmUpdate.setInt(4, sno);
        pstmUpdate.executeUpdate();

        displayData(stmt, "After Update");

        // Deletion
        System.out.print("Enter the number of records you want to delete: ");
        n = in.nextInt();
        for (int i = 0; i < n; i++) {
            pstmDelete.setInt(1, getIntInput(in, "\nData " + (i + 1) + "\nEnter Sno: "));
            pstmDelete.executeUpdate();
        }

        displayData(stmt, "After Deletion");

        con.close();
    }

    private static void displayData(Statement stmt, String message) throws SQLException {
        ResultSet rs = stmt.executeQuery("SELECT * FROM Personal");
        System.out.println("\n" + message);
        System.out.println("Sno\tName\tTelephone\tGender");
        while (rs.next()) {
            System.out.println(rs.getInt(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" + rs.getString(4));
        }
    }

    private static void displaySingleResult(Statement stmt, String query, String message) throws SQLException {
        ResultSet rs = stmt.executeQuery(query);
        System.out.println("\n" + message);
        System.out.println("Sno\tName\tTelephone\tGender");
        if (rs.next()) {
            System.out.println(rs.getInt(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" + rs.getString(4));
        }
    }

    private static int getIntInput(Scanner in, String prompt) {
        System.out.print(prompt);
        return in.nextInt();
    }

    private static String getStringInput(Scanner in, String prompt) {
        System.out.print(prompt);
        return in.next();
    }
}


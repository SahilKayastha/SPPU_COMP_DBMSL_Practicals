package MongoDB;

import java.util.Scanner;
import com.mongodb.*;

public class MongoDB {
    public static void displayData(String field, DBCollection table) {
        DBCursor cursor = table.find();
        while (cursor.hasNext()) {
            Object data = cursor.next().get(field);
            System.out.print(field + ": " + data + "\t");
        }
        System.out.println();
    }

    public static void main(String[] args) throws Exception {
        MongoClient mongo = new MongoClient("localhost", 27017);
        System.out.println("Connected to the database successfully");

        Scanner sc = new Scanner(System.in);
        String name, mobile, ans, ans1;
        int age, n;

        do {
            DB db = mongo.getDB("Info");
            DBCollection table = db.getCollection("Personal");

            System.out.println("Enter the number of records you want to insert:");
            n = sc.nextInt();
            for (int i = 0; i < n; i++) {
                BasicDBObject info = new BasicDBObject();
                System.out.println("Enter Data " + (i + 1));

                System.out.print("Enter name: ");
                name = sc.next();
                info.put("Name", name);

                System.out.print("Enter age: ");
                age = sc.nextInt();
                info.put("Age", age);

                System.out.print("Enter Mobile Number: ");
                mobile = sc.next();
                info.put("Mobile Number", mobile);

                table.insert(info);
            }

            System.out.println("Insert Operation");
            displayData("Name", table);
            displayData("Mobile Number", table);
            displayData("Age", table);

            System.out.print("Enter the number of records you want to delete: ");
            n = sc.nextInt();
            for (int i = 0; i < n; i++) {
                System.out.println("Enter Data " + (i + 1));

                System.out.print("Enter name: ");
                name = sc.next();
                table.remove(new BasicDBObject("Name", name));
            }

            System.out.println("Delete Operation");
            displayData("Name", table);
            displayData("Mobile Number", table);
            displayData("Age", table);

            System.out.println("Do you want to drop the database? (y/n): ");
            ans = sc.next();
            if (ans.equalsIgnoreCase("y")) {
                db.dropDatabase();
                System.out.println("Database Dropped");
            }

            System.out.println("Do you want to continue? (y/n): ");
            ans1 = sc.next();
        } while (ans1.equalsIgnoreCase("y"));

        sc.close();
    }
}

import java.util.*;
import java.util.stream.*;

/**
 * SampleProgram — demonstrates core Java features:
 *   Collections, Streams, Lambdas, Records, and Optional.
 */
public class SampleProgram {

    // A simple record to model a student
    record Student(String name, int age, double gpa) {}

    public static void main(String[] args) {
        List<Student> students = List.of(
            new Student("Alice", 21, 3.9),
            new Student("Bob", 22, 3.4),
            new Student("Charlie", 20, 3.7),
            new Student("Diana", 23, 3.95),
            new Student("Eve", 21, 2.8),
            new Student("Frank", 22, 3.6)
        );

        System.out.println("=== All Students ===");
        students.forEach(s ->
            System.out.printf("  %-10s | Age: %d | GPA: %.2f%n", s.name(), s.age(), s.gpa())
        );

        // Filter: honor roll (GPA >= 3.5)
        List<Student> honorRoll = students.stream()
            .filter(s -> s.gpa() >= 3.5)
            .sorted(Comparator.comparingDouble(Student::gpa).reversed())
            .collect(Collectors.toList());

        System.out.println("\n=== Honor Roll (GPA >= 3.5) ===");
        honorRoll.forEach(s ->
            System.out.printf("  %-10s | GPA: %.2f%n", s.name(), s.gpa())
        );

        // Statistics
        DoubleSummaryStatistics stats = students.stream()
            .mapToDouble(Student::gpa)
            .summaryStatistics();

        System.out.println("\n=== GPA Statistics ===");
        System.out.printf("  Count:   %d%n", stats.getCount());
        System.out.printf("  Average: %.2f%n", stats.getAverage());
        System.out.printf("  Min:     %.2f%n", stats.getMin());
        System.out.printf("  Max:     %.2f%n", stats.getMax());

        // Group by age
        Map<Integer, List<Student>> byAge = students.stream()
            .collect(Collectors.groupingBy(Student::age));

        System.out.println("\n=== Students Grouped by Age ===");
        byAge.forEach((age, group) -> {
            String names = group.stream().map(Student::name).collect(Collectors.joining(", "));
            System.out.printf("  Age %d: %s%n", age, names);
        });

        // Optional: find top student
        Optional<Student> topStudent = students.stream()
            .max(Comparator.comparingDouble(Student::gpa));

        topStudent.ifPresent(s ->
            System.out.printf("%n=== Top Student ===%n  %s with GPA %.2f%n", s.name(), s.gpa())
        );
    }
}

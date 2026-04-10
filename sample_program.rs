// Sample Rust Program: Student Grade Analyzer
// Demonstrates structs, enums, traits, iterators, pattern matching, and error handling

use std::collections::HashMap;
use std::fmt;

#[derive(Debug, Clone)]
struct Student {
    name: String,
    grades: Vec<f64>,
}

#[derive(Debug, PartialEq)]
enum LetterGrade {
    A,
    B,
    C,
    D,
    F,
}

impl fmt::Display for LetterGrade {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            LetterGrade::A => write!(f, "A"),
            LetterGrade::B => write!(f, "B"),
            LetterGrade::C => write!(f, "C"),
            LetterGrade::D => write!(f, "D"),
            LetterGrade::F => write!(f, "F"),
        }
    }
}

trait GradeCalculator {
    fn average(&self) -> Option<f64>;
    fn highest(&self) -> Option<f64>;
    fn lowest(&self) -> Option<f64>;
    fn letter_grade(&self) -> Option<LetterGrade>;
}

impl GradeCalculator for Student {
    fn average(&self) -> Option<f64> {
        if self.grades.is_empty() {
            return None;
        }
        let sum: f64 = self.grades.iter().sum();
        Some(sum / self.grades.len() as f64)
    }

    fn highest(&self) -> Option<f64> {
        self.grades.iter().cloned().reduce(f64::max)
    }

    fn lowest(&self) -> Option<f64> {
        self.grades.iter().cloned().reduce(f64::min)
    }

    fn letter_grade(&self) -> Option<LetterGrade> {
        self.average().map(|avg| match avg as u32 {
            90..=100 => LetterGrade::A,
            80..=89 => LetterGrade::B,
            70..=79 => LetterGrade::C,
            60..=69 => LetterGrade::D,
            _ => LetterGrade::F,
        })
    }
}

impl Student {
    fn new(name: &str, grades: Vec<f64>) -> Self {
        Student {
            name: name.to_string(),
            grades,
        }
    }
}

fn grade_distribution(students: &[Student]) -> HashMap<String, usize> {
    let mut distribution: HashMap<String, usize> = HashMap::new();
    for student in students {
        if let Some(grade) = student.letter_grade() {
            *distribution.entry(grade.to_string()).or_insert(0) += 1;
        }
    }
    distribution
}

fn top_performers(students: &[Student], threshold: f64) -> Vec<&Student> {
    students
        .iter()
        .filter(|s| s.average().unwrap_or(0.0) >= threshold)
        .collect()
}

fn main() {
    let students = vec![
        Student::new("Alice", vec![95.0, 88.0, 92.0, 97.0]),
        Student::new("Bob", vec![78.0, 82.0, 75.0, 80.0]),
        Student::new("Charlie", vec![65.0, 70.0, 68.0, 72.0]),
        Student::new("Diana", vec![90.0, 93.0, 88.0, 95.0]),
        Student::new("Eve", vec![55.0, 60.0, 58.0, 52.0]),
        Student::new("Frank", vec![85.0, 87.0, 90.0, 82.0]),
    ];

    println!("=== Student Grade Report ===\n");

    for student in &students {
        println!("Student: {}", student.name);
        match student.average() {
            Some(avg) => println!("  Average: {:.2}", avg),
            None => println!("  Average: N/A"),
        }
        if let Some(high) = student.highest() {
            println!("  Highest: {:.1}", high);
        }
        if let Some(low) = student.lowest() {
            println!("  Lowest:  {:.1}", low);
        }
        if let Some(grade) = student.letter_grade() {
            println!("  Grade:   {}", grade);
        }
        println!();
    }

    // Grade distribution
    println!("=== Grade Distribution ===");
    let distribution = grade_distribution(&students);
    let mut sorted: Vec<_> = distribution.iter().collect();
    sorted.sort_by_key(|(k, _)| k.clone());
    for (grade, count) in &sorted {
        println!("  {}: {} student(s)", grade, count);
    }

    // Top performers (average >= 85)
    println!("\n=== Top Performers (avg >= 85.0) ===");
    let top = top_performers(&students, 85.0);
    if top.is_empty() {
        println!("  None");
    } else {
        for s in &top {
            println!("  {} — {:.2}", s.name, s.average().unwrap());
        }
    }

    // Class average using iterators
    let class_avg: f64 = students
        .iter()
        .filter_map(|s| s.average())
        .sum::<f64>()
        / students.len() as f64;
    println!("\n=== Class Average: {:.2} ===", class_avg);
}

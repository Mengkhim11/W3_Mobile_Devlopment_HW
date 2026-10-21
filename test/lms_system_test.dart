import 'package:test/test.dart';
import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });
  
  // course
  test('adds a course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    expect(lms.courses.length, 1);
    expect(lms.courses.first.name, 'Mobile Dev');
  });

  test('rejects duplicate course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    expect(
      () => lms.addCourse(courseId: 'C1', courseName: 'Other'),
      throwsException,
    );
  });

  test('removes a course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.removeCourse(courseId: 'C1');
    expect(lms.courses.length, 0);
  });

  // enroll
  test('enrolls a student in a course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Alice');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(lms.courses.first.studentIds.contains('S1'), true);
  });

  test('rejects duplicate enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Alice');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(
      () => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
      throwsException,
    );
  });

  // Discard
  test('removes student from course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Alice');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');
    expect(lms.courses.first.studentIds.contains('S1'), false);
  });

  // add result
  test('adds a result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Alice');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);
    expect(lms.courseResults.first.score, 85);
  });

  test('rejects invalid score', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Alice');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(
      () => lms.addResult(studentId: 'S1', courseId: 'C1', score: 150),
      throwsException,
    );
  });

  // remove result
  test('removes a result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Alice');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Dev');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);
    lms.removeResult(studentId: 'S1', courseId: 'C1');
    expect(lms.courseResults.length, 0);
  });
}
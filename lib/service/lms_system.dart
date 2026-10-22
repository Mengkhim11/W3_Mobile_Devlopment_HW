import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> courseResults = [];

  // --- Student Management ---

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    // 1- Remove student from student list
    students.removeWhere((s) => s.id == studentId);

    // 2- Remove student from every course
    for (var course in courses) {
      course.studentIds.remove(studentId);
    }

    // 3- Remove all results
    courseResults.removeWhere((cr) => cr.studentId == studentId);
  }

  // --- Course Management ---

  void addCourse({required String courseId, required String courseName}) {
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Course $courseId already exists');
    }

    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    courses.removeWhere((c) => c.id == courseId);
    courseResults.removeWhere((cr) => cr.courseId == courseId);
  }

  // --- Enrollment  ---

  void enrollStudent({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (course.studentIds.contains(studentId)) {
      throw Exception(
          'Student $studentId is already enrolled in course $courseId');
    }

    course.studentIds.add(studentId);
  }

  void discardStudentFromCourse(
      {required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    course.studentIds.remove(studentId);

    courseResults.removeWhere(
        (cr) => cr.studentId == studentId && cr.courseId == courseId);
  }

  // --- Result ---

  void addResult({
    required String studentId,
    required String courseId,
    required int score,
  }) {
    if (score > 100 || score < 0) {
      throw Exception(
          'Invalid result: $score. Score must be between 0 and 100.');
    }

    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    bool isResultExist = false;
    for (CourseResult cr in courseResults) {
      if (cr.studentId == studentId && cr.courseId == courseId) {
        isResultExist = true;
        break;
      }
    }
    if (isResultExist) {
      throw Exception(
          'Result for student $studentId in course $courseId already exists');
    }

    courseResults.add(CourseResult(
        id: '${studentId}_$courseId',
        studentId: studentId,
        courseId: courseId,
        score: score));
  }

  void removeResult({required String studentId, required String courseId}) {
    CourseResult? courseResult = _findResultOrNull(studentId, courseId);

    if (courseResult == null) {
      throw Exception('Result not found');
    }

    courseResults.remove(courseResult);
  }

  // --- Helper ---

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null;
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  CourseResult? _findResultOrNull(String studentId, String courseId) {
    for (CourseResult cr in courseResults) {
      if (cr.studentId == studentId && cr.courseId == courseId) {
        return cr;
      }
    }
    return null;
  }
}

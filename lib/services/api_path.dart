class APIPath {
  static String publicProject(String projectId) => 'public_projects/$projectId';
  static String personalProject(String uid, String projectId) => 'users/$uid/projects/$projectId';
  static String publicProjectsList() => 'public_projects';
  static String personalProjectsList(String uid, ) => 'users/$uid/projects';
}
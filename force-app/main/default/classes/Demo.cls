public with sharing class Demo {
  public static Integer demoSum(Integer a, Integer b) {
    System.debug('Hello from CircleCI');
    System.debug('Modify for Test12 branch');
    return a + b;
  }

  public static Integer demoMulti(Integer a, Integer b) {
    System.debug('Hello from CircleCI');
    System.debug('Hello from CircleCI');
    System.debug('Hello from CircleCI');
    return a * b;
  }
}

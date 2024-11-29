@isTest
private class DemoTest {
  @isTest
  static void myUnitTest() {
    Integer num = Demo.demoSum(2, 3);
    System.assertEquals(5, num, 'Num should be 5');
  }

  @isTest
  static void myUnitTestforMultiplication() {
    Integer num = Demo.demoMulti(2, 3);
    System.assertEquals(5, num, 'Num should be 6');
  }
}

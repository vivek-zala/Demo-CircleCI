@isTest
private class DemoTest {
  @isTest
  static void myUnitTest() {
    Integer num = Demo.demoSum(2, 3);
    System.assertEquals(5, num, 'Num should be 5');
  }
}

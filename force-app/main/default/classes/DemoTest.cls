@isTest
private class DemoTest {

    @isTest
    static void myUnitTest() {
        Integer num = Demo.demoSum(2,3);
        System.assertEqual(5, num, 'Num should be 5');
    }
}
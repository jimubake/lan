> 每天两题，从 easy 到 hard

### 数组：easy

1. 原地移除一个有序数组中的重复元素

   - 使用双指针，fast、slow

     ```java
     /**
     * 原地移除一个有序数组中的重复元素
     * @param nums: 有序数组
     * @return 去掉重复元素后的数组长度
     */
     public int removeDuplicatesFromSortedArray(int[] nums) {
       int fast = 1, slow = 1;
       int length = nums.length;
       for (; fast < length; fast++) {
         if(nums[fast] != nums[fast-1])
           nums[slow++] = nums[fast];
       }
       return slow;
     }
     ```

2. 买卖股票的最佳时机 I

   - 买卖一次获取的最大收入

     ```java
     public int maxProfit(int[] prices) {
       if (prices.length < 1)
         return 0;
       int maxValue = 0;
       // 表示前一天卖出股票时获取的最大收入
       int previous = 0;
       for (int i = 1; i < prices.length; i++) {
         // 当天和前一天的利润差
         int diff = prices[i] - prices[i - 1];
         // 状态转移方程：第 n 天卖出时能获取的最大收入 = 第 n-1 天卖出时的最大收入 + 利润差
         previous = Math.max(previous + diff, 0);
         maxValue = Math.max(previous, maxValue);
       }
       return maxValue;
     }
     ```

3. 买卖股票的最佳时机 II

   - 多次买卖获取最大收益

   - 你不能同时参与多笔交易（你必须在再次购买前出售掉之前的股票）

   - https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/solution/best-time-to-buy-and-sell-stock-ii-zhuan-hua-fa-ji/

     ```java
     public int maxProfit2(int[] prices) {
       int profit = 0;
       for (int i = 1; i < prices.length; i++) {
         int tmp = prices[i] - prices[i - 1];
         if (tmp > 0) profit += tmp;
       }
       return profit;
     }
     
     // 动态规划
     public int maxProfit2_1(int[] prices) {
       int len = prices.length;
       int dp0 = 0, dp1 = -prices[0];
       for (int i = 1; i < len; i++) {
         int newDp0 = Math.max(dp0, dp1 + prices[i]);
         int newDp1 = Math.max(dp0 - prices[1], dp1);
         dp0 = newDp0;
         dp1 = newDp1;
       }
       return dp0;
     }
     ```

     




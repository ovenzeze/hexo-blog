---
title: 前端同学算法课:二分查找
date: 2020-02-05 22:37:41
tags:
---
> 最近在LeetCode刷题，顺便温习了大学时学的数据结构和算法的知识。同时由于现在所处的环境和认知的差异，对这些知识有有了新的理解。这里简单记录一下，算是自己的一个学习、归纳到输出的过程。欢迎感兴趣的同学一起探讨。
<!--more-->
## 什么是二分查找
二分查找，顾名思义，就是在查找中不断的将查找空间一分为二的查找方式。采用的是算法里最常用的`分治`的思想，每次查找后都会将待查找的集合缩小一半。常见的`快速排序算法`就是分治思想的另一种实现。
## 为什么使用二分查找
对于在一个大小为n线性集合中搜索特定值这一类问题，如果使用常规的检索方法。最好的情况需要`1次`比较，最坏的情况需要`n次`比较。
如果使用二分查找，最坏的情况也只需要`log2^n`次查找。效率明显比全检索要快。
## 二分查找的流程
* 预处理(排序、获取起点和终点)
* 循环或递归对待搜索集合进行对半划分
* 后处理(判断是否搜索结束)
## 二分查找的实现
> 没有特殊说明，所有的代码实现都通过TypeScript实现

### 最常见的场景:
> 在一个无重复值从小到大排列的数组中，查找数字K出现的位置, 不存在返回-1。   
```javascript
/**
 * search index of target number from a sorted no-duplicate array list
 * @param list: number[]
 * @param target: number
 * @returns index: number
 */
const BinarySearch = (list: number[], target: number) => {
    let index: number = -1
    let left: number = 0
    let right: number = list.length - 1
    let mid: number
    if (list.length === 0) {
        return index
    }
    while (left <= right) {
        console.debug('[left]:', left, '[mid]:', mid, '[right]:', right)
        mid = Math.floor(left + (right - left) / 2)
        if (list[mid] > target) {
            right = mid - 1
        } else if (list[mid] < target) {
            left = mid + 1
        } else {
            index = mid
            break
        }
    }
    return index
}
```
二分查找的逻辑和思想理解起来都很简单，但是面试或者实战的时候，经常说十个二分查找九个错。其中的主要问题就是在边界的处理和终止条件的判断上。
* 如何处理上下界
二分查找的核心思想就是每次将目标值和中点的值进行比较，如果`中点值 > 目标值`，说明目标值在中间值的左侧。如果`中点值 < 目标值`，说明目标值在中间值的右侧。    
这个时候，一个很常见的写法就是:`left = mid`或者`right = mid`。没错，正确的东西总是简洁的，多一次比较也没问题。
执行一下代码就会发现，如果在`right - left = 1`并且`mid < target`时，会陷入死循环。
比如: `在 [1,2,3]中找3`
理解起来也很容易，在`right - left = 1`并且`mid < target`时，因为`Math.floor`向下取整，其实是在`right - left = 奇数`的时候，将`mid`值向左偏移了。最后出现的结果就是`left = a mid = a right = a + 1`始终在循环，既无法访问到`a + 1`，结束查找。也无法达到`left > right`的条件跳出循环。
正确的逻辑应该是: `left = mid + 1`和`right = mid - 1`
`index = mid`的值在我们的判断条件中已经比较过了，所以对于下一次的查找应该`mid`左侧的数据或者右侧的数据。正是循环跳出条件的处理上，使用了一个不变值，造成了在特殊的数据集合下代码执行出现问题。对于`while循环`和`递归`来说，这是一个非常常见的错误。需要非常谨慎的处理循环跳出条件。
* 什么时候终止查找
这个问题其实和上面的问题如出一辙。一种常见的错误是循环条件写成`left < right` ,而不是`left <= right`。这个也很好理解，`left = right`的时候已经逼近到了最后一个值，只需要比较这个值和`target`就可以。没有必要再执行一次循环。
但是在`right - left = 1`并且`right = target`的场景下，会导致无法正确的获取到`target`值。
比如: `在 [1,2,3]中找3`
原因在于我们判断是否找到`target`值使用的是`index = mid`时的值，在`left = right`的上一次循环中，`list[mid] !== target`，此时需要多执行一次循环，使` left = mid = right`, 来逼近正确的边界值。
对于这个问题，有同学会说，可以在`while`循环结束的时候，再判断一次`list[left]` 是否等于`taget`的值来避免。对于分治思想的算法还是说，能够用同一套逻辑去处理不同的数据集下的数据，尽可能的避免为特殊的数据设置特殊的逻辑。当然这样的处理是没有问题的，如果能够在第一时间考虑到，也是很好的处理方式。

### 递归版的写法
```javascript
const BinarySearchRecur = (list: number[], target: number, left?: number, right?: number) => {
    left = left || 0
    right = right === 0 ? right : (right || list.length - 1)
    let mid: number
    mid = Math.floor(left + (right - left) / 2)
    if (left === right && list[left] !== target) {
        return -1
    }
    if (list[mid] > target) {
            return BinarySearchRecur(list, target, left, mid - 1)
        } else if (list[mid] < target) {
            return BinarySearchRecur(list, target, mid + 1, right)
        } else {
            return mid
        }
}
```
### 变种的场景之一:
 > 在一个可能有重复值从小到大排列的数组中，查找数字K第一次出现的位置, 不存在返回-1。

上面的二分查找是无法处理有重复值的情况，如果出现重复值，返回的位置是错误的，无法保证返回第一个重复值或最后一个重复值。
> 但是我们可以这样理解，既然二分查找的思想是通过分治的方法不断的逼近目标值，
那么如果需要获取第一次目标值出现的位置，那么我们在查找到目标值的时候再继续逼近不是就可以？
直到无法再继续逼近(已经达到了目标值第一次出现的位置)。
因为如果前面不存在目标值了(前面的值始终小于目标值)，那么二分查找的区间就无法继续向前缩小。

1: 按照正常二分查找的方法获取第一次找到目标值的位置
2: 以此位置为`right`坐标，继续向左缩小查找区间，如此循环
3: 最终查找区间无法再继续缩小，即是最左侧(第一次出现)目标值
```javascript
const BinarySearchFirstDupElement = (list: number[], target: number) => {
    let index: number = -1
    let left: number = 0
    let right: number = list.length - 1
    let mid: number
    while (left <= right) {
        mid = Math.floor(left + (right - left) / 2)
        console.log('[debug][left]:', left, '[debug][mid]:', mid, '[debug][right]:', right)
        if (list[mid] >= target) {
            right = mid - 1
        } else if (list[mid] < target) {
            left = mid + 1
        }
    }
    // Q: why use left index to check?
    index = list[left] === target ? left : index
    return index
}
```
### 变种的场景之二:
>在一个可能有重复值从小到大排列的数组中，查找数字K最后一次出现的位置, 不存在返回-1。

同理，查找最后一次出现的位置，那么在查找到目标值后，再继续向右查找，直到查找结束

```javascript
const BinarySearchLastDupElement = (list: number[], target: number) => {
    let index: number = -1
    let left: number = 0
    let right: number = list.length - 1
    let mid: number
    while (left <= right) {
        mid = Math.floor(left + (right - left) / 2)
        console.log('[debug][left]:', left, '[debug][mid]:', mid, '[debug][right]:', right)
        if (list[mid] > target) {
            right = mid - 1
        } else if (list[mid] <= target) {
            left = mid + 1
        }
    }
    // Q: why use right index to check?
    index = list[right] === target ? right : index
    return index
}
```
对于这两种场景，有一个需要特别注意的问题。在最终跳出`while`循环的时候，我们要去检查`目标位置是否等于目标值`，因为我们的场景里存在着目标值不存在于待检索数组中的情况。

**在查找第一次出现的值，使用的是`left`去检查，在查找最后一次出现的值，使用的是`right`去检查。为什么？**

> 比如: `在[1, 2, 2, 2, 3]中找2第一次出现的位置和最后一次出现的位置`
可以看到如果都使用`left`去检查，第一次出现的位置是`1`，最后一次出现的位置是`-1`
如果都使用`right`去检查，第一次出现的位置是`-1`，最后一次出现的位置是`3`

这里还是上面提到的边界值的处理的问题，有了上面的经验我们可以知道，在达到`left > right`，即跳出`while循环`之前，我们首选会达到`right - left  = 1`这一个临界状态。而此时，如果说待搜索数组中存在目标值的话，目标值肯定是`right`或者`left`处的值(否则的话就无法逼近到这个区间，可以仔细理解一下)
我们以检索最后一次出现的目标值的位置这个问题为例看一下:
`left = a, mid = a, right = a + 1 `，我们需要检查的最终值是`list[a]`或`list[a + 1]`
现在分三种情况:
```
 # a) list[a] = target
 1: 继续向右逼近，left = a + 1, mid = a + 1, right = a + 1
 2: list[a] = target，list[a + 1] >= target
 2.1: list[a + 1] > target，left = a + 1, right = a, left > right, 跳出循环
 2.2: list[a + 1] = target，left = a + 1 + 1, right = a + 1, left > right, 跳出循环
 # b) list[a] > target
## 左值大于目标值，说明目标值小于此数组的最小值，不存在于此数组中
 1: 继续向左逼近，left = a , right = a - 1
 2: left > right, 跳出循环
 # c) list[a] < target
 1: 继续向右逼近，left = a + 1, mid = a + 1, right = a + 1
 2: 此时最多执行一次循环，无论是right = mid - 1还是left = mid + 1都会导致left > right
 2.1: list[a + 1] > target，left = a + 1, right = a, left > right, 跳出循环
 2.2: list[a + 1] = target，left = a + 1 + 1, right = a + 1, left > right, 跳出循环
 2.3: list[a + 1] < target，右值小于目标值，说明目标值大于此数组的最大值，不存在于此数组中
```
可以看到，无论在哪一种情况下，因为我们在`list[mid] = target`时对`left`的处理，导致`left`的最终值已不具有参考性。所以，在向右查找中，我们使用`right`处的值来判断是否等于`target`,向左查找时同理使用`left`处的值。
### 变种的场景之三:
> 在一个可能有重复值从小到大排列的数组中，查找数字K出现的所有的位置, 不存在返回空数组。   

有了前面的两个基础，这个场景应该很简单。提供一个思路，对于一个有序的数组来说，我们知道，相等的值肯定是相邻的。
对于这个问题就转化成`找到目标值第一次出现的位置和最后一次出现的位置，这之间的所有位置都是目标值`
具体步骤如下:
* 找到目标值第一次出现的位置
* 找到目标值最后一次出现的位置
* 比较两次查找到的位置，获取结果
```javascript
 * search all index of target value from a sorted array list which may contains duplicate element
 * @param list: number[]
 * @param target: number
 * @returns list: number[] all index of target
 */
const BinarySearchAllIndex = (list: number[], target: number) => {
    const indexList: number[] = []
    const firstIndex: number = BinarySearchFirstDupElement(list, target)
    const lastIndex: number = BinarySearchLastDupElement(list, target)
    console.log('firstIndex:', firstIndex, 'lastIndex:', lastIndex)
    if (firstIndex === lastIndex && firstIndex !== -1) {
        indexList.push(firstIndex)
    } else if (firstIndex !== lastIndex) {
        for (let i = firstIndex; i <= lastIndex; i++) {
            indexList.push(i)
        }
    }
    return indexList
}
```
## 时间和空间复杂度
* 时间复杂度
 > 时间复杂度指的是随着数据规模n的增长，算法执行时间的增长趋势。
常见的时间复杂度从低到高有:
常数阶O(1),
对数阶O(log2^n),
线性阶O(n),
线性对数阶O(nlog2^n),
平方阶O(n^2)，
立方阶O(n^3)
k次方阶O(n^K),
指数阶O(2^n)

对于二分查找，时间复杂度就是`while`循环执行的次数。我们看最坏的情况
```
第一次: n
第二次: n / 2
第三次: n / 2 ^ 2
第四次: n / 2 ^ 3
第K次: n / 2 ^ k
K就是二分查找的循环执行的次数，最坏的情况一直查找到最后只剩一个元素才结束查找。
则有: n / 2 ^ k = 1 => k = log2 ^ n 时间复杂度为以2为底n的对数
对于算法执行次数，递归版和非递归版没有区别，故时间复杂度一样
```
时间复杂度: `log2 ^ n`
* 空间复杂度
> 空间复杂度是用来描述随着数据规模n的增长，执行时需要临时占用的空间的大小的增长趋势。
对于所有的空间只申请一次的算法，和时间复杂度一样，空间复杂度是O(1)，不随着数据规模n的增长而增长。

对于`非递归版的二分查找`，所有的临时空间只申请一次，和数据规模n无关，则很容易得出空间复杂度是`O(1)`
对于`递归版的二分查找`，我们可以拆分看一下:
```
第一次: 申请一次空间存储mid的值
第二次: 第二次申请一次新的空间存储mid的值
第K次: 第K次申请一次新的空间存储mid的值
可以看到，占用的空间的大小和算法执行的次数有关
而在时间复杂度这一部分，我们已经得到算法执行的次数和数据规模n有关: k = log2 ^ n
那么，递归版的空间占用的复杂度就是 每次占用的空间O(1) * 算法执行的次数O(log2^n) = O(log2^n)
```
空间复杂度: 非递归: `O(1)` 递归: `log2 ^ n`
## Try It On
如果觉得差不多已经理解二分查找了，可以试试`LeetCode`上的这些使用二分查找的题目，都是`easy`难度。一旦开始做题，就不要再回头看这篇解析了，记住关掉文章再去做题哦！！！

[LeetCode374:猜数字大小](https://leetcode-cn.com/problems/guess-number-higher-or-lower/)
[LeetCode69:x 的平方根](https://leetcode-cn.com/problems/sqrtx/)
[LeetCode69:检查一个数是否在数组中占绝大多数](https://leetcode-cn.com/problems/check-if-a-number-is-majority-element-in-a-sorted-array/)
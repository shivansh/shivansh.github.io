---
title: "How interesting can structs get ?"
layout: single
---

This afternoon, my professor and me were discussing the fixed point method to determine the dominators of a node in a control flow graph, and how choosing a good seed value is extremely important in such problems. This is when I recalled the [reddit post](https://www.reddit.com/r/programming/comments/t9zb/origin_of_quake3s_fast_invsqrt/) I came across sometime back about the fixed point method to evaluate inverse square root and how the seed value used in it is extremely efficient. The code for this (which was also used in the game Quake 3) uses an interesting C construct of [casting a pointer](https://www.reddit.com/r/programming/comments/t9zb/origin_of_quake3s_fast_invsqrt/ctaek/) (instead of the usual type casting) to retain the contents of a variable while changing its type.  
Basically, when you want to perform a type cast, say a float to an integer, it might result in truncation (i.e. the resultant will be a floor value of the initial value). A way of achieving this without losing data is to cast the pointer to that data type, changing the way that pointer is interpreted, and then dereferencing it. This will preserve the exact memory representation of the initial value and will also change its type.  

The following code demonstrates pointer casting -

```
float pi     = M_PI;
int   i_cast = (int) pi;        // type casting
int   i_ptr  = *(int *)&pi;     // pointer casting
```

A union can also be used for the above problem

|---|
| **NOTE:** The above defined scenario of pointer casting might lead to undefined behavior and should be avoided unless one is pretty sure of what is to be achieved. |


After this, we started discussing interesting hacks that can be made use of in C, and here is a cool one which he recalled -

> Suppose you have a struct definition in C which contains an array member (let's say it is an array of ints). While declaring the struct, you don't know how many elements the array will contain and you also don't want to declare it with arbitrary number of elements. A known way for this case is using an integer pointer, and later using `malloc()` for space allocation. But now, I want to access this array like `my_struct->my_array[i]` (`my_struct` will be a pointer to the struct in discussion), and I cannot use an integer pointer. How to achieve this ?

Suppose the number of elements I want in the array is stored in a variable of type int named `count`. An interesting method of approaching this problem is to take advantage of the memory representation of a struct.  

- We declare the array to initially contain zero elements in the struct definition.
- Next, when we allocate space for the struct (via `malloc()`), we also allocate space for "count" number of integer elements following it. Thus, `malloc()` will return a pointer to a struct which essentially contains an array of "count" elements.
- Now we can use this array (which was initially declared with zero elements) as a usual "count" sized array.

The following C code demonstrates the above described procedure -

```
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  // We don't know how many entries "arr" will contain at this
  // point, so declare it to (initially) contain zero elements.
  int arr[0];
} test_struct;

int main() {
  // The variable "count" contains the number of
  // entries that we desire in the array "arr".
  int count = 4;        // an arbitrary value
  test_struct *str;

  // We take advantage of the memory representation of a struct in C.
  // After allocating space for "str", we also allocate space for "count"
  // number of integers. This way, the pointer to test_struct returned
  // by malloc() will now contain an array (of size 0), followed by space
  // for "count" number of ints.
  // Thus, "arr" will behave exactly as a "count" sized array.
  str = (test_struct*) malloc(sizeof(test_struct) + count*sizeof(int));

  // Test for validity: populate "arr" and print its contents.
  for (int i = 0; i < count; i++)
    str->arr[i] = i;

  for (int i = 0; i < count; i++)
    printf("%d\n", str->arr[i]);

  return 0;
}
```

To summarize, the title of the post can be answered in two words - **A LOT!**

Thanks for reading!

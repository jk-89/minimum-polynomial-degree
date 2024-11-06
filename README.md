# Minimum Polynomial Degree

An Assembly program developed for the Operating System course at the University of Warsaw. The solution is based on repeatedly subtracting values, which require implementing a manual subtraction algorithm for large integers.

## Detailed description

Implement a function in assembly named `polynomial_degree` to be called from C with the signature:
```
int polynomial_degree(int const *y, size_t n);
```
The function parameters are a pointer $y$ to an array of integers $y_{0}, y_{1}, ..., y_{n - 1}$ and an integer $n$ representing the length of this array. The function should return the minimum degree of a polynomial $w(x)$ of one variable with real coefficients such that $w(x + kr) = y_{k}$ for some real number $x$, some non-zero real number $r$, and $k = 0, 1, ..., n - 1$.

We assume that a polynomial identically equal to zero has a degree of $-1$. You may assume the pointer $y$ is valid and points to an array of $n$ elements, and that $n$ has a positive value.

Note that if the polynomial $w(x)$ has degree $d$ and $d \geq 0$, then for $r \neq 0$, the polynomial $w(x + r) − w(x)$ has degree $d - 1$.

## Usage
Compile with
```
nasm -f elf64 -w+all -w+error -o polynomial_degree.o polynomial_degree.asm
```
To run a test use
```
gcc -c -Wall -Wextra -std=c17 -O2 -o polynomial_degree_example.o polynomial_degree_example.c
gcc -o polynomial_degree_example polynomial_degree_example.o polynomial_degree.o
```

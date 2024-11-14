# Chelancer

## What

**Che**mical equation ba**lancer**

Built with Flutter using Visual Studio Code

## How

Given chemical equation below
`H2 + O2 = H2O`

1. Remove blanks
   `H2+O2=H2O`
2. Count every element (with the order of first appearing from left to right) in every formulars from left to right
   ```
   H in H2: 2
   H in O2: 0
   H in H2O: 2
   
   O in H2: 0
   O in O2: 2
   O in H2O: 1
   ```
3. Build a map
   ```
   {'H': [2, 0, -2]}
   {'O': [0, 2, -1]}
   ```
   *Note that count on the right of '=' should be negative, see below for reason.*
4. Build linear equation system
   $
   \begin{bmatrix}
   2 & 0 & -2 & 0 \\\
   0 & 2 & -1 & 0 \\\
   1 & 0 & 0 & 1
   \end{bmatrix}
   $
   *We add last row here cuz we wanna this matrix has only one solution so you may write like `0 1 0 2`, `0 0 1 1`, or whatever, that's all ok.*
5. Solve it and all done!

## Known issues

Not support `()`, like `Cu(SO)4`

## Thanks

Inspired by https://www.quora.com/Is-there-an-algorithm-to-balance-a-chemical-equation-Or-is-it-a-hard-problem

*I found this one answered by `Faris Muhammad` but unfortunately the repository is no longer exist so I write this*

## Libraries

advanced_math https://pub.dev/packages/advance_math#solving-linear-systems-of-equations for solving linears equations

fraction https://pub.dev/packages/fraction for converting from `double` to `String` in fraction format

## More

The linear system we mentioned above actually don't need the last row when we are using Python since https://docs.sympy.org/latest/tutorials/intro-tutorial/matrices.html#nullspace can directly give the solution
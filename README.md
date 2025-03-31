# Convert to Natural Coefficients

Функция `convert_to_natural_coeffs` предназначена для преобразования кодированных коэффициентов факторной модели в натуральные коэффициенты. Функция используется для уравнения вида:

<b> y = b<sub>0</sub> + b<sub>1</sub>x<sub>1</sub> + b<sub>2</sub>x<sub>2</sub> + b<sub>3</sub>x<sub>3</sub> + b<sub>12</sub>x<sub>1</sub>x<sub>2</sub> + b<sub>13</sub>x<sub>1</sub>x<sub>3</sub> + b<sub>23</sub>x<sub>2</sub>x<sub>3</sub> + b<sub>123</sub>x<sub>1</sub>x<sub>2</sub>x<sub>3</sub> </b>

где:
-  b<sub>0</sub>, b<sub>1</sub>, b<sub>2</sub>, b<sub>3</sub>, b<sub>12</sub>, b<sub>13</sub>, b<sub>23</sub>, b<sub>123</sub> — коэффициенты, которые могут быть заданы в кодированном виде,
-  x<sub>1</sub>, x<sub>2</sub>, x<sub>3</sub> — кодированные значения факторов,
-  X<sub>1</sub>, X<sub>2</sub>, X<sub>3</sub> — натуральные значения факторов.

### Преобразование значений
При переходе от **кодированных** значений к **натуральным** используется формула:
\[ x<sub>i</sub> = \frac{X<sub>i</sub> - X<sub>0</sub>}{n} \]
где:
- **x<sub>i</sub>** — кодированное значение фактора,
- **X<sub>i</sub>** — натуральное значение фактора,
- **X<sub>0</sub>** — натуральное значение основного уровня (базовая точка),
- **n** — интервал варьирования (шаг изменения в натуральных единицах).


Итоговое уравнение имеет вид:
<b> y = B<sub>0</sub> + B<sub>1</sub>X<sub>1</sub> + B<sub>2</sub>B<sub>2</sub> + B<sub>3</sub>X<sub>3</sub> + B<sub>12</sub>X<sub>1</sub>X<sub>2</sub> + B<sub>13</sub>X<sub>1</sub>X<sub>3</sub> + B<sub>23</sub>X<sub>2</sub>X<sub>3</sub> + B<sub>123</sub>X<sub>1</sub>X<sub>2</sub>X<sub>3</sub> </b>
## Использование
```matlab
[B0, B1, B2, B3, B12, B13, B23, B123] = convert_to_natural_coeffs(b0, b1, b2, b3, b12, b13, b23, b123, X0, n);

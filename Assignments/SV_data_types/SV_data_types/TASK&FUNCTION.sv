TASK & FUNCTION:  Tasks and Functions provide a means of splitting code into small parts.


TASK: A Task can contain a declaration of parameters, input arguments, output arguments, in-out arguments, registers, events,
 and zero or more behavioral statements.

SystemVerilog task can be:
static   :  Static tasks share the same storage space for all task calls.
automatic:  Automatic tasks allocate unique, stacked storage for each task call.

SystemVerilog allows:
to declare an automatic variable in a static task
to declare a static variable in an automatic task
more capabilities for declaring task ports
multiple statements within task without requiring a begin…end or fork…join block
returning from the task before reaching the end of the task
passing values by reference, value, names, and position
default argument values
the default direction of argument is input if no direction has been specified
default arguments type is logic if no type has been specified

EX1: task arguments in parentheses:-

module sv_task;
  int x;

  //task to add two integer numbers.
  task sum(input int a,b,output int c);
    c = a+b;   
  endtask

  initial begin
    sum(10,5,x);
    $display("\tValue of x = %0d",x);
  end
endmodule

O/P: Value of x=15


EX2: task arguments in declarations and mentioning directions:-

module sv_task;
  int x;

  //task to add two integer numbers.
  task sum;
    input int a,b;
    output int c;
    c = a+b;   
  endtask

  initial begin
    sum(10,5,x);
    $display("\tValue of x = %0d",x);
  end
endmodule

O/P: Value of x = 15


/************************/

FUNCTION: A Function can contain declarations of range, returned type, parameters, input arguments, registers, and events.

A function without a range or return type declaration returns a one-bit value
Any expression can be used as a function call argument
Functions cannot contain any time-controlled statements, and they cannot enable tasks
Functions can return only one value

SystemVerilog function can be:
static   : Static functions share the same storage space for all function calls.
automatic: Automatic functions allocate unique, stacked storage for each function call.

SystemVerilog allows:
to declare an automatic variable in static functions
to declare the static variable in automatic functions
more capabilities for declaring function ports
multiple statements within a function without requiring a begin…end or fork…join block
returning from the function before reaching the end of the function
Passing values by reference, value, names, and position
default argument values
function output and inout ports
the default direction of argument is input if no direction has been specified.
default arguments type is logic if no type has been specified.


EX1: function arguments in parentheses

module sv_function;
  int x;
  //function to add two integer numbers.
  function int sum(input int a,b);
    sum = a+b;   
  endfunction

  initial begin
    x=sum(10,5);
    $display("\tValue of x = %0d",x);
  end
endmodule

O/P=Value of x=15


EX2:function arguments in declarations and mentioning directions

module sv_function;
  int x;

  //function to add two integer numbers.
  function int sum;
    input int a,b;
    sum = a+b;   
  endfunction
  initial begin
    x=sum(10,5);
    $display("\tValue of x = %0d",x);
  end
endmodule

O/P: Value of x = 15


EX3: function with return value with the return keyword
In the below example,
arguments in declarations and directions, return value is specified using the return statement.

module sv_function;
  int x;

  //function to add two integer numbers.
  function int sum;
    input int a,b;
    return a+b;     
  endfunction

  initial begin
    x=sum(10,5);
    $display("\tValue of x = %0d",x);
  end
endmodule

O/P: Value of x = 15

EX4: Void function
The example below shows usage of void function, void function,(function with no return value)

module sv_function;
  int x;
  //void function to display current simulation time 
  function void current_time;
    $display("\tCurrent simulation time is %0d",$time);    
  endfunction
 
  initial begin
    #10;
    current_time();
    #20;
    current_time();
  end
endmodule

Simulator Output:
Current simulation time is 10
Current simulation time is 30


discarding function return value:
The function return value must be assigned to a variable or used in an expression.
Calling a function without return value assigned to a variable can result in a warning message.
 SystemVerilog void data type is used to discard a function’s return value without any warning message.


EX5: 
module sv_function;
  int x;
   //function to add two integer numbers. 
  function int sum;
    input int a,b;
    return a+b;    
  endfunction
 
  initial begin
    $display("Calling function with void");
    void'(sum(10,5));
  end
 endmodule
 
Simulator Output:
Calling function with void


EX6: function call as an expression

module sv_function;
  int x;
  //function to add two integer numbers. 
  function int sum;
    input int a,b;
  return a+b;    
  endfunction
  initial begin
    x = 10 + sum(10,5);
    $display("\tValue of x = %0d",x);
  end
endmodule
Simulator Output

Value of x = 25


/***************************/
Task and Function argument passing:

SystemVerilog provides below means for passing arguments to functions and tasks:
argument pass by value
argument pass by reference
argument pass by name
argument pass by position
also, functions and tasks can have default argument values.

1)argument pass by 'value':
In argument pass by value,
the argument passing mechanism works by copying each argument into the subroutine area.
if any changes to arguments within the subroutine, those changes will not be visible outside the subroutine.

EX1:
module argument_passing;
  int x,y,z;
  //function to add two integer numbers.
  function int sum(int x,y);
    x = x+y;
    return x+y;   
  endfunction

  initial begin
    x = 20;
    y = 30;
    z = sum(x,y);
    $display("-----------------------------------------------------------------");
    $display("\tValue of x = %0d",x);
    $display("\tValue of y = %0d",y);
    $display("\tValue of z = %0d",z);
    $display("-----------------------------------------------------------------");
  end
endmodule

O/P:
-----------------------------------------------------------------
Value of x = 20
Value of y = 30
Value of z = 80
-----------------------------------------------------------------


2)argument pass by 'reference':
In pass by reference, a reference to the original argument is passed to the subroutine.
As the argument within a subroutine is pointing to an original argument, any changes to the argument within subroutine will be visible outside.
To indicate argument pass by reference, the argument declaration is preceded by keyword ref.

Any modifications to the argument value in a pass by reference can be avoided by using const keyword before ref,
 any attempt in changing the argument value in subroutine will lead to a compilation error.
 
EX1: argument pass by reference example
variables x and y are passed as an argument in the function call sum, changes to the argument x within the function, is visible outside.

module argument_passing;
  int x,y,z;

  //function to add two integer numbers.
  function int sum(ref int x,y);
    x = x+y;
    return x+y;   
  endfunction

  initial begin
    x = 20;
    y = 30;
    z = sum(x,y);
    $display("-----------------------------------------------------------------");
    $display("\tValue of x = %0d",x);
    $display("\tValue of y = %0d",y);
    $display("\tValue of z = %0d",z);
    $display("-----------------------------------------------------------------");
  end
endmodule

O/P:
-----------------------------------------------------------------
Value of x = 50
Value of y = 30
Value of z = 80
-----------------------------------------------------------------

==>Any modifications to the argument value in a pass by reference can be avoided by using const keyword before ref,
 any attempt in changing the argument value in subroutine will lead to a compilation error.
 
EX1: argument pass by reference with the const keyword
variables x and y are passed as an argument in the function call sum, as arguments are mentioned as const,
changes to the argument x within the function leads to a compilation error.

module argument_passing;
  int x,y,z;
  //function to add two integer numbers.
  function int sum(const ref int x,y);   //Here const keyword makes error
    x = x+y;
    return x+y;   
  endfunction

  initial begin
    x = 20;
    y = 30;
    z = sum(x,y);
    $display("-----------------------------------------------------------------");
    $display("\tValue of x = %0d",x);
    $display("\tValue of y = %0d",y);
    $display("\tValue of z = %0d",z);
    $display("-----------------------------------------------------------------");
  end
endmodule

O/P:
-----------------------------------------------------------------
'const' variable is either driven or connected to a non-const variable.
Variable 'x' declared as 'const' cannot be used in this context
Source info: x = (x + y);
1 error
-----------------------------------------------------------------

3)default argument values:
The default value can be specified to the arguments of the subroutine.
In the subroutine call, arguments with a default value can be omitted from the call.
if any value is passed to an argument with a default value, then the new value will be considered.

EX1: an argument with default value example
variables x, y and z of the subroutine has a default value of 1,2 and 3 respectively, in the function call value is passed only for z. 
x and y will take the default value.

module argument_passing;
  int q;

  //function to add three integer numbers.
  function int sum(int x=5,y=10,z=20);
    return x+y+z;   
  endfunction

  initial begin
    q = sum( , ,10);
    $display("-----------------------------------------------------------------");
    $display("\tValue of z = %0d",q);
    $display("-----------------------------------------------------------------");
  end
endmodule

O/P:
-----------------------------------------------------------------
Value of x = 20
Value of y = 30
Value of z = 25
-----------------------------------------------------------------


4)argument pass by 'name':
In argument pass by name, arguments can be passed in any order by specifying the name of the subroutine argument.

EX1: argument pass by name example
value to the second argument is passed first by specifying the argument name.

module argument_passing;
  int x,y,z;

  function void display(int x,string y);
    $display("\tValue of x = %0d, y = %0s",x,y);   
  endfunction

  initial begin
    display(.y("Hello World"),.x(2016));
  end
endmodule

O/P:
Value of x = 2016, y = Hello World


/*********************/
Code for Inheritance:

// Code your testbench here
// or browse Examples
class transaction;
int data;
int addr;
bit bit_write;
  
  function new();
     data = 12;
     addr = 20;
     bit_write = 1;
  endfunction
  
  function void display();
    $display("data = %0d, addr = %0d, bit_write = %0b", data, addr, bit_write);
  endfunction
endclass

module tb;
initial begin
transaction trans_h1;
transaction trans_h2;
trans_h1=new();
// where we are overridden the vslues
  trans_h1.data = 13;
  trans_h1.addr = 21;
  trans_h1.bit_write = 0;
  
  trans_h1.display();
//trans_h1.data=10;
//$display(trans_h1.data);
trans_h2=new();
  trans_h2.display();
 //trans_h2.data=20;
//$display(trans_h2.data);
//trans_h2 = trans_h1;
//trans_h2.data=40;
  //$display(trans_h1.data);
//$display(trans_h2.data);
end
endmodule

Procedural Statements and Control Flow:

SystemVerilog Blocking assignment:

Blocking assignment statements execute in 'series' order. 
'Blocking assignment blocks the execution of the next statement until the completion of the current assignment execution'.

EX1:In Below Example, a and b is initialized with value 10 and 15 respectively, 
after that b is being assigned to a (a value will become 15), and value 20 is assigned to b. After assignment value of a = 15 and b=20.

module blocking_assignment;
  //variables declaration
  int a,b;
  initial begin  
    $display("-----------------------------------------------------------------");
    //initializing a and b
    a = 10;
    b = 15;
   
    //displaying initial value of a and b
    $display("\tBefore Assignment :: Value of a is %0d",a);
    $display("\tBefore Assignment :: Value of b is %0d",b);
   
    a = b;
    b = 20;
   
    $display("\tAfter  Assignment :: Value of a is %0d",a);
    $display("\tAfter  Assignment :: Value of b is %0d",b);
    $display("-----------------------------------------------------------------");
  end    
endmodule

Simulator Output:
-----------------------------------------------------------------
Before Assignment :: Value of a is 10
Before Assignment :: Value of b is 15
After Assignment :: Value of a is 15
After Assignment :: Value of b is 20
-----------------------------------------------------------------


EX2: In Below Example, a and b are initialized with value 10 and 15 respectively,
after that b is being assigned to a (a value will become 15), and value 20 is assigned to b. After assignment value of a = 15 and b = 20.

module blocking_assignment;
  //variables declaration
  int a,b;
  int x,y;
  initial begin  
    //initializing a and b
    a = 10;
    b = 15;
   
    x = a + b;
    y = a + b + x;
   
    $display("-----------------------------------------------------------------");
    $display("\tValue of x is %0d",x);
    $display("\tValue of y is %0d",y);
    $display("-----------------------------------------------------------------");
  end    
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of x is 25  Value of y is 50
-----------------------------------------------------------------

/********************************/

SystemVerilog NonBlocking assignment:

non-blocking assignment statements execute in 'parallel'.
In the non-blocking assignment, all the assignments will occur at the same time. (during the end of simulation timestamp)
Nonblocking assignment example

EX1: a and b are initialized with values 10 and 15 respectively, after that b is being assigned to a (a value will become 15), 
and value 20 is assigned to b.
After assignment values expected in a and b are 15 and 20 respectively.
but these values will get assigned only after the simulation time-stamp

module nonblocking_assignment;

  //variables declaration
  int a,b;

  initial begin  //initial block will get executed at starting of simulation
    $display("-----------------------------------------------------------------");
    //initializing a and b
    a = 10;
    b = 15;
 
    //displaying initial value of a and b
    $display("\tBefore Assignment :: Value of a is %0d",a);
    $display("\tBefore Assignment :: Value of b is %0d",b);
 
    a <= b;
    b <= 20;
  
    $display("\tAfter  Assignment :: Value of a is %0d",a);
    $display("\tAfter  Assignment :: Value of b is %0d",b);
    $display("-----------------------------------------------------------------");
  end

  final begin  //final block will get executed at end of simulation
    $display("-----------------------------------------------------------------");
    $display("\tEnd of Simulation :: Value of a is %0d",a);
    $display("\tEnd of Simulation :: Value of b is %0d",b);
    $display("-----------------------------------------------------------------");
  end
endmodule

Simulator Output:
-----------------------------------------------------------------
Before Assignment :: Value of a is 10
Before Assignment :: Value of b is 15
After Assignment :: Value of a is 10
After Assignment :: Value of b is 15
-----------------------------------------------------------------
-----------------------------------------------------------------
End of Simulation :: Value of a is 15
End of Simulation :: Value of b is 20
-----------------------------------------------------------------



EX2: a and b are initialized with value 10 and 15 respectively.
x<=a+b and y<=a+b+x
value of x is sum of a (10) and b (15). -> x=10+15=25.
value of y is sum of a (10) ,b(15) and x (0) -> became at current simulation time-stamp value of x=0.
new value will get assigned at the end of current time stamp, and new value will be available only after the current time-stamp). therefore y=10+15+0=25;

module nonblocking_assignment;
  //variables declaration
  int a,b;
  int x,y;
  
  initial begin
    //initializing a and b
    a = 10;
    b = 15;
    
    x <= a + b;
    y <= a + b + x;
    
    $display("-----------------------------------------------------------------");
    $display("\tValue of x is %0d",x);
    $display("\tValue of y is %0d",y);
    $display("-----------------------------------------------------------------");
  end
  
  final begin
    $display("-----------------------------------------------------------------");
    $display("\tEnd of Simulation :: Value of x is %0d",x);
    $display("\tEnd of Simulation :: Value of y is %0d",y);
    $display("-----------------------------------------------------------------");
  end
      

endmodule

Simulator Output:
-----------------------------------------------------------------
Value of x is 0
Value of y is 0
-----------------------------------------------------------------
-----------------------------------------------------------------
End of Simulation :: Value of x is 25
End of Simulation :: Value of y is 25
-----------------------------------------------------------------

/*******************************/

SystemVerilog Unique if:

Unique if evaluates all the conditions 'parallel'.
In the following conditions simulator issue a run time error/warning,
=>More than one condition is true
=>No condition is true or final if doesn’t have corresponding else

EX1: More than one condition is true.
value of a=10, b=20 and c=40. conditions a<b and a<c are true,
Therefore on execution, simulator issue a run time warning.
“RT Warning: More than one condition match in ‘unique if’ statement.”

module unique_if;
  //variables declaration
  int a,b,c;

   initial begin
     //initialization
     a=10;
     b=20;
     c=40;

     unique if ( a < b ) $display("\t a is less than b");
     else   if ( a < c ) $display("\t a is less than c");
     else                $display("\t a is greater than b and c");
  end
endmodule

Simulator Output:
a is less than b
RT Warning: More than one conditions match in 'unique if' statement.


EX2: In below example,
No condition is true and final if doesn’t have corresponding else.
value of a=50, b=20 and c=40, conditions a<b and a<c are false,

Therefore on execution, simulator issue a run time warning.
“RT Warning: No condition matches in ‘unique if’ statement

module unique_if;
  //variables declaration
  int a,b,c;

   initial begin
     //initialization
     a=50;
     b=20;
     c=40;
   
     unique if ( a < b ) $display("\t a is less than b");
     else   if ( a < c ) $display("\t a is less than c");
  end
    
endmodule

Simulator Output:
RT Warning: No condition matches in 'unique if' statement


EX3: In below example, value of a=50, b=20 and c=40.
conditions a<b and a<c are false, so else part is true, there is no simulator run time warning.

module unique_if;

  //variables declaration
  int a,b,c;

   initial begin
     //initialization
     a=50;
     b=20;
     c=40;
   
     priority if ( a < b ) $display("\t a is less than b");
     else     if ( a < c ) $display("\t a is less than c");
     else                  $display("\t a is greater than b and c");
  end
   
endmodule

Simulator Output:
a is greater than b and c

/**************************************/

SystemVerilog Priority if:

priority if:- Priority if evaluates all the conditions in 'sequential' order.
In the following conditions simulator issue a run time error/warning
'No condition is true or final if doesn’t have corresponding else'

EX1: In the below example,
No condition is true or final if doesn’t have corresponding else.
value of a=50,b=20 and c=40. conditions a<b and a<c are false,

module priority_if;
  //variables declaration
  int a,b,c;
  
  initial begin
     //initialization
     a=50;
     b=20;
     c=40;
  
     priority if ( a < b ) $display("\t a is less than b");
     else     if ( a < c ) $display("\t a is less than c");
  end
 endmodule
 
Simulator Output:
RT Warning: No condition matches in 'priority if' statement.

EX2: In the below example,
value of a=10,b=20 and c=40.
conditions a<b and a<c are true, as it is priority based, simulator
considers the first match. therefore there will be no simulator warning message.

module priority_if;

  //variables declaration
  int a,b,c;

   initial begin
     //initialization
     a=10;
     b=20;
     c=40;

     priority if ( a < b ) $display("\t a is less than b");
     else     if ( a < c ) $display("\t a is less than c");
     else                $display("\t a is greater than b and c");
  end
   
endmodule

Simulator Output:
a is less than b

/************************************/

SystemVerilog do while and while:

do while loop:- A do while loop is a control flow statement that allows code to be executed repeatedly based on a given condition.

do while loop syntax:
    do begin
        // statement -1       
        ...
        // statement -n 
    end
    while(condition);
	
In do-while:
the condition will be checked after the execution of statements inside the loop
the condition can be any expression.

do-while is similar to while loop but in case of while loop execution of statements happens only if the condition is true. 
In a do while, statements inside the loop will be executed at least once even if the condition is not satisfied.

EX1: do while loop 
module do_while;
  int a;
 
  initial begin
    $display("-----------------------------------------------------------------");

    do
      begin
        $display("\tValue of a=%0d",a);
        a++;
      end
    while(a<5);    // If we write while(a>5); then we get o/p: Value of a=0
  
    $display("-----------------------------------------------------------------");
  end    
endmodule

Simulator output:
-----------------------------------------------------------------
Value of a=0
Value of a=1
Value of a=2
Value of a=3
Value of a=4
-----------------------------------------------------------------

while loop SystemVerilog: A while loop is a control flow statement that allows code to be executed repeatedly based on a given condition.

while loop syntax
    while(condition) begin
        // statement -1       
        ...
        // statement -n 
    end
	
In a while,
Execution of statements within the loop happens only if the condition is true

EX1:
module while_loop;
  int a;

  initial begin
    $display("-----------------------------------------------------------------");

    while(a<5)  // If we write while(a>5); then we get o/p: is shows empty
  
      begin
        $display("\tValue of a=%0d",a);
        a++;
    end
    $display("-----------------------------------------------------------------");
  end    
endmodule
Simulator Output

-----------------------------------------------------------------
Value of a=0
Value of a=1
Value of a=2
Value of a=3
Value of a=4
-----------------------------------------------------------------

/*************************/

SystemVerilog foreach loop:
foreach loop:-SystemVerilog foreach specifies iteration over the elements of an array. 
the loop variable is considered based on elements of an array and the number of loop variables must match the dimensions of an array.

foreach loop syntax
foreach(<variable>[<iterator>]]) begin
  //statement - 1
  ...
  //statement - n
end
Foreach loop iterates through each index starting from index 0.

EX1: below example shows,
foreach loop in the single dimensional array.

module for_loop;
  int a[4];
  initial begin
    $display("-----------------------------------------------------------------"); 
    foreach(a[i]) a[i] = i;
    foreach(a[i]) $display("\tValue of a[%0d]=%0d",i,a[i]);
 
    $display("-----------------------------------------------------------------");
  end   
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of a[0]=0
Value of a[1]=1
Value of a[2]=2
Value of a[3]=3
-----------------------------------------------------------------

EX2: foreach multidimensional array
Below example shows how to use the foreach loop in a multidimensional array.

module for_loop;
  int a[3][2];

  initial begin
    $display("-----------------------------------------------------------------");
    foreach(a[i,j]) a[i][j] = i+j;
    foreach(a[i,j]) $display("\tValue of a[%0d][%0d]=%0d",i,j,a[i][j]);  
    $display("-----------------------------------------------------------------");
  end    
endmodule
Simulator Output

-----------------------------------------------------------------
 Value of a[0][0]=0
 Value of a[0][1]=1
 Value of a[1][0]=1
 Value of a[1][1]=2
 Value of a[2][0]=2
 Value of a[2][1]=3
-----------------------------------------------------------------

/*****************************/

SystemVerilog For loop:

for loop:- SystemVerilog for loop is enhanced for loop of Verilog.
In Verilog,
the control variable of the loop must be declared before the loop
allows only a single initial declaration and single step assignment within the for a loop
SystemVerilog for loop allows,

declaration of a loop variable within the for loop
one or more initial declaration or assignment within the for loop
one or more step assignment or modifier within the for loop

for loop syntax:
for(initialization; condition; modifier) begin
  //statement - 1
  ...
  //statement - n
end

Initialization: executed first, and only once. This allows the user to declare and initialize loop control variables.
Condition: the condition is evaluated. If it is true, the body of the loop is executed, else the flow jumps to the statement after the ‘for’ loop.
Modifier: at the end of each iteration it will be executed, and execution moves to Condition.

EX1: Below example shows the declaration of a loop variable within the for loop.

module for_loop;
  initial begin
    $display("-----------------------------------------------------------------");
    for(int i=0;i<5;i++) $display("\t Value of i = %0d",i);
    $display("-----------------------------------------------------------------");
  end  
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of i = 0
Value of i = 1
Value of i = 2
Value of i = 3
Value of i = 4
-----------------------------------------------------------------

multiple initializations in for loop:
EX2: Below example shows the declaration and initialization of two variables i and j in for loop.

module for_loop;

  initial begin
    $display("-----------------------------------------------------------------");
 
    for ( int j=0,i=4;j<8;j++) begin
      if(j==i) $display("\tValue j equals to Value of i. j=%0d i=%0d",j,i);
    end
 
    $display("-----------------------------------------------------------------");
  end
   
endmodule

Simulator Output:
-----------------------------------------------------------------
Value j=4 equals to Value of i=4
-----------------------------------------------------------------

EX2:multiple modifiers in for loop
Below example shows the use of two modifiers j++ and i– within the for loop.

module for_loop;

  initial begin
    $display("-----------------------------------------------------------------");
  
    for ( int j=0,i=7;j<8;j++,i--) begin
      $display("\tValue j=%0d Value of i=%0d",j,i);
    end

    $display("-----------------------------------------------------------------");
  end
   
endmodule

Simulator Output:
-----------------------------------------------------------------
Value j equals to Value of i. j=0 i=7
Value j equals to Value of i. j=1 i=6
Value j equals to Value of i. j=2 i=5
Value j equals to Value of i. j=3 i=4
Value j equals to Value of i. j=4 i=3
Value j equals to Value of i. j=5 i=2
Value j equals to Value of i. j=6 i=1
Value j equals to Value of i. j=7 i=0
-----------------------------------------------------------------

/*****************************/

SystemVerilog repeat and forever loop:

repeat loop: repeat will execute the statements within the loop for a loop variable number of times.

'if the loop variable is N, then the statements within the repeat block will be executed N number of times'.

repeat loop syntax
repeat(<variable>) begin
  //statement - 1
  ...
  //statement - n
end

statements 1-n will be executed for a variable value number of times.

EX1: repeat loop value is 4, so the statements within the repeat loop will be executed for 4 times.

module repeat_loop;
  int a;
  initial begin
    $display("-----------------------------------------------------------------");

    repeat(4) begin
        $display("\tValue of a=%0d",a);
        a++;
     end
    $display("-----------------------------------------------------------------");
  end   
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of a=0
Value of a=1
Value of a=2
Value of a=3
-----------------------------------------------------------------

forever loop: As the name says forever loop will execute the statements inside the loop forever.
It can be said as indefinite iteration.

forever loop syntax:
forever begin
  //statement - 1
  ...
  //statement - n
end

forever loop example
module forever_loop;
  int a;
  initial begin
    $display("-----------------------------------------------------------------");
 
    forever begin
      $display("\tValue of a=%0d",a);
      a++;
      #5;
    end
 
    $display("-----------------------------------------------------------------");
  end
  initial begin
    #20 $finish;
  end   
endmodule

Simulator Output:
-----------------------------------------------------------------
           Value of a=0
           Value of a=1
           Value of a=2
           Value of a=3
$finish called from file "testbench.sv", line 27.
$finish at simulation time                   20

/****************************/

SystemVerilog break and continue:

break: The execution of a break statement leads to the end of the loop.

break shall be used in all the loop constructs (while, do-while, foreach, for, repeat and forever).
syntax: break;

EX1: break in while loop
module break_in_while_loop;
  int i;
  
  initial begin
    $display("-----------------------------------------------------------------");
    i = 8;
    
    while(i!=0) begin
      $display("\tValue of i=%0d",i);
      if(i == 4) begin
        $display("\tCalling break,");
        break;
      end  
      i--;
    end
    
    $display("-----------------------------------------------------------------");
  end      
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of i=8
Value of i=7
Value of i=6
Value of i=5
Value of i=4
Calling break,
-----------------------------------------------------------------

EX2: break in do while loop
module break_in_do_while_loop;
  int i;
  
  initial begin
    $display("-----------------------------------------------------------------");
    i = 8;
    
    do begin
      $display("\tValue of i=%0d",i);
      if(i == 4) begin
        $display("\tCalling break,");
        break;
      end  
      i--;
    end
    while(i!=0);
    
    $display("-----------------------------------------------------------------");
  end      
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of i=8
Value of i=7
Value of i=6
Value of i=5
Value of i=4
Calling break,
-----------------------------------------------------------------

EX3: break in a foreach loop
module foreach_loop_break;
  int a[4];
  
  initial begin
    $display("-----------------------------------------------------------------");
    
    foreach(a[i]) a[i] = i;
    foreach(a[i]) begin
      $display("\tValue of a[%0d]=%0d",i,a[i]);
      if(i == 2) begin
        $display("\tCalling break,");
        break;
      end  
    end      
    
    $display("-----------------------------------------------------------------");
  end     
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of a[0]=0
Value of a[1]=1
Value of a[2]=2
Calling break,
-----------------------------------------------------------------

EX4: break in for loop
when the loop value equals 4, the break is called this leads to the end of the loop.

module break_in_loop;

  initial begin
    $display("-----------------------------------------------------------------"); 

    for(int i=0;i<8;i++) begin
      $display("\tValue of i=%0d",i);
      if(i == 4) begin
        $display("\tCalling break,");
        break;
      end 
    end  

    $display("-----------------------------------------------------------------");
  end

endmodule

Simulator Output:
-----------------------------------------------------------------
Value of i=0
Value of i=1
Value of i=2
Value of i=3
Value of i=4
Calling break,
-----------------------------------------------------------------

 
EX5: break in repeat loop
module repeat_loop_break;
  int i;
  
  initial begin
    $display("-----------------------------------------------------------------");
    repeat(5) begin
      $display("\tValue of i=%0d",i);
      if(i == 2) begin
        $display("\tCalling break,");
        break;
      end
      i++;
    end      
    
    $display("-----------------------------------------------------------------");
  end     
endmodule
Simulator Output

-----------------------------------------------------------------
Value of i=0
Value of i=1
Value of i=2
Calling break,
-----------------------------------------------------------------

EX6: break in forever loop
module forever_loop_break;
  int i;
  
  initial begin
    $display("-----------------------------------------------------------------");
    i = 5;
    forever begin
      $display("\tValue of i=%0d",i);
      if(i == 2) begin
        $display("\tCalling break,");
        break;
      end
      i++;
    end      
    
    $display("-----------------------------------------------------------------");
  end     
endmodule

Simulator Output:
-----------------------------------------------------------------
Value of i=0
Value of i=1
Value of i=2
Calling break,
-----------------------------------------------------------------


Continue in SystemVerilog: Execution of continue statement leads to skip the execution of statements followed by continue and jump to next loop or iteration value.

syntax: continue;

EX1: when ever the loop value is with in 3 to 6, continue statement will be executed, this leads to skip the execution of display statement after the continue.

module continue_in_loop;

  initial begin
    $display("-----------------------------------------------------------------");
 
    for(int i=0;i<8;i++) begin     

      if((i > 2) && (i < 7))begin
        $display("\t\tCalling continue,");
        continue;
      end   

      $display("\t\tAfter Continue\t:: Value of i=%0d",i);
    end

    $display("-----------------------------------------------------------------");

  end

endmodule
Simulator Output

-----------------------------------------------------------------
 After Continue :: Value of i=0
 After Continue :: Value of i=1
 After Continue :: Value of i=2
 Calling continue,
 Calling continue,
 Calling continue,
 Calling continue,
 After Continue :: Value of i=7
-----------------------------------------------------------------

/********************/*
ASSIGNMENT 1: Execute SystemVerilog Shallow Copy and deep copy with examples:
/********************/*

Shallow Copy: An object will be created only after doing new to a class handle,

packet   pkt_1;
pkt_1  = new();

packet   pkt_2;
pkt_2  = new pkt_1;

In the last statement, pkt_2 is created and class properties were copied from pkt_1 to pkt_2, this is called as “shallow copy”.
Shallow copy allocates the memory, copies the variable values and returns the memory handle.

In shallow copy, All of the variables are copied across: integers, strings, instance handles, etc.
Note:: Objects will not be copied, only their handles will be copied.

Shallow copy example:
packet class has the properties of bit type and object type (address_range).
after the shallow copy addr, data and handle to ar were copied. As it is shallow copy any changes on pkt_2.
ar will reflect in pkt_1.ar (because pkt_2.ar and pkt_1.ar will point to the same object)
 
 //-- class --- 
class address_range;
  bit [31:0] start_address;
  bit [31:0] end_address  ;
  function new();    start_address = 10;
    end_address   = 50;
  endfunction
endclass

//-- class ---   
class packet;
  //class properties
  bit [31:0] addr;
  bit [31:0] data;
  address_range ar; //class handle

  //constructor
  function new();
    addr  = 32'h10;
    data  = 32'hFF;
    ar = new(); //creating object
  endfunction
  //method to display class properties
  function void display();
    $display("---------------------------------------------------------");
    $display("\t addr  = %0h",addr);
    $display("\t data  = %0h",data);
    $display("\t start_address  = %0d",ar.start_address);
    $display("\t end_address  = %0d",ar.end_address);
    $display("---------------------------------------------------------");
  endfunction
endclass

// -- module ---
module class_assignment;
  packet pkt_1;
  packet pkt_2;

  initial begin
    pkt_1 = new();   //creating pkt_1 object
    $display("\t****  calling pkt_1 display  ****");
    pkt_1.display();
 
    pkt_2 = new pkt_1;   //creating pkt_2 object and copying pkt_1 to pkt_2
    $display("\t****  calling pkt_2 display  ****");
    pkt_2.display();

    //changing values with pkt_2 handle
    pkt_2.addr = 32'h68;
    pkt_2.ar.start_address = 60;
    pkt_2.ar.end_address = 80;
    $display("\t****  calling pkt_1 display after changing pkt_2 properties ****");

    //changes made to pkt_2.ar properties reflected on pkt_1.ar, so only handle of the object get copied, this is called shallow copy
    pkt_1.display();
    $display("\t****  calling pkt_2 display after changing pkt_2 properties ****");
    pkt_2.display(); //
  end
endmodule

Simulator Output:
**** calling pkt_1 display ****
---------------------------------------------------------
addr = 10
data = ff
start_address = 10
end_address = 50
---------------------------------------------------------
**** calling pkt_2 display ****
---------------------------------------------------------
addr = 10
data = ff
start_address = 10
end_address = 50
---------------------------------------------------------
**** calling pkt_1 display after changing pkt_2 properties ****
---------------------------------------------------------
addr = 10
data = ff
start_address = 60
end_address = 80
---------------------------------------------------------
**** calling pkt_2 display after changing pkt_2 properties ****
---------------------------------------------------------
addr = 68
data = ff
start_address = 60
end_address = 80
---------------------------------------------------------



SystemVerilog deep copy:
deep copy:
SystemVerilog deep copy copies all the class members and its nested class members. unlike in shallow copy, only nested class handles will be copied. 
 In shallow copy, Objects will not be copied, only their handles will be copied to perform a full or deep copy, the custom method needs to be added.
 
 deep copy example
In the below example, the copy method is added in each class. 
whenever the copy method is called, it will create the new object and copies all the class properties to a new object handle and return the new object handle.

//-- class --- 
class address_range;
  bit [31:0] start_address;
  bit [31:0] end_address  ;

  function new();
    start_address = 10;
    end_address   = 50;
  endfunction
  //copy method
  function address_range copy;
    copy = new();
    copy.start_address = this.start_address;
    copy.end_address   = this.end_address;
    return copy;
  endfunction
endclass

//-- class ---   
class packet;
  //class properties
  bit [31:0] addr;
  bit [31:0] data;
  address_range ar; //class handle

  //constructor
  function new();
    addr  = 32'h10;
    data  = 32'hFF;
    ar = new(); //creating object
  endfunction

  //method to display class prperties
  function void display();
    $display("---------------------------------------------------------");
    $display("\t addr  = %0h",addr);
    $display("\t data  = %0h",data);
    $display("\t start_address  = %0d",ar.start_address);
    $display("\t end_address  = %0d",ar.end_address);
    $display("---------------------------------------------------------");
  endfunction

  //copy method
  function packet copy();
    copy = new();
    copy.addr = this.addr;
    copy.data = this.data;
    copy.ar   = ar.copy;//calling copy function of ar
    return copy;
  endfunction
endclass

// -- module ---
module class_assignment;
  packet pkt_1;
  packet pkt_2;
  initial begin
    pkt_1 = new();   //creating pkt_1 object
    $display("\t****  calling pkt_1 display  ****");
    pkt_1.display();
    pkt_2 = new();   //creating pkt_2 object
    $display("\t****  calling pkt_2 display  ****");
    pkt_2.display();
    pkt_2 = pkt_1.copy(); //calling copy method
    //changing values with pkt_2 handle
    pkt_2.addr = 32'h68;
    pkt_2.ar.start_address = 60;
    pkt_2.ar.end_address = 80;
    $display("\t****  calling pkt_1 display after changing pkt_2 properties ****");
    pkt_1.display();
    $display("\t****  calling pkt_2 display after changing pkt_2 properties ****");
    pkt_2.display();
  end
endmodule

Simulator Output:
**** calling pkt_1 display ****
---------------------------------------------------------
addr = 10
data = ff
start_address = 10
end_address = 50
---------------------------------------------------------
**** calling pkt_2 display ****
---------------------------------------------------------
addr = 10
data = ff
start_address = 10
end_address = 50
---------------------------------------------------------
**** calling pkt_1 display after changing pkt_2 properties ****
---------------------------------------------------------
addr = 10
data = ff
start_address = 10
end_address = 50
---------------------------------------------------------
**** calling pkt_2 display after changing pkt_2 properties ****
---------------------------------------------------------
addr = 68
data = ff
start_address = 60
end_address = 80
---------------------------------------------------------



/********************/*
ASSIGNMENT 2: Task and Function argument passing(value & reference):
/********************/*

SystemVerilog provides below means for passing arguments to functions and tasks:
1)argument pass by value
2)argument pass by reference
3)argument pass by name
4)argument pass by position
also, functions and tasks can have default argument values.

1)argument pass by 'value':
In argument pass by value,
i)the argument passing mechanism works by copying each argument into the subroutine area.
ii)if any changes to arguments within the subroutine, those changes will not be visible outside the subroutine.

EX1:
module argument_passing;
  int x,y,z;
  //function to add two integer numbers.
  //INSIDE subroutine (local copy area)
  function int sum(int x,y);  //x and y are function arguments and local copies
                              //They are NOT the same x and y declared in the module
    x = x+y;                  //This modifies local copy of x
                              //Original x in the module is untouched
    return x+y;               //Returns a calculated value 
  endfunction

  initial begin
  //OUTSIDE the subroutine 
    x = 20;
    y = 30;
    z = sum(x,y);           // CALLING the subroutine
    $display("-----------------------------------------------------------------");
    $display("\tValue of x = %0d",x);
    $display("\tValue of y = %0d",y);
    $display("\tValue of z = %0d",z);
    $display("-----------------------------------------------------------------");
  end
endmodule

O/P:
-----------------------------------------------------------------
Value of x = 20   //if any changes to arguments within the subroutine, those changes will not be visible outside the subroutine.
Value of y = 30
Value of z = 80   //the argument passing mechanism works by copying each argument into the subroutine area.

-----------------------------------------------------------------


2)argument pass by 'reference':
i)In pass by reference, a reference to the original argument is passed to the subroutine.
ii)As the argument within a subroutine is pointing to an original argument, any changes to the argument within subroutine will be visible outside.
To indicate argument pass by reference, the argument declaration is preceded by keyword ref.

Any modifications to the argument value in a pass by reference can be avoided by using const keyword before ref,
 any attempt in changing the argument value in subroutine will lead to a compilation error.
 
EX1: argument pass by reference example
variables x and y are passed as an argument in the function call sum, changes to the argument x within the function, is visible outside.

module argument_passing;
  int x,y,z;

  //function to add two integer numbers.
  function int sum(ref int x,y);        //arguments are copied.
    x = x+y;                            // x and y are REFERENCES to the original variables
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

DIFFERENCE:
🔹 Pass-By-Value:
A copy of the actual argument is passed to the subroutine.
Changes inside the subroutine do not affect the original variable.

🔹 Pass-By-Reference:
A reference (alias) to the original argument is passed to the subroutine.
Changes inside the subroutine directly affect the original variable.


/******************************/
ASSIGNMENT 3: Execute the basic inheritance example: 
              Class A, Class B  and Class B extends A;                                       
 /********************/*
		
=>Class B inherits variables from Class A
=>Child object can access both parent & child members		

EX1: 

class A;
  int a;   // parent class variable
endclass

class B extends A;
  int b;   // child class variable
endclass

module inheritance_example_1;
  initial begin
    B obj = new();   // create child class object

    obj.a = 10;      // inherited from class A
    obj.b = 20;      // belongs to class B

    $display("Value of a (from Class A) = %0d", obj.a);
    $display("Value of b (from Class B) = %0d", obj.b);
  end
endmodule

O/P:
Value of a (from Class A) = 10
Value of b (from Class B) = 20


EX2: 

class A;
  int a;

  function void show();
    $display("Class A: a = %0d", a);
  endfunction
endclass

class B extends A;
  int b;

  function void show_b();
    $display("Class B: b = %0d", b);
  endfunction
endclass

module inheritance_example_2;
  initial begin
    B obj = new();

    obj.a = 5;   // inherited variable
    obj.b = 15;  // child variable

    obj.show();    // parent class method
    obj.show_b();  // child class method
  end
endmodule

O/P:
Class A: a = 5
Class B: b = 15




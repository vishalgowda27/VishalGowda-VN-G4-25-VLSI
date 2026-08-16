Topic: VERILOG EVENT SCHEDULER

This is core digital simulation knowledge.

Meaning

"The event scheduler decides when and in what order statements execute during simulation".

Verilog simulation is event-driven, not line-by-line like C.

Verilog Scheduler Regions (CLASSIC)
1️.Active region

Executes blocking assignments (=)
Executes always blocks

2️.Non-blocking assign (NBA) region

Executes <=
Updates registers after active region

3️.Monitor / postponed region

$display, $monitor

📌 Why this exists
To avoid race conditions between:
q <= d;  &  d = x;



Toipc: SYSTEMVERILOG SCHEDULER (EXTENDED)

SystemVerilog adds more regions to make behavior safer and more predictable.

Key additional regions:

Preponed → sampling (assertions)
Active
Inactive
NBA
Observed
Reactive
Postponed

Practical difference 
Verilog
Easy to create race conditions
Less control

SystemVerilog
Clear separation between:
Design
Testbench
Assertions
Race conditions reduced

Enables always_ff, assertions, clocking blocks

📌 Key sentence

“SystemVerilog scheduler improves determinism and avoids races compared to Verilog.”




-***************
Topic: SYSTEMVERILOG EVENT SCHEDULER 

History: 24DEC2025

ASSIGNMENT-1: Understanding the Execution of Event Scheduler in SV with all regions

/----------------

SystemVerilog simulation is NOT executed line-by-line like C.
It is executed in time slots, and inside each time slot, there are multiple regions.

Think of one clock edge as one day.
Inside that day, work happens in shifts.

Regions:

PREPONED
ACTIVE
INACTIVE
NBA
OBSERVED
REACTIVE
POSTPONED

Let see one by one:-

1)PREPONED REGION
👉 “Camera snapshot before action”

What happens here?

Signals are sampled
Assertions sample inputs
No signal updates

Real-world analogy
📸 Traffic camera takes a photo before cars move.

Why this exists

If you want to check what signals were BEFORE a clock edge, you need a safe place.

Used by:

Assertions
Coverage
Property sampling
Problem it solves

❌ Without this, assertions would see updated values, not original ones.



2)ACTIVE REGION
👉 “Workers start doing work”
What happens here?

always blocks execute
Blocking (=) assignments
RHS expressions evaluated

Real-world analogy
👷 Workers start tasks simultaneously when the bell rings.

Example problem
always @(posedge clk)
  a = b;

always @(posedge clk)
  b = a;

❌ Race condition if both run together.

Key point
Active region does calculations, not final storage.



3) INACTIVE REGION
👉 “Deferred work for same time”
What happens here?

#0 delays
Some scheduling cleanup

Real-world analogy
🧾 Tasks postponed for later within the same day.

Why it exists
Allows:
#0 signal = value;
Not very important for beginners, but critical for simulators.



4)NBA (Non-Blocking Assignment) REGION
👉 “Official update / commit phase”

What happens here?
All <= assignments update LHS
Happens after all Active work is done

Real-world analogy
🏦 Bank transactions are calculated during the day, but posted at end of day.

Problem it solves (VERY IMPORTANT)
Problem without NBA
Two flip-flops update wrong order.

Solution
NBA guarantees:
All registers update simultaneously
This is why:
q <= d;
is mandatory for sequential logic.



5)OBSERVED REGION
👉 “Inspector checks final values”
What happens here?

Assertions evaluate
No signal modification

Real-world analogy
👮 Inspector checks results after updates, without changing anything.

Why needed
Assertions must see:
Stable
Final
Race-free values



6)REACTIVE REGION
👉 “Testbench reacts”
What happens here?

Testbench drives new stimulus
Clocking blocks operate here

Real-world analogy
🎮 Game controller reacts after seeing game state

Problem it solves

❌ Testbench and DUT racing each other

SV Solution:
DUT runs first
TB reacts later

This prevents:
tb_signal = dut_signal;  // race



7)POSTPONED REGION
👉 “Report & logging”
What happens here?

$display
$monitor
$strobe

Real-world analogy
📢 End-of-day report printed after everything is settled

Why?
So printed values are:
Final
Stable
Correct



-**************
Topic: SYSTEMVERILOG  

History: 24DEC2025

ASSIGNMENT-2: Findout difference between $display, $monitor, $strobe with Examples.

/----------------

$display: “Prints values immediately when executed.”

$monitor: “Continuously prints when any signal changes.”

$strobe: “Prints final stable values after all updates.”


1)$display
✅ Definition

"$display prints the values of signals immediately when the statement is executed, using the current values at that moment".

Simulation region: "Active region"


✅ Example Code
module display_example;
    logic a, b;

    initial begin
        a = 0; b = 0;
        #10 a = 1;
        #10 b = 1;

        $display("Time=%0t a=%0b b=%0b", $time, a, b);
    end
endmodule

Output
Time=20 a=1 b=1

explaination:

$display executes right away

Prints instant snapshot

If signals change later in the same timestep → $display won’t see them

✅ Advantages

Simple

Good for debug checkpoints

Easy to control when it prints

❌ Disadvantages

Can miss final updated values

Not synchronized to NBA updates




2️)$monitor
✅ Definition

"$monitor automatically prints signal values whenever any monitored signal changes".

Simulation region:

==>Reactive / Postponed behavior
==>Continuously active after being called


✅ Example Code
module monitor_example;
    logic a, b;

    initial begin
        $monitor("Time=%0t a=%0b b=%0b", $time, a, b);

        a = 0; b = 0;
        #10 a = 1;
        #10 b = 1;
        #10 a = 0;
    end
endmodule

Output
Time=0  a=0 b=0
Time=10 a=1 b=0
Time=20 a=1 b=1
Time=30 a=0 b=1

explaination:

$monitor is event-driven

Prints every time a signal changes

"Only one $monitor active at a time"

✅ Advantages

Excellent for continuous tracking

No need to repeatedly call it

❌ Disadvantages

Can flood the console

Hard to control in large designs



3) $strobe
✅ Definition

"$strobe prints signal values at the very end of the current simulation time slot, after all updates are complete".

Simulation region: "Postponed region"



✅ Example Code
module strobe_example;
    logic a;
    logic d;

    initial begin
        a = 0; b = 0;
        #10 a = 1;
		#10 b = 1;
		#40 a = 0;
		#10 b = 1;

        $strobe("Time=%0t a=%0b, b=%0b", $time, a,b);
    end
endmodule

Output
Time=10 a=1


explaination:

$strobe waits until:

All <= (NBA) updates finish

Always prints final, stable values

✅ Advantages

Race-free

Best for final value checking

❌ Disadvantages

Not immediate

Less intuitive for beginners


COMBINE ALL 3

module compare_display_monitor_strobe;

    logic clk;
    logic d, q;

    initial clk = 0;
    always #5 clk = ~clk;

    always_ff @(posedge clk)
        q <= d;

    initial begin
        $monitor("MONITOR: Time=%0t d=%0b q=%0b", $time, d, q);

        d = 0;
        #7 d = 1;

        @(posedge clk);
        $display("DISPLAY: Time=%0t d=%0b q=%0b", $time, d, q);
        $strobe ("STROBE : Time=%0t d=%0b q=%0b", $time, d, q);

        #20 $finish;
    end
endmodule




*/--------------
Topic: SYSTEMVERILOG  

History: 24DEC2025

ASSIGNMENT-3: Understand the fixed array and demonstrate with 2-examples.
/--------------


What is a Fixed Array?
"A fixed array in SystemVerilog is an array whose size is decided at compile time and cannot change during simulation".

Why it is called “fixed”

i) Size is known before simulation starts
ii) Memory is statically allocated
iii) Faster and simpler than dynamic arrays


Fixed array syntax (general form): data_type array_name [SIZE];

or multi-dimensional: data_type array_name [ROWS][COLUMNS];


Where fixed arrays are used (very important)

Register banks
Small memories
Lookup tables
Coefficient storage
FSM tables
RTL modeling (synthesizable)


EXAMPLE 1: Fixed Array as a Register Bank
Problem statement: Store 4 registers of 8-bit width and read one of them.

Solution:

module fixed_array_regbank (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [1:0]  addr,      // 2-bit address (0–3)
    input  logic [7:0]  data_in,
    input  logic        write_en,
    output logic [7:0]  data_out
);

    // Fixed array of 4 registers, each 8-bit wide
    logic [7:0] reg_bank [0:3];

    int i;

    // Write logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all registers
            for (i = 0; i < 4; i++)
                reg_bank[i] <= 8'd0;
        end
        else if (write_en) begin
            reg_bank[addr] <= data_in;
        end
    end

    // Read logic (combinational)
    always_comb begin
        data_out = reg_bank[addr];
    end

endmodule


Explanation:

reg_bank [0:3] → fixed array with 4 elements

Each element is 8 bits
Array size cannot change
Synthesizer maps this to 4 registers
Address selects which element is accessed



EXAMPLE 2: Fixed Array as a Lookup Table (LUT)
Problem statement: Use a fixed array to store predefined constant values.

Solution:

module fixed_array_lut (
    input  logic [2:0] index,     // 0 to 7
    output logic [7:0] lut_out
);

    // Fixed array initialized with constant values
    logic [7:0] lut [0:7] = '{
        8'd10, 8'd20, 8'd30, 8'd40,
        8'd50, 8'd60, 8'd70, 8'd80
    };

    // Combinational read
    always_comb begin
        lut_out = lut[index];
    end

endmodule


Explanation:

Fixed array size = 8

Values are known at compile time

Used as ROM / lookup table

Very common in DSP, control logic





***************
Topic: SYSTEMVERILOG  

History: 24DEC2025

ASSIGNMENT-4: PACKED ARRAY vs UNPACKED ARRAY (SystemVerilog) with suitable example.

/---------------

First understand:
"Packed arrays represent a single data word split into bits".

"Unpacked arrays represent multiple data elements grouped together".

Let's elaborate it: 

1)PACKED ARRAY
✅ Definition: A packed array is an array where all bits are stored contiguously as a single vector, treated as one data object.

Bit-level representation
Stored next to each other
Behaves like a number

Key Characteristics:
Acts like a single variable
Can be used in arithmetic
Can be sliced ([7:4])
Synthesizable
Used for datapath signals


Example 1: Packed Array (8-bit data bus)

module packed_array_example (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [8:0] sum
);

    always_comb begin
        sum = a + b;   // arithmetic on packed arrays
    end

endmodule

Explanation:

[7:0] is a packed array

a and b are treated as numbers

Synthesizer builds an adder

All bits belong to one word


Where packed arrays are used?

Data buses
ALU operands
Registers
Counters
FSM encoding



2)UNPACKED ARRAY
✅ Definition: "An unpacked array is an array where each element is a separate variable, grouped together like a list".

Element-level representation

Stored as multiple elements

Behaves like memory


Key Characteristics:

Each element is independent
Cannot do arithmetic on whole array
Accessed using index (array[i])
Synthesizable (fixed size)
Used for storage


Example 2: Unpacked Array (Register Bank)

module unpacked_array_example (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [1:0] addr,
    input  logic [7:0] data_in,
    output logic [7:0] data_out
);

    // Unpacked array of 4 registers
    logic [7:0] reg_bank [0:3];

    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i++)
                reg_bank[i] <= 8'd0;
        end
        else begin
            reg_bank[addr] <= data_in;
        end
    end

    assign data_out = reg_bank[addr];

endmodule

Explanation:

reg_bank is an unpacked array
Each element is one registe
addr selects which register
Synthesizer creates 4 registers

Where unpacked arrays are used:
Register banks
Memories
FIFOs
Lookup tables
Buffers

DIFFERENCE:

| Feature            | Packed Array     | Unpacked Array    |
| ------------------ | ---------------- | ----------------- |
| Stored as          | One word         | Multiple elements |
| Acts like          | A number         | A list/memory     |
| Arithmetic allowed | Yes              | No                |
| Index meaning      | Bit position     | Element index     |
| Example            | `logic [7:0] a;  | logic a [0:7];    |
| Synth usage        | Datapath         | Storage           |




***************
Topic: SYSTEMVERILOG  

History: 26DEC2025

ASSIGNMENT-5: Dynamic, Associative and Queue array (SystemVerilog) with suitable example and its defaults.

/---------------


"Queues and associative arrays are NOT synthesizable. They are used only in SystemVerilog testbenches and verification.
Dynamic arrays are NOT synthesizable. They are used in testbenches and verification only".


1)Dynamic arrays: A dynamic array in SystemVerilog is an array whose size is decided at run time, not at compile time, and can be resized during simulation.

Why dynamic arrays exist (REAL reason)

Fixed arrays:

Size must be known before simulation
Waste memory if over-allocated
Not flexible for unpredictable data

Dynamic arrays solve real verification problems:

Unknown number of transactions
Variable-length packets
Runtime configuration
File-driven data

Syntax of Dynamic Array: data_type array_name[];
ex: int data[];
At this point:
Array exists
Size = 0
Memory not allocated yet

Memory Allocation (MOST IMPORTANT)
Dynamic arrays must be allocated using new[].
data = new[10];  -->   data[0] to data[9] are valid

#The 3 DEFAULT METHODS:

1)size()
What it does
Returns the current number of elements in the dynamic array

int a[];
a = new[5]; //a[0] to a[4]

$display("Size = %0d", a.size());

output: Size = 5

Why important

Loop bounds
Runtime checks
Avoid out-of-bound access

2)delete()
What it does
Frees the memory and makes array size zero.

int a[];
a = new[5];

a.delete();

After delete:
a.size() == 0
Memory released
Why important
Prevent memory leaks
Reset testbench data cleanly


3)new[] (Constructor / Resizing)

This is the most powerful feature

a = new[10];

Resize later
a = new[20](a);   // copy old values

This means:
Old data preserved
New elements added

Why important:
Grow data as simulation runs
Model packets, transactions

PROFESSIONAL EXAMPLE 1
Variable-Length Packet

module dynamic_array_packet;

    byte packet[];   // dynamic array of bytes
    int i;

    initial begin
        // Packet length decided at runtime
        packet = new[12];

        // Fill packet
        for (i = 0; i < packet.size(); i++)
            packet[i] = i;

        $display("Packet size = %0d", packet.size());

        packet.delete();  // free memory
    end
endmodule


PROFESSIONAL EXAMPLE 2
File-Driven Data (VERY COMMON IN TB)

module dynamic_array_file;

    int data[];
    int i;

    initial begin
        data = new[4];

        data[0] = 10;
        data[1] = 20;
        data[2] = 30;
        data[3] = 40;

        // Resize when more data arrives
        data = new[6](data);
        data[4] = 50;
        data[5] = 60;

        for (i = 0; i < data.size(); i++)
            $display("data[%0d] = %0d", i, data[i]);
    end
endmodule


Why this matters:
Data size grows as simulation progresses
Fixed arrays would force guessing size

Why NOT use dynamic arrays in RTL?
Because hardware:
Cannot allocate memory at runtime
Needs fixed resources
Must be synthesizabl



2)QUEUE Arrays:

"A queue is a variable-size array that allows insertion and deletion at both ends, typically used to model FIFO or LIFO behavior".

Syntax:data_type queue_name[$];

Example:
int q[$];

$ → size decided at runtime
Order is preserved

Why queues exist (REAL reason)

Dynamic arrays:
Good for resize
Bad for frequent insert/delete

Queues solve:
Transaction buffering
Scoreboards
FIFOs
Pipelines
Producer–consumer problems

QUEUE DEFAULT METHODS (VERY IMPORTANT)
1)push_back()
👉 Insert element at end
q.push_back(10);

2)push_front()
👉 Insert element at front
q.push_front(5);

3)pop_front()
👉 Remove element from front
int x = q.pop_front();
(FIFO behavior)

4)pop_back()
👉 Remove element from end
int y = q.pop_back();
(LIFO behavior)

5)size()
👉 Number of elements
int n = q.size()

6)delete()
👉 Clear entire queue
q.delete();


✅ PROFESSIONAL EXAMPLE 1 – FIFO

module queue_fifo;

    int fifo[$];
    int data;

    initial begin
        fifo.push_back(10);
        fifo.push_back(20);
        fifo.push_back(30);

        data = fifo.pop_front(); // 10
        $display("Popped = %0d", data);

        data = fifo.pop_front(); // 20
        $display("Popped = %0d", data);
    end
endmodule

Explanation:
push_back() → enqueue
pop_front() → dequeue
Models real hardware FIFO in TB

✅ PROFESSIONAL EXAMPLE 2 – LIFO (Stack):

module queue_stack;

    int stack[$];
    int data;

    initial begin
        stack.push_back(1);
        stack.push_back(2);
        stack.push_back(3);

        data = stack.pop_back(); // 3
        $display("Pop = %0d", data);
    end
endmodule

When to use Queue:
Scoreboards
Expected vs actual comparison
Transaction ordering
Packet streams



3)ASSOCIATIVE ARRAY
✅ Definition 
An associative array is an array indexed by arbitrary keys instead of numeric indices, allowing fast lookup.

Think of it as a dictionary / map.

Syntax
data_type array_name [index_type];

Example:
int mem[string];
Here:
Index = string
Value = int


🔹 Why associative arrays exist (REAL reason)

Queues:
Ordered access
Sequential
but....
Associative arrays solve:
Sparse data
Random access
Lookups by ID, name, address
Scoreboards (key-based)


ASSOCIATIVE ARRAY DEFAULT METHODS
1)exists(key)
👉 Check if key exists
if (mem.exists("CPU"))

2)delete(key)
👉 Delete specific entry
mem.delete("CPU");
Delete all:
mem.delete();

3)num()
👉 Number of elements
int n = mem.num();

4)first(key)
👉 Get first key
string k;
mem.first(k);

5)last(key)
👉 Get last key
mem.last(k);

6)next(key)
👉 Get next key
mem.next(k);

7)prev(key)
👉 Get previous key
mem.prev(k);


✅ PROFESSIONAL EXAMPLE 1 – Scoreboard Style

module assoc_scoreboard;

    int expected[string];
    string key;

    initial begin
        expected["pkt1"] = 100;
        expected["pkt2"] = 200;

        if (expected.exists("pkt1"))
            $display("pkt1 value = %0d", expected["pkt1"]);

        expected.first(key);
        $display("First key = %s", key);

        expected.next(key);
        $display("Next key = %s", key);
    end
endmodule


✅ PROFESSIONAL EXAMPLE 2 – Sparse Memory

module assoc_memory;

    logic [7:0] mem[int];
    int addr;

    initial begin
        mem[100] = 8'hAA;
        mem[500] = 8'hBB;

        foreach (mem[addr])
            $display("mem[%0d] = %h", addr, mem[addr]);
    end
endmodule

When to use Associative Arrays:
Sparse address spaces
Scoreboards
Lookups by ID
Protocol tracking


| Feature       | Queue   | Associative Array |
| ------------- | ------- | ----------------- |
| Access        | Ordered | Key-based         |
| Index         | Numeric | Any type          |
| FIFO/LIFO     | ✅       | ❌                 |
| Random lookup | ❌       | ✅                 |
| Common use    | Streams | Scoreboards       |

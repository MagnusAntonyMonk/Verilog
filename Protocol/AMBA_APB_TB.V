module APB_MASTER_TB;

  // Inputs
  reg pclk;
  reg prst;
  reg pread_write;
  reg ptransfer;
  reg pready;
  reg [7:0] apb_write_paddr;
  reg [7:0] apb_read_paddr;
  reg [7:0] apb_write_data;
  reg [7:0] prdata;

  // Outputs
  wire psel;
  wire penable;
  wire pwrite;
  wire [7:0] pwdata;
  wire [7:0] paddr;
  wire [7:0] apb_read_out_data;

  // Instantiate the Unit Under Test (UUT)
  APB_MASTER uut (
    .pclk(pclk),
    .prst(prst),
    .pread_write(pread_write),
    .ptransfer(ptransfer),
    .pready(pready),
    .apb_write_paddr(apb_write_paddr),
    .apb_read_paddr(apb_read_paddr),
    .apb_write_data(apb_write_data),
    .prdata(prdata),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .paddr(paddr),
    .apb_read_out_data(apb_read_out_data)
  );

  // Clock generation
  initial begin
    pclk =0;
    forever #5 pclk = ~pclk;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    prst = 1;
    pread_write = 0;
    ptransfer = 0;
    pready = 0;
    apb_write_paddr = 8'h00;
    apb_read_paddr = 8'h00;
    apb_write_data = 8'h00;
    prdata = 8'h00;

    // Reset the design
    #10;
    prst = 0;

    // Write operation
    #10;
    ptransfer = 1;
    pread_write = 1;
    apb_write_paddr = 8'hAA;
    apb_write_data = 8'h55;
    
    // Wait for the access phase
    #10;
    pready = 0;
    #10;
    pready=1;
    
    // Read operation
    #10;
    ptransfer = 1;
    pread_write = 0;
    apb_read_paddr = 8'hBB;
   prdata=8'hCC;
    #10;
    pready =0;
   
    //apb_read_paddr = 8'hBB;
    #10;
    pready=1;
    
    // Simulate read data
  //  prdata = 8'hCC;

    // End of test
    #100;
    $finish;
  end

  // Monitor the outputs
  initial begin
    $monitor("Time=%0d, psel=%b, penable=%b, pwrite=%b, paddr=%h, pwdata=%h, apb_read_out_data=%h", 
             $time, psel, penable, pwrite, paddr, pwdata, apb_read_out_data);
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule

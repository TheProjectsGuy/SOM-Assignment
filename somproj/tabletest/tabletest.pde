Table table;
void setup()
{
  table= new Table();
  table.addColumn("Name Of Material", Table.STRING);
  table.addColumn("Maximum Allowable Stress", Table.FLOAT);

  
  TableRow newRow = table.addRow();
  newRow.setString("Name Of Material", "Aluminium");
  newRow.setFloat("Maximum Allowable Stress" , 20e6);
  
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "Copper");
  newRow.setFloat("Maximum Allowable Stress" , 117e6);
  
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "Tantalum");
  newRow.setFloat("Maximum Allowable Stress" , 180e6);
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "Wrought Iron");
  newRow.setFloat("Maximum Allowable Stress" , 210e6);
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "Mild Steel");
  newRow.setFloat("Maximum Allowable Stress" ,248e6);
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "Diamond");
  newRow.setFloat("Maximum Allowable Stress" , 1600e6);
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "2800 Maraging Steel");
  newRow.setFloat("Maximum Allowable Stress" , 2617e6);
  
  newRow = table.addRow();
  newRow.setString("Name Of Material", "Steel");
  newRow.setFloat("Maximum Allowable Stress" , 690e6);
  
  saveTable(table, "data/new.csv");
}



  
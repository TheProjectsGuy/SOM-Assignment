Table table;

void setup() {
  
  table = loadTable("new.csv", "header");

  for (TableRow row : table.rows()) {
    
    String name = row.getString("Name Of Material");
    Float ystress = row.getFloat("Maximum Allowable Stress");
  
    println(name + " has an yield stress of of " + ystress);
  }
  
}
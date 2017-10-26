ArrayList<Integer> list = new ArrayList<Integer>();

Table materialsTable;

void setup() {
  list.add(4);
  list.add(5);
  list.remove(list.size()-1);
  println(list);
  
  materialsTable = new Table();
  
  materialsTable.addColumn("Name",Table.STRING);
  materialsTable.addColumn("Young's Modulous",Table.FLOAT);
  materialsTable.addColumn("Maximum Tensile Stress",Table.FLOAT);
  
  
  TableRow material = materialsTable.addRow();
  
  material.setString(0,"Steel");
  material.setFloat(1,211E9);
  material.setFloat(2,309E6);
  
  println(materialsTable);
  
}

void draw() {
}
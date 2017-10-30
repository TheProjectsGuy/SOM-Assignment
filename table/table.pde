/*
Table Material_csv;
 void setup() {
 Material_csv = new Table();
 
 Material_csv.addColumn("Name",Table.STRING);
 Material_csv.addColumn("Maximum Permissible Stress", Table.FLOAT);
 
 TableRow material_data = Material_csv.addRow();
 material_data.setString(
 }
 
 */
class Material
{
  String Name;
  float Max_Stress;
  Material(String name, float Max_yield_stress)
  {
    this.Name = name;
    this.Max_Stress = Max_yield_stress;
  }
}           // Created a Material class and Material contructor having Name and Yield Stress as parameters.


Table table;  // To load .csv document into processing...Document already added to this program.

ArrayList<Material> Materials_list;
void loadMaterials()
{
  table = loadTable("Materials/Material Data.csv", "header");
  
  Materials_list = new ArrayList<Material>();  // ArrayList to store all the Materials Available

  //for (int i=0; i<Materials_list.size(); i++)   // For loop to assign each Material parameter to its data from the .csv Document.
  //{
  //  Material load = new Material(table.getString(i, 0), table.getFloat(i, 1)); // Instances of Material created and its parameters are assigned values from Document.
  //  Materials_list.add(load);   //Adding instances into ArrayList
  //}
  println(str(table.lastRowIndex()) + " materials found");
  for (int i = 0 ; i <= table.lastRowIndex(); i++) {
    TableRow row = table.getRow(i);
    Material m = new Material(row.getString(0), row.getFloat(1));
    Materials_list.add(m);
  }
}

void setup() {
  loadMaterials();
  for (Material m : Materials_list) {
    println(m.Name + ": " + str(m.Max_Stress));
  }
}
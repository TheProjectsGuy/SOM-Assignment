abstract class Function {
  String Description;
  abstract float f();
}

Function stress = new Function() {
  float f() {
    return 100;
  }
};
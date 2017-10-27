float scale_1m_pixels = 200;

float m_to_pixel(float value_m) {
  float value_pixels = value_m * scale_1m_pixels;
  return value_pixels;
}
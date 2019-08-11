version = WhiteTriangle;

version (WhiteTriangle) {
    import whiteTriangle;
}

version (PerVertexTriangle) {
    import perVertexTriangle;
}

version (UniformTriangle) {
    import uniformTriangle;
}

version (TextureRectangle) {
    import textureRectangle;
}

version (Rectangle3D) {
    import rectangle3d;
}

void main() {
    entryPoint();
}

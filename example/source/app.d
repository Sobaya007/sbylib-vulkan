version = UniformTriangle;

version (WhiteTriangle) {
    import whiteTriangle;
}

version (PerVertexTriangle) {
    import perVertexTriangle;
}

version (UniformTriangle) {
    import uniformTriangle;
}

void main() {
    entryPoint();
}

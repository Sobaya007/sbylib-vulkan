version = WhiteTriangle;

version (WhiteTriangle) {
    import whiteTriangle;
}

version (PerVertexTriangle) {
    import perVertexTriangle;
}

void main() {
    entryPoint();
}

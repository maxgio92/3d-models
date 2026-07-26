# Rubber Duck

The OpenSCAD source is in `rubber-duck.scad`.

Generate the STL with:

```sh
openscad -o rubber-duck.stl rubber-duck.scad
```

Or, when using the OpenSCAD Flatpak:

```sh
flatpak run org.openscad.OpenSCAD --export-format binstl -o rubber-duck.stl rubber-duck.scad
```

The model is a single-piece bath duck silhouette with a flattened underside, raised wings, a short bill, a small tail, eyes, and shallow beak/mouth grooves that remain visible in a monochrome STL.

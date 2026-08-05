# 3D Models

Personal archive of printable models, editable source files, generated meshes,
reference images, and upstream license notes.

## Contents

```text
automotive/
  bmw/
  mini/
  opel/
coffee/
  1zpresso/
  pour-over-filter-holder/
electronics/
  google/
toys/
  rubber/
utility/
  fan/
```

Each leaf directory is one model project. Project-level notes live in that
directory when the model needs dimensions, generation steps, or design context.

## File Types

`.scad` files are editable OpenSCAD source.

`.stl`, `.3mf`, `.step`, and `.zip` files are printable or CAD model artifacts.

`.png`, `.jpg`, and `.jpeg` files are reference images, render previews, or
downloaded project images.

`license.txt` files come from upstream model sources when they exist.

## Regenerating OpenSCAD Models

Generate an STL from an OpenSCAD source file:

```sh
openscad -o path/to/model.stl path/to/model.scad
```

Multiline form:

```sh
openscad \
  -o category/brand/project/model.stl \
  category/brand/project/model.scad
```

Flatpak OpenSCAD works too:

```sh
flatpak run org.openscad.OpenSCAD \
  --export-format binstl \
  -o path/to/model.stl \
  path/to/model.scad
```

## Licenses

Third-party models keep their upstream license files beside the project files.
Some projects use Creative Commons Non-Commercial terms.

# typst-mirea-template
Implementation of MIREA document template in Typst

## Usage

```
#show: project.with(
  title: "ontology",
  authors: (
    "Andrey Lomovtsev",
  ),
)
```

For chapters without numbering you must use `#numberless` function:
```
#numberless[ВВЕДЕНИЕ]
```

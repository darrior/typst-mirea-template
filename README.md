# typst-mirea-template
Implementation of MIREA document template in Typst

## Usage

```
#show: project.with(
  title: "<name of project>",
  authors: (
    "Your Name",
  ),
)
```

For chapters without numbering you must use `#numberless` function:
```
#numberless[ВВЕДЕНИЕ]
```

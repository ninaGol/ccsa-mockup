
# Project Background #

This is an experimental project to explore the potential for producing
an RStudio-based supplement to (or possibly an entire replacement version of)
the [How COVID-19 Is Changing the World][covid2] series of reports from the CCSA.

Currently, the `prototype` branch contains code to build an online, interactive report
based on member contributions. The plan is for each member to contribute a chapter
in RMarkdown format (including R code) along with data files in open formats. Chapters
are organized in the `contrib/` directory while data files are organized in the `data/`
directory; each file name should begin with an organizational prefix such as `wbg-`.

[covid2]: https://unstats.un.org/unsd/ccsa/documents/covid19-report-ccsa_vol2.pdf

# Build Instructions #

This site is currently built from the `prototype` branch using the [bookdown](https://bookdown.org)
package and designed to be hosted via Github Pages.  There are several
experimental output options defined in `_output.yml` but the primary one is
`bookdown::gitbook`. In R, run:

````
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')
````

In RStudio, choose `bookdown::gitbook` from the "Build Book" menu in the Build tab.

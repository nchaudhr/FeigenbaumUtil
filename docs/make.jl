using Documenter
using FeigenbaumUtil

makedocs(
    modules = [FeigenbaumUtil], doctest = false
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    deps = Deps.pip("pygments", "mkdocs", "python-markdown-math"),
    repo = "github.com/nchaudhr/FeigenbaumUtil.git",
    julia  = "0.5",
    osname = "linux"
    # ...
)

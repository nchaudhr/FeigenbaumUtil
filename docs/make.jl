using Documenter
using FeigenbaumUtil

makedocs(
    modules = [FeigenbaumUtil]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
=deploydocs(
     repo = "https://github.com/nchaudhr/FeigenbaumUtil"
 )=#

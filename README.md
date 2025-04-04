
# campsisverse <img src='man/figures/logo.png' align="right" alt="" width="120" />

The official R package manager of the Campsis suite.

## Install Campsisverse

Install the Campsisverse package with the following command:

``` r
remotes::install_github("Calvagone/campsisverse")
```

## Install the Campsis suite

The Campsis suite comprises 5 open-source packages that are available on
GitHub/CRAN:

- [Campsismod](https://github.com/Calvagone/campsismod)
- [Campsis](https://github.com/Calvagone/campsis)
- [Campsisnca](https://github.com/Calvagone/campsisnca)
- [Campsismisc](https://github.com/Calvagone/campsismisc)
- [Campsisqual](https://github.com/Calvagone/campsisqual)

The Campsisverse package allows you to install the Campsis suite with a
single command:

``` r
campsisverse::install()
```

The installation will install the latest versions of the Campsis
packages and dependencies, as well as a few extra packages (`rxode2`,
`mrgsolve`, etc.).

The `install` method is quick and easy, but it may not be suitable for
all users. For instance, you may want to install the Campsis suite in a
sandbox environment or restore a specific version of the suite. In this
case, the `restore` and `use` functions are more appropriate (see
below).

## Restoring specific versions of the Campsis suite

Specific versions of the Campsis suite can be restored thanks to the
`use` or `restore` functions. These 2 functions have a `version`
argument, which can be used to restore the Campsis suite (i.e. the
Campsis packages + all dependencies) with specific package versions.
This importantly ensures the reproducibility of your simulation scripts
over time. The underlying mechanism is based on the `renv.lock` file,
which is a snapshot of the Campsis suite at a specific date. All
snapshots created in campsisverse are tested extensively with our
[qualification suite](https://github.com/Calvagone/campsisqual).

### Using the ‘use’ function (sandbox environment)

The Campsis suite can be run in a sandbox environment using the `use`
function. This function is useful when you want to run the Campsis suite
in a temporary environment without affecting your current R
distribution.

``` r
campsisverse::use(version="25-03-29")
```

By executing this command, the whole Campsis suite is installed in a
temporary R environment based on the `renv.lock` file dated on the 1st
of December 2024, i.e., the latest Campsis snapshot available at the
time of writing. Thanks to this file, packages are restored with the
exact versions specified in the snapshot and your Campsis script should
run without any issues.

### Using the ‘restore’ function within your R distribution

Restoring the Campsis suite into your current R distribution is easy.
Just run the following command:

``` r
campsisverse::restore(version="25-03-29")
```

In interactive mode, and if you don’t want to activate a renv project,
click 2 (’Do not activate the project and use the current library
paths). In this case, the whole Campsis suite is restored into your R
distribution based on the package versions specified in the `renv.lock`
file dated on the 1st of December 2024. Note that some of your previous
packages may be downgraded or upgraded during the restoration process.

In case you do not want to install the Campsis dependencies
(e.g. `rxode2`, `mrgsolve`, `dplyr`, `ggplot`, etc.) with specific
versions, use the `no_deps` argument. When `no_deps` is TRUE, only the
Campsis packages are installed with the versions specified in the lock
file.

``` r
campsisverse::restore(version="25-03-29", no_deps=TRUE)
```

Please be aware that setting `no_deps` to TRUE may cause unexpected
behavior of some Campsis packages. In any case, we recommend using our
qualification package to validate the correct functioning of Campsis.
Please visit the [Campsisqual
repository](https://github.com/Calvagone/campsisqual) for more
information.

### Using the ‘restore’ function within your renv project

Initialize a new project (with an empty R library) by typing the
following command in your R console:

``` r
renv::init(bare=TRUE)
```

Then, restore the Campsis suite into your project as follows:

``` r
renv::install("Calvagone/campsisverse")
campsisverse::restore(version="25-03-29")
```

The Campsis packages can then be loaded to run your simulation scripts.
Use the renv commands as usual to manage your project and dependencies.

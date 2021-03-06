% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pre-action-variables.R
\name{add_variables}
\alias{add_variables}
\alias{remove_variables}
\alias{update_variables}
\title{Add variables to a workflow}
\usage{
add_variables(x, outcomes, predictors, ..., blueprint = NULL)

remove_variables(x)

update_variables(x, outcomes, predictors, ..., blueprint = NULL)
}
\arguments{
\item{x}{A workflow}

\item{outcomes, predictors}{Tidyselect expressions specifying the terms
of the model. \code{outcomes} is evaluated first, and then all outcome columns
are removed from the data before \code{predictors} is evaluated.
See \link[tidyselect:language]{tidyselect::select_helpers} for the full range of possible ways to
specify terms.}

\item{...}{Not used.}

\item{blueprint}{A hardhat blueprint used for fine tuning the preprocessing.

If \code{NULL}, \code{\link[hardhat:default_xy_blueprint]{hardhat::default_xy_blueprint()}} is used.

Note that preprocessing done here is separate from preprocessing that
might be done by the underlying model.}
}
\value{
\code{x}, updated with either a new or removed variables preprocessor.
}
\description{
\itemize{
\item \code{add_variables()} specifies the terms of the model through the usage of
\link[tidyselect:language]{tidyselect::select_helpers} for the \code{outcomes} and \code{predictors}.
\item \code{remove_variables()} removes the variables. Additionally, if the model
has already been fit, then the fit is removed.
\item \code{update_variables()} first removes the variables, then replaces the
previous variables with the new ones. Any model that has already been
fit based on the original variables will need to be refit.
}
}
\details{
To fit a workflow, exactly one of \code{\link[=add_formula]{add_formula()}}, \code{\link[=add_recipe]{add_recipe()}}, or
\code{\link[=add_variables]{add_variables()}} \emph{must} be specified.
}
\examples{
library(parsnip)

spec_lm <- linear_reg()
spec_lm <- set_engine(spec_lm, "lm")

workflow <- workflow()
workflow <- add_model(workflow, spec_lm)

# Add terms with tidyselect expressions.
# Outcomes are specified before predictors.
workflow1 <- add_variables(
  workflow,
  outcomes = mpg,
  predictors = c(cyl, disp)
)

workflow1 <- fit(workflow1, mtcars)
workflow1

# Removing the variables of a fit workflow will also remove the model
remove_variables(workflow1)

# Variables can also be updated
update_variables(workflow1, mpg, starts_with("d"))

# The `outcomes` are removed before the `predictors` expression
# is evaluated. This allows you to easily specify the predictors
# as "everything except the outcomes".
workflow2 <- add_variables(workflow, mpg, everything())
workflow2 <- fit(workflow2, mtcars)
pull_workflow_mold(workflow2)$predictors
}

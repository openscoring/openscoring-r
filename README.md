Openscoring-R
=============

R client library for the Openscoring REST web service.

# Installation #

Install from GitHub using the [`devtools` package](http://cran.r-project.org/web/packages/devtools/):
```R
library("devtools")

install_git("git://github.com/openscoring/openscoring-r.git")
```

# Usage #

Creating an `Openscoring` S4 object:
```R
library("openscoring")

os = new("Openscoring", base_url = "http://localhost:8080/openscoring")
```

Deploying a PMML document `DecisionTreeIris.pmml` as an `Iris` model:
```R
deployFile(os, "Iris", "DecisionTreeIris.pmml")
```

Evaluating the `Iris` model with a data record:
```R
arguments = list(
	Sepal_Length = 5.1,
	Sepal_Width = 3.5,
	Petal_Length = 1.4,
	Petal_Width = 0.2
)

result = evaluate(os, "Iris", arguments)
print(result)
```

The same, but wrapping the data record into an `EvaluationRequest` S4 object for request identification purposes:
```R
evaluationRequest = new("EvaluationRequest", id = "record-001", arguments = arguments)

evaluationResponse = evaluate(os, "Iris", evaluationRequest)
print(evaluationResponse@result)
```

Undeploying the `Iris` model:
```R
undeploy(os, "Iris")
```

# De-installation #

Uninstall:
```R
remove.packages("openscoring")
```

# License #

Openscoring-R is dual-licensed under the [GNU Affero General Public License (AGPL) version 3.0](http://www.gnu.org/licenses/agpl-3.0.html), and a commercial license.

# Additional information #

Openscoring-R is developed and maintained by Openscoring Ltd, Estonia.

Interested in using Openscoring software in your application? Please contact [info@openscoring.io](mailto:info@openscoring.io)

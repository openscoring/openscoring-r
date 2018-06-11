context("README")

os = new("Openscoring")

test_that("Openscoring is S4 object", {
	expect_true(isS4(os))
	expect_equal(os@base_url, "http://localhost:8080/openscoring")
})

modelResponse = deployFile(os, "Iris", "resources/DecisionTreeIris.pmml")

test_that("ModelResponse is S4 object", {
	expect_true(isS4(modelResponse))
	expect_true(is(modelResponse, "SimpleResponse"))
	expect_true(is(modelResponse, "ModelResponse"))
	expect_equal(modelResponse@id, "Iris")
	expect_equal(modelResponse@miningFunction, "classification")
	expect_equal(modelResponse@summary, "Tree model")
	expect_true(length(modelResponse@properties) > 0)
	expect_equal(length(modelResponse@schema), 4)
	expect_equal(length(modelResponse@schema$inputFields), 4)
	expect_equal(length(modelResponse@schema$groupFields), 0)
	expect_equal(length(modelResponse@schema$targetFields), 1)
	expect_equal(length(modelResponse@schema$outputFields), 4)
})

arguments = list(
	Sepal_Length = 5.1,
	Sepal_Width = 3.5,
	Petal_Length = 1.4,
	Petal_Width = 0.2
)

result = evaluate(os, "Iris", arguments)

test_that("Default evaluation response is list", {
	expect_true(is(result, "list"))
	expect_equal(length(result), 1 + 4)
	expect_equal(result$Species, "setosa")
})

evaluationRequest = new("EvaluationRequest", id = "record-001", arguments = arguments)

evaluationResponse = evaluate(os, "Iris", evaluationRequest)

test_that("EvaluationResponse is S4 object", {
	expect_true(isS4(evaluationResponse))
	expect_true(is(evaluationResponse, "SimpleResponse"))
	expect_true(is(evaluationResponse, "EvaluationResponse"))
	expect_equal(evaluationResponse@id, "record-001")
	expect_equal(length(evaluationResponse@result), 1 + 4)
	expect_equal(evaluationResponse@result$Species, "setosa")
})

test_that("Default evaluation response and EvaluationResponse contain the same prediction", {
	expect_equal(evaluationResponse@result, result)
})

simpleResponse = undeploy(os, "Iris")

test_that("SimpleResponse is empty S4 object", {
	expect_true(isS4(simpleResponse))
	expect_equal(simpleResponse@message, NA_character_)
})

simpleResponse = undeploy(os, "Iris")

test_that("SimpleResponse is non-empty S4 object", {
	expect_true(isS4(simpleResponse))
	expect_equal(simpleResponse@message, "Model \"Iris\" not found")
})

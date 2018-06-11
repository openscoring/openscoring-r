context("README")

os = new("Openscoring")

test_that("Openscoring is S4 object", {
	expect_true(isS4(os))
	expect_equal(os@base_url, "http://localhost:8080/openscoring")
})

deployResponse = deployFile(os, "Iris", "resources/DecisionTreeIris.pmml")

test_that("Deploy response is ModelResponse object", {
	expect_true(isS4(deployResponse))
	expect_true(is(deployResponse, "SimpleResponse"))
	expect_true(is(deployResponse, "ModelResponse"))
	expect_equal(deployResponse@id, "Iris")
	expect_equal(deployResponse@miningFunction, "classification")
	expect_equal(deployResponse@summary, "Tree model")
	expect_true(length(deployResponse@properties) > 0)
	expect_equal(length(deployResponse@schema), 4)
	expect_equal(length(deployResponse@schema$inputFields), 4)
	expect_equal(length(deployResponse@schema$groupFields), 0)
	expect_equal(length(deployResponse@schema$targetFields), 1)
	expect_equal(length(deployResponse@schema$outputFields), 4)
})

arguments = list(
	Sepal_Length = 5.1,
	Sepal_Width = 3.5,
	Petal_Length = 1.4,
	Petal_Width = 0.2
)

result = evaluate(os, "Iris", arguments)

test_that("Simple evaluation response is list", {
	expect_true(is(result, "list"))
	expect_equal(length(result), 1 + 4)
	expect_equal(result$Species, "setosa")
})

evaluationRequest = new("EvaluationRequest", id = "record-001", arguments = arguments)

evaluationResponse = evaluate(os, "Iris", evaluationRequest)

test_that("Advanced evaluation response is EvaluationResponse object", {
	expect_true(isS4(evaluationResponse))
	expect_true(is(evaluationResponse, "SimpleResponse"))
	expect_true(is(evaluationResponse, "EvaluationResponse"))
	expect_equal(evaluationResponse@id, "record-001")
	expect_equal(length(evaluationResponse@result), 1 + 4)
	expect_equal(evaluationResponse@result$Species, "setosa")
})

test_that("Simple evaluation and advanced evaluation contain the same prediction", {
	expect_equal(evaluationResponse@result, result)
})

evaluationResponse = evaluate(os, "Flower", evaluationRequest)

test_that("Failed advanced evaluation response is SimpleResponse object", {
	expect_true(isS4(evaluationResponse))
	expect_true(is(evaluationResponse, "SimpleResponse"))
	expect_false(is(evaluationResponse, "EvaluationResponse"))
	expect_equal(evaluationResponse@message, "Model \"Flower\" not found")
})

tmpfile = tempfile(pattern = "test", fileext = ".csv")

evaluationResponse = evaluateCsvFile(os, "Iris", "resources/input.csv", tmpfile)

test_that("CSV evaluation response is path", {
	expect_true(is(evaluationResponse, "character"))
	expect_true(file.size(evaluationResponse) > 100)
})

evaluationResponse = evaluateCsvFile(os, "Flower", "resources/input.csv", tmpfile)

test_that("Failed CSV evaluation response is SimpleResponse object", {
	expect_true(isS4(evaluationResponse))
	expect_true(is(evaluationResponse, "SimpleResponse"))
	expect_equal(evaluationResponse@message, "Model \"Flower\" not found")
})

undeployResponse = undeploy(os, "Iris")

test_that("Undeploy response is SimpleResponse object", {
	expect_true(isS4(undeployResponse))
	expect_equal(undeployResponse@message, NA_character_)
})

undeployResponse = undeploy(os, "Flower")

test_that("Failed undeploy response is SimpleResponse object", {
	expect_true(isS4(undeployResponse))
	expect_equal(undeployResponse@message, "Model \"Flower\" not found")
})

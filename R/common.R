setClass("SimpleRequest")
setClass("SimpleResponse",
	slots = c(
		message = "character"
	),
	prototype = list(
		message = NA_character_
	)
)

as.list.SimpleRequest = function(x){
	return (mapply(FUN = function(name){ slot(x, name) }, slotNames(x), SIMPLIFY = FALSE))
}

setClass("ModelResponse", contains = "SimpleRequest",
	slots = c(
		id = "character",
		miningFunction = "character",
		summary = "character",
		properties = "list",
		schema = "list"
	),
	prototype = list(
		id = NA_character_,
		miningFunction = NA_character_,
		summary = NA_character_,
		properties = list(),
		schema = list()
	)
)

setClass("EvaluationRequest", contains = "SimpleRequest",
	slots = c(
		id = "character",
		arguments = "list"
	),
	prototype = list(
		id = NA_character_,
		arguments = list()
	)
)
setClass("EvaluationResponse", contains = "SimpleResponse",
	slots = c(
		id = "character",
		result = "list"
	),
	prototype = list(
		id = NA_character_,
		result = list()
	)
)

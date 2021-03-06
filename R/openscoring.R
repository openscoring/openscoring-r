library("httr")

setClass("Openscoring",
	slots = c(
		base_url = "character"
	),
	prototype = list(
		base_url = "http://localhost:8080/openscoring"
	)
)

parseContent = function(clazz, response){
	if(http_error(response)){
		args = list(Class = "SimpleResponse")
		args = c(args, content(response, as = "parsed"))
		return (do.call("new", args))
	}
	args = list(Class = clazz)
	args = c(args, content(response, as = "parsed"))
	return (do.call("new", args))
}

model_url = function(os, id){
	return (paste(os@base_url, "model", id, sep = "/"))
}

setGeneric("deployFile",
	def = function(os, id, path){
		standardGeneric("deployFile")
	}
)
setMethod("deployFile",
	signature = c("Openscoring", "character", "character"),
	definition = function(os, id, path){
		putResponse = PUT(url = model_url(os, id), body = upload_file(path, type = "application/xml"))
		return (parseContent("ModelResponse", putResponse))
	}
)

setGeneric("evaluate",
	def = function(os, id, payload){
		standardGeneric("evaluate")
	}
)
setMethod("evaluate",
	signature = c("Openscoring", "character", "list"),
	definition = function(os, id, payload){
		evalRequest = new("EvaluationRequest", id = NA_character_, arguments = payload)
		evalResponse = evaluate(os, id, evalRequest)
		return (evalResponse@result)
	}
)
setMethod("evaluate",
	signature = c("Openscoring", "character", "EvaluationRequest"),
	definition = function(os, id, payload){
		postResponse = POST(url = model_url(os, id), body = as.list(payload), encode = "json")
		return (parseContent("EvaluationResponse", postResponse))
	}
)

setGeneric("evaluateCsv",
	def = function(os, id, df){
		standardGeneric("evaluateCsv")
	}
)
setMethod("evaluateCsv",
	signature = c("Openscoring", "character", "data.frame"),
	definition = function(os, id, df){
		inpath = tempfile(pattern = "input-", fileext = ".tsv")
		outpath = tempfile(pattern = "output-", fileext = ".tsv")
		write.table(df, file = inpath, quote = FALSE, sep = "\t", na = "N/A", row.names = FALSE, col.names = TRUE)
		response = evaluateCsvFile(os, id = id, inpath = inpath, outpath = outpath)
		if(isS4(response)){
			return (response)
		}
		result = read.table(file = outpath, header = TRUE, sep = "\t", na.strings = "N/A", check.names = FALSE)
		unlink(inpath)
		unlink(outpath)
		return (result)
	}
)

setGeneric("evaluateCsvFile",
	def = function(os, id, inpath, outpath){
		standardGeneric("evaluateCsvFile")
	}
)
setMethod("evaluateCsvFile",
	signature = c("Openscoring", "character", "character", "character"),
	definition = function(os, id, inpath, outpath){
		path = tempfile(pattern = "openscoring-", fileext = ".csv")
		postResponse = POST(url = paste(model_url(os, id), "csv", sep = "/"), write_disk(path), body = upload_file(inpath, type = "text/plain"))
		if(http_error(postResponse)){
			return (parseContent("SimpleResponse", postResponse))
		}
		file.copy(path, outpath)
		unlink(path)
		return (outpath)
	}
)

setGeneric("undeploy",
	def = function(os, id){
		standardGeneric("undeploy")
	}
)
setMethod("undeploy",
	signature = c("Openscoring", "character"),
	definition = function(os, id){
		deleteResponse = DELETE(url = model_url(os, id))
		return (parseContent("SimpleResponse", deleteResponse))
	}
)

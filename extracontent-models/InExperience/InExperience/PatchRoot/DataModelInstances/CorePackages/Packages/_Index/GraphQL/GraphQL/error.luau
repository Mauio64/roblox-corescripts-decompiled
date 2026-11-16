local GraphQLError = require(script.GraphQLError)
local formatError = require(script.formatError)

local Error = {
	GraphQLError = GraphQLError.GraphQLError,
	printError = GraphQLError.printError,
	syntaxError = 0,
	locatedError = 0,
	formatError = 0
}
local syntaxError = require(script.syntaxError)
Error.syntaxError = syntaxError.syntaxError
local locatedError = require(script.locatedError)
Error.locatedError = locatedError.locatedError
Error.formatError = formatError.formatError
return Error

local parent = script.Parent.Parent

require(parent.ES7Types)

return {
	Map = require(script.Map),
	coerceToMap = require(script.coerceToMap),
	coerceToTable = require(script.coerceToTable)
}

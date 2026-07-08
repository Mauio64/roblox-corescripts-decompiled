local ParentParent = script.Parent.Parent

require(ParentParent.ES7Types)

local Map = require(script.Map)
local coerceToMap = require(script.coerceToMap)
local coerceToTable = require(script.coerceToTable)

return {
	Map = Map,
	coerceToMap = coerceToMap,
	coerceToTable = coerceToTable
}

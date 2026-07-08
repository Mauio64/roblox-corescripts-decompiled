local Array = require(script.Array)
local AssertionError = require(script.AssertionError)
local Error = require(script.Error)
local Object = require(script.Object)

require(script.Promise)

local Set = require(script.Set)
local Symbol = require(script.Symbol)
local Timers = require(script.Timers)
local WeakMap = require(script.WeakMap)
local Map = require(script.Map)
local coerceToMap = require(script.Map.coerceToMap)
local coerceToTable = require(script.Map.coerceToTable)

require(script.types)

return {
	Array = Array,
	AssertionError = AssertionError,
	Boolean = require(script.Boolean),
	console = require(script.console),
	Error = Error,
	extends = require(script.extends),
	instanceof = require(script.instanceof),
	Math = require(script.Math),
	Number = require(script.Number),
	Object = Object,
	Map = Map,
	coerceToMap = coerceToMap,
	coerceToTable = coerceToTable,
	Set = Set,
	WeakMap = WeakMap,
	String = require(script.String),
	Symbol = Symbol,
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
	setInterval = Timers.setInterval,
	clearInterval = Timers.clearInterval,
	util = require(script.util)
}

local scriptParent = script.Parent
local Boolean = require(scriptParent.Boolean)
local Collections = require(scriptParent.Collections)
local Console = require(scriptParent.Console)
local Math = require(scriptParent.Math)
local Number = require(scriptParent.Number)
local String = require(scriptParent.String)
local Symbol = require(scriptParent.Symbol)
local Timers = require(scriptParent.Timers)

require(scriptParent.ES7Types)

local AssertionError = require(script.AssertionError)
local Error = require(script.Error)

require(script.Promise)

local extends = require(script.extends)
local InstanceOf = require(scriptParent.InstanceOf)

return {
	Array = Collections.Array,
	AssertionError = AssertionError,
	Boolean = Boolean,
	console = Console,
	Error = Error,
	extends = extends,
	instanceof = InstanceOf,
	Math = Math,
	Number = Number,
	Object = Collections.Object,
	Map = Collections.Map,
	coerceToMap = Collections.coerceToMap,
	coerceToTable = Collections.coerceToTable,
	Set = Collections.Set,
	WeakMap = Collections.WeakMap,
	String = String,
	Symbol = Symbol,
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
	setInterval = Timers.setInterval,
	clearInterval = Timers.clearInterval,
	util = {
		inspect = Collections.inspect
	}
}

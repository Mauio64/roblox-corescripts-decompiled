local parent = script.Parent

local Boolean = require(parent.Boolean)
local Collections = require(parent.Collections)
local Console = require(parent.Console)
local Math = require(parent.Math)
local Number = require(parent.Number)
local String = require(parent.String)
local Symbol = require(parent.Symbol)
local Timers = require(parent.Timers)
require(parent.ES7Types)

local AssertionError = require(script.AssertionError)
local Error = require(script.Error)
require(script.Promise)
local extends = require(script.extends)
local InstanceOf = require(parent.InstanceOf)

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
	util = { inspect = Collections.inspect }
}

local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local console = LuauPolyfill.console
local Error = LuauPolyfill.Error

local object = setmetatable({}, { __index = Error })
object.__index = object

function object.new(p)
	local v = p == nil and "Invariant Violation" or p

	if typeof(v) == "number" then
		v = ("%s: %s (see https://github.com/apollographql/invariant-packages)"):format(
			"Invariant Violation",
			(tostring(v))
		)
	end

	local v2 = Error.new(v)
	v2.framesToPop = 1
	v2.name = "Invariant Violation"

	return (setmetatable(v2, object))
end

local function invariant(p, p2: string?) -- 1 equivalent call inferred from this helper
	if not Boolean.toJSBoolean(p) then
		error(object.new(p2))
	end
end

local v = { "debug", "log", "warn", "error", "silent" }

local v2 = Array.indexOf(v, "log")

local function wrapConsoleMethod(p: string) -- 4 equivalent calls inferred from this helper
	return function(...)
		local index = Array.indexOf(v, p)

		if v2 <= index then
			return (Boolean.toJSBoolean(console[p]) and console[p] or console.log)(...)
		end
	end
end

local v3 = {
	debug = wrapConsoleMethod("debug"), -- inferred equivalent call
	log = wrapConsoleMethod("log"), -- inferred equivalent call
	warn = wrapConsoleMethod("warn"), -- inferred equivalent call
	error = wrapConsoleMethod("error") -- inferred equivalent call
}
return {
	invariant = setmetatable(v3, {
		__call = function(_, p, p2: string?)
			invariant(p, p2) -- inferred equivalent call
		end
	}),
	InvariantError = object,
	setVerbosity = function(p: string)
		local v4 = v[v2]
		v2 = math.max(1, Array.indexOf(v, p))
		return v4
	end
}

local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local console = LuauPolyfill.console
local Error = LuauPolyfill.Error
local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.new(p1) -- line: 20
	-- upvalues: Error (copy), self (copy)
	if p1 == nil then
		p1 = "Invariant Violation"
	end

	local v19 = if typeof(p1) ~= "number" then p1 else ("%s: %s (see https://github.com/apollographql/invariant-packages)"):format("Invariant Violation", (tostring(p1)))
	local v20 = Error.new(v19)

	v20.framesToPop = 1
	v20.name = "Invariant Violation"

	return (setmetatable(v20, self))
end

local function invariant(p2, s1: string?) -- line: 43
	-- upvalues: Boolean (copy), self (copy)
	if not Boolean.toJSBoolean(p2) then
		error(self.new(s1))
	end
end

local t1 = {
	"debug",
	"log",
	"warn",
	"error",
	"silent"
}
local u10 = Array.indexOf(t1, "log")

local function wrapConsoleMethod(s2: string) -- line: 53
	-- upvalues: Array (copy), t1 (copy), u10 (ref), Boolean (copy), console (copy)
	return function(...) -- line: 54
		-- upvalues: Array (copy), t1 (copy), s2 (copy), u10 (ref), Boolean (copy), console (copy)
		if Array.indexOf(t1, s2) >= u10 then
			return (Boolean.toJSBoolean(console[s2]) and console[s2] or console.log)(...)
		end
	end
end

local t2 = {}
local t3 = {}
local s3 = "debug"

function t3.debug(...) -- line: 54
	-- upvalues: Array (copy), t1 (copy), s3 (copy), u10 (ref), Boolean (copy), console (copy)
	if Array.indexOf(t1, s3) >= u10 then
		return (Boolean.toJSBoolean(console[s3]) and console[s3] or console.log)(...)
	end
end

local s4 = "log"

function t3.log(...) -- line: 54
	-- upvalues: Array (copy), t1 (copy), s4 (copy), u10 (ref), Boolean (copy), console (copy)
	if Array.indexOf(t1, s4) >= u10 then
		return (Boolean.toJSBoolean(console[s4]) and console[s4] or console.log)(...)
	end
end

local s5 = "warn"

function t3.warn(...) -- line: 54
	-- upvalues: Array (copy), t1 (copy), s5 (copy), u10 (ref), Boolean (copy), console (copy)
	if Array.indexOf(t1, s5) >= u10 then
		return (Boolean.toJSBoolean(console[s5]) and console[s5] or console.log)(...)
	end
end

local s6 = "error"

function t3.error(...) -- line: 54
	-- upvalues: Array (copy), t1 (copy), s6 (copy), u10 (ref), Boolean (copy), console (copy)
	if Array.indexOf(t1, s6) >= u10 then
		return (Boolean.toJSBoolean(console[s6]) and console[s6] or console.log)(...)
	end
end

t2.invariant = setmetatable(t3, {
	__call = function(_, p4, s7: string?) -- line: 72
		-- upvalues: Boolean (copy), self (copy)
		if not Boolean.toJSBoolean(p4) then
			error(self.new(s7))
		end
	end
})
t2.InvariantError = self

function t2.setVerbosity(s8: string) -- line: 77
	-- upvalues: t1 (copy), u10 (ref), Array (copy)
	local v28 = t1[u10]

	u10 = math.max(1, Array.indexOf(t1, s8))

	return v28
end

return t2

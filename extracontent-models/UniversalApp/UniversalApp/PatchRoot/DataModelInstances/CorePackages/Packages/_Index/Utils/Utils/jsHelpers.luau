local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local function isSymbol(p): boolean -- 2 equivalent calls inferred from this helper
	return typeof(p) == "userdata" and string.sub(tostring(p), 1, 7) == "Symbol("
end

local JsHelpers = {}
JsHelpers.isSymbol = isSymbol

function JsHelpers.getOwnPropertySymbols(p)
	return Array.filter(Object.keys(p), function(p2)
		return isSymbol(p2) -- inferred equivalent call
	end)
end

function JsHelpers.getOwnPropertyNames(p)
	Array.filter(Object.keys(p), function(p2): boolean
		return not isSymbol(p2) -- inferred equivalent call
	end)
end

function JsHelpers.create(p)
	if p then
		return (setmetatable({}, p))
	end

	return {}
end

return JsHelpers

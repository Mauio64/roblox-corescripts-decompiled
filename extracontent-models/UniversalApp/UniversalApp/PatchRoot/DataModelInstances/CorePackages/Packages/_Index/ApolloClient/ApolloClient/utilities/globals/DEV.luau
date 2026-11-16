local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local global = require(script.Parent.Parent.common.global)
local default = global.default

local function getDEV()
	local _, result = xpcall(function()
		return Boolean.toJSBoolean(_G.__DEV__)
	end, function()
		default.__DEV__ = true

		return default.__DEV__
	end)

	return result
end

local _, result = xpcall(function()
	return Boolean.toJSBoolean(_G.__DEV__)
end, function()
	default.__DEV__ = true

	return default.__DEV__
end)
return { default = result }

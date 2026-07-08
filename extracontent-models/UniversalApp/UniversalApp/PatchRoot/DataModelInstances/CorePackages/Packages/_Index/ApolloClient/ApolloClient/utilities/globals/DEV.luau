local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local default = require(script.Parent.Parent.common.global).default

local function getDEV() -- line: 23
	-- upvalues: Boolean (copy), default (copy)
	local _, result = xpcall(function() -- line: 25
		-- upvalues: Boolean (copy)
		return Boolean.toJSBoolean(_G.__DEV__)
	end, function() -- line: 27
		-- upvalues: default (copy)
		default.__DEV__ = true

		return default.__DEV__
	end)

	return result
end

local _, result = xpcall(function() -- line: 25
	-- upvalues: Boolean (copy)
	return Boolean.toJSBoolean(_G.__DEV__)
end, function() -- line: 27
	-- upvalues: default (copy)
	default.__DEV__ = true

	return default.__DEV__
end)

t1.default = result

return t1

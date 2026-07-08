local NavigationSymbol = require(script.Parent.NavigationSymbol)
local v2 = NavigationSymbol("BACK")
local v3 = NavigationSymbol("INIT")
local v4 = NavigationSymbol("NAVIGATE")
local v5 = NavigationSymbol("SET_PARAMS")
local t1 = {
	Back = v2,
	Init = v3,
	Navigate = v4,
	SetParams = v5
}

setmetatable(t1, {
	__index = function(_, p2) -- line: 24
		error(("%q is not a valid member of NavigationActions"):format((tostring(p2))), 2)
	end
})

function t1.back(p3) -- line: 30
	-- upvalues: v2 (copy)
	local v10 = p3 or {}

	return {
		type = v2,
		key = v10.key,
		immediate = v10.immediate
	}
end
function t1.init(p4) -- line: 40
	-- upvalues: v3 (copy)
	local v12 = p4 or {}

	return {
		type = v3,
		params = v12.params
	}
end
function t1.navigate(p5) -- line: 49
	-- upvalues: v4 (copy)
	local v14 = p5 or {}

	return {
		type = v4,
		routeName = v14.routeName,
		params = v14.params,
		action = v14.action,
		key = v14.key
	}
end
function t1.setParams(p6) -- line: 61
	-- upvalues: v5 (copy)
	local v16 = p6 or {}

	return {
		preserveFocus = true,
		type = v5,
		key = v16.key,
		params = v16.params
	}
end

return t1

local ReactUtils = script:FindFirstAncestor("ReactUtils")
local ReactUtilsParent = ReactUtils.Parent
local React = require(ReactUtilsParent.React)
local LUAU_ANALYZE_ERROR = ReactUtils.LUAU_ANALYZE_ERROR

local function useStackState(t1: {[any]: any}?) -- line: 9
	-- upvalues: React (copy), LUAU_ANALYZE_ERROR (copy)
	local v7 = React.useRef(t1 or {})

	assert(v7.current ~= nil, LUAU_ANALYZE_ERROR)

	local v8, v9 = React.useState(#v7.current)
	local v10 = React.useCallback(function(p1) -- line: 21
		-- upvalues: v7 (copy), v9 (copy)
		table.insert(v7.current, p1)
		v9(#v7.current)
	end, {})
	local v11 = React.useCallback(function() -- line: 26
		-- upvalues: v7 (copy), v9 (copy)
		local v15 = table.remove(v7.current)

		v9(#v7.current)

		return v15
	end, {})
	local v12 = React.useCallback(function() -- line: 32
		-- upvalues: v7 (copy)
		return v7.current[#v7.current]
	end, {})
	local v13 = React.useCallback(function() -- line: 36
		-- upvalues: v7 (copy), v9 (copy)
		table.clear(v7.current)
		v9(0)
	end, {})

	return {
		push = v10,
		pop = v11,
		getTop = v12,
		clear = v13,
		size = v8
	}
end

return useStackState

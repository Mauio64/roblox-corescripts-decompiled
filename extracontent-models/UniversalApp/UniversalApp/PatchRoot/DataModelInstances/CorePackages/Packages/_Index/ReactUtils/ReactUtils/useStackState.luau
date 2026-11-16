local ReactUtils = script:FindFirstAncestor("ReactUtils")

local parent = ReactUtils.Parent
local React = require(parent.React)

local LUAU_ANALYZE_ERROR = require(ReactUtils.LUAU_ANALYZE_ERROR)

local function useStackState(options)
	local ref = React.useRef(options or {})
	assert(ref.current ~= nil, LUAU_ANALYZE_ERROR)

	local state, setState = React.useState(#ref.current)

	return {
		push = React.useCallback(function(p)
			table.insert(ref.current, p)
			setState(#ref.current)
		end, {}),
		pop = React.useCallback(function()
			local v = table.remove(ref.current)
			setState(#ref.current)
			return v
		end, {}),
		getTop = React.useCallback(function()
			return ref.current[#ref.current]
		end, {}),
		clear = React.useCallback(function()
			table.clear(ref.current)
			setState(0)
		end, {}),
		size = state
	}
end

return useStackState

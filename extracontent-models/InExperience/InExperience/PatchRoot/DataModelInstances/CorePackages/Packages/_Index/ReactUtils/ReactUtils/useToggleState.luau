local ReactUtils = script:FindFirstAncestor("ReactUtils")
local ReactUtilsParent = ReactUtils.Parent
local React = require(ReactUtilsParent.React)
local v4 = require(ReactUtils.Flags.getFFlagUseToggleStateImprovements)()

local function useToggleState(p1) -- line: 10
	-- upvalues: React (copy), v4 (copy)
	local v7, v8 = React.useState(p1 or false)
	local v9 = React.useCallback(function() -- line: 19
		-- upvalues: v8 (copy)
		v8(true)
	end, {})
	local v10 = React.useCallback(function() -- line: 23
		-- upvalues: v8 (copy)
		v8(false)
	end, {})
	local v11 = nil

	if v4 then
		v11 = React.useCallback(function() -- line: 29
			-- upvalues: v8 (copy)
			v8(function(p2) -- line: 30
				return not p2
			end)
		end, {})
	end

	return {
		enabled = v7,
		enable = v9,
		disable = v10,
		toggle = if not v4 then nil else v11,
		set = if not v4 then nil else v8
	}
end

return useToggleState

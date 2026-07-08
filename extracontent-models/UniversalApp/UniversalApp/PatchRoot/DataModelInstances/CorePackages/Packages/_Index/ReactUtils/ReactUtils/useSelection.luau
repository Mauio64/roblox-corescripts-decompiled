local ReactUtils = script:FindFirstAncestor("ReactUtils")
local ReactUtilsParent = ReactUtils.Parent
local React = require(ReactUtilsParent.React)
local useEventConnection = require(ReactUtils.useEventConnection)

local function useSelection(p1) -- line: 9
	-- upvalues: React (copy), useEventConnection (copy)
	local v7 = p1 or game:GetService("Selection")
	local v8, v9 = React.useState(function() -- line: 12
		-- upvalues: v7 (copy)
		return v7:Get()
	end)

	useEventConnection(v7.SelectionChanged, function() -- line: 16
		-- upvalues: v9 (copy), v7 (copy)
		v9(v7:Get())
	end, {})

	return v8
end

return useSelection

local ReactUtils = script:FindFirstAncestor("ReactUtils")

local parent = ReactUtils.Parent
local React = require(parent.React)

local useEventConnection = require(ReactUtils.useEventConnection)

local function useSelection(p)
	local v = p or game:GetService("Selection")

	local state, setState = React.useState(function()
		return v:Get()
	end)

	useEventConnection(v.SelectionChanged, function()
		setState(v:Get())
	end, {})

	return state
end

return useSelection

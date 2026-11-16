local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local function isSelectionWithin(ancestor, flag: boolean, instance)
	if not flag then
		if instance == nil then
			flag = false
		else
			flag = instance:IsDescendantOf(ancestor)
		end
	end

	return flag
end

return {
	useDescendantSelected = function()
		local state, setState = React.useState(nil)
		local state2, setState2 = React.useState(false)
		local v = React.useCallback(function(p)
			setState(p)
		end, {})

		React.useEffect(function()
			setState2(false)

			if not state then
				return
			end

			local selectionChangedConnection = state.SelectionChanged:Connect(function(flag: boolean, _, instance)
				if not flag then
					if instance == nil then
						flag = false
					else
						flag = instance:IsDescendantOf(state)
					end
				end

				setState2(flag)
			end)

			return function()
				selectionChangedConnection:Disconnect()
			end
		end, { state })

		return state2, v
	end
}

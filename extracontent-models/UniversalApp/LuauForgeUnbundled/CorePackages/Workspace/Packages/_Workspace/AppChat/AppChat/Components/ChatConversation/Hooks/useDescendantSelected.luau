local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local function isSelectionWithin(ancestor, p2, instance)
	if not p2 then
		p2 = not (instance == nil) and instance:IsDescendantOf(ancestor)
	end

	return p2
end

return {
	useDescendantSelected = function()
		local state, setState = React.useState(nil)
		local state2, setState2 = React.useState(false)
		local v5 = React.useCallback(function(p2)
			setState(p2)
		end, {})

		React.useEffect(function()
			setState2(false)

			if not state then
				return
			end

			local selectionChangedConnection = state.SelectionChanged:Connect(function(p2, p3, instance)
				local v7 = state

				if not p2 then
					p2 = not (instance == nil) and instance:IsDescendantOf(v7)
				end

				setState2(p2)
			end)

			return function()
				selectionChangedConnection:Disconnect()
			end
		end, { state })

		return state2, v5
	end
}

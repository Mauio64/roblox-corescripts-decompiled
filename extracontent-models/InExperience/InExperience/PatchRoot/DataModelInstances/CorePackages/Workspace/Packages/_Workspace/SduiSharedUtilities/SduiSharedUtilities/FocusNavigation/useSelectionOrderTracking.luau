local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local React = require(parent.React)

local function useSelectionOrderTracking(p)
	React.useEffect(function()
		local current = p.current

		if not current then
			return
		end

		local selectionOrder = -1
		local selectionChangedConnection = current.SelectionChanged:Connect(function(_: boolean, instance, instance2)
			if
				instance2 == nil
				or instance == nil
				or not (instance2:IsDescendantOf(current) and instance:IsDescendantOf(current))
			then
				return
			end

			instance2.SelectionOrder = selectionOrder
			selectionOrder -= 1
		end)

		return function()
			selectionChangedConnection:Disconnect()
		end
	end, {})
end

return useSelectionOrderTracking

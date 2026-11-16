local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")

local function useSelectionOrderTracking(p2)
	React.useEffect(function()
		local current = p2.current

		if not current then
			return
		end

		local v5 = -1
		local selectionChangedConnection = current.SelectionChanged:Connect(function(p3, instance, instance2)
			if
				instance2 == nil
				or instance == nil
				or not (instance2:IsDescendantOf(current) and instance:IsDescendantOf(current))
			then
				return
			end

			instance2.SelectionOrder = v5
			v5 -= 1
		end)

		return function()
			selectionChangedConnection:Disconnect()
		end
	end, {})
end

return useSelectionOrderTracking

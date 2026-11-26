local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")

local function hasFocus(ancestor)
	local selectedCoreObject = GuiService.SelectedCoreObject

	if ancestor and selectedCoreObject then
		return (selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor))
			and selectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil
	end

	return false
end

local function useDescendantHasFocus(ancestor)
	local selectedCoreObject = GuiService.SelectedCoreObject
	local v5

	if ancestor and selectedCoreObject then
		v5 = (selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor))
			and selectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil
	else
		v5 = false
	end

	local state, setState = React.useState(v5)

	React.useEffect(function()
		local selectedCoreObjectChangedConnection = nil
		local ancestryChangedConnection = nil

		if ancestor then
			local v7 = ancestor
			local selectedCoreObject2 = GuiService.SelectedCoreObject

			local v8 = if v7 and selectedCoreObject2 then (selectedCoreObject2 == v7 or selectedCoreObject2:IsDescendantOf(v7)) and selectedCoreObject2:FindFirstAncestorOfClass("CoreGui") ~= nil else false

			setState(v8)
			selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
				if ancestryChangedConnection then
					ancestryChangedConnection:Disconnect()
				end

				local v9 = ancestor
				local selectedCoreObject3 = GuiService.SelectedCoreObject
				local v10

				if v9 and selectedCoreObject3 then
					v10 = (selectedCoreObject3 == v9 or selectedCoreObject3:IsDescendantOf(v9))
						and selectedCoreObject3:FindFirstAncestorOfClass("CoreGui") ~= nil
				else
					v10 = false
				end

				local selectedCoreObject4 = GuiService.SelectedCoreObject

				if v10 and selectedCoreObject4 then
					ancestryChangedConnection = selectedCoreObject4.AncestryChanged:Connect(function()
						if selectedCoreObject4:FindFirstAncestorOfClass("CoreGui") == nil then
							ancestryChangedConnection:Disconnect()
							local v12 = ancestor
							local selectedCoreObject5 = GuiService.SelectedCoreObject

							local v13 = if v12 and selectedCoreObject5 then (selectedCoreObject5 == v12 or selectedCoreObject5:IsDescendantOf(v12)) and selectedCoreObject5:FindFirstAncestorOfClass("CoreGui") ~= nil else false

							setState(v13)
						end
					end)
				end

				setState(v10)
			end)
		else
			setState(false)
		end

		return function()
			if selectedCoreObjectChangedConnection then
				selectedCoreObjectChangedConnection:Disconnect()
			end

			if ancestryChangedConnection then
				ancestryChangedConnection:Disconnect()
			end
		end
	end, { ancestor })

	return state
end

return useDescendantHasFocus

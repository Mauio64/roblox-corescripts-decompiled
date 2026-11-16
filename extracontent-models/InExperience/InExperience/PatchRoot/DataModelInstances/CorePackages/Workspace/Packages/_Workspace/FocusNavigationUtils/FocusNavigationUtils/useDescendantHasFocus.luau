local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)

local function hasFocus(ancestor) -- 4 equivalent calls inferred from this helper
	local selectedCoreObject = GuiService.SelectedCoreObject

	if ancestor and selectedCoreObject then
		return (selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor))
			and selectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil
	end

	return false
end

local function useDescendantHasFocus(ancestor)
	local focus = hasFocus(ancestor) -- inferred equivalent call
	local state, setState = React.useState(focus)

	React.useEffect(function()
		local selectedCoreObjectChangedConnection = nil
		local ancestryChangedConnection = nil

		if ancestor then
			setState(hasFocus(ancestor)) -- inferred equivalent call
			selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
				if ancestryChangedConnection then
					ancestryChangedConnection:Disconnect()
				end

				local focus2 = hasFocus(ancestor) -- inferred equivalent call
				local selectedCoreObject = GuiService.SelectedCoreObject

				if focus2 and selectedCoreObject then
					ancestryChangedConnection = selectedCoreObject.AncestryChanged:Connect(function()
						if selectedCoreObject:FindFirstAncestorOfClass("CoreGui") == nil then
							ancestryChangedConnection:Disconnect()
							setState(hasFocus(ancestor)) -- inferred equivalent call
						end
					end)
				end

				setState(focus2)
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

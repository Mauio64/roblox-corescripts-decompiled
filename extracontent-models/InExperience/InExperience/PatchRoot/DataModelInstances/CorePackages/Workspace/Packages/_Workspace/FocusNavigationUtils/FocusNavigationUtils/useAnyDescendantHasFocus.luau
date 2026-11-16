local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)

local function hasFocus(items): boolean
	local selectedCoreObject = GuiService.SelectedCoreObject

	if selectedCoreObject == nil or items == nil or selectedCoreObject:FindFirstAncestorOfClass("CoreGui") == nil then
		return false
	end

	for _, ancestor in items do
		if selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor) then
			return true
		end
	end

	return false
end

local function useAnyDescendantHasFocus(list)
	local focus = hasFocus(list)
	local state, setState = React.useState(focus)

	React.useEffect(function()
		local selectedCoreObjectChangedConnection = nil
		local ancestryChangedConnection = nil
		local v

		if list == nil then
			v = false
		else
			v = #list > 0
		end

		if v then
			setState(hasFocus(list))
			selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
				if ancestryChangedConnection then
					ancestryChangedConnection:Disconnect()
				end

				local focus2 = hasFocus(list)
				local selectedCoreObject = GuiService.SelectedCoreObject

				if focus2 and selectedCoreObject then
					ancestryChangedConnection = selectedCoreObject.AncestryChanged:Connect(function()
						if selectedCoreObject:FindFirstAncestorOfClass("CoreGui") == nil then
							ancestryChangedConnection:Disconnect()
							setState(hasFocus(list))
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
	end, { list })

	return state
end

return useAnyDescendantHasFocus

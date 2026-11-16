local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)

local function getSelectionIsOutsideGuiObject(current) -- 2 equivalent calls inferred from this helper
	local selectionIsOutsideGuiObject = GuiService.SelectedCoreObject
		and not GuiService.SelectedCoreObject:IsDescendantOf(current)

	if selectionIsOutsideGuiObject then
		selectionIsOutsideGuiObject = GuiService.SelectedCoreObject ~= current
	end

	return selectionIsOutsideGuiObject
end

local function useRedirectFocusIntoGuiObject(p)
	React.useEffect(function()
		local current = p.current

		if current then
			if getSelectionIsOutsideGuiObject(current) then -- inferred equivalent call
				current.Selectable = true
			else
				current.Selectable = false
			end
		end

		local changedConnection = GuiService.Changed:Connect(function(p2)
			local current2 = p2 == "SelectedCoreObject" and p.current

			if current2 then
				if getSelectionIsOutsideGuiObject(current2) then -- inferred equivalent call
					current2.Selectable = true
				elseif GuiService.SelectedCoreObject == current2 then
					current2.Selectable = false
					GuiService:Select(current2)
				elseif GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(current2) then
					current2.Selectable = false
				end
			end
		end)

		return function()
			return changedConnection:Disconnect()
		end
	end, {})
end

return useRedirectFocusIntoGuiObject

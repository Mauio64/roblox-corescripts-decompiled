local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local function getSelectionIsOutsideGuiObject(ancestor)
	local selectionIsOutsideGuiObject = GuiService.SelectedCoreObject
		and not GuiService.SelectedCoreObject:IsDescendantOf(ancestor)

	if selectionIsOutsideGuiObject then
		selectionIsOutsideGuiObject = GuiService.SelectedCoreObject ~= ancestor
	end

	return selectionIsOutsideGuiObject
end

local function useRedirectFocusIntoGuiObject(p2)
	React.useEffect(function()
		local current = p2.current

		if current then
			local v5 = GuiService.SelectedCoreObject
				and not GuiService.SelectedCoreObject:IsDescendantOf(current)

			if v5 then
				v5 = GuiService.SelectedCoreObject ~= current
			end

			if v5 then
				current.Selectable = true
			else
				current.Selectable = false
			end
		end

		local changedConnection = GuiService.Changed:Connect(function(p3)
			local current2 = p3 == "SelectedCoreObject" and p2.current

			if current2 then
				local v5 = GuiService.SelectedCoreObject
					and not GuiService.SelectedCoreObject:IsDescendantOf(current2)

				if v5 then
					v5 = GuiService.SelectedCoreObject ~= current2
				end

				if v5 then
					current2.Selectable = true
				elseif GuiService.SelectedCoreObject == current2 then
					current2.Selectable = false
					GuiService:Select(current2)
				elseif
					GuiService.SelectedCoreObject
					and GuiService.SelectedCoreObject:IsDescendantOf(current2)
				then
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

local fFlagLuaAppGamepadSelectionRespectsInteractable = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags").FFlagLuaAppGamepadSelectionRespectsInteractable

local function isSelectableGuiObject(instance): boolean
	if not ((instance:IsA("GuiButton") or instance:IsA("TextBox")) and (instance.Visible and instance.Active and instance.Selectable)) then
		return false
	end

	if instance.AbsoluteSize.Magnitude == 0 then
		return false
	end

	if not fFlagLuaAppGamepadSelectionRespectsInteractable then
		return true
	end

	while instance do
		if instance:IsA("GuiObject") then
			if not instance.Interactable then
				return false
			end
		elseif not instance:IsA("Folder") then
			break
		end

		instance = instance.Parent
	end

	return true
end

return isSelectableGuiObject

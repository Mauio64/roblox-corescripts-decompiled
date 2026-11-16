local parent = script.Parent.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGamepadSelectionRespectsInteractable = SharedFlags.FFlagLuaAppGamepadSelectionRespectsInteractable

local function isSelectableGuiObject(instance): boolean
	if not ((instance:IsA("GuiButton") or instance:IsA("TextBox")) and (instance.Active and instance.Selectable) and instance.AbsoluteSize.Magnitude ~= 0) then
		return false
	end

	if not FFlagLuaAppGamepadSelectionRespectsInteractable then
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

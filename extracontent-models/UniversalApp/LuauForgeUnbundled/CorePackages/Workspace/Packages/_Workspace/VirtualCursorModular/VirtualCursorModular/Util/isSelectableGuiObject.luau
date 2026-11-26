local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags")
local fFlagLuaAppGamepadSelectionRespectsInteractable = SharedFlags.FFlagLuaAppGamepadSelectionRespectsInteractable
local fFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink

local function isSelectableGuiObject(instance, p2): boolean
	if not (instance:IsA("GuiButton") or instance:IsA("TextBox")) then
		return false
	end

	local v5 = if fFlagVirtualCursorInputSink and p2 then instance.Interactable else instance.Active

	if not (instance.Visible and v5 and instance.Selectable and instance.AbsoluteSize.Magnitude ~= 0) then
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

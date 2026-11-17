local parent = script:FindFirstAncestor("VirtualCursorModular").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGamepadSelectionRespectsInteractable = SharedFlags.FFlagLuaAppGamepadSelectionRespectsInteractable
local FFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink

local function isSelectableGuiObject(instance, flag: boolean?): boolean
	if not (instance:IsA("GuiButton") or instance:IsA("TextBox")) then
		return false
	end

	local v

	if FFlagVirtualCursorInputSink and flag then
		v = instance.Interactable
	else
		v = instance.Active
	end

	if not (instance.Visible and v and instance.Selectable and instance.AbsoluteSize.Magnitude ~= 0) then
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

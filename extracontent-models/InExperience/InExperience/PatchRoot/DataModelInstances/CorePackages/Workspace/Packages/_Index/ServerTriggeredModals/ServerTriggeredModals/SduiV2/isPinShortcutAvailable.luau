local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local SduiCapabilities = require(Parent.SduiSharedUtilities).SduiCapabilities

local function isPinShortcutAvailable() -- line: 8
	-- upvalues: SduiCapabilities (copy)
	return SduiCapabilities.isEnabled("CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION")
end

return isPinShortcutAvailable

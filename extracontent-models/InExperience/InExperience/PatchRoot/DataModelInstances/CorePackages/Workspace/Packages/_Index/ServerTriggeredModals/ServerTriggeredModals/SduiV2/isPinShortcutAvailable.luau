local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local function isPinShortcutAvailable()
	return SduiCapabilities.isEnabled("CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION")
end

return isPinShortcutAvailable

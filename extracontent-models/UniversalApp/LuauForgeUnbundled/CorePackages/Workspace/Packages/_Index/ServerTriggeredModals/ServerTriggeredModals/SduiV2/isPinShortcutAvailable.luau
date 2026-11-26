local sduiCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities").SduiCapabilities

local function isPinShortcutAvailable()
	return sduiCapabilities.isEnabled("CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION")
end

return isPinShortcutAvailable

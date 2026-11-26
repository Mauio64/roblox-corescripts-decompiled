local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore/createFriendsChatSettingsStore")

return Signals.createComputed(function()
	return createFriendsChatSettingsStore()
end)

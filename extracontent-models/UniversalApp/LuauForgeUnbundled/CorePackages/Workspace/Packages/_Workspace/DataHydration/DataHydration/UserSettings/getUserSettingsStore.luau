local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUserSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserSettings/createUserSettingsStore")

return Signals.createComputed(function()
	return createUserSettingsStore()
end)

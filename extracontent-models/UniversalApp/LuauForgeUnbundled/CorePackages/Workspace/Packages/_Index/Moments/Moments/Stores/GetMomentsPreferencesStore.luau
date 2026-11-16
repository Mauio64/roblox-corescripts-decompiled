local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore/createMomentsPreferencesStore")

return Signals.createComputed(function(p2)
	return createMomentsPreferencesStore()
end)

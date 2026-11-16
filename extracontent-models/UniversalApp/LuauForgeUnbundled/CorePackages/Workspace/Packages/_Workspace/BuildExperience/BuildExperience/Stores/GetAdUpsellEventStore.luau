local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createAdUpsellEventStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdUpsellEventStore/createAdUpsellEventStore")

return Signals.createComputed(function()
	return createAdUpsellEventStore()
end)

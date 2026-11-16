local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local createMomentsCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Stores/GetMomentsCapabilities/createMomentsCapabilities")

return Signals.createComputed(function(p2)
	return createMomentsCapabilities()
end)

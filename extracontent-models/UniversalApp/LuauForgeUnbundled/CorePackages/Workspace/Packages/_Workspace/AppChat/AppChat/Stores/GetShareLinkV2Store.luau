local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createShareLinkV2Store = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkV2Store/createShareLinkV2Store")

return Signals.createComputed(function(p2)
	return createShareLinkV2Store()
end)

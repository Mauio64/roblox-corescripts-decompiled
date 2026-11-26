local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/Rodux")

local Networking = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Networking/Networking")

return Rodux.createReducer({}, {
	[Networking.ShareLinksNetworking.GetOrGenerateLink.Succeeded.name] = function(p2, p3)
		return p3.responseBody
	end
})

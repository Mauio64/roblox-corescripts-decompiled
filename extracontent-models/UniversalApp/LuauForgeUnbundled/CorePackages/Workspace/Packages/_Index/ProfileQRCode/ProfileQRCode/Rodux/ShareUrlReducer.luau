local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Rodux")
local createOrGetProfileShareUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/createOrGetProfileShareUrl")

return Rodux.createReducer({}, {
	[createOrGetProfileShareUrl.Succeeded.name] = function(p2, p3)
		return p3.responseBody
	end
})

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.RoactRodux.useSelector
local createOrGetProfileShareUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/createOrGetProfileShareUrl")

return function()
	return useSelector(function(p2)
		return createOrGetProfileShareUrl.getStatus(p2)
	end)
end

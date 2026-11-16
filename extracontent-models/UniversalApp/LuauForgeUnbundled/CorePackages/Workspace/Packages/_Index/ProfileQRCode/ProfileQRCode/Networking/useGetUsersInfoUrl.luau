local configureRoduxUsers = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/configureRoduxUsers")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.RoactRodux.useDispatch

return function()
	local v5 = useDispatch()

	return function(p2)
		return v5(configureRoduxUsers.GetUserV2FromUserId.API(p2))
	end
end

local createOrGetProfileShareUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/createOrGetProfileShareUrl")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.RoactRodux.useDispatch

return function()
	local v5 = useDispatch()

	return function()
		return v5(createOrGetProfileShareUrl.API()):catch(function() end)
	end
end

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.RoactRodux.useDispatch

local refreshQrSession = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/refreshQrSession")

return function()
	local v5 = useDispatch()

	return function()
		return v5(refreshQrSession.API()):catch(function() end)
	end
end

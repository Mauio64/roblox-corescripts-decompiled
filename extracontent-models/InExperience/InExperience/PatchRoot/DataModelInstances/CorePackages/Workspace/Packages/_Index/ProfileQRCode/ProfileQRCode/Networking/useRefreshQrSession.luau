local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local refreshQrSession = require(ProfileQRCode.Networking.refreshQrSession)

return function()
	local v = useDispatch()

	return function()
		return v(refreshQrSession.API()):catch(function() end)
	end
end

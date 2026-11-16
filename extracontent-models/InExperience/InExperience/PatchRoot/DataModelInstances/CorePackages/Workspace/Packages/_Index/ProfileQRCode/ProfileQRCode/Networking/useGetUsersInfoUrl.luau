local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local configureRoduxUsers = require(ProfileQRCode.Networking.configureRoduxUsers)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function()
	local v = useDispatch()

	return function(p: string)
		return v(configureRoduxUsers.GetUserV2FromUserId.API(p))
	end
end

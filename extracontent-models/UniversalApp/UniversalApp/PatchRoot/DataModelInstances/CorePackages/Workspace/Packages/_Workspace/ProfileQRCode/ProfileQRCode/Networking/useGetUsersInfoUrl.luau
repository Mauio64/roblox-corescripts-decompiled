local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local configureRoduxUsers = require(ProfileQRCode.Networking.configureRoduxUsers)
local useDispatch = require(ProfileQRCodeParent.RoactUtils).Hooks.RoactRodux.useDispatch

return function() -- line: 7
	-- upvalues: useDispatch (copy), configureRoduxUsers (copy)
	local v5 = useDispatch()

	return function(s1: string) -- line: 10
		-- upvalues: v5 (copy), configureRoduxUsers (copy)
		return v5(configureRoduxUsers.GetUserV2FromUserId.API(s1))
	end
end

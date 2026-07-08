local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local RoactUtils = require(ProfileQRCodeParent.RoactUtils)
local configureRoduxFriends = require(ProfileQRCode.Networking.configureRoduxFriends)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function() -- line: 10
	-- upvalues: useDispatch (copy), configureRoduxFriends (copy)
	local v6 = useDispatch()

	return function(s1: string, s2: string) -- line: 13
		-- upvalues: v6 (copy), configureRoduxFriends (copy)
		return v6(configureRoduxFriends.AcceptFriendRequestFromUserId.API({
			currentUserId = s1,
			targetUserId = s2
		}))
	end
end

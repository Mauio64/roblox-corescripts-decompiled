local FriendRequestNicknames = script:FindFirstAncestor("FriendRequestNicknames")
local FriendRequestNicknamesParent = FriendRequestNicknames.Parent
local useUserExperiment = require(FriendRequestNicknamesParent.RoactAppExperiment).useUserExperiment
local FStringSocialFriendsLayer = require(FriendRequestNicknames.Flags.FStringSocialFriendsLayer)
local FStringCanSendNicknames = require(FriendRequestNicknames.Flags.FStringCanSendNicknames)
local FFlagFriendRequestNicknames = require(FriendRequestNicknamesParent.SharedFlags).FFlagFriendRequestNicknames

local function v7(p1) -- line: 13
	-- upvalues: FFlagFriendRequestNicknames (copy), FStringSocialFriendsLayer (copy), FStringCanSendNicknames (copy)
	if not FFlagFriendRequestNicknames then
		return false
	end

	return (p1[FStringSocialFriendsLayer] or {})[FStringCanSendNicknames] == "True"
end

return {
	FFlagFriendRequestNicknames = FFlagFriendRequestNicknames,
	useFriendRequestNicknames = function() -- line: 24
		-- upvalues: FFlagFriendRequestNicknames (copy), useUserExperiment (copy), FStringSocialFriendsLayer (copy), v7 (copy)
		if not FFlagFriendRequestNicknames then
			return false
		end

		return (useUserExperiment({ FStringSocialFriendsLayer }, v7))
	end
}

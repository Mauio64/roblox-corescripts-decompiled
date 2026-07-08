local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)

return function(p1) -- line: 5
	-- upvalues: Enums (copy)
	if not p1 then
		return Enums.FriendStatus.Unknown
	end

	if p1 == Enums.ProfileActions.PendingFriendRequest then
		return Enums.FriendStatus.RequestSent
	end

	if p1 == Enums.ProfileActions.AcceptFriendRequest then
		return Enums.FriendStatus.RequestReceived
	end

	if p1 == Enums.ProfileActions.Chat or p1 == Enums.ProfileActions.JoinExperience then
		return Enums.FriendStatus.Friends
	end

	if p1 == Enums.ProfileActions.EditProfile then
		return Enums.FriendStatus.Self
	end

	if p1 == Enums.ProfileActions.Unfriend then
		return Enums.FriendStatus.Ineligible
	end

	return Enums.FriendStatus.NotFriends
end

local FriendsOwnedUserList = require(script.FriendsOwnedUserList)
local SocialProofVerticalUserListSheet = require(script.SocialProofVerticalUserListSheet)
local parent = script:FindFirstAncestor("SocialProof").Parent

local SharedFlags = require(parent.SharedFlags)

if not SharedFlags.FFlagEnableSocialProofVerticalUserListSheet then
	SocialProofVerticalUserListSheet = nil
end

return {
	FriendsOwnedUserList = FriendsOwnedUserList,
	SocialProofVerticalUserListSheet = SocialProofVerticalUserListSheet
}

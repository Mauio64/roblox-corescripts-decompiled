local FriendsOwnedUserList = require(script.FriendsOwnedUserList)
local SocialProofVerticalUserListSheet = require(script.SocialProofVerticalUserListSheet)
local Parent = script:FindFirstAncestor("SocialProof").Parent
local FFlagEnableSocialProofVerticalUserListSheet = require(Parent.SharedFlags).FFlagEnableSocialProofVerticalUserListSheet

return {
	FriendsOwnedUserList = FriendsOwnedUserList,
	SocialProofVerticalUserListSheet = if not FFlagEnableSocialProofVerticalUserListSheet then nil else SocialProofVerticalUserListSheet
}

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

local function ContextualInformation(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), Enums (copy), TextKeys (copy), Images (copy), React (copy), PlayerContext (copy)
	local v12 = useLocalization({
		[Enums.ContextualTypes.AccountDeleted] = TextKeys.AccountDeleted,
		[Enums.ContextualTypes.IsYourself] = TextKeys.ThisIsYou,
		[Enums.ContextualTypes.PreviousUsername] = TextKeys.Previously,
		[Enums.ContextualTypes.YouAreFollowing] = TextKeys.YouAreFollowing,
		[Enums.ContextualTypes.FollowsYou] = TextKeys.FollowsYou,
		[Enums.ContextualTypes.PlayedTogether] = TextKeys.PlayedTogether,
		[Enums.ContextualTypes.OffNetworkFriendRequest] = TextKeys.FriendInvite,
		[Enums.ContextualTypes.SentFromQrCode] = TextKeys.FromQRCode,
		[Enums.ContextualTypes.SentFromExperience] = {
			TextKeys.SentFromWithContext,
			gameName = t1.experienceName
		}
	})
	local contextualType = t1.contextualType
	local v14 = v12[contextualType]
	local v15 = nil

	if contextualType == Enums.ContextualTypes.YouAreFollowing or contextualType == Enums.ContextualTypes.FollowsYou then
		v15 = Images["icons/status/player/following"]
	end

	return React.createElement(PlayerContext, {
		text = t1.textOverride or v14,
		icon = t1.iconOverride or v15
	})
end

return ContextualInformation

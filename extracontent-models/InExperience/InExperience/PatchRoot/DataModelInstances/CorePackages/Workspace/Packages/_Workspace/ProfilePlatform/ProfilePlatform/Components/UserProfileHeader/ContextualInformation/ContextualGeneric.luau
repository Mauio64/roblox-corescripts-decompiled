local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local PlayerContext = UIBlox.App.Indicator.PlayerContext

local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

local function ContextualInformation(props)
	local v = useLocalization({
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
			gameName = props.experienceName
		}
	})

	local contextualType = props.contextualType
	local v2 = v[contextualType]
	local v3

	if
		contextualType == Enums.ContextualTypes.YouAreFollowing
		or contextualType == Enums.ContextualTypes.FollowsYou
	then
		v3 = Images["icons/status/player/following"]
	end

	return React.createElement(PlayerContext, {
		text = props.textOverride or v2,
		icon = props.iconOverride or v3
	})
end

return ContextualInformation

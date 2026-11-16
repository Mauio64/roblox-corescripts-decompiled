local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local images = UIBlox.App.ImageSet.Images
local playerContext = UIBlox.App.Indicator.PlayerContext

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local function ContextualInformation(props)
	local v7 = useLocalization({
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
	local v8 = v7[contextualType]

	local v9 = if contextualType == Enums.ContextualTypes.YouAreFollowing or contextualType == Enums.ContextualTypes.FollowsYou then images["icons/status/player/following"] else nil

	return React.createElement(playerContext, {
		text = props.textOverride or v8,
		icon = props.iconOverride or v9
	})
end

return ContextualInformation

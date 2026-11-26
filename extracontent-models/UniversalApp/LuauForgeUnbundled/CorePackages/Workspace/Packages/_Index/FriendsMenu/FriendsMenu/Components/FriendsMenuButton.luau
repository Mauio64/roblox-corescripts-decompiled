local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation").Utility.normalizeFontFace
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/RoactUtils")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Signals")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SignalsReact").useSignalState

local fFlagUseSignalsForGameInvitesStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if fFlagUseSignalsForGameInvitesStatus then
	getGameInvitesStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").LocalizationHelper
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants")
local FriendsListContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContext")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useStyle = UIBlox.Core.Style.useStyle
local inviteStatus = Constants.InviteStatus
local getLocalizedStrings = localizationHelper.getLocalizedStrings

local v5 = {
	inviteFriend = "Feature.SettingsHub.Action.InviteFriend",
	[inviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[inviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[inviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}

return function(props)
	local v6

	if fFlagUseSignalsForGameInvitesStatus then
		local id = props.friend and props.friend.id
		v6 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2)
				return getGameInvitesStatusStore(false).getGameInvitesStatus(p2)[id]
			end)
		end, { id })))
	else
		v6 = useSelector(function(p2)
			local friend = props.friend
			assert(friend, "friend should be non-nil. Silence type checker.")

			return p2.GameInvitesStatus[friend.id]
		end)
	end

	local localizedStrings = getLocalizedStrings(v5)

	local v7 = React.useContext(FriendsListContext)

	local v8 = useStyle()
	local theme = v8 and v8.Theme
	local font = v8 and v8.Font

	local isFetchingFriends = v7.isFetchingFriends
	local v9 = font.BaseSize * font.CaptionHeader.RelativeSize

	local v10 = not (v6 and v6 ~= inviteStatus.Failed) and not props.isFullRowActivatable

	if v10 then
		return React.createElement(button, {
			buttonType = buttonType.Secondary,
			isDisabled = isFetchingFriends,
			isLoading = false,
			onActivated = props.onInvite,
			standardSize = standardButtonSize.XSmall,
			fitContent = true,
			anchorPoint = props.anchorPoint,
			position = props.position,
			text = localizedStrings.inviteFriend,
			layoutOrder = props.layoutOrder
		})
	end

	local v11 = localizedStrings[v6] or localizedStrings.inviteFriend

	return React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Text = v11,
		TextSize = v9,
		TextWrapped = true,
		Size = props.size,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		TextColor3 = theme.TextDefault.Color,
		FontFace = normalizeFontFace(v8.Tokens.Typography.CaptionLarge.Font),
		LayoutOrder = props.layoutOrder
	})
end

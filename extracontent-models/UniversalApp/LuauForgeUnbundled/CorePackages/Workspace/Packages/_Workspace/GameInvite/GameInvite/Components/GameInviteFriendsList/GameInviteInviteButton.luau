local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation")
local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RoactUtils")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Signals")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SignalsReact").useSignalState
local FFlagGameInviteInExpJoinCta = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpJoinCta")
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")

local fFlagUseSignalsForGameInvitesStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagUseSignalsForGameInvitesStatus

local getGameInvitesStatusStore = if fFlagUseSignalsForGameInvitesStatus then NotificationsCommon.GetGameInvitesStatusStore else nil

local getLocalizedStrings = NotificationsCommon.LocalizationHelper.getLocalizedStrings
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local inviteStatus = FriendsMenu.InviteStatus

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local fillBehavior = Foundation.Enums.FillBehavior

local v5 = {
	MinSize = Vector2.new(GameInviteConstants.Layout.JoinCtaMinWidth, 0),
	MaxSize = Vector2.new(GameInviteConstants.Layout.JoinCtaMaxWidth, 1e999)
}

local v6 = {
	inviteFriend = "Feature.SettingsHub.Action.InviteFriend",
	[inviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[inviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[inviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}

local function GameInviteInviteButton(props)
	local userId = props.userId
	local rowNumber = props.rowNumber
	local isFetchingFriends = React.useContext(FriendsMenu.FriendsListContext).isFetchingFriends
	local inviteSingleFriend = React.useContext(FriendsMenu.InviteFriendContext).inviteSingleFriend
	local v7 = React.useCallback(function()
		inviteSingleFriend(userId, rowNumber)
	end, { inviteSingleFriend, userId, rowNumber })
	local v8

	if fFlagUseSignalsForGameInvitesStatus then
		v8 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				return getGameInvitesStatusStore(false).getGameInvitesStatus(p2)[userId]
			end)
		end, { userId })
	end

	local v9

	if fFlagUseSignalsForGameInvitesStatus then
		v9 = useSignalState(v8)
	else
		v9 = useSelector(function(p2)
			return p2.GameInvitesStatus[userId]
		end)
	end

	local localizedStrings = getLocalizedStrings(v6)

	if FFlagGameInviteInExpJoinCta then
		local v10 = if v9 == nil or v9 == inviteStatus.Failed then React.createElement(button, {
			text = localizedStrings.inviteFriend,
			variant = buttonVariant.Standard,
			size = inputSize.Small,
			fillBehavior = fillBehavior.Fill,
			isDisabled = isFetchingFriends,
			onActivated = v7
		}) else React.createElement(text, {
			tag = "fill auto-xy text-caption-large text-wrap text-align-x-center content-default",
			Text = localizedStrings[v9] or localizedStrings.inviteFriend
		})

		return React.createElement(
			view,
			{
				tag = "row align-x-center align-y-center auto-xy",
				sizeConstraint = v5,
				LayoutOrder = props.layoutOrder
			},
			{ Content = v10 }
		)
	elseif v9 == nil or v9 == inviteStatus.Failed then
		return React.createElement(button, {
			text = localizedStrings.inviteFriend,
			variant = buttonVariant.Standard,
			size = inputSize.Small,
			isDisabled = isFetchingFriends,
			onActivated = v7,
			LayoutOrder = props.layoutOrder
		})
	else
		return React.createElement(text, {
			tag = "auto-xy text-caption-large content-default",
			Text = localizedStrings[v9] or localizedStrings.inviteFriend,
			LayoutOrder = props.layoutOrder
		})
	end
end

return GameInviteInviteButton

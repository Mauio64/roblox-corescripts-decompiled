local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FriendsMenu = require(parent.FriendsMenu)
local NotificationsCommon = require(parent.NotificationsCommon)
local RoactUtils = require(parent.RoactUtils)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local FFlagGameInviteInExpJoinCta = require(GameInvite.Flags.FFlagGameInviteInExpJoinCta)
local GameInviteConstants = require(GameInvite.GameInviteConstants)

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if FFlagUseSignalsForGameInvitesStatus then
	getGameInvitesStatusStore = NotificationsCommon.GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

local getLocalizedStrings = NotificationsCommon.LocalizationHelper.getLocalizedStrings
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local InviteStatus = FriendsMenu.InviteStatus

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FillBehavior = Foundation.Enums.FillBehavior

local sizeConstraint = {
	MinSize = Vector2.new(GameInviteConstants.Layout.JoinCtaMinWidth, 0),
	MaxSize = Vector2.new(GameInviteConstants.Layout.JoinCtaMaxWidth, 1e999)
}

local v = {
	inviteFriend = "Feature.SettingsHub.Action.InviteFriend",
	[InviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[InviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[InviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}

local function GameInviteInviteButton(props)
	local userId = props.userId
	local rowNumber = props.rowNumber
	local isFetchingFriends = React.useContext(FriendsMenu.FriendsListContext).isFetchingFriends
	local inviteSingleFriend = React.useContext(FriendsMenu.InviteFriendContext).inviteSingleFriend
	local onActivated = React.useCallback(function()
		inviteSingleFriend(userId, rowNumber)
	end, { inviteSingleFriend, userId, rowNumber })
	local v2

	if FFlagUseSignalsForGameInvitesStatus then
		v2 = React.useMemo(function()
			return Signals.createComputed(function(p)
				return getGameInvitesStatusStore(false).getGameInvitesStatus(p)[userId]
			end)
		end, { userId })
	end

	local v3

	if FFlagUseSignalsForGameInvitesStatus then
		v3 = useSignalState(v2)
	else
		v3 = useSelector(function(p)
			return p.GameInvitesStatus[userId]
		end)
	end

	local localizedStrings = getLocalizedStrings(v)

	if FFlagGameInviteInExpJoinCta then
		local content

		if v3 == nil or v3 == InviteStatus.Failed then
			content = React.createElement(Button, {
				text = localizedStrings.inviteFriend,
				variant = ButtonVariant.Standard,
				size = InputSize.Small,
				fillBehavior = FillBehavior.Fill,
				isDisabled = isFetchingFriends,
				onActivated = onActivated
			})
		else
			content = React.createElement(Text, {
				tag = "fill auto-xy text-caption-large text-wrap text-align-x-center content-default",
				Text = localizedStrings[v3] or localizedStrings.inviteFriend
			})
		end

		return React.createElement(
			View,
			{
				tag = "row align-x-center align-y-center auto-xy",
				sizeConstraint = sizeConstraint,
				LayoutOrder = props.layoutOrder
			},
			{ Content = content }
		)
	elseif v3 == nil or v3 == InviteStatus.Failed then
		return React.createElement(Button, {
			text = localizedStrings.inviteFriend,
			variant = ButtonVariant.Standard,
			size = InputSize.Small,
			isDisabled = isFetchingFriends,
			onActivated = onActivated,
			LayoutOrder = props.layoutOrder
		})
	else
		return React.createElement(Text, {
			tag = "auto-xy text-caption-large content-default",
			Text = localizedStrings[v3] or localizedStrings.inviteFriend,
			LayoutOrder = props.layoutOrder
		})
	end
end

return GameInviteInviteButton

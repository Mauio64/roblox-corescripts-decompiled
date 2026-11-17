local Players = game:GetService("Players")

local parent = script.Parent.Parent
local actions = parent.State.Actions
local parent2 = parent.Parent

local FriendsMenu = require(parent2.FriendsMenu)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local InviteFriendContext = FriendsMenu.InviteFriendContext
local InviteStatus = FriendsMenu.InviteStatus

local GameInviteDependencies = require(parent.GameInviteDependencies)
local GameInviteAnalyticsManager = require(parent.analytics.GameInviteAnalyticsManager)
local FFlagGameInviteSpaceSends = require(parent.Flags.FFlagGameInviteSpaceSends)
local spacedSender = require(parent.utils.spacedSender)

local NotificationsCommon = require(parent2.NotificationsCommon)
local Throttle = NotificationsCommon.Throttle

local ReceivedUserInviteStatus = require(actions.ReceivedUserInviteStatus)

local networkImpl = GameInviteDependencies.networkImpl
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local PostSendExperienceInvite = require(parent.Requests.PostSendExperienceInvite)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent2.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent2.SharedFlags)
local GetFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if FFlagUseSignalsForGameInvitesStatus then
	local NotificationsCommon2 = require(parent2.NotificationsCommon)
	getGameInvitesStatusStore = NotificationsCommon2.GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

return function(props)
	local v = useDispatch()

	local ref = React.useRef(0)
	local v2

	if FFlagUseSignalsForGameInvitesStatus then
		v2 = useSignalState(getGameInvitesStatusStore(false).getGameInvitesStatus)
	else
		v2 = useSelector(function(p)
			return p.GameInvitesStatus
		end)
	end

	local inviteSingleFriend = Throttle(function(recipient_user_id: string, recipient_row_number: number)
		ref.current = math.max(recipient_row_number, ref.current)

		if
			GetFFlagFriendsMenuDummyLoadingFriendsFix()
			and (not recipient_user_id or recipient_user_id == "" or not tonumber(recipient_user_id) or tonumber(recipient_user_id) == 0)
		then
			return
		end

		if
			v2[recipient_user_id]
			and (v2[recipient_user_id] ~= InviteStatus.Failed or v2[recipient_user_id] == InviteStatus.Pending)
		then
			return
		end

		local v3

		if props.isCoreScript then
			v3 = tostring(game.PlaceId)
		else
			v3 = props.rootPlaceId or tostring(game.PlaceId)
		end

		if v3 == "0" then
			warn("Game Invite failed to send. Cannot send invite to unpublished Place.")

			if FFlagUseSignalsForGameInvitesStatus then
				getGameInvitesStatusStore(false).receivedUserInviteStatus(recipient_user_id, InviteStatus.Failed)
			else
				v(ReceivedUserInviteStatus(recipient_user_id, InviteStatus.Failed))
			end
		else
			local is_launch_data_provided

			if props.launchData == nil then
				is_launch_data_provided = false
			else
				is_launch_data_provided = props.launchData ~= ""
			end

			local is_prompt_customized

			if props.promptMessage == nil then
				is_prompt_customized = false
			else
				is_prompt_customized = props.promptMessage ~= ""
			end

			local is_invite_message_id_provided

			if props.inviteMessageId == nil then
				is_invite_message_id_provided = false
			else
				is_invite_message_id_provided = props.inviteMessageId ~= ""
			end

			GameInviteAnalyticsManager:sendGameInviteModalEvent(props.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.InviteTriggered,
				is_launch_data_provided = is_launch_data_provided,
				is_prompt_customized = is_prompt_customized,
				is_invite_message_id_provided = is_invite_message_id_provided,
				recipient_user_id = recipient_user_id,
				recipient_row_number = recipient_row_number
			})

			if FFlagUseSignalsForGameInvitesStatus then
				getGameInvitesStatusStore(false).receivedUserInviteStatus(recipient_user_id, InviteStatus.Pending)
			else
				v(ReceivedUserInviteStatus(recipient_user_id, InviteStatus.Pending))
			end

			local function fn()
				return PostSendExperienceInvite(
					networkImpl,
					recipient_user_id,
					v3,
					props.trigger,
					props.inviteMessageId,
					props.launchData
				)
			end

			local v4

			if FFlagGameInviteSpaceSends then
				v4 = spacedSender.send(fn)
			else
				v4 = PostSendExperienceInvite(
					networkImpl,
					recipient_user_id,
					v3,
					props.trigger,
					props.inviteMessageId,
					props.launchData
				)
			end

			v4:andThen(function(p)
				GameInviteAnalyticsManager:onActivatedInviteSent(
					Players.LocalPlayer.UserId,
					p.conversationId,
					{ recipient_user_id },
					props.rootPlaceId,
					props.universeId
				)

				if FFlagUseSignalsForGameInvitesStatus then
					getGameInvitesStatusStore(false).receivedUserInviteStatus(recipient_user_id, InviteStatus.Success)
				else
					v(ReceivedUserInviteStatus(recipient_user_id, InviteStatus.Success))
				end
			end, function()
				GameInviteAnalyticsManager:sendGameInviteModalEvent(props.trigger, {
					action_type = GameInviteAnalyticsManager.ActionType.InviteFailure,
					is_launch_data_provided = is_launch_data_provided,
					is_prompt_customized = is_prompt_customized,
					is_invite_message_id_provided = is_invite_message_id_provided,
					recipient_user_id = recipient_user_id,
					recipient_row_number = recipient_row_number
				})

				if FFlagUseSignalsForGameInvitesStatus then
					getGameInvitesStatusStore(false).receivedUserInviteStatus(recipient_user_id, InviteStatus.Failed)
				else
					v(ReceivedUserInviteStatus(recipient_user_id, InviteStatus.Failed))
				end
			end)
		end
	end)
	return React.createElement(InviteFriendContext.Provider, {
		value = {
			inviteSingleFriend = inviteSingleFriend,
			getMaxRecipientRowNum = function()
				return ref.current
			end
		}
	}, props.children)
end

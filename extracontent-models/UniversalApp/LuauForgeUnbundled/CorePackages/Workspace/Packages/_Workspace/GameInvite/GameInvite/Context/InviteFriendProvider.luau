local Players = game:GetService("Players")

local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RoactUtils")

local inviteFriendContext = FriendsMenu.InviteFriendContext
local inviteStatus = FriendsMenu.InviteStatus

local GameInviteDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteDependencies")
local GameInviteAnalyticsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalyticsManager")
local FFlagGameInviteSpaceSends = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteSpaceSends")
local spacedSender = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/spacedSender")

local throttle = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").Throttle

local ReceivedUserInviteStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Actions/ReceivedUserInviteStatus")

local networkImpl = GameInviteDependencies.networkImpl
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local PostSendExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Requests/PostSendExperienceInvite")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SignalsReact").useSignalState
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags")
local getFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix
local fFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if fFlagUseSignalsForGameInvitesStatus then
	getGameInvitesStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

return function(props)
	local v5 = useDispatch()

	local ref = React.useRef(0)
	local v6

	if fFlagUseSignalsForGameInvitesStatus then
		v6 = useSignalState(getGameInvitesStatusStore(false).getGameInvitesStatus)
	else
		v6 = useSelector(function(p2)
			return p2.GameInvitesStatus
		end)
	end

	local v7 = throttle(function(p2, p3)
		ref.current = math.max(p3, ref.current)

		if
			getFFlagFriendsMenuDummyLoadingFriendsFix()
			and (not p2 or p2 == "" or not tonumber(p2) or tonumber(p2) == 0)
		then
			return
		end

		if v6[p2] and (v6[p2] ~= inviteStatus.Failed or v6[p2] == inviteStatus.Pending) then
			return
		end

		local v8

		if props.isCoreScript then
			v8 = tostring(game.PlaceId)
		else
			v8 = props.rootPlaceId or tostring(game.PlaceId)
		end

		if v8 == "0" then
			warn("Game Invite failed to send. Cannot send invite to unpublished Place.")

			if fFlagUseSignalsForGameInvitesStatus then
				getGameInvitesStatusStore(false).receivedUserInviteStatus(p2, inviteStatus.Failed)
			else
				v5(ReceivedUserInviteStatus(p2, inviteStatus.Failed))
			end
		else
			local v9 = not (props.launchData == nil) and props.launchData ~= ""
			local v10 = not (props.promptMessage == nil) and props.promptMessage ~= ""
			local v11 = not (props.inviteMessageId == nil) and props.inviteMessageId ~= ""

			GameInviteAnalyticsManager:sendGameInviteModalEvent(props.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.InviteTriggered,
				is_launch_data_provided = v9,
				is_prompt_customized = v10,
				is_invite_message_id_provided = v11,
				recipient_user_id = p2,
				recipient_row_number = p3
			})

			if fFlagUseSignalsForGameInvitesStatus then
				getGameInvitesStatusStore(false).receivedUserInviteStatus(p2, inviteStatus.Pending)
			else
				v5(ReceivedUserInviteStatus(p2, inviteStatus.Pending))
			end

			local function fn()
				return PostSendExperienceInvite(networkImpl, p2, v8, props.trigger, props.inviteMessageId, props.launchData)
			end

			local v12

			if FFlagGameInviteSpaceSends then
				v12 = spacedSender.send(fn)
			else
				v12 = PostSendExperienceInvite(networkImpl, p2, v8, props.trigger, props.inviteMessageId, props.launchData)
			end

			v12:andThen(function(p4)
				GameInviteAnalyticsManager:onActivatedInviteSent(
					Players.LocalPlayer.UserId,
					p4.conversationId,
					{ p2 },
					props.rootPlaceId,
					props.universeId
				)

				if fFlagUseSignalsForGameInvitesStatus then
					getGameInvitesStatusStore(false).receivedUserInviteStatus(p2, inviteStatus.Success)
				else
					v5(ReceivedUserInviteStatus(p2, inviteStatus.Success))
				end
			end, function()
				GameInviteAnalyticsManager:sendGameInviteModalEvent(props.trigger, {
					action_type = GameInviteAnalyticsManager.ActionType.InviteFailure,
					is_launch_data_provided = v9,
					is_prompt_customized = v10,
					is_invite_message_id_provided = v11,
					recipient_user_id = p2,
					recipient_row_number = p3
				})

				if fFlagUseSignalsForGameInvitesStatus then
					getGameInvitesStatusStore(false).receivedUserInviteStatus(p2, inviteStatus.Failed)
				else
					v5(ReceivedUserInviteStatus(p2, inviteStatus.Failed))
				end
			end)
		end
	end)
	return React.createElement(inviteFriendContext.Provider, {
		value = {
			inviteSingleFriend = v7,
			getMaxRecipientRowNum = function()
				return ref.current
			end
		}
	}, props.children)
end

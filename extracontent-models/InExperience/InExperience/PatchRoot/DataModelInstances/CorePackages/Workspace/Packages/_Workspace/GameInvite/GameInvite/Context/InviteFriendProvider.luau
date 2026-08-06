local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Actions = ParentParent.State.Actions
local ParentParentParent = ParentParent.Parent
local FriendsMenu = require(ParentParentParent.FriendsMenu)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local InviteFriendContext = FriendsMenu.InviteFriendContext
local InviteStatus = FriendsMenu.InviteStatus
local GameInviteDependencies = require(ParentParent.GameInviteDependencies)
local GameInviteAnalyticsManager = require(ParentParent.analytics.GameInviteAnalyticsManager)
local Throttle = require(ParentParentParent.NotificationsCommon).Throttle
local ReceivedUserInviteStatus = require(Actions.ReceivedUserInviteStatus)
local networkImpl = GameInviteDependencies.networkImpl
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local PostSendExperienceInvite = require(ParentParent.Requests.PostSendExperienceInvite)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = require(ParentParentParent.SignalsReact).useSignalState
local SharedFlags = require(ParentParentParent.SharedFlags)
local GetFFlagFriendsMenuDummyLoadingFriendsFix = SharedFlags.GetFFlagFriendsMenuDummyLoadingFriendsFix
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local v22 = if not FFlagUseSignalsForGameInvitesStatus then nil else require(ParentParentParent.NotificationsCommon).GetGameInvitesStatusStore

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: useDispatch (copy), React (copy), FFlagUseSignalsForGameInvitesStatus (copy), useSignalState (copy), v22 (copy), useSelector (copy), GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), InviteStatus (copy), ReceivedUserInviteStatus (copy), GameInviteAnalyticsManager (copy), PostSendExperienceInvite (copy), networkImpl (copy), Players (copy), Throttle (copy), InviteFriendContext (copy)
	local v24 = useDispatch()
	local v25 = React.useRef(0)
	local v26 = if not FFlagUseSignalsForGameInvitesStatus then useSelector(function(p1) -- line: 53
		return p1.GameInvitesStatus
	end) else useSignalState(v22(false).getGameInvitesStatus)
	local v27 = Throttle(function(s1: string, n1: number) -- line: 61
		-- upvalues: v25 (copy), GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), v26 (copy), InviteStatus (copy), t1 (copy), FFlagUseSignalsForGameInvitesStatus (copy), v22 (copy), v24 (copy), ReceivedUserInviteStatus (copy), GameInviteAnalyticsManager (copy), PostSendExperienceInvite (copy), networkImpl (copy), Players (copy)
		v25.current = math.max(n1, v25.current)

		if GetFFlagFriendsMenuDummyLoadingFriendsFix() and (not s1 or s1 == "" or not tonumber(s1) or tonumber(s1) == 0) then
			return
		end

		if v26[s1] and (v26[s1] ~= InviteStatus.Failed or v26[s1] == InviteStatus.Pending) then
			return
		end

		local v31 = if not t1.isCoreScript then t1.rootPlaceId or tostring(game.PlaceId) else tostring(game.PlaceId)

		if v31 == "0" then
			warn("Game Invite failed to send. Cannot send invite to unpublished Place.")

			if FFlagUseSignalsForGameInvitesStatus then
				v22(false).receivedUserInviteStatus(s1, InviteStatus.Failed)

				return
			end

			v24(ReceivedUserInviteStatus(s1, InviteStatus.Failed))

			return
		end

		local v32 = t1.launchData ~= nil and t1.launchData ~= ""
		local v33 = t1.promptMessage ~= nil and t1.promptMessage ~= ""
		local v34 = t1.inviteMessageId ~= nil and t1.inviteMessageId ~= ""

		GameInviteAnalyticsManager:sendGameInviteModalEvent(t1.trigger, {
			action_type = GameInviteAnalyticsManager.ActionType.InviteTriggered,
			is_launch_data_provided = v32,
			is_prompt_customized = v33,
			is_invite_message_id_provided = v34,
			recipient_user_id = s1,
			recipient_row_number = n1
		})

		if FFlagUseSignalsForGameInvitesStatus then
			v22(false).receivedUserInviteStatus(s1, InviteStatus.Pending)
		else
			v24(ReceivedUserInviteStatus(s1, InviteStatus.Pending))
		end

		PostSendExperienceInvite(networkImpl, s1, v31, t1.trigger, t1.inviteMessageId, t1.launchData):andThen(function(p2) -- line: 116
			-- upvalues: Players (copy), s1 (copy), GameInviteAnalyticsManager (copy), t1 (copy), FFlagUseSignalsForGameInvitesStatus (copy), v22 (copy), InviteStatus (copy), v24 (copy), ReceivedUserInviteStatus (copy)
			local LocalPlayer = Players.LocalPlayer
			local t2 = { s1 }

			GameInviteAnalyticsManager:onActivatedInviteSent(LocalPlayer.UserId, p2.conversationId, t2, t1.rootPlaceId, t1.universeId)

			if FFlagUseSignalsForGameInvitesStatus then
				v22(false).receivedUserInviteStatus(s1, InviteStatus.Success)

				return
			end

			v24(ReceivedUserInviteStatus(s1, InviteStatus.Success))
		end, function() -- line: 132
			-- upvalues: GameInviteAnalyticsManager (copy), t1 (copy), v32 (copy), v33 (copy), v34 (copy), s1 (copy), n1 (copy), FFlagUseSignalsForGameInvitesStatus (copy), v22 (copy), InviteStatus (copy), v24 (copy), ReceivedUserInviteStatus (copy)
			GameInviteAnalyticsManager:sendGameInviteModalEvent(t1.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.InviteFailure,
				is_launch_data_provided = v32,
				is_prompt_customized = v33,
				is_invite_message_id_provided = v34,
				recipient_user_id = s1,
				recipient_row_number = n1
			})

			if FFlagUseSignalsForGameInvitesStatus then
				v22(false).receivedUserInviteStatus(s1, InviteStatus.Failed)

				return
			end

			v24(ReceivedUserInviteStatus(s1, InviteStatus.Failed))
		end)
	end)

	return React.createElement(InviteFriendContext.Provider, {
		value = {
			inviteSingleFriend = v27,
			getMaxRecipientRowNum = function() -- line: 57
				-- upvalues: v25 (copy)
				return v25.current
			end
		}
	}, t1.children)
end

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
local GetFFlagFriendsMenuDummyLoadingFriendsFix = require(ParentParentParent.SharedFlags).GetFFlagFriendsMenuDummyLoadingFriendsFix

return function(t1: {[any]: any}) -- line: 41
	-- upvalues: useDispatch (copy), React (copy), useSelector (copy), GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), InviteStatus (copy), ReceivedUserInviteStatus (copy), GameInviteAnalyticsManager (copy), PostSendExperienceInvite (copy), networkImpl (copy), Players (copy), Throttle (copy), InviteFriendContext (copy)
	local v20 = useDispatch()
	local v21 = React.useRef(0)
	local v22 = useSelector(function(p1) -- line: 46
		return p1.GameInvitesStatus
	end)
	local v23 = Throttle(function(s1: string, n1: number) -- line: 54
		-- upvalues: v21 (copy), GetFFlagFriendsMenuDummyLoadingFriendsFix (copy), v22 (copy), InviteStatus (copy), t1 (copy), v20 (copy), ReceivedUserInviteStatus (copy), GameInviteAnalyticsManager (copy), PostSendExperienceInvite (copy), networkImpl (copy), Players (copy)
		v21.current = math.max(n1, v21.current)

		if GetFFlagFriendsMenuDummyLoadingFriendsFix() and (not s1 or s1 == "" or not tonumber(s1) or tonumber(s1) == 0) then
			return
		end

		if v22[s1] and (v22[s1] ~= InviteStatus.Failed or v22[s1] == InviteStatus.Pending) then
			return
		end

		local v27 = if not t1.isCoreScript then t1.rootPlaceId or tostring(game.PlaceId) else tostring(game.PlaceId)

		if v27 == "0" then
			warn("Game Invite failed to send. Cannot send invite to unpublished Place.")
			v20(ReceivedUserInviteStatus(s1, InviteStatus.Failed))

			return
		end

		local v28 = t1.launchData ~= nil and t1.launchData ~= ""
		local v29 = t1.promptMessage ~= nil and t1.promptMessage ~= ""
		local v30 = t1.inviteMessageId ~= nil and t1.inviteMessageId ~= ""

		GameInviteAnalyticsManager:sendGameInviteModalEvent(t1.trigger, {
			action_type = GameInviteAnalyticsManager.ActionType.InviteTriggered,
			is_launch_data_provided = v28,
			is_prompt_customized = v29,
			is_invite_message_id_provided = v30,
			recipient_user_id = s1,
			recipient_row_number = n1
		})
		v20(ReceivedUserInviteStatus(s1, InviteStatus.Pending))
		PostSendExperienceInvite(networkImpl, s1, v27, t1.trigger, t1.inviteMessageId, t1.launchData):andThen(function(p2) -- line: 101
			-- upvalues: Players (copy), s1 (copy), GameInviteAnalyticsManager (copy), t1 (copy), v20 (copy), ReceivedUserInviteStatus (copy), InviteStatus (copy)
			local LocalPlayer = Players.LocalPlayer
			local t2 = { s1 }

			GameInviteAnalyticsManager:onActivatedInviteSent(LocalPlayer.UserId, p2.conversationId, t2, t1.rootPlaceId, t1.universeId)
			v20(ReceivedUserInviteStatus(s1, InviteStatus.Success))
		end, function() -- line: 113
			-- upvalues: GameInviteAnalyticsManager (copy), t1 (copy), v28 (copy), v29 (copy), v30 (copy), s1 (copy), n1 (copy), v20 (copy), ReceivedUserInviteStatus (copy), InviteStatus (copy)
			GameInviteAnalyticsManager:sendGameInviteModalEvent(t1.trigger, {
				action_type = GameInviteAnalyticsManager.ActionType.InviteFailure,
				is_launch_data_provided = v28,
				is_prompt_customized = v29,
				is_invite_message_id_provided = v30,
				recipient_user_id = s1,
				recipient_row_number = n1
			})
			v20(ReceivedUserInviteStatus(s1, InviteStatus.Failed))
		end)
	end)

	return React.createElement(InviteFriendContext.Provider, {
		value = {
			inviteSingleFriend = v23,
			getMaxRecipientRowNum = function() -- line: 50
				-- upvalues: v21 (copy)
				return v21.current
			end
		}
	}, t1.children)
end

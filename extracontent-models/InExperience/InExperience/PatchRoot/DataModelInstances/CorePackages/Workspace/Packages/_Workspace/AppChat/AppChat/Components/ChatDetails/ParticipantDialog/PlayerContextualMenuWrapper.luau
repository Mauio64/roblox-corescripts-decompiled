local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Component = require(AppChatParent.PlayerContextualMenu).Component
local React = require(AppChatParent.React)
local SharedFlags = require(AppChatParent.SharedFlags)
local SocialCommon = require(AppChatParent.SocialCommon)
local UIBlox = require(AppChatParent.UIBlox)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(AppChatParent.Responsive)
local memo = React.memo
local convertUserPresenceTypeToString = SocialCommon.Utils.convertUserPresenceTypeToString
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local useEffect = React.useEffect
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local v17 = require(AppChat.Logger):new(script.Name)
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)

require(AppChat.types)

local v19 = game:DefineFastFlag("AppChatDisablePCMExperienceCTAs", false)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagSkipBlockModal = SharedFlags.FFlagSkipBlockModal
local v22 = if not FFlagAppChatPresenceStoreMigration then nil else require(AppChatParent.FriendsCommon).Hooks.useGetPresenceByUserId

function PlayerContextualMenuWrapper(t1: {[any]: any}) -- line: 46
	-- upvalues: useDispatch (copy), Responsive (copy), FFlagAppChatPresenceStoreMigration (copy), v22 (copy), useSelector (copy), convertUserPresenceTypeToString (copy), useEffect (copy), NetworkingFriends (copy), useIsInExperience (copy), v19 (copy), React (copy), Interactable (copy), Component (copy), v17 (copy), FFlagSkipBlockModal (copy), Images (copy)
	local v24 = useDispatch()
	local v25 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v27

	if FFlagAppChatPresenceStoreMigration then
		local v26 = v22(t1.participantId)

		v27 = if not v26 then nil else {
			locationString = v26.lastLocation,
			locationPlaceId = if v26.placeId == "" then nil else v26.placeId,
			locationRootPlaceId = if v26.rootPlaceId == "" then nil else v26.rootPlaceId,
			locationUniverseId = if v26.universeId == "" then nil else v26.universeId,
			status = v26.userPresenceType
		}
	else
		local v28 = useSelector(function(p1) -- line: 66
			return p1.ChatAppReducer.Presence.byUserId
		end)[t1.participantId]

		v27 = if not v28 then nil else {
			locationString = v28.lastLocation,
			locationPlaceId = v28.placeId,
			locationRootPlaceId = v28.rootPlaceId,
			locationUniverseId = v28.universeId,
			status = convertUserPresenceTypeToString(v28.userPresenceType)
		}
	end

	local v29 = useSelector(function(p2) -- line: 82
		return p2.ChatAppReducer.Friends.friendshipStatus
	end)[t1.participantId]

	useEffect(function() -- line: 87
		-- upvalues: v24 (copy), NetworkingFriends (copy), t1 (copy)
		v24(NetworkingFriends.GetExtendedFriendshipStatus.API({
			targetUserId = t1.participantId
		}))
	end, { t1.participantId })

	local v30 = useIsInExperience()
	local v31 = not v19 and not v30

	return React.createElement(Interactable, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		onStateChanged = function() -- line: 101
		end,
		Selectable = false,
		[React.Event.Activated] = t1.onDismiss
	}, {
		PCM = React.createElement(Component, {
			enableExperienceCTAs = v31,
			subjectPresence = v27,
			subjectUserId = t1.participantId,
			robloxFriendshipStatus = v29,
			closeCentralOverlayThunk = function() -- line: 110
			end,
			onReportActivated = t1.openReportUser and function() -- line: 111
				-- upvalues: v17 (copy), t1 (copy)
				v17:info("User activated reportUser | userId: {}, conversationId: {}", t1.participantId, t1.conversationId)
				t1.openReportUser(t1.participantId, t1.conversationId)
			end,
			onBlockActivated = t1.openBlockingModal and function() -- line: 120
				-- upvalues: t1 (copy)
				t1.openBlockingModal(t1.participantId, t1.conversationId)
			end,
			skipBlockModal = FFlagSkipBlockModal,
			additionalButtons = if not t1.showRemoveUserButton then nil else {{
				icon = Images["icons/actions/leave"],
				text = t1.removeFromGroupText,
				onActivated = function() -- line: 131
					-- upvalues: t1 (copy)
					t1.openRemoveUserDialog(t1.participantId, t1.conversationId)
				end
			}},
			width = UDim.new(0, not v25 and 400 or 300)
		})
	})
end

return memo(PlayerContextualMenuWrapper)

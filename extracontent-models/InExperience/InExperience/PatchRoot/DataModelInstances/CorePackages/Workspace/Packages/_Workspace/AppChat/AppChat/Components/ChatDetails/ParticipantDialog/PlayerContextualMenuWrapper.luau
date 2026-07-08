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
local FFlagSkipBlockModal = SharedFlags.FFlagSkipBlockModal

function PlayerContextualMenuWrapper(t1: {[any]: any}) -- line: 41
	-- upvalues: useDispatch (copy), Responsive (copy), useSelector (copy), useEffect (copy), NetworkingFriends (copy), useIsInExperience (copy), v19 (copy), React (copy), Interactable (copy), Component (copy), convertUserPresenceTypeToString (copy), v17 (copy), FFlagSkipBlockModal (copy), Images (copy)
	local v22 = useDispatch()
	local v23 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v24 = useSelector(function(p1) -- line: 45
		return p1.ChatAppReducer.Presence.byUserId
	end)[t1.participantId]
	local v25 = useSelector(function(p2) -- line: 50
		return p2.ChatAppReducer.Friends.friendshipStatus
	end)[t1.participantId]

	useEffect(function() -- line: 55
		-- upvalues: v22 (copy), NetworkingFriends (copy), t1 (copy)
		v22(NetworkingFriends.GetExtendedFriendshipStatus.API({
			targetUserId = t1.participantId
		}))
	end, { t1.participantId })

	local v26 = useIsInExperience()
	local v27 = not v19 and not v26

	return React.createElement(Interactable, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		onStateChanged = function() -- line: 69
		end,
		Selectable = false,
		[React.Event.Activated] = t1.onDismiss
	}, {
		PCM = React.createElement(Component, {
			enableExperienceCTAs = v27,
			subjectPresence = if not v24 then nil else {
				locationString = v24.lastLocation,
				locationPlaceId = v24.placeId,
				locationRootPlaceId = v24.rootPlaceId,
				locationUniverseId = v24.universeId,
				status = convertUserPresenceTypeToString(v24.userPresenceType)
			},
			subjectUserId = t1.participantId,
			robloxFriendshipStatus = v25,
			closeCentralOverlayThunk = function() -- line: 86
			end,
			onReportActivated = t1.openReportUser and function() -- line: 87
				-- upvalues: v17 (copy), t1 (copy)
				v17:info("User activated reportUser | userId: {}, conversationId: {}", t1.participantId, t1.conversationId)
				t1.openReportUser(t1.participantId, t1.conversationId)
			end,
			onBlockActivated = t1.openBlockingModal and function() -- line: 96
				-- upvalues: t1 (copy)
				t1.openBlockingModal(t1.participantId, t1.conversationId)
			end,
			skipBlockModal = FFlagSkipBlockModal,
			additionalButtons = if not t1.showRemoveUserButton then nil else {{
				icon = Images["icons/actions/leave"],
				text = t1.removeFromGroupText,
				onActivated = function() -- line: 107
					-- upvalues: t1 (copy)
					t1.openRemoveUserDialog(t1.participantId, t1.conversationId)
				end
			}},
			width = UDim.new(0, not v23 and 400 or 300)
		})
	})
end

return memo(PlayerContextualMenuWrapper)

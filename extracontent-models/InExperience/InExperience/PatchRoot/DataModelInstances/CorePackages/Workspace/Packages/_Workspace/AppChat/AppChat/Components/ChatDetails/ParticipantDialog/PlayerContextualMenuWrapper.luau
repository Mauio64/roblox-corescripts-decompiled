local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local PlayerContextualMenu = require(parent.PlayerContextualMenu)
local Component = PlayerContextualMenu.Component
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SocialCommon = require(parent.SocialCommon)
local UIBlox = require(parent.UIBlox)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local Responsive = require(parent.Responsive)
local memo = React.memo

local convertUserPresenceTypeToString = SocialCommon.Utils.convertUserPresenceTypeToString
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local useEffect = React.useEffect

local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
require(AppChat.types)
local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetFriendshipStatus = FriendsHydrationReact.useGetFriendshipStatus

local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagAppChatMigrateFriendshipStatuses = require(AppChat.Flags.FFlagAppChatMigrateFriendshipStatuses)
local FFlagSkipBlockModal = SharedFlags.FFlagSkipBlockModal
local useGetPresenceByUserId

if FFlagAppChatPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

function PlayerContextualMenuWrapper(props)
	local v2 = useDispatch()
	local v3 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local subjectPresence

	if FFlagAppChatPresenceStoreMigration then
		local v4 = useGetPresenceByUserId(props.participantId)

		if v4 then
			subjectPresence = {
				locationString = v4.lastLocation,
				locationPlaceId = 0,
				locationRootPlaceId = 0,
				locationUniverseId = 0,
				status = 0
			}
			local locationPlaceId

			if v4.placeId ~= "" then
				locationPlaceId = v4.placeId
			end

			subjectPresence.locationPlaceId = locationPlaceId
			local locationRootPlaceId

			if v4.rootPlaceId ~= "" then
				locationRootPlaceId = v4.rootPlaceId
			end

			subjectPresence.locationRootPlaceId = locationRootPlaceId
			local locationUniverseId

			if v4.universeId ~= "" then
				locationUniverseId = v4.universeId
			end

			subjectPresence.locationUniverseId = locationUniverseId
			subjectPresence.status = v4.userPresenceType
		end
	else
		local v4 = useSelector(function(p)
			return p.ChatAppReducer.Presence.byUserId
		end)[props.participantId]

		subjectPresence = v4 and {
			locationString = v4.lastLocation,
			locationPlaceId = v4.placeId,
			locationRootPlaceId = v4.rootPlaceId,
			locationUniverseId = v4.universeId,
			status = convertUserPresenceTypeToString(v4.userPresenceType)
		} or nil
	end

	local robloxFriendshipStatus

	if FFlagAppChatMigrateFriendshipStatuses then
		robloxFriendshipStatus = useGetFriendshipStatus(props.participantId)
	else
		robloxFriendshipStatus = useSelector(function(p)
			return p.ChatAppReducer.Friends.friendshipStatus
		end)[props.participantId]

		useEffect(function()
			v2(NetworkingFriends.GetExtendedFriendshipStatus.API({
				targetUserId = props.participantId
			}))
		end, { props.participantId })
	end

	local enableExperienceCTAs = not useIsInExperience()

	return React.createElement(Interactable, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		onStateChanged = function() end,
		Selectable = false,
		[React.Event.Activated] = props.onDismiss
	}, {
		PCM = React.createElement(Component, {
			enableExperienceCTAs = enableExperienceCTAs,
			subjectPresence = subjectPresence,
			subjectUserId = props.participantId,
			robloxFriendshipStatus = robloxFriendshipStatus,
			closeCentralOverlayThunk = function() end,
			onReportActivated = props.openReportUser and function()
				v:info(
					"User activated reportUser | userId: {}, conversationId: {}",
					props.participantId,
					props.conversationId
				)

				props.openReportUser(props.participantId, props.conversationId)
			end,
			onBlockActivated = props.openBlockingModal and function()
				props.openBlockingModal(props.participantId, props.conversationId)
			end,
			skipBlockModal = FFlagSkipBlockModal,
			additionalButtons = props.showRemoveUserButton and {
				{
					icon = Images["icons/actions/leave"],
					text = props.removeFromGroupText,
					onActivated = function()
						props.openRemoveUserDialog(props.participantId, props.conversationId)
					end
				}
			} or nil,
			width = UDim.new(0, v3 and 300 or 400)
		})
	})
end

return memo(PlayerContextualMenuWrapper)

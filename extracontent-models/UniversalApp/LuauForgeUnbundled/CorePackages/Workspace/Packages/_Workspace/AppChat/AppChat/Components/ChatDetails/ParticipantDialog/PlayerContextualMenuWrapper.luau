local component = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlayerContextualMenu").Component
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local memo = React.memo

local convertUserPresenceTypeToString = SocialCommon.Utils.convertUserPresenceTypeToString
local images = UIBlox.App.ImageSet.Images
local interactable = UIBlox.Core.Control.Interactable
local useEffect = React.useEffect

local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("PlayerContextualMenuWrapper")
local NetworkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingBlocking")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local useGetFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsHydrationReact").useGetFriendshipStatus

local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")
local FFlagAppChatMigrateFriendshipStatuses = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMigrateFriendshipStatuses")
local fFlagSkipBlockModal = SharedFlags.FFlagSkipBlockModal
local useGetPresenceByUserId

if FFlagAppChatPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

function LUAUFORGE_MODULE_GLOBALS_hoY_PlayerContextualMenuWrapper(props)
	local v6 = useDispatch()
	local v7 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v8

	if FFlagAppChatPresenceStoreMigration then
		local v9 = useGetPresenceByUserId(props.participantId)

		if v9 then
			v8 = {
				locationString = v9.lastLocation,
				locationPlaceId = 0,
				locationRootPlaceId = 0,
				locationUniverseId = 0,
				status = 0
			}
			local v10 = if v9.placeId ~= "" then v9.placeId else nil
			v8.locationPlaceId = v10
			local v11 = if v9.rootPlaceId ~= "" then v9.rootPlaceId else nil
			v8.locationRootPlaceId = v11

			local v12 = if v9.universeId ~= "" then v9.universeId else nil
			v8.locationUniverseId = v12
			v8.status = v9.userPresenceType
		end
	else
		local v9 = useSelector(function(p2)
			return p2.ChatAppReducer.Presence.byUserId
		end)[props.participantId]

		v8 = v9 and {
			locationString = v9.lastLocation,
			locationPlaceId = v9.placeId,
			locationRootPlaceId = v9.rootPlaceId,
			locationUniverseId = v9.universeId,
			status = convertUserPresenceTypeToString(v9.userPresenceType)
		} or nil
	end

	local v9

	if FFlagAppChatMigrateFriendshipStatuses then
		v9 = useGetFriendshipStatus(props.participantId)
	else
		v9 = useSelector(function(p2)
			return p2.ChatAppReducer.Friends.friendshipStatus
		end)[props.participantId]

		useEffect(function()
			v6(NetworkingBlocking.GetExtendedFriendshipStatus.API({
				targetUserId = props.participantId
			}))
		end, { props.participantId })
	end

	local v10 = not useIsInExperience()

	return React.createElement(interactable, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		onStateChanged = function() end,
		Selectable = false,
		[React.Event.Activated] = props.onDismiss
	}, {
		PCM = React.createElement(component, {
			enableExperienceCTAs = v10,
			subjectPresence = v8,
			subjectUserId = props.participantId,
			robloxFriendshipStatus = v9,
			closeCentralOverlayThunk = function() end,
			onReportActivated = props.openReportUser and function()
				v5:info(
					"User activated reportUser | userId: {}, conversationId: {}",
					props.participantId,
					props.conversationId
				)

				props.openReportUser(props.participantId, props.conversationId)
			end,
			onBlockActivated = props.openBlockingModal and function()
				props.openBlockingModal(props.participantId, props.conversationId)
			end,
			skipBlockModal = fFlagSkipBlockModal,
			additionalButtons = props.showRemoveUserButton and {
				{
					icon = images["icons/actions/leave"],
					text = props.removeFromGroupText,
					onActivated = function()
						props.openRemoveUserDialog(props.participantId, props.conversationId)
					end
				}
			} or nil,
			width = UDim.new(0, v7 and 300 or 400)
		})
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hoY_PlayerContextualMenuWrapper)

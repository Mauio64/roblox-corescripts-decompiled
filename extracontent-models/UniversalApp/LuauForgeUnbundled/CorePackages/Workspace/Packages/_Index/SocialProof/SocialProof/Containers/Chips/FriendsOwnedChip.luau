local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Foundation")
local chip = Foundation.Chip

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppEnums").AppPage
local avatarGroupType = Foundation.Enums.AvatarGroupType
local useEntityConnectionsPagination = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Hooks/useEntityConnectionsPagination")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Enums")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Types")

local fFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation

local function FriendsOwnedChip(props, p2)
	local fromProfile = props.fromProfile
	local itemId = props.itemId
	local itemType = props.itemType

	local v5 = useDispatch()

	local v6 = useEntityConnectionsPagination({
		entityId = itemId,
		entityType = itemType,
		connectionType = Enums.ConnectionType.Friend
	})

	local userIds = v6.userIds or {}

	local v7 = { table.unpack(userIds, 1, (math.min(2, #userIds))) }
	local totalConnections = v6.totalConnections or 0

	local v8 = React.useCallback(function()
		local v9 = {
			name = appPage.FriendsOwnedUserList,
			extraProps = {
				entityId = itemId,
				entityType = itemType,
				source = fromProfile and "profile" or "marketplace"
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9))
		end
	end, { v5, itemId, itemType, fromProfile })

	local v9 = useLocalization({
		connectionsOwn = {
			"Feature.Friends.Label.FriendsOwn",
			numberOfConnections = totalConnections
		},
		singleConnectionOwns = "Feature.Friends.Label.FriendOwns"
	})

	local v10 = if totalConnections == 1 then v9.singleConnectionOwns else v9.connectionsOwn

	if fFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation then
		React.useEffect(function()
			if totalConnections > 0 and props.chipIsRenderedCallback then
				props.chipIsRenderedCallback(true)
			end
		end, { totalConnections, props.chipIsRenderedCallback })
	end

	if totalConnections == 0 then
		return nil
	end

	return React.createElement(chip, {
		LayoutOrder = props.layoutOrder or 0,
		text = v10,
		onActivated = v8,
		leading = {
			type = "AvatarGroup",
			props = { avatars = v7, type = avatarGroupType.Stacked, max = 2 }
		},
		ref = p2,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionLeft = props.NextSelectionLeft
	})
end

return React.forwardRef(FriendsOwnedChip)

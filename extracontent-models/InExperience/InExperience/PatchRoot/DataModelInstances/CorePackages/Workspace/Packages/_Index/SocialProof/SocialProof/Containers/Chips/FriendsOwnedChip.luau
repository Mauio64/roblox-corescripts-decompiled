local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent

local Foundation = require(parent.Foundation)
local Chip = Foundation.Chip

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local useEntityConnectionsPagination = require(SocialProof.Hooks.useEntityConnectionsPagination)
local Enums = require(SocialProof.Common.Enums)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(SocialProof.Common.Types)

local SharedFlags2 = require(parent.SharedFlags)

local FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation = SharedFlags2.FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation

local function FriendsOwnedChip(props, ref)
	local fromProfile = props.fromProfile
	local itemId = props.itemId
	local itemType = props.itemType

	local v = useDispatch()

	local v2 = useEntityConnectionsPagination({
		entityId = itemId,
		entityType = itemType,
		connectionType = Enums.ConnectionType.Friend
	})

	local userIds = v2.userIds or {}

	local avatars = { table.unpack(userIds, 1, (math.min(2, #userIds))) }
	local totalConnections = v2.totalConnections or 0

	local onActivated = React.useCallback(function()
		local v3 = {
			name = AppPage.FriendsOwnedUserList,
			extraProps = {
				entityId = itemId,
				entityType = itemType,
				source = fromProfile and "profile" or "marketplace"
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v3))
		else
			v(NavigateDown(v3))
		end
	end, { v, itemId, itemType, fromProfile })

	local v3 = useLocalization({
		connectionsOwn = {
			"Feature.Friends.Label.FriendsOwn",
			numberOfConnections = totalConnections
		},
		singleConnectionOwns = "Feature.Friends.Label.FriendOwns"
	})
	local text

	if totalConnections == 1 then
		text = v3.singleConnectionOwns
	else
		text = v3.connectionsOwn
	end

	if FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation then
		React.useEffect(function()
			if totalConnections > 0 and props.chipIsRenderedCallback then
				props.chipIsRenderedCallback(true)
			end
		end, { totalConnections, props.chipIsRenderedCallback })
	end

	if totalConnections == 0 then
		return nil
	end

	return React.createElement(Chip, {
		LayoutOrder = props.layoutOrder or 0,
		text = text,
		onActivated = onActivated,
		leading = {
			type = "AvatarGroup",
			props = { avatars = avatars, type = AvatarGroupType.Stacked, max = 2 }
		},
		ref = ref,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionLeft = props.NextSelectionLeft
	})
end

return React.forwardRef(FriendsOwnedChip)

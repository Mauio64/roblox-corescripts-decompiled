local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/FriendsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SocialCommon")

local ShareSheetItemView = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetItemView")

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function ShareSheetItemContainer(props)
	local v5 = useGetPresenceByUserId(props.primaryUserId)
	local v6 = if v5 and v5.userPresenceType then convertToFoundationPresenceEnum(v5.userPresenceType) else Foundation.Enums.UserPresence.None

	return React.createElement(ShareSheetItemView, {
		icon = props.icon,
		isSelected = props.isSelected,
		primaryUserId = props.primaryUserId,
		secondUserId = props.secondUserId,
		label = props.label,
		onActivated = props.onActivated,
		shouldAnimate = props.shouldAnimate,
		userPresence = v6,
		LayoutOrder = props.LayoutOrder
	})
end

return ShareSheetItemContainer

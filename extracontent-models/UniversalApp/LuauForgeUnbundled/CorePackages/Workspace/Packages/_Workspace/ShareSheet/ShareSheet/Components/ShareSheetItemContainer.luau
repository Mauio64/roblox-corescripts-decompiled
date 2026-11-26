local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/FriendsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SocialCommon")

local FFlagShareSheetDesktopReadiness = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetDesktopReadiness")
local ShareSheetItemView = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetItemView")

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function ShareSheetItemContainer(props)
	local v5 = useGetPresenceByUserId(props.primaryUserId)
	local v6

	if v5 and v5.userPresenceType then
		v6 = convertToFoundationPresenceEnum(v5.userPresenceType)
	else
		v6 = Foundation.Enums.UserPresence.None
	end

	local createElement = React.createElement
	local v8 = {
		icon = props.icon,
		isSelected = props.isSelected,
		primaryUserId = props.primaryUserId,
		secondUserId = props.secondUserId,
		label = props.label,
		onActivated = props.onActivated,
		shouldAnimate = props.shouldAnimate,
		userPresence = v6,
		width = 0,
		LayoutOrder = 0
	}

	local v9 = if FFlagShareSheetDesktopReadiness then props.width else nil
	v8.width = v9
	v8.LayoutOrder = props.LayoutOrder
	return createElement(ShareSheetItemView, v8)
end

return ShareSheetItemContainer

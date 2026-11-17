local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local FriendsCommon = require(parent.FriendsCommon)
local React = require(parent.React)
local SocialCommon = require(parent.SocialCommon)

local FFlagShareSheetDesktopReadiness = require(ShareSheet.Flags.FFlagShareSheetDesktopReadiness)
local ShareSheetItemView = require(script.Parent.ShareSheetItemView)

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function ShareSheetItemContainer(props)
	local v = useGetPresenceByUserId(props.primaryUserId)
	local userPresence

	if v and v.userPresenceType then
		userPresence = convertToFoundationPresenceEnum(v.userPresenceType)
	else
		userPresence = Foundation.Enums.UserPresence.None
	end

	local createElement = React.createElement
	local v2 = {
		icon = props.icon,
		isSelected = props.isSelected,
		primaryUserId = props.primaryUserId,
		secondUserId = props.secondUserId,
		label = props.label,
		onActivated = props.onActivated,
		shouldAnimate = props.shouldAnimate,
		userPresence = userPresence,
		width = 0,
		LayoutOrder = 0
	}
	local width

	if FFlagShareSheetDesktopReadiness then
		width = props.width
	end

	v2.width = width
	v2.LayoutOrder = props.LayoutOrder
	return createElement(ShareSheetItemView, v2)
end

return ShareSheetItemContainer

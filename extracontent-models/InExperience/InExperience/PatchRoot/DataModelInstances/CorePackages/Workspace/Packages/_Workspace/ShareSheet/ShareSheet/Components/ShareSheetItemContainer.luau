local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local FriendsCommon = require(parent.FriendsCommon)
local React = require(parent.React)
local SocialCommon = require(parent.SocialCommon)

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

	return React.createElement(ShareSheetItemView, {
		icon = props.icon,
		isSelected = props.isSelected,
		primaryUserId = props.primaryUserId,
		secondUserId = props.secondUserId,
		label = props.label,
		onActivated = props.onActivated,
		shouldAnimate = props.shouldAnimate,
		userPresence = userPresence,
		LayoutOrder = props.LayoutOrder
	})
end

return ShareSheetItemContainer

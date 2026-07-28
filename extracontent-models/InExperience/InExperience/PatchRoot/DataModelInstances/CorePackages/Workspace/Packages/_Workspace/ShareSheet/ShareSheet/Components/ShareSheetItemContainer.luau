local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local FriendsCommon = require(Parent.FriendsCommon)
local React = require(Parent.React)
local SocialCommon = require(Parent.SocialCommon)
local ShareSheetItemView = require(script.Parent.ShareSheetItemView)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function ShareSheetItemContainer(t1: {[any]: any}) -- line: 25
	-- upvalues: useGetPresenceByUserId (copy), convertToFoundationPresenceEnum (copy), Foundation (copy), React (copy), ShareSheetItemView (copy)
	local v11 = useGetPresenceByUserId(t1.primaryUserId)
	local v12 = if not v11 or not v11.userPresenceType then Foundation.Enums.UserPresence.None else convertToFoundationPresenceEnum(v11.userPresenceType)

	return React.createElement(ShareSheetItemView, {
		icon = t1.icon,
		isSelected = t1.isSelected,
		primaryUserId = t1.primaryUserId,
		secondUserId = t1.secondUserId,
		label = t1.label,
		onActivated = t1.onActivated,
		shouldAnimate = t1.shouldAnimate,
		userPresence = v12,
		LayoutOrder = t1.LayoutOrder
	})
end

return ShareSheetItemContainer

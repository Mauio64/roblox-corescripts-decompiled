local Parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(Parent.React)
local SocialCommon = require(Parent.SocialCommon)
local UserTile = require(Parent.UserTile).UserTile
local LayoutMode = require(Parent.UserTile).LayoutMode
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function UserTile2(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), Foundation (copy), convertToFoundationPresenceEnum (copy), React (copy), View (copy), UserTile (copy), LayoutMode (copy)
	local v12 = useTokens()
	local v13 = if t1.item.presence == nil then Foundation.Enums.UserPresence.None else Foundation.Enums.UserPresence[convertToFoundationPresenceEnum(t1.item.presence.userPresenceType)]

	return React.createElement(View, {
		tag = "auto-none",
		Size = t1.itemSize,
		LayoutOrder = t1.index,
		ref = t1.tileRef,
		selection = if not t1.selectionOrder then nil else {
			Selectable = true,
			SelectionOrder = t1.selectionOrder
		}
	}, {
		Content = React.createElement(UserTile, {
			layoutMode = LayoutMode.compact,
			userId = t1.item.id,
			title = t1.name,
			subtitle = t1.contextualText,
			titleStyle = v12.Typography.TitleSmall,
			subtitleStyle = v12.Typography.LabelSmall,
			userPresenceType = v13,
			onActivated = t1.onActivated,
			titleIcon = t1.titleIcon
		})
	})
end

return UserTile2

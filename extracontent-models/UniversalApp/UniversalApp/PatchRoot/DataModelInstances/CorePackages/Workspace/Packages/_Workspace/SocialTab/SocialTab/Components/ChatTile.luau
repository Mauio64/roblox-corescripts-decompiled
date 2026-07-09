local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local BadgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local Images = UIBlox.App.ImageSet.Images
local v8 = Roact.PureComponent:extend("ChatTile")

v8.defaultProps = {
	LayoutOrder = 1,
	unreadConversationCount = nil,
	title = "",
	onActivated = function() -- line: 15
	end
}
v8.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.number),
	unreadConversationCount = t.optional(t.number),
	onActivated = t.optional(t.callback),
	title = t.optional(t.string)
})

function v8.render(p1) -- line: 26
	-- upvalues: BadgeStates (copy), UIBlox (copy), Roact (copy), Images (copy)
	local v10 = if not p1.props.unreadConversationCount or not (p1.props.unreadConversationCount > 0) then nil else BadgeStates.isEmpty

	return UIBlox.Style.withStyle(function() -- line: 31
		-- upvalues: Roact (copy), UIBlox (copy), p1 (copy), v10 (copy), Images (copy)
		return Roact.createElement(UIBlox.App.Tile.MenuTile, {
			size = UDim2.fromScale(1, 1),
			layoutOrder = p1.props.LayoutOrder,
			badgeValue = v10,
			icon = Images["icons/menu/messages_large"],
			title = p1.props.title,
			onActivated = p1.props.onActivated
		})
	end)
end

return v8

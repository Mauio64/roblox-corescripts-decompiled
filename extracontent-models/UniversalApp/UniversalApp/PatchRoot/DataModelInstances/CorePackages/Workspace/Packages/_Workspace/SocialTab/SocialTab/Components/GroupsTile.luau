local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Images = UIBlox.App.ImageSet.Images
local v7 = Roact.PureComponent:extend("GroupsTile")

v7.defaultProps = {
	LayoutOrder = 0,
	title = "",
	onActivated = function() -- line: 13
	end
}
v7.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.number),
	onActivated = t.optional(t.callback),
	title = t.optional(t.string)
})

function v7.render(p1) -- line: 23
	-- upvalues: UIBlox (copy), Roact (copy), Images (copy)
	return UIBlox.Style.withStyle(function() -- line: 24
		-- upvalues: Roact (copy), UIBlox (copy), p1 (copy), Images (copy)
		return Roact.createElement(UIBlox.App.Tile.MenuTile, {
			size = UDim2.fromScale(1, 1),
			layoutOrder = p1.props.LayoutOrder,
			icon = Images["icons/menu/groups_large"],
			title = p1.props.title,
			onActivated = p1.props.onActivated
		})
	end)
end

return v7

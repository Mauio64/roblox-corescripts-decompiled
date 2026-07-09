local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local uDim = UDim.new(0, 10)
local v14 = Images["icons/menu/more_off"]
local v15 = Roact.PureComponent:extend("LCSortMoreButton")

v15.validateProps = t.strictInterface({
	Visible = t.union(t.boolean, t.table),
	ZIndex = t.number,
	asset = t.table,
	onUnequip = t.optional(t.callback),
	navigation = t.table
})

function v15.init(p1) -- line: 40
	-- upvalues: Roact (copy), AvatarScreen (copy)
	p1.menuRef = Roact.createRef()

	function p1.contextMenuOpen() -- line: 43
		-- upvalues: p1 (copy), AvatarScreen (copy)
		p1.props.navigation.navigate(AvatarScreen.LCSortContextMenu, {
			asset = p1.props.asset,
			tilePositionY = p1.menuRef:getValue() and p1.menuRef:getValue().AbsolutePosition.Y or 0,
			onUnequip = p1.props.onUnequip
		})
	end
end
function v15.render(p2) -- line: 52
	-- upvalues: withStyle (copy), Roact (copy), Constants (copy), uDim (copy), ImageSetLabel (copy), v14 (copy)
	return withStyle(function(p3) -- line: 53
		-- upvalues: Roact (copy), Constants (copy), p2 (copy), uDim (copy), ImageSetLabel (copy), v14 (copy)
		local Theme = p3.Theme

		return Roact.createElement("TextButton", {
			Text = "",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromOffset(Constants.Tile.ContextWidth - Constants.Tile.ShownContextWidth, 0),
			Size = UDim2.new(0, Constants.Tile.ContextWidth, 1, 0),
			BackgroundColor3 = Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = Theme.BackgroundUIContrast.Transparency,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			ZIndex = p2.props.ZIndex,
			Visible = p2.props.Visible,
			[Roact.Event.Activated] = p2.contextMenuOpen,
			[Roact.Ref] = p2.menuRef
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = uDim
			}),
			ImageSetLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(Constants.Tile.MoreIconSize, Constants.Tile.MoreIconSize),
				Position = UDim2.new(0.5, -4, 0.5, 0),
				Image = v14,
				ImageTransparency = Theme.IconEmphasis.Transparency,
				ImageColor3 = Theme.IconEmphasis.Color
			})
		})
	end)
end

return (withNavigation(v15))

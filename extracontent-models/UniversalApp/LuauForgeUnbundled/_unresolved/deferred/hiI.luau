local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local withNavigation = RoactNavigation.withNavigation
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local module = require("@luauforge/deferred/gLv")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local udim = UDim.new(0, 10)
local iconsmenumore_off = images["icons/menu/more_off"]

local extended = Roact.PureComponent:extend("LCSortMoreButton")

extended.validateProps = t.strictInterface({
	Visible = t.union(t.boolean, t.table),
	ZIndex = t.number,
	asset = t.table,
	onUnequip = t.optional(t.callback),
	navigation = t.table
})

function extended:init()
	self.menuRef = Roact.createRef()

	function self.contextMenuOpen()
		self.props.navigation.navigate(avatarScreen.LCSortContextMenu, {
			asset = self.props.asset,
			tilePositionY = self.menuRef:getValue() and self.menuRef:getValue().AbsolutePosition.Y or 0,
			onUnequip = self.props.onUnequip
		})
	end
end

function extended.render(data)
	return withStyle(function(p2)
		local theme = p2.Theme

		return Roact.createElement("TextButton", {
			Text = "",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromOffset(module.Tile.ContextWidth - module.Tile.ShownContextWidth, 0),
			Size = UDim2.new(0, module.Tile.ContextWidth, 1, 0),
			BackgroundColor3 = theme.BackgroundUIContrast.Color,
			BackgroundTransparency = theme.BackgroundUIContrast.Transparency,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			ZIndex = data.props.ZIndex,
			Visible = data.props.Visible,
			[Roact.Event.Activated] = data.contextMenuOpen,
			[Roact.Ref] = data.menuRef
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = udim }),
			ImageSetLabel = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(module.Tile.MoreIconSize, module.Tile.MoreIconSize),
				Position = UDim2.new(0.5, -4, 0.5, 0),
				BackgroundTransparency = 1,
				Image = iconsmenumore_off,
				ImageTransparency = theme.IconEmphasis.Transparency,
				ImageColor3 = theme.IconEmphasis.Color
			})
		})
	end)
end

return (withNavigation(extended))

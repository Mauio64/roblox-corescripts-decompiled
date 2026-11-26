local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local module = require("@luauforge/bundled/fvR")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local extended = Roact.PureComponent:extend("ManageButton")

extended.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	navigation = t.table
})

function extended:init()
	function self.showManageCostumesCallback()
		self.props.navigation.navigate(avatarScreen.ManageOutfitPage)
	end
end

function extended.render(p2)
	return withStyle(function(p3)
		local iconButtonSize = module.getIconButtonSize(p2.props.formFactor)

		return Roact.createElement(iconButton, {
			size = UDim2.new(0, iconButtonSize, 1, 0),
			icon = images["icons/common/settings"],
			iconSize = iconSize.Medium,
			iconColor3 = p3.Theme.IconEmphasis.Color,
			iconTransparency = p3.Theme.IconEmphasis.Transparency,
			onActivated = p2.showManageCostumesCallback,
			buttonRef = p2.props.buttonRef
		})
	end)
end

return (RoactNavigation.withNavigation(extended))

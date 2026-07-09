local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local v14 = Roact.PureComponent:extend("ManageButton")

v14.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	navigation = t.table
})

function v14.init(p1) -- line: 36
	-- upvalues: AvatarScreen (copy)
	function p1.showManageCostumesCallback() -- line: 37
		-- upvalues: p1 (copy), AvatarScreen (copy)
		p1.props.navigation.navigate(AvatarScreen.ManageOutfitPage)
	end
end
function v14.render(p2) -- line: 42
	-- upvalues: withStyle (copy), TopBar (copy), Roact (copy), IconButton (copy), Images (copy), IconSize (copy)
	return withStyle(function(p3) -- line: 43
		-- upvalues: TopBar (copy), p2 (copy), Roact (copy), IconButton (copy), Images (copy), IconSize (copy)
		local v18 = TopBar.getIconButtonSize(p2.props.formFactor)

		return Roact.createElement(IconButton, {
			size = UDim2.new(0, v18, 1, 0),
			icon = Images["icons/common/settings"],
			iconSize = IconSize.Medium,
			iconColor3 = p3.Theme.IconEmphasis.Color,
			iconTransparency = p3.Theme.IconEmphasis.Transparency,
			onActivated = p2.showManageCostumesCallback,
			buttonRef = p2.props.buttonRef
		})
	end)
end

return (RoactNavigation.withNavigation(v14))

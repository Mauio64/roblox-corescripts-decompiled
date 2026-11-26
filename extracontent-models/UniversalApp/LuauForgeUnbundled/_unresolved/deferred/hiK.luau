local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withNavigation = RoactNavigation.withNavigation
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/deferred/gLv")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/deferred/gKK")
local module3 = require("@luauforge/deferred/gKL")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local iconsactionsreset = images["icons/actions/reset"]

local udim = UDim.new(0, 10)

local function ResetButtonDefault(p2)
	local theme = useStyle().Theme

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -module.RightMargin, 0, -9),
		Size = UDim2.fromOffset(34, 34),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Visible = not p2.lastInputIsGamepad
	}, {
		Button = Roact.createElement(imageSetButton, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 1),
			Image = iconsactionsreset,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = theme.IconEmphasis.Transparency,
			[Roact.Event.Activated] = p2.onActivated
		})
	})
end

local function ResetButtonVR(p2)
	local theme = useStyle().Theme

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(1, -module.VerticalList.Width / 2, 0, 0),
		Size = UDim2.fromOffset(module.Tile.MoreIconSize, module.Tile.MoreIconSize),
		LayoutOrder = 1,
		Visible = not p2.lastInputIsGamepad,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency
	}, {
		UICorner = Roact.createElement("UICorner", { CornerRadius = udim }),
		Button = Roact.createElement(imageSetButton, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 1),
			Image = iconsactionsreset,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = theme.IconEmphasis.Transparency,
			[Roact.Event.Activated] = p2.onActivated
		})
	})
end

local extended = Roact.PureComponent:extend("ResetButton")

extended.validateProps = t.strictInterface({
	lastInputIsGamepad = t.boolean,
	isDragging = t.boolean,
	navigation = t.table,
	analytics = t.table,
	sendAnalytics = t.callback
})

extended.defaultProps = { lastInputIsGamepad = false, isDragging = false }

function extended:init()
	function self.openResetConfirmation()
		if self.props.isDragging then
			return
		end

		self.props.sendAnalytics(self.props.analytics.avatarRefineLayersResetTap)
		self.props.navigation.navigate(avatarScreen.ResetLayeredItemsSortPrompt)
	end
end

function extended.render(p2)
	if isVRAppBuild() then
		return Roact.createElement(ResetButtonVR, {
			onActivated = p2.openResetConfirmation,
			lastInputIsGamepad = p2.props.lastInputIsGamepad
		})
	end

	return Roact.createElement(ResetButtonDefault, {
		onActivated = p2.openResetConfirmation,
		lastInputIsGamepad = p2.props.lastInputIsGamepad
	})
end

local v5 = withNavigation(extended, nil)

local v6 = roactServices.connect({ analytics = module2 })(v5)

return (RoactRodux.connect(nil, function(callback)
	return {
		sendAnalytics = function(p2)
			callback(module3(p2))
		end
	}
end)(v6))

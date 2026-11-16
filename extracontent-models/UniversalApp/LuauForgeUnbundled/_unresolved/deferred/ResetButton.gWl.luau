local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad

local module = require("@luauforge/deferred/ggP")

local iconsactionsreset = images["icons/actions/reset"]

local function mapTokens(p2)
	return { mediumIconSize = p2.Size.Size_900 }
end

local function ResetButton(props)
	local v5 = useDesignTokens(mapTokens)
	local theme = useStyle().Theme
	local v6 = useIsGamepad()

	return React.createElement(focusable[imageSetButton], {
		ref = props.resetRef,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -module.RightMargin, 0, -9),
		Size = UDim2.new(0, v5.mediumIconSize, 0, v5.mediumIconSize),
		BackgroundTransparency = 1,
		Image = iconsactionsreset,
		ImageColor3 = theme.SystemPrimaryDefault.Color,
		ImageTransparency = 0,
		LayoutOrder = 1,
		[React.Event.Activated] = props.onResetButtonPressed,
		NextSelectionLeft = props.NextSelectionLeft,
		ZIndex = 3,
		Visible = not v6
	})
end

return ResetButton

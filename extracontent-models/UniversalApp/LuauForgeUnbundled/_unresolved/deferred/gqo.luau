local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local iconButton = UIBlox.App.Button.IconButton
local useStyle = UIBlox.Core.Style.useStyle
local iconSize = UIBlox.App.Constant.IconSize
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local colorGradientCircle = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.ColorGradientCircle
local defineFastFlag = game:DefineFastFlag("AXFixColorAdjustmentQuickButtonSize", false)

local udim = UDim.new(0, 8)

local udim2 = UDim.new(0, 4)

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local v6 = useStyle()
	local v7 = useSelectionCursor(cursorKind.RoundedRect)
	local theme = v6.Theme
	local ref = if defineFastFlag then React.useRef(nil) else nil

	if not defineFastFlag then
		return React.createElement(iconButton, {
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			layoutOrder = props.LayoutOrder,
			showBackground = true,
			iconSize = iconSize.Medium,
			onActivated = props.onActivated,
			backgroundColor = theme.BackgroundUIDefault,
			buttonRef = p2
		}, {
			Color = React.createElement(colorGradientCircle, {
				Size = UDim2.fromOffset(v5.Size.Size_700, v5.Size.Size_700),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Colors = props.colors
			})
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromOffset(44, 44),
		BackgroundColor3 = theme.BackgroundMuted.Color,
		BackgroundTransparency = theme.BackgroundMuted.Transparency,
		LayoutOrder = props.LayoutOrder,
		ref = p2
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim }),
		Button = React.createElement(imageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize.Regular, iconSize.Regular),
			BackgroundTransparency = 1,
			[React.Event.Activated] = props.onActivated,
			ref = ref,
			SelectionImageObject = v7
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = udim2,
				PaddingBottom = udim2,
				PaddingLeft = udim2,
				PaddingRight = udim2
			}),
			Color = React.createElement(colorGradientCircle, {
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Colors = props.colors
			})
		})
	})
end))

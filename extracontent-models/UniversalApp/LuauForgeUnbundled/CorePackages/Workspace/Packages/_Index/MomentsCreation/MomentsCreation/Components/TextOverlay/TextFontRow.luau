local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local useTextFontRowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/useTextFontRowState")
local FFlagMomentsTextOverlayColorPickerIcon = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayColorPickerIcon")

local v5 = {
	{ font = Enum.Font.BuilderSansMedium, label = "Builder" },
	{ font = Enum.Font.SourceSans, label = "Source Sans" },
	{ font = Enum.Font.LuckiestGuy, label = "Luckiest Guy" },
	{ font = Enum.Font.Bangers, label = "Bangers" },
	{ font = Enum.Font.PermanentMarker, label = "Permanent Marker" },
	{ font = Enum.Font.Creepster, label = "Creepster" },
	{ font = Enum.Font.Arcade, label = "Arcade" },
	{ font = Enum.Font.SciFi, label = "Sci-Fi" },
	{ font = Enum.Font.IndieFlower, label = "Indie Flower" },
	{ font = Enum.Font.GrenzeGotisch, label = "Grenze Gotisch" },
	{ font = Enum.Font.SpecialElite, label = "Special Elite" }
}

local v6 = { Color3 = Color3.fromRGB(32, 34, 39), Transparency = 0 }

local function TextFontRow(p2)
	local v7 = useTokens()
	local v8 = useTextFontRowState(p2.controller)

	local children = {}

	for k, v9 in v5 do
		local v10 = v8.font == v9.font
		local v11 = "Chip" .. k
		local createElement = React.createElement
		local v13 = {
			LayoutOrder = k,
			tag = "row align-x-center align-y-center size-0-800 auto-x radius-circle clip",
			padding = 0,
			backgroundStyle = 0,
			onActivated = 0
		}

		local v14 = {
			left = UDim.new(0, v7.Padding.Medium),
			right = UDim.new(0, v7.Padding.Medium),
			top = 0
		}

		local v15 = if FFlagMomentsTextOverlayColorPickerIcon and v9.font == Enum.Font.LuckiestGuy then UDim.new(0, v7.Size.Size_100) else nil
		v14.top = v15
		v13.padding = v14

		local v16 = if v10 then v7.Inverse.Surface.Surface_0 else v7.Color.ActionStandard.Background
		v13.backgroundStyle = v16

		function v13.onActivated()
			v8.onChipActivated(v9.font, k)
		end

		local createElement2 = React.createElement
		local v18 = {
			Text = v9.label,
			tag = "shrink auto-x text-label-medium text-truncate-end",
			fontStyle = { Font = v9.font },
			textStyle = 0
		}
		local v19 = if v10 then v6 else v7.Color.ActionStandard.Foreground
		v18.textStyle = v19
		children[v11] = createElement(view, v13, { Label = createElement2(text, v18) })
	end

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = p2.LayoutOrder,
		Size = UDim2.new(1, 0, 0, Constants.TextOverlay.PickerRowHeight)
	}
	local v11 = {
		Scroll = React.createElement(Foundation.ScrollView, {
			Size = UDim2.new(1, 0, 1, 0),
			scrollingFrameRef = v8.scrollingFrameRef,
			onCanvasPositionChanged = v8.onScrollViewportChanged,
			onAbsoluteCanvasSizeChanged = v8.onScrollViewportChanged,
			onAbsoluteWindowSizeChanged = v8.onScrollViewportChanged,
			scroll = {
				scrollBarVisibility = Foundation.Enums.Visibility.None,
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticCanvasSize = Enum.AutomaticSize.X
			}
		}, {
			Row = React.createElement(
				view,
				{
					tag = "row align-y-center gap-medium size-0-full auto-x padding-x-large"
				},
				children
			)
		}),
		LeftChevron = 0,
		RightChevron = 0
	}

	local v12 = if v8.showLeftChevron then React.createElement(
		view,
		{ ZIndex = 2, tag = "position-center-left anchor-center-left auto-xy" },
		{
			Icon = React.createElement(iconButton, {
				icon = BuilderIcons.Icon.ChevronSmallLeft,
				onActivated = v8.onLeftChevronActivated,
				size = Foundation.Enums.InputSize.Medium
			})
		}
	) else nil
	v11.LeftChevron = v12

	local v13 = if v8.showRightChevron then React.createElement(
		view,
		{ ZIndex = 2, tag = "position-center-right anchor-center-right auto-xy" },
		{
			Icon = React.createElement(iconButton, {
				icon = BuilderIcons.Icon.ChevronSmallRight,
				onActivated = v8.onRightChevronActivated,
				size = Foundation.Enums.InputSize.Medium
			})
		}
	) else nil
	v11.RightChevron = v13
	return createElement(view, v10, v11)
end

return TextFontRow

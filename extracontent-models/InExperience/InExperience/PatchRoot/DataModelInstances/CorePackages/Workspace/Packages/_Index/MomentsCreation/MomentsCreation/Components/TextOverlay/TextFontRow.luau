local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local Constants = require(MomentsCreation.Constants)
require(MomentsCreation.Types.CreationFlowTypes)
local useTextFontRowState = require(MomentsCreation.Components.TextOverlay.useTextFontRowState)
local FFlagMomentsTextOverlayColorPickerIcon = require(MomentsCreation.Flags.FFlagMomentsTextOverlayColorPickerIcon)

local v = {
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

local v2 = { Color3 = Color3.fromRGB(32, 34, 39), Transparency = 0 }

local function TextFontRow(p)
	local v3 = useTokens()
	local v4 = useTextFontRowState(p.controller)

	local children = {}

	for k, v5 in v do
		local v6 = v4.font == v5.font
		local v7 = "Chip" .. k
		local createElement = React.createElement
		local v8 = {
			LayoutOrder = k,
			tag = "row align-x-center align-y-center size-0-800 auto-x radius-circle clip",
			padding = 0,
			backgroundStyle = 0,
			onActivated = 0
		}

		local padding = {
			left = UDim.new(0, v3.Padding.Medium),
			right = UDim.new(0, v3.Padding.Medium),
			top = 0
		}
		local top

		if FFlagMomentsTextOverlayColorPickerIcon and v5.font == Enum.Font.LuckiestGuy then
			top = UDim.new(0, v3.Size.Size_100)
		end

		padding.top = top
		v8.padding = padding
		local backgroundStyle

		if v6 then
			backgroundStyle = v3.Inverse.Surface.Surface_0
		else
			backgroundStyle = v3.Color.ActionStandard.Background
		end

		v8.backgroundStyle = backgroundStyle

		function v8.onActivated()
			v4.onChipActivated(v5.font, k)
		end

		local createElement2 = React.createElement
		local v9 = {
			Text = v5.label,
			tag = "shrink auto-x text-label-medium text-truncate-end",
			fontStyle = { Font = v5.font },
			textStyle = 0
		}
		local textStyle

		if v6 then
			textStyle = v2
		else
			textStyle = v3.Color.ActionStandard.Foreground
		end

		v9.textStyle = textStyle
		children[v7] = createElement(View, v8, { Label = createElement2(Text, v9) })
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = p.LayoutOrder,
		Size = UDim2.new(1, 0, 0, Constants.TextOverlay.PickerRowHeight)
	}
	local v6 = {
		Scroll = React.createElement(Foundation.ScrollView, {
			Size = UDim2.new(1, 0, 1, 0),
			scrollingFrameRef = v4.scrollingFrameRef,
			onCanvasPositionChanged = v4.onScrollViewportChanged,
			onAbsoluteCanvasSizeChanged = v4.onScrollViewportChanged,
			onAbsoluteWindowSizeChanged = v4.onScrollViewportChanged,
			scroll = {
				scrollBarVisibility = Foundation.Enums.Visibility.None,
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticCanvasSize = Enum.AutomaticSize.X
			}
		}, {
			Row = React.createElement(
				View,
				{ tag = "row align-y-center gap-medium size-0-full auto-x padding-x-large" },
				children
			)
		}),
		LeftChevron = 0,
		RightChevron = 0
	}
	local leftChevron

	if v4.showLeftChevron then
		leftChevron = React.createElement(
			View,
			{ ZIndex = 2, tag = "position-center-left anchor-center-left auto-xy" },
			{
				Icon = React.createElement(IconButton, {
					icon = BuilderIcons.Icon.ChevronSmallLeft,
					onActivated = v4.onLeftChevronActivated,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		)
	end

	v6.LeftChevron = leftChevron
	local rightChevron

	if v4.showRightChevron then
		rightChevron = React.createElement(
			View,
			{ ZIndex = 2, tag = "position-center-right anchor-center-right auto-xy" },
			{
				Icon = React.createElement(IconButton, {
					icon = BuilderIcons.Icon.ChevronSmallRight,
					onActivated = v4.onRightChevronActivated,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		)
	end

	v6.RightChevron = rightChevron
	return createElement(View, v5, v6)
end

return TextFontRow

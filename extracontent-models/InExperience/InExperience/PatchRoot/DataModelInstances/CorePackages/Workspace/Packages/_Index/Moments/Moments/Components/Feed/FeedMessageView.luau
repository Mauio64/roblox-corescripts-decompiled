local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local FFlagMomentsParentTimeLimit = MomentsCommon.Flags.FFlagMomentsParentTimeLimit

local Button = Foundation.Button
local Icon = Foundation.Icon
local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor

local function renderGraphic(props, emphasis)
	if props.pictogram ~= nil then
		local asset = FoundationCloudAssets.Assets[props.pictogram]
		return React.createElement(Image, {
			LayoutOrder = 1,
			Image = asset.assetId,
			aspectRatio = asset.size.X / asset.size.Y,
			imageStyle = emphasis,
			tag = "size-full-0",
			Size = UDim2.new(1, 0, 0, 199),
			testId = "--moments-feed-message--pictogram"
		})
	end

	local iconName = props.iconName

	if iconName == nil then
		return nil
	end

	local v = React.createElement(Icon, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		name = iconName,
		size = props.iconSize or IconSize.Large,
		style = emphasis,
		testId = "--moments-feed-message--icon",
		ZIndex = 2
	})

	local frameRadiusTag = FFlagMomentsParentTimeLimit and props.frameRadiusTag or "radius-large"

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = 1,
		tag = "size-full-0",
		Size = UDim2.new(1, 0, 0, props.tilted and 180 or 140)
	}

	if props.tilted then
		v = React.createElement(
			View,
			{ tag = "position-center-center anchor-center-center", Size = UDim2.fromOffset(94, 94) },
			{
				TiltFrame = React.createElement(View, {
					tag = `position-center-center anchor-center-center stroke-standard stroke-default {frameRadiusTag}`,
					Size = UDim2.fromOffset(115, 115),
					Rotation = -15,
					testId = "--moments-feed-message--tilt-frame",
					ZIndex = 1
				}),
				Glyph = v
			}
		)
	end

	return createElement(View, v2, { Cluster = v })
end

local function FeedMessageView(props)
	local v = useTokens()
	local v2 = useFormFactor() == FormFactor.Wide
	local primaryAction = props.primaryAction

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center gap-xxlarge size-full-0 auto-y",
		sizeConstraint = 0,
		testId = 0
	}
	local maxSize

	if v2 then
		maxSize = Vector2.new(420, 1e999)
	end

	v3.sizeConstraint = { MaxSize = maxSize }

	v3.testId = props.testId or "--moments-feed-message"
	local v4 = {
		TextBlock = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "col align-x-center gap-medium size-full-0 auto-y" },
			{
				Graphic = renderGraphic(props, v.Color.Content.Emphasis),
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.title,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
				}),
				Description = React.createElement(Text, {
					LayoutOrder = 3,
					Text = props.description,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				})
			}
		),
		ButtonGroup = 0
	}
	local buttonGroup

	if primaryAction ~= nil then
		buttonGroup = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-center gap-small auto-xy"
		}, {
			Primary = React.createElement(Button, {
				LayoutOrder = 1,
				onActivated = primaryAction.onActivated,
				size = InputSize.Medium,
				text = primaryAction.text,
				testId = primaryAction.testId or "--moments-feed-message--primary",
				variant = ButtonVariant.Emphasis
			})
		})
	end

	v4.ButtonGroup = buttonGroup
	return createElement(View, v3, v4)
end

return FeedMessageView

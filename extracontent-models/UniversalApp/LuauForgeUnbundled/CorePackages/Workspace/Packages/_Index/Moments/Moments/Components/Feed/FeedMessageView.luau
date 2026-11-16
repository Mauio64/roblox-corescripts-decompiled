local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FoundationCloudAssets")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local button = Foundation.Button
local icon = Foundation.Icon
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local formFactor = MomentsCommon.Enums.FormFactor

local function renderGraphic(props, emphasis)
	if props.pictogram ~= nil then
		local asset = FoundationCloudAssets.Assets[props.pictogram]
		return React.createElement(image, {
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

	local v5 = React.createElement(icon, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		name = iconName,
		size = props.iconSize or iconSize.Large,
		style = emphasis,
		testId = "--moments-feed-message--icon",
		ZIndex = 2
	})

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = 1,
		tag = "size-full-0",
		Size = UDim2.new(1, 0, 0, props.tilted and 180 or 140)
	}

	if props.tilted then
		v5 = React.createElement(
			view,
			{
				tag = "position-center-center anchor-center-center",
				Size = UDim2.fromOffset(94, 94)
			},
			{
				TiltFrame = React.createElement(view, {
					tag = "position-center-center anchor-center-center stroke-standard stroke-default radius-large",
					Size = UDim2.fromOffset(115, 115),
					Rotation = -15,
					testId = "--moments-feed-message--tilt-frame",
					ZIndex = 1
				}),
				Glyph = v5
			}
		)
	end

	return createElement(view, v7, { Cluster = v5 })
end

local function FeedMessageView(props)
	local v5 = useTokens()
	local v6 = useFormFactor() == formFactor.Wide
	local primaryAction = props.primaryAction

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center gap-xxlarge size-full-0 auto-y",
		sizeConstraint = 0,
		testId = 0
	}

	local v10 = if v6 then Vector2.new(420, 1e999) else nil
	v8.sizeConstraint = { MaxSize = v10 }

	v8.testId = props.testId or "--moments-feed-message"
	local v11 = {
		TextBlock = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "col align-x-center gap-medium size-full-0 auto-y"
			},
			{
				Graphic = renderGraphic(props, v5.Color.Content.Emphasis),
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.title,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
				}),
				Description = React.createElement(text, {
					LayoutOrder = 3,
					Text = props.description,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				})
			}
		),
		ButtonGroup = 0
	}

	local v12 = if primaryAction ~= nil then React.createElement(
		view,
		{ LayoutOrder = 2, tag = "row align-x-center gap-small auto-xy" },
		{
			Primary = React.createElement(button, {
				LayoutOrder = 1,
				onActivated = primaryAction.onActivated,
				size = inputSize.Medium,
				text = primaryAction.text,
				testId = primaryAction.testId or "--moments-feed-message--primary",
				variant = buttonVariant.Emphasis
			})
		}
	) else nil
	v11.ButtonGroup = v12
	return createElement(view, v8, v11)
end

return FeedMessageView

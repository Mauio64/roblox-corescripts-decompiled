local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor

local v = {
	title = "Feature.Moments.Label.NonInfiniteScrollEndTitle",
	description = "Feature.Moments.Description.NonInfiniteScrollEndBody",
	loadMore = "Feature.Moments.Action.Continue"
}

local v2 = {
	title = "Feature.Moments.Label.FeedEndTitle",
	description = "Feature.Moments.Label.FeedEndBody"
}

local function resolveLocalized(p: string?, p2: string)
	return if p == nil or p == "" then p2 else p
end

local function MomentsEndStateView(props)
	local v3 = useTokens()
	local v4 = useFormFactor() == FormFactor.Wide
	local showLoadMore = props.showLoadMore ~= false
	local v5 = if showLoadMore then v else v2
	local v6 = useLocalization(v5)

	local title = v6.title
	local text = (title == nil or title == "") and "There are more Moments to watch" or title

	local description = v6.description
	local text2 = (description == nil or description == "")
		and "We've paused your feed. You can decide if you'd like to continue watching."
		or description

	local loadMore = v6.loadMore
	local text3 = (loadMore == nil or loadMore == "") and "Continue" or loadMore

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center align-y-center gap-xxlarge size-full clip bg-surface-0"
	}

	local createElement2 = React.createElement
	local maxSize

	if v4 then
		maxSize = Vector2.new(420, 1e999)
	end

	local v8 = {
		TextBlock = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "col align-x-center gap-medium size-full-0 auto-y" },
			{
				Graphic = React.createElement(
					View,
					{
						LayoutOrder = 1,
						tag = "align-x-center align-y-center size-full-0 auto-y",
						Size = UDim2.new(1, 0, 0, 180)
					},
					{
						IconCluster = React.createElement(
							View,
							{
								tag = "position-center-center anchor-center-center",
								Size = UDim2.fromOffset(94, 94),
								testId = "moments-end-state-icon-cluster"
							},
							{
								TiltFrame = React.createElement(View, {
									tag = "position-center-center anchor-center-center stroke-standard stroke-default radius-large",
									Size = UDim2.fromOffset(115, 115),
									Rotation = -15,
									testId = "moments-end-state-tilt-frame",
									ZIndex = 1
								}),
								Glyph = React.createElement(Icon, {
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5),
									name = "icons/brands/moments_large",
									size = IconSize.Large,
									style = v3.Color.Content.Emphasis,
									testId = "moments-end-state-brand-icon",
									ZIndex = 2
								})
							}
						)
					}
				),
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = text,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
				}),
				Description = React.createElement(Text, {
					LayoutOrder = 3,
					Text = text2,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				})
			}
		),
		ButtonGroup = 0
	}
	local buttonGroup

	if showLoadMore then
		buttonGroup = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "col align-x-center gap-small auto-y",
				Size = UDim2.fromOffset(200, 0)
			},
			{
				LoadMore = React.createElement(Button, {
					LayoutOrder = 1,
					fillBehavior = FillBehavior.Fill,
					onActivated = props.onLoadMore,
					size = InputSize.Medium,
					text = text3,
					testId = "moments-end-state-load-more",
					variant = ButtonVariant.Standard,
					width = UDim.new(1, 0)
				})
			}
		)
	end

	v8.ButtonGroup = buttonGroup
	return createElement(View, v7, {
		Content = createElement2(View, {
			tag = "col align-x-center gap-xxlarge size-full-0 auto-y",
			sizeConstraint = { MaxSize = maxSize }
		}, v8)
	})
end

return MomentsEndStateView

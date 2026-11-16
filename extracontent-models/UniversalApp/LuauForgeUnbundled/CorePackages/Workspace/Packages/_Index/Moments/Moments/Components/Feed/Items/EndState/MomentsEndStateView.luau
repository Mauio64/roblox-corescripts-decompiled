local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local button = Foundation.Button
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local formFactor = MomentsCommon.Enums.FormFactor

local v5 = {
	title = "Feature.Moments.Label.NonInfiniteScrollEndTitle",
	description = "Feature.Moments.Description.NonInfiniteScrollEndBody",
	loadMore = "Feature.Moments.Action.Continue"
}

local v6 = {
	title = "Feature.Moments.Label.FeedEndTitle",
	description = "Feature.Moments.Label.FeedEndBody"
}

local function resolveLocalized(p2, p3)
	if p2 == nil or p2 == "" then
		return p3
	end

	return p2
end

local function MomentsEndStateView(props)
	local v7 = useTokens()
	local v8 = useFormFactor() == formFactor.Wide
	local showLoadMore = props.showLoadMore ~= false
	local v10 = if showLoadMore then v5 else v6
	local v11 = useLocalization(v10)

	local title = v11.title
	local v12 = (title == nil or title == "") and "There are more Moments to watch" or title

	local description = v11.description
	local v13 = (description == nil or description == "")
		and "We've paused your feed. You can decide if you'd like to continue watching."
		or description

	local loadMore = v11.loadMore
	local v14 = (loadMore == nil or loadMore == "") and "Continue" or loadMore

	local createElement = React.createElement
	local v16 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center align-y-center gap-xxlarge size-full clip bg-surface-0"
	}

	local createElement2 = React.createElement

	local v21 = if v8 then Vector2.new(420, 1e999) else nil

	local v22 = {
		TextBlock = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "col align-x-center gap-medium size-full-0 auto-y"
			},
			{
				Graphic = React.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "align-x-center align-y-center size-full-0 auto-y",
						Size = UDim2.new(1, 0, 0, 180)
					},
					{
						IconCluster = React.createElement(
							view,
							{
								tag = "position-center-center anchor-center-center",
								Size = UDim2.fromOffset(94, 94),
								testId = "moments-end-state-icon-cluster"
							},
							{
								TiltFrame = React.createElement(view, {
									tag = "position-center-center anchor-center-center stroke-standard stroke-default radius-large",
									Size = UDim2.fromOffset(115, 115),
									Rotation = -15,
									testId = "moments-end-state-tilt-frame",
									ZIndex = 1
								}),
								Glyph = React.createElement(icon, {
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5),
									name = "icons/brands/moments_large",
									size = iconSize.Large,
									style = v7.Color.Content.Emphasis,
									testId = "moments-end-state-brand-icon",
									ZIndex = 2
								})
							}
						)
					}
				),
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = v12,
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
				}),
				Description = React.createElement(text, {
					LayoutOrder = 3,
					Text = v13,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				})
			}
		),
		ButtonGroup = 0
	}

	local v23 = if showLoadMore then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "col align-x-center gap-small auto-y",
			Size = UDim2.fromOffset(200, 0)
		},
		{
			LoadMore = React.createElement(button, {
				LayoutOrder = 1,
				fillBehavior = fillBehavior.Fill,
				onActivated = props.onLoadMore,
				size = inputSize.Medium,
				text = v14,
				testId = "moments-end-state-load-more",
				variant = buttonVariant.Standard,
				width = UDim.new(1, 0)
			})
		}
	) else nil
	v22.ButtonGroup = v23
	return createElement(view, v16, {
		Content = createElement2(view, {
			tag = "col align-x-center gap-xxlarge size-full-0 auto-y",
			sizeConstraint = { MaxSize = v21 }
		}, v22)
	})
end

return MomentsEndStateView

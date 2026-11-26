local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconSize = Foundation.Enums.IconSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local v5 = {
	title = "Feature.Moments.Label.MomentRemovedTitle",
	body = "Feature.Moments.Label.MomentRemovedBody"
}

local v6 = {
	title = "Feature.Moments.Label.MomentUnavailable",
	body = "Feature.Moments.Label.MomentUnavailableDefault"
}

local v7 = {
	duration = 0.75,
	easingStyle = { 0.37, 0, 0.63, 1 }
}

local function MomentUnavailableView(props)
	local v8 = useTokens()
	local v10 = if props.isModerated then v5 else v6
	local v11 = useLocalization(v10)
	local animate = props.animate

	local ref = React.useRef(animate)
	local ref2 = React.useRef(nil)
	local v12 = React.useCallback(function(p2)
		local current = ref2.current

		if ref.current and current ~= nil then
			current(ReactOtter.ease(p2 >= 0.5 and 0 or 1, v7))
		end
	end, {})
	local v13, v14 = ReactOtter.useAnimatedBinding(0, v12)

	React.useEffect(function()
		ref.current = animate
		ref2.current = v14

		if animate then
			v14(ReactOtter.ease(1, v7))
		else
			v14(ReactOtter.instant(0))
		end
	end, { animate, v14 })

	local v15 = 8 / v8.Size.Size_1200
	local mapped = v13:map(function(p2)
		return UDim2.fromScale(0.5, 0.5 + p2 * v15)
	end)

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "size-full bg-surface-0",
			testId = "moments-unavailable-moment"
		},
		{
			Content = React.createElement(
				view,
				{
					tag = "col align-x-center align-y-center size-full padding-x-xlarge",
					ZIndex = 1
				},
				{
					TextBlock = React.createElement(view, {
						tag = "col align-x-center gap-small size-full-0 auto-y",
						sizeConstraint = { MaxSize = Vector2.new(420, 1e999) }
					}, {
						Title = React.createElement(text, {
							LayoutOrder = 1,
							Text = v11.title,
							tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
						}),
						Body = React.createElement(text, {
							LayoutOrder = 2,
							Text = v11.body,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
						})
					})
				}
			),
			NextAffordance = React.createElement(view, {
				tag = "position-bottom-center anchor-bottom-center auto-xy",
				padding = {
					bottom = UDim.new(0, (props.bottomInset or 0) + v8.Padding.Small)
				},
				ZIndex = 2
			}, {
				NextButton = React.createElement(view, {
					tag = "size-1200 radius-circle",
					onActivated = props.onNext,
					stateLayer = { affordance = stateLayerAffordance.None },
					testId = "moments-unavailable-next"
				}, {
					Arrow = React.createElement(icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = mapped,
						name = BuilderIcons.Icon.DoubleChevronLargeDown,
						size = iconSize.Large,
						style = v8.Color.Content.Emphasis,
						testId = "moments-unavailable-next-arrow"
					})
				})
			})
		}
	)
end

return MomentUnavailableView

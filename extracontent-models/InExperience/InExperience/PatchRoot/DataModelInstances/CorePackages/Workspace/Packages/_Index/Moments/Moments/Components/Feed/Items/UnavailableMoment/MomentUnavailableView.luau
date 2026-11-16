local parent = script:FindFirstAncestor("Moments").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconSize = Foundation.Enums.IconSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local v = {
	title = "Feature.Moments.Label.MomentRemovedTitle",
	body = "Feature.Moments.Label.MomentRemovedBody"
}

local v2 = {
	title = "Feature.Moments.Label.MomentUnavailable",
	body = "Feature.Moments.Label.MomentUnavailableDefault"
}

local v3 = {
	duration = 0.75,
	easingStyle = { 0.37, 0, 0.63, 1 }
}

local function MomentUnavailableView(props)
	local v4 = useTokens()
	local v5 = if props.isModerated then v else v2
	local v6 = useLocalization(v5)
	local animate = props.animate

	local ref = React.useRef(animate)
	local ref2 = React.useRef(nil)
	local v7 = React.useCallback(function(p: number)
		local current = ref2.current

		if ref.current and current ~= nil then
			current(ReactOtter.ease(p >= 0.5 and 0 or 1, v3))
		end
	end, {})
	local v8, current = ReactOtter.useAnimatedBinding(0, v7)

	React.useEffect(function()
		ref.current = animate
		ref2.current = current

		if animate then
			current(ReactOtter.ease(1, v3))
		else
			current(ReactOtter.instant(0))
		end
	end, { animate, current })

	local v9 = 8 / v4.Size.Size_1200
	local mapped = v8:map(function(p: number)
		return UDim2.fromScale(0.5, 0.5 + p * v9)
	end)

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "size-full bg-surface-0",
			testId = "moments-unavailable-moment"
		},
		{
			Content = React.createElement(
				View,
				{ tag = "col align-x-center align-y-center size-full padding-x-xlarge", ZIndex = 1 },
				{
					TextBlock = React.createElement(View, {
						tag = "col align-x-center gap-small size-full-0 auto-y",
						sizeConstraint = { MaxSize = Vector2.new(420, 1e999) }
					}, {
						Title = React.createElement(Text, {
							LayoutOrder = 1,
							Text = v6.title,
							tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
						}),
						Body = React.createElement(Text, {
							LayoutOrder = 2,
							Text = v6.body,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
						})
					})
				}
			),
			NextAffordance = React.createElement(View, {
				tag = "position-bottom-center anchor-bottom-center auto-xy",
				padding = {
					bottom = UDim.new(0, (props.bottomInset or 0) + v4.Padding.Small)
				},
				ZIndex = 2
			}, {
				NextButton = React.createElement(View, {
					tag = "size-1200 radius-circle",
					onActivated = props.onNext,
					stateLayer = { affordance = StateLayerAffordance.None },
					testId = "moments-unavailable-next"
				}, {
					Arrow = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = mapped,
						name = BuilderIcons.Icon.DoubleChevronLargeDown,
						size = IconSize.Large,
						style = v4.Color.Content.Emphasis,
						testId = "moments-unavailable-next-arrow"
					})
				})
			})
		}
	)
end

return MomentUnavailableView

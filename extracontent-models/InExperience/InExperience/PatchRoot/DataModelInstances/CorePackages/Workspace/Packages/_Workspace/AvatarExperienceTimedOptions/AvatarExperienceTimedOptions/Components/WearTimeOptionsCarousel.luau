local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local View = Foundation.View
local Enums = Foundation.Enums

require(parent.AvatarExperienceCommon)
local WearTimeOptionButton = require(script.Parent.WearTimeOptionButton)

local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local AXTooltip = AvatarExperienceUIKit.AXTooltipComponents.AXTooltip

local function WearTimeOptionsCarousel(props)
	local v = useTokens()

	local v2 = useLocalization({
		wearTimeOptions = "Feature.Durables.ItemDetails.WearTimeOptions.Title",
		tooltipText = "Feature.Durables.FTUX.Tooltip"
	})

	local state, setState = React.useState(false)
	React.useEffect(function()
		local thread = task.delay(5, function()
			setState(false)
		end)

		return function()
			task.cancel(thread)
		end
	end, {})

	local state2, setState2 = React.useState(function()
		for k, option in props.options do
			if option.selected then
				return k
			end
		end

		return 1
	end)

	local v3 = React.useMemo(function()
		local children = {}

		for k, option in props.options do
			children[k] = React.createElement(WearTimeOptionButton, {
				option = {
					days = option.days,
					price = option.price,
					selected = k == state2
				},
				onActivated = function()
					setState2(k)

					if props.onOptionActivated then
						props.onOptionActivated(k)
					end
				end,
				LayoutOrder = k
			})
		end

		return children
	end, { props.options, state2, props.onOptionActivated })

	local element = React.createElement(View, { tag = "row gap-medium align-y-center auto-xy" }, {
		Options = React.createElement(React.Fragment, nil, v3)
	})
	local carouselContainer

	if props.useWrapping then
		carouselContainer = React.createElement(
			View,
			{
				tag = "row wrap gap-medium align-y-center size-full-0 auto-y",
				LayoutOrder = 2,
				wrap = true
			},
			v3
		)
	else
		carouselContainer = React.createElement(
			View,
			{
				tag = "size-full-0",
				Size = UDim2.new(1, 0, 0, v.Size.Size_1200),
				LayoutOrder = 2
			},
			{
				ScrollingFrame = React.createElement("ScrollingFrame", {
					Size = UDim2.new(1, 0, 1, 0),
					CanvasSize = UDim2.new(0, 0, 0, v.Size.Size_1200),
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.X,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					ElasticBehavior = Enum.ElasticBehavior.Always,
					Selectable = false
				}, element)
			}
		)
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = "size-full-0 auto-y col gap-medium"
	}, {
		Heading = React.createElement(View, {
			tag = "auto-xy row gap-xxsmall align-y-center",
			LayoutOrder = 1
		}, {
			HeadingText = React.createElement(Text, {
				Text = v2.wearTimeOptions,
				textStyle = v.Color.Content.Emphasis,
				fontStyle = {
					Font = v.Typography.TitleLarge.Font,
					FontSize = v.FontSize.FontSize_500
				},
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1
			}),
			InfoIconContainer = React.createElement(View, { tag = "auto-xy", LayoutOrder = 2 }, {
				InfoIcon = React.createElement(Foundation.IconButton, {
					icon = Enums.IconName.CircleI,
					size = Enums.IconSize.Small,
					onActivated = function()
						setState(true)
					end
				}),
				Tooltip = React.createElement(AXTooltip, {
					isOpen = state,
					popoverSide = "Top",
					tooltipText = v2.tooltipText,
					maxWidth = v.Size.Size_1200 * 3,
					onTooltipActivated = function()
						setState(false)
					end
				})
			})
		}),
		CarouselContainer = carouselContainer
	})
end

return WearTimeOptionsCarousel

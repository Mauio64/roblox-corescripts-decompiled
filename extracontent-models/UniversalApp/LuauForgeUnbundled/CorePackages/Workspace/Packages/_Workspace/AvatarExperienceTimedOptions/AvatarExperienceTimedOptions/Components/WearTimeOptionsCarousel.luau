local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local view = Foundation.View
local enums = Foundation.Enums

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceCommon")
local WearTimeOptionButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/WearTimeOptionButton")

local axTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceUIKit").AXTooltipComponents.AXTooltip

local function WearTimeOptionsCarousel(props)
	local v5 = useTokens()

	local v6 = useLocalization({
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

	local v7 = React.useMemo(function()
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

	local element = React.createElement(view, {
		tag = "row gap-medium align-y-center auto-xy"
	}, {
		Options = React.createElement(React.Fragment, nil, v7)
	})
	local v8

	if props.useWrapping then
		v8 = React.createElement(
			view,
			{
				tag = "row wrap gap-medium align-y-center size-full-0 auto-y",
				LayoutOrder = 2,
				wrap = true
			},
			v7
		)
	else
		v8 = React.createElement(
			view,
			{
				tag = "size-full-0",
				Size = UDim2.new(1, 0, 0, v5.Size.Size_1200),
				LayoutOrder = 2
			},
			{
				ScrollingFrame = React.createElement("ScrollingFrame", {
					Size = UDim2.new(1, 0, 1, 0),
					CanvasSize = UDim2.new(0, 0, 0, v5.Size.Size_1200),
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

	return React.createElement(
		view,
		{ LayoutOrder = props.LayoutOrder, tag = "size-full-0 auto-y col gap-medium" },
		{
			Heading = React.createElement(
				view,
				{ tag = "auto-xy row gap-xxsmall align-y-center", LayoutOrder = 1 },
				{
					HeadingText = React.createElement(text, {
						Text = v6.wearTimeOptions,
						textStyle = v5.Color.Content.Emphasis,
						fontStyle = {
							Font = v5.Typography.TitleLarge.Font,
							FontSize = v5.FontSize.FontSize_500
						},
						AutomaticSize = Enum.AutomaticSize.XY,
						LayoutOrder = 1
					}),
					InfoIconContainer = React.createElement(view, {
						tag = "auto-xy",
						LayoutOrder = 2
					}, {
						InfoIcon = React.createElement(Foundation.IconButton, {
							icon = enums.IconName.CircleI,
							size = enums.IconSize.Small,
							onActivated = function()
								setState(true)
							end
						}),
						Tooltip = React.createElement(axTooltip, {
							isOpen = state,
							popoverSide = "Top",
							tooltipText = v6.tooltipText,
							maxWidth = v5.Size.Size_1200 * 3,
							onTooltipActivated = function()
								setState(false)
							end
						})
					})
				}
			),
			CarouselContainer = v8
		}
	)
end

return WearTimeOptionsCarousel

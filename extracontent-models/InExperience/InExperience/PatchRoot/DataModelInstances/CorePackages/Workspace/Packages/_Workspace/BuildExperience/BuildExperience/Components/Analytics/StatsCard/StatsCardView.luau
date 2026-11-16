local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconPosition = Foundation.Enums.IconPosition
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local Radius = Foundation.Enums.Radius

local function StatsCardView(props)
	local v = useTokens()
	local testId = props.testId or "StatsCardView"
	local style

	if props.isDeltaPositive then
		style = v.Color.System.Success
	else
		style = v.Color.Content.Default
	end

	local name

	if props.isDeltaPositive then
		name = IconName.ArrowWideShortUp
	else
		name = IconName.ArrowWideShortDown
	end

	local v2 = (props.statIconPosition or IconPosition.Left) == IconPosition.Left
	local v3 = (props.deltaIconPosition or IconPosition.Left) == IconPosition.Left

	local backgroundStyle = props.isDeltaPositive
		and {
			Color3 = v.Color.System.Success.Color3,
			Transparency = v.Color.Shift.Shift_300.Transparency
		}
		or nil

	local isSelected = props.isSelected == true
	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col gap-xsmall size-full-0 auto-y padding-large stroke-standard radius-large clip"] = true,
			["stroke-emphasis bg-surface-100"] = isSelected,
			["stroke-default"] = not isSelected
		},
		testId = testId,
		onActivated = props.onActivated
	}
	local v5 = {
		Header = React.createElement(View, { LayoutOrder = 1, tag = "row size-full-0 auto-y" }, {
			Title = React.createElement(Text, {
				Text = props.title,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default",
				testId = `{testId}-title`
			})
		}),
		StatRow = 0
	}

	local createElement2 = React.createElement
	local v6

	if props.isLoading then
		v6 = {
			Loading = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v.Size.Size_500),
				radius = Radius.Small,
				testId = `{testId}-loading`
			})
		}
	else
		v6 = { Stat = 0, Delta = 0 }
		local createElement3 = React.createElement
		local icon

		if props.statIcon then
			icon = React.createElement(Icon, {
				LayoutOrder = v2 and 1 or 2,
				name = props.statIcon,
				size = IconSize.Small,
				tag = "content-emphasis",
				testId = `{testId}-stat-icon`
			})
		end

		v6.Stat = createElement3(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall auto-xy"
		}, {
			Icon = icon,
			Value = React.createElement(Text, {
				LayoutOrder = v2 and 2 or 1,
				Text = props.statText,
				tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
				testId = `{testId}-stat`
			})
		})
		local delta

		if props.deltaText ~= nil then
			local createElement4 = React.createElement
			local v7 = {
				LayoutOrder = 2,
				tag = {
					["row align-y-center gap-xxsmall auto-xy padding-y-xxsmall padding-left-xsmall padding-right-small radius-small"] = true,
					["bg-shift-200"] = not props.isDeltaPositive
				},
				backgroundStyle = backgroundStyle,
				testId = `{testId}-delta`
			}
			local v8 = {
				Arrow = React.createElement(Icon, {
					LayoutOrder = 1,
					name = name,
					size = IconSize.XSmall,
					variant = IconVariant.Filled,
					style = style
				}),
				Icon = 0,
				Value = 0
			}
			local icon2

			if props.deltaIcon then
				icon2 = React.createElement(Icon, {
					LayoutOrder = v3 and 2 or 3,
					name = props.deltaIcon,
					size = IconSize.XSmall,
					tag = "content-default",
					testId = `{testId}-delta-icon`
				})
			end

			v8.Icon = icon2

			v8.Value = React.createElement(Text, {
				LayoutOrder = v3 and 3 or 2,
				Text = props.deltaText,
				tag = "auto-xy text-caption-small text-align-x-left content-default"
			})
			delta = createElement4(View, v7, v8)
		end

		v6.Delta = delta
	end

	v5.StatRow = createElement2(View, {
		LayoutOrder = 2,
		tag = "row align-y-center gap-small size-full-0 auto-y"
	}, v6)
	return createElement(View, v4, v5)
end

return StatsCardView

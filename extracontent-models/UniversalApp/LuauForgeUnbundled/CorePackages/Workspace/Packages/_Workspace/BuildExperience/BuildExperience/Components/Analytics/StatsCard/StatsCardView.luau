local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local iconName = Foundation.Enums.IconName
local iconPosition = Foundation.Enums.IconPosition
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local radius = Foundation.Enums.Radius

local function StatsCardView(props)
	local v5 = useTokens()
	local testId = props.testId or "StatsCardView"

	local v6 = if props.isDeltaPositive then v5.Color.System.Success else v5.Color.Content.Default
	local v7 = if props.isDeltaPositive then iconName.ArrowWideShortUp else iconName.ArrowWideShortDown

	local v8 = (props.statIconPosition or iconPosition.Left) == iconPosition.Left
	local v9 = (props.deltaIconPosition or iconPosition.Left) == iconPosition.Left

	local v10 = props.isDeltaPositive
		and {
			Color3 = v5.Color.System.Success.Color3,
			Transparency = v5.Color.Shift.Shift_300.Transparency
		}
		or nil

	local isSelected = props.isSelected == true
	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col gap-xsmall size-full-0 auto-y padding-large stroke-standard radius-large clip"] = true,
			["stroke-emphasis bg-surface-100"] = isSelected,
			["stroke-default"] = not isSelected
		},
		testId = testId,
		onActivated = props.onActivated
	}
	local v13 = {
		Header = React.createElement(view, {
			LayoutOrder = 1,
			tag = "row size-full-0 auto-y"
		}, {
			Title = React.createElement(text, {
				Text = props.title,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default",
				testId = `{testId}-title`
			})
		}),
		StatRow = 0
	}

	local createElement2 = React.createElement
	local v16

	if props.isLoading then
		v16 = {
			Loading = React.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v5.Size.Size_500),
				radius = radius.Small,
				testId = `{testId}-loading`
			})
		}
	else
		v16 = { Stat = 0, Delta = 0 }
		local createElement3 = React.createElement

		local v20 = if props.statIcon then React.createElement(icon, {
			LayoutOrder = v8 and 1 or 2,
			name = props.statIcon,
			size = iconSize.Small,
			tag = "content-emphasis",
			testId = `{testId}-stat-icon`
		}) else nil
		v16.Stat = createElement3(
			view,
			{ LayoutOrder = 1, tag = "row align-y-center gap-xsmall auto-xy" },
			{
				Icon = v20,
				Value = React.createElement(text, {
					LayoutOrder = v8 and 2 or 1,
					Text = props.statText,
					tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
					testId = `{testId}-stat`
				})
			}
		)
		local v21

		if props.deltaText ~= nil then
			local createElement4 = React.createElement
			local v23 = {
				LayoutOrder = 2,
				tag = {
					["row align-y-center gap-xxsmall auto-xy padding-y-xxsmall padding-left-xsmall padding-right-small radius-small"] = true,
					["bg-shift-200"] = not props.isDeltaPositive
				},
				backgroundStyle = v10,
				testId = `{testId}-delta`
			}
			local v24 = {
				Arrow = React.createElement(icon, {
					LayoutOrder = 1,
					name = v7,
					size = iconSize.XSmall,
					variant = iconVariant.Filled,
					style = v6
				}),
				Icon = 0,
				Value = 0
			}

			local v25 = if props.deltaIcon then React.createElement(icon, {
				LayoutOrder = v9 and 2 or 3,
				name = props.deltaIcon,
				size = iconSize.XSmall,
				tag = "content-default",
				testId = `{testId}-delta-icon`
			}) else nil
			v24.Icon = v25

			v24.Value = React.createElement(text, {
				LayoutOrder = v9 and 3 or 2,
				Text = props.deltaText,
				tag = "auto-xy text-caption-small text-align-x-left content-default"
			})
			v21 = createElement4(view, v23, v24)
		end

		v16.Delta = v21
	end

	v13.StatRow = createElement2(
		view,
		{ LayoutOrder = 2, tag = "row align-y-center gap-small size-full-0 auto-y" },
		v16
	)
	return createElement(view, v12, v13)
end

return StatsCardView

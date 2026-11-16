local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local button = Foundation.Button
local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function MetricItem(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "row align-y-center gap-xxsmall auto-xy",
		testId = props.testId
	}
	local v8 = {
		Icon = React.createElement(icon, {
			LayoutOrder = 1,
			name = props.iconName,
			size = iconSize.XSmall,
			tag = "content-action-standard"
		}),
		Value = 0
	}
	local v9

	if props.value == nil then
		if props.isLoading then
			v9 = React.createElement(skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v5.Size.Size_200, v5.Size.Size_300),
				radius = radius.Small,
				testId = `{props.testId}-skeleton`
			})
		end
	else
		v9 = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.value,
			tag = "auto-xy text-caption-medium content-action-standard"
		})
	end

	v8.Value = v9
	return createElement(view, v7, v8)
end

local function LiveVersionCardView(props)
	local testId = props.testId or "LiveVersionCardView"
	local v5 = props.totalUpVotes ~= nil
		or props.totalVisits ~= nil
		or (props.isTotalUpVotesLoading or props.isTotalVisitsLoading)

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium radius-large clip bg-shift-200",
		testId = testId
	}

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		tag = "col gap-xxsmall size-full-0 auto-y",
		testId = `{testId}-content`
	}

	local createElement3 = React.createElement
	local v11 = {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-top gap-small size-full-0 auto-y",
		testId = `{testId}-eyebrow`
	}
	local v12 = {
		VersionAndTitle = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "col align-x-left align-y-top fill gap-xxsmall auto-y"
			},
			{
				Version = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.versionLabel,
					tag = "size-full-0 auto-y text-caption-medium text-align-x-left content-muted",
					testId = `{testId}-version`
				}),
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.title,
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
					testId = `{testId}-title`
				})
			}
		),
		Metrics = 0
	}
	local v13

	if v5 then
		local createElement4 = React.createElement
		local v15 = {
			LayoutOrder = 2,
			tag = "row align-y-center gap-small auto-xy padding-x-small padding-y-xsmall radius-small bg-action-standard",
			testId = `{testId}-metrics`
		}

		local v17 = if props.totalVisits ~= nil or not not props.isTotalVisitsLoading then React.createElement(MetricItem, {
			layoutOrder = 1,
			iconName = iconName.Eye,
			value = props.totalVisits,
			isLoading = props.isTotalVisitsLoading,
			testId = `{testId}-total-visits`
		}) else nil

		local v18 = if props.totalUpVotes ~= nil or not not props.isTotalUpVotesLoading then React.createElement(MetricItem, {
			layoutOrder = 2,
			iconName = iconName.ThumbUp,
			value = props.totalUpVotes,
			isLoading = props.isTotalUpVotesLoading,
			testId = `{testId}-total-up-votes`
		}) else nil
		v13 = createElement4(view, v15, { TotalVisits = v17, TotalUpVotes = v18 })
	end

	v12.Metrics = v13
	return createElement(view, v7, {
		Content = createElement2(view, v9, {
			Eyebrow = createElement3(view, v11, v12),
			Description = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.description,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
				testId = `{testId}-description`
			})
		}),
		Actions = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row size-full-0 auto-y",
				testId = `{testId}-actions`
			},
			{
				Play = React.createElement(button, {
					text = props.playText,
					icon = iconName.PlaySmall,
					size = inputSize.Small,
					variant = buttonVariant.SoftEmphasis,
					fillBehavior = fillBehavior.Fill,
					isDisabled = props.isPlayDisabled,
					onActivated = props.onPlayActivated,
					testId = `{testId}-play`
				})
			}
		)
	})
end

return LiveVersionCardView

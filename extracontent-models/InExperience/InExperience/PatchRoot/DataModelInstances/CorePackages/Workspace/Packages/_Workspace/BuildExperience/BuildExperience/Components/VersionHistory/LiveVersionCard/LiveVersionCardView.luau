local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function MetricItem(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "row align-y-center gap-xxsmall auto-xy",
		testId = props.testId
	}
	local v3 = {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = props.iconName,
			size = IconSize.XSmall,
			tag = "content-action-standard"
		}),
		Value = 0
	}
	local v4

	if props.value == nil then
		if props.isLoading then
			v4 = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v.Size.Size_200, v.Size.Size_300),
				radius = Radius.Small,
				testId = `{props.testId}-skeleton`
			})
		end
	else
		v4 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.value,
			tag = "auto-xy text-caption-medium content-action-standard"
		})
	end

	v3.Value = v4
	return createElement(View, v2, v3)
end

local function LiveVersionCardView(props)
	local testId = props.testId or "LiveVersionCardView"
	local v = props.totalUpVotes ~= nil
		or props.totalVisits ~= nil
		or (props.isTotalUpVotesLoading or props.isTotalVisitsLoading)

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium radius-large clip bg-shift-200",
		testId = testId
	}

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = "col gap-xxsmall size-full-0 auto-y",
		testId = `{testId}-content`
	}

	local createElement3 = React.createElement
	local v4 = {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-top gap-small size-full-0 auto-y",
		testId = `{testId}-eyebrow`
	}
	local v5 = {
		VersionAndTitle = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "col align-x-left align-y-top fill gap-xxsmall auto-y" },
			{
				Version = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.versionLabel,
					tag = "size-full-0 auto-y text-caption-medium text-align-x-left content-muted",
					testId = `{testId}-version`
				}),
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.title,
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
					testId = `{testId}-title`
				})
			}
		),
		Metrics = 0
	}
	local metrics

	if v then
		local createElement4 = React.createElement
		local v6 = {
			LayoutOrder = 2,
			tag = "row align-y-center gap-small auto-xy padding-x-small padding-y-xsmall radius-small bg-action-standard",
			testId = `{testId}-metrics`
		}
		local totalVisits

		if not (props.totalVisits == nil and not props.isTotalVisitsLoading) then
			totalVisits = React.createElement(MetricItem, {
				layoutOrder = 1,
				iconName = IconName.Eye,
				value = props.totalVisits,
				isLoading = props.isTotalVisitsLoading,
				testId = `{testId}-total-visits`
			})
		end

		local totalUpVotes

		if not (props.totalUpVotes == nil and not props.isTotalUpVotesLoading) then
			totalUpVotes = React.createElement(MetricItem, {
				layoutOrder = 2,
				iconName = IconName.ThumbUp,
				value = props.totalUpVotes,
				isLoading = props.isTotalUpVotesLoading,
				testId = `{testId}-total-up-votes`
			})
		end

		metrics = createElement4(View, v6, {
			TotalVisits = totalVisits,
			TotalUpVotes = totalUpVotes
		})
	end

	v5.Metrics = metrics
	return createElement(View, v2, {
		Content = createElement2(View, v3, {
			Eyebrow = createElement3(View, v4, v5),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.description,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
				testId = `{testId}-description`
			})
		}),
		Actions = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "row size-full-0 auto-y", testId = `{testId}-actions` },
			{
				Play = React.createElement(Button, {
					text = props.playText,
					icon = IconName.PlaySmall,
					size = InputSize.Small,
					variant = ButtonVariant.SoftEmphasis,
					fillBehavior = FillBehavior.Fill,
					isDisabled = props.isPlayDisabled,
					onActivated = props.onPlayActivated,
					testId = `{testId}-play`
				})
			}
		)
	})
end

return LiveVersionCardView

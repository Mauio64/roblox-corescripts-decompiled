local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local noDataPlaceholder = require(BuildExperience.Components.Analytics.noDataPlaceholder)

local Text = Foundation.Text
local View = Foundation.View

local function metricCell(layoutOrder: number, text: string, p: number?, robloxLocaleId: string, testId: string)
	local createElement = React.createElement

	local v = {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = text,
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-default"
		}),
		Value = 0
	}

	local createElement2 = React.createElement
	local text2

	if p == nil then
		text2 = noDataPlaceholder
	else
		text2 = NumberLocalization.localizeDecimal(p, robloxLocaleId, 0)
	end

	v.Value = createElement2(Text, {
		LayoutOrder = 2,
		Text = text2,
		tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
		testId = testId
	})
	return createElement(View, { LayoutOrder = layoutOrder, tag = "col fill gap-xxsmall auto-y" }, v)
end

local function PastCampaignRow(props)
	local testId = props.testId or "PastCampaignRow"
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-small size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
			testId = testId
		},
		{
			Date = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.dateText,
				tag = "size-full-0 auto-y text-title-small text-align-x-left content-emphasis",
				testId = `{testId}-date`
			}),
			Metrics = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row gap-medium size-full-0 auto-y"
			}, {
				AdViews = metricCell(1, props.labels.adViews, props.adViews, robloxLocaleId, `{testId}-ad-views`),
				AdClicks = metricCell(2, props.labels.adClicks, props.adClicks, robloxLocaleId, `{testId}-ad-clicks`),
				GamePlays = metricCell(
					3,
					props.labels.gamePlays,
					props.gamePlays,
					robloxLocaleId,
					`{testId}-game-plays`
				)
			})
		}
	)
end

return PastCampaignRow

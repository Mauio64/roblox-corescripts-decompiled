local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization
local noDataPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/noDataPlaceholder")

local text = Foundation.Text
local view = Foundation.View

local function metricCell(p2, p3, p4, robloxLocaleId, testId)
	local createElement = React.createElement

	local v7 = {
		Label = React.createElement(text, {
			LayoutOrder = 1,
			Text = p3,
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-default"
		}),
		Value = 0
	}

	local createElement2 = React.createElement

	local v10 = if p4 == nil then noDataPlaceholder else numberLocalization.localizeDecimal(p4, robloxLocaleId, 0)
	v7.Value = createElement2(text, {
		LayoutOrder = 2,
		Text = v10,
		tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
		testId = testId
	})
	return createElement(view, { LayoutOrder = p2, tag = "col fill gap-xxsmall auto-y" }, v7)
end

local function PastCampaignRow(props)
	local testId = props.testId or "PastCampaignRow"
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-small size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
			testId = testId
		},
		{
			Date = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.dateText,
				tag = "size-full-0 auto-y text-title-small text-align-x-left content-emphasis",
				testId = `{testId}-date`
			}),
			Metrics = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "row gap-medium size-full-0 auto-y" },
				{
					AdViews = metricCell(
						1,
						props.labels.adViews,
						props.adViews,
						robloxLocaleId,
						`{testId}-ad-views`
					),
					AdClicks = metricCell(
						2,
						props.labels.adClicks,
						props.adClicks,
						robloxLocaleId,
						`{testId}-ad-clicks`
					),
					GamePlays = metricCell(
						3,
						props.labels.gamePlays,
						props.gamePlays,
						robloxLocaleId,
						`{testId}-game-plays`
					)
				}
			)
		}
	)
end

return PastCampaignRow

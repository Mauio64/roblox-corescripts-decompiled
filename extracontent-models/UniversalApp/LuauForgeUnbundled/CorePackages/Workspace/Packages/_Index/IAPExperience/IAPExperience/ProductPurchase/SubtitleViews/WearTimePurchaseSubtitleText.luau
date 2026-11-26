local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local enums = Foundation.Enums

local function WearTimePurchaseSubtitleText(p2)
	local timedOptionDays = p2.timedOptionDays

	local v5 = useLocalization({
		timedOptionText = {
			"Feature.Durables.UnifiedBuyModal.Subtitle.TimedOptionText",
			days = timedOptionDays or 0
		},
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite"
	})

	local createElement = React.createElement

	local v9 = if timedOptionDays then React.createElement(icon, {
		LayoutOrder = 1,
		name = enums.IconName.Clock,
		size = enums.IconSize.Small
	}) else nil

	local createElement2 = React.createElement

	local v12 = if timedOptionDays and timedOptionDays ~= 0 then v5.timedOptionText else v5.infinite
	return createElement(view, {
		tag = "row auto-xy align-y-center gap-xsmall",
		LayoutOrder = 2
	}, {
		ClockIcon = v9,
		DurationText = createElement2(text, {
			LayoutOrder = 2,
			Text = v12,
			tag = "auto-xy text-title-small content-default"
		})
	})
end

return WearTimePurchaseSubtitleText

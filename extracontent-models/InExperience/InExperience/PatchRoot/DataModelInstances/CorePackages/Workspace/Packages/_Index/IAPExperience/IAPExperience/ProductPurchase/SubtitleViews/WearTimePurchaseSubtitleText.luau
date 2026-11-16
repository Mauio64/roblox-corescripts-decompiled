local parent = script:FindFirstAncestor("IAPExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local function WearTimePurchaseSubtitleText(p)
	local timedOptionDays = p.timedOptionDays

	local v = useLocalization({
		timedOptionText = {
			"Feature.Durables.UnifiedBuyModal.Subtitle.TimedOptionText",
			days = timedOptionDays or 0
		},
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite"
	})

	local createElement = React.createElement
	local clockIcon

	if timedOptionDays then
		clockIcon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = Enums.IconName.Clock,
			size = Enums.IconSize.Small
		})
	end

	local createElement2 = React.createElement
	local text

	if timedOptionDays and timedOptionDays ~= 0 then
		text = v.timedOptionText
	else
		text = v.infinite
	end

	return createElement(View, { tag = "row auto-xy align-y-center gap-xsmall", LayoutOrder = 2 }, {
		ClockIcon = clockIcon,
		DurationText = createElement2(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "auto-xy text-title-small content-default"
		})
	})
end

return WearTimePurchaseSubtitleText

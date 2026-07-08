local Parent = script:FindFirstAncestor("IAPExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local function WearTimePurchaseSubtitleText(t1: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), React (copy), View (copy), Icon (copy), Enums (copy), FoundationText (copy)
	local timedOptionDays = t1.timedOptionDays
	local v12 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		timedOptionText = {
			"Feature.Durables.UnifiedBuyModal.Subtitle.TimedOptionText",
			days = timedOptionDays or 0
		}
	})

	return React.createElement(View, {
		tag = "row auto-xy align-y-center gap-xsmall",
		LayoutOrder = 2
	}, {
		ClockIcon = if not timedOptionDays then nil else React.createElement(Icon, {
			LayoutOrder = 1,
			name = Enums.IconName.Clock,
			size = Enums.IconSize.Small
		}),
		DurationText = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-title-small content-default",
			Text = if not timedOptionDays or timedOptionDays == 0 then v12.infinite else v12.timedOptionText
		})
	})
end

return WearTimePurchaseSubtitleText

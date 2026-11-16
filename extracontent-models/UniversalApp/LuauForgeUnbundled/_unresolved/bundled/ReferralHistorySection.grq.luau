local module = require("@luauforge/bundled/grg")
local module2 = require("@luauforge/bundled/gri")
local view = module2.View
local text = module2.Text
local iconName = module2.Enums.IconName

local module3 = require("@luauforge/bundled/grr")

local function ReferralHistorySection(props)
	local v5 = not (props.pendingRobux == nil) and props.pendingRobuxLabel ~= nil

	local createElement = module.createElement
	local v7 = {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}
	local v8 = {
		Header = module.createElement(text, {
			tag = "auto-xy text-title-large text-align-x-left content-emphasis",
			Text = props.heading,
			LayoutOrder = 1
		}),
		Stats = 0
	}

	local createElement2 = module.createElement

	local v11 = {
		SuccessfulReferrals = module.createElement(module3, {
			label = props.successfulReferralsLabel,
			value = props.successfulReferrals,
			layoutOrder = 1
		}),
		RobuxEarned = module.createElement(module3, {
			label = props.robuxEarnedLabel,
			value = props.robuxEarned,
			valueIconName = iconName.Robux,
			layoutOrder = 2
		}),
		PendingRobux = 0
	}

	local v12 = if v5 then module.createElement(module3, {
		label = props.pendingRobuxLabel,
		value = props.pendingRobux,
		valueIconName = iconName.Robux,
		layoutOrder = 3
	}) else nil
	v11.PendingRobux = v12
	v8.Stats = createElement2(
		view,
		{ tag = "row wrap gap-medium size-full-0 auto-y", LayoutOrder = 2 },
		v11
	)
	return createElement(view, v7, v8)
end

return ReferralHistorySection

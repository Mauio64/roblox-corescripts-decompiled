local module = require("@luauforge/deferred/gQN")
local module2 = require("@luauforge/deferred/gQM")

local fFlagAXBackgroundGenerationAnalytics = require("@luauforge/deferred/gQK").FFlagAXBackgroundGenerationAnalytics

local module3 = require("@luauforge/deferred/gRB")

local function BackgroundsPlusSectionHeader(props)
	local v5 = not (props.actionText == nil) and props.onActionActivated ~= nil

	local createElement = module2.createElement
	local view = module.View
	local v6 = {
		tag = "row align-y-center gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		testId = "BackgroundsPlusSectionHeader",
		ref = 0
	}

	local v7 = if fFlagAXBackgroundGenerationAnalytics then props.impressionRef else nil
	v6.ref = v7
	local v8 = {
		PlusIcon = module2.createElement(module.Icon, {
			name = module.Enums.IconName.RobloxPlus,
			variant = module.Enums.IconVariant.Regular,
			size = module.Enums.IconSize.Medium,
			LayoutOrder = 1,
			testId = "BackgroundsPlusSectionHeaderPlusIcon"
		}),
		Title = module2.createElement(module.Text, {
			Text = props.title,
			tag = "shrink auto-xy text-heading-small text-no-wrap text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 2
		}),
		Spacer = 0,
		Action = 0
	}

	local v9 = if v5 then module2.createElement(module.View, {
		tag = "fill auto-y",
		LayoutOrder = 4
	}) else nil
	v8.Spacer = v9

	local v10 = if v5 then module2.createElement(module3, {
		text = props.actionText,
		onActivated = props.onActionActivated,
		LayoutOrder = 5,
		testId = "BackgroundsPlusSectionHeaderAction"
	}) else nil
	v8.Action = v10
	return createElement(view, v6, v8)
end

return module2.memo(BackgroundsPlusSectionHeader)

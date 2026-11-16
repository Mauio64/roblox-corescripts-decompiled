local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")

local view = Foundation.View
local text = Foundation.Text
local iconButton = Foundation.IconButton

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local buttonVariant = Foundation.Enums.ButtonVariant

local function SchoolsPageHeader(props)
	local createElement = module.createElement
	local v6 = {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge padding-y-small bg-surface-0",
		LayoutOrder = props.layoutOrder,
		testId = props.testId
	}
	local v7 = {
		BackButton = module.createElement(iconButton, {
			icon = iconName.ChevronLargeLeft,
			size = iconSize.Medium,
			variant = buttonVariant.Utility,
			onActivated = props.onBack,
			LayoutOrder = 1
		}),
		Title = module.createElement(text, {
			tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
			Text = props.title,
			LayoutOrder = 2
		}),
		Trailing = 0
	}

	local v8 = if props.renderTrailing then module.createElement(
		view,
		{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = 3 },
		props.renderTrailing()
	) else nil
	v7.Trailing = v8
	return createElement(view, v6, v7)
end

return SchoolsPageHeader

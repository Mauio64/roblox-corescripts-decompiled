local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local badge = Foundation.Badge

local enums = Foundation.Enums
local iconName = enums.IconName
local iconSize = enums.IconSize
local badgeShape = enums.BadgeShape
local badgeSize = enums.BadgeSize
local badgeVariant = enums.BadgeVariant

local function RobloxPlusThemeGroupHeader(props)
	local v5 = Foundation.Hooks.useTokens()

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-y-center gap-small size-full-0 auto-y",
		testId = props.testId
	}

	local createElement2 = React.createElement

	local v12 = if props.showPlusIcon then React.createElement(icon, {
		LayoutOrder = 1,
		name = iconName.RobloxPlus,
		size = iconSize.Small,
		style = v5.Color.Content.Default
	}) else nil

	local createElement3 = React.createElement
	local v14 = {
		LayoutOrder = 2,
		Text = props.title,
		tag = "auto-xy text-title-medium text-align-x-left content-default",
		testId = 0
	}

	local v15 = if props.testId then `{props.testId}--title` else nil
	v14.testId = v15
	local v8 = {
		TitleGroup = createElement2(
			view,
			{ LayoutOrder = 1, tag = "row align-y-center gap-xsmall auto-xy" },
			{ PlusIcon = v12, Title = createElement3(text, v14) }
		),
		Badge = 0
	}

	local v16 = if props.badgeText ~= nil then React.createElement(badge, {
		LayoutOrder = 2,
		text = props.badgeText,
		variant = badgeVariant.Contrast,
		shape = badgeShape.Box,
		size = badgeSize.XSmall
	}) else nil
	v8.Badge = v16
	return createElement(view, v7, v8)
end

return RobloxPlusThemeGroupHeader

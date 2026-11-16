local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function escapeRichText(text: string) -- 1 equivalent call inferred from this helper
	return (text:gsub("[&<>\"']", {
		["&"] = "&amp;",
		["<"] = "&lt;",
		[">"] = "&gt;",
		["\""] = "&quot;",
		["'"] = "&apos;"
	}))
end

local function DesktopOfferBanner(props)
	local name = props.icon and IconName[props.icon] or IconName.Tag

	local createElement = React.createElement
	local v = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-large padding-y-medium radius-medium bg-shift-200",
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}
	local v2 = {
		BannerIcon = React.createElement(Icon, {
			name = name,
			size = IconSize.Medium,
			variant = IconVariant.Filled,
			LayoutOrder = 1,
			testId = "DesktopOfferBanner_Icon"
		}),
		Message = React.createElement(Text, {
			Text = props.text,
			tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 2,
			testId = "DesktopOfferBanner_Text"
		}),
		Link = 0
	}
	local link

	if props.link then
		link = React.createElement(Text, {
			Text = `<u>{escapeRichText(props.link.text)}</u>`,
			RichText = true,
			tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
			stateLayer = { affordance = StateLayerAffordance.None },
			onActivated = props.link.onActivated,
			LayoutOrder = 3,
			testId = "DesktopOfferBanner_Link"
		}) -- inferred equivalent call
	end

	v2.Link = link
	return createElement(View, v, v2)
end

return DesktopOfferBanner

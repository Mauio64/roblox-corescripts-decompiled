local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")

local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")
local FFlagMomentsActionRailSpacing = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsActionRailSpacing")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function formatCount(p2, p3)
	if p2 == nil then
		return ""
	end

	local v5

	if p2 >= 1000000 then
		v5 = string.format("%.1fM", p2 / 1000000)
	else
		v5 = if p2 >= 1000 then string.format("%.1fK", p2 / 1000) else tostring(p2)
	end

	if p3 then
		return `{v5}+`
	end

	return v5
end

local function RailItem(props)
	local count = props.count

	local nextOrder = ReactUtils.createNextOrder()
	local v5 = useTokens()

	local mapped = props.animationRatio:map(function(p2)
		return getColorStyleWithTransparency(v5.Color.Content.Emphasis, p2)
	end)

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = FFlagMomentsActionRailSpacing and "col align-x-center align-y-center gap-small size-1200-1200 auto-xy radius-medium" or "col align-x-center align-y-center gap-xsmall size-1200-1200 radius-medium",
		isDisabled = props.isDisabled,
		onActivated = props.onActivated,
		ref = props.nativeRef,
		testId = props.testId
	}

	local v10 = if type(props.slot) == "string" then React.createElement(icon, {
		LayoutOrder = nextOrder(),
		name = props.slot,
		size = iconSize.Large,
		style = mapped
	}) else React.createElement(view, {
		tag = "auto-xy",
		Active = props.isDisabled ~= false,
		LayoutOrder = nextOrder()
	}, props.slot)
	local v11

	if count then
		v11 = React.createElement(text, {
			LayoutOrder = nextOrder(),
			tag = "auto-xy text-caption-large text-align-x-center content-emphasis",
			Text = count:map(function(p2)
				return formatCount(p2, props.countIsCapped == true)
			end),
			Visible = count:map(function(p2): boolean
				return p2 ~= nil
			end),
			textStyle = mapped
		})
	end

	return createElement(view, v8, { Slot = v10, Count = v11 })
end

return React.memo(RailItem)

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local Foundation = require(parent.Foundation)

local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local FFlagMomentsActionRailSpacing = require(Moments.Flags.FFlagMomentsActionRailSpacing)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function formatCount(p: number?, flag: boolean)
	if p == nil then
		return ""
	end

	local v

	if p >= 1000000 then
		v = string.format("%.1fM", p / 1000000)
	elseif p >= 1000 then
		v = string.format("%.1fK", p / 1000)
	else
		v = tostring(p)
	end

	if flag then
		return `{v}+`
	end

	return v
end

local function RailItem(props)
	local count = props.count

	local nextOrder = ReactUtils.createNextOrder()
	local v = useTokens()

	local mapped = props.animationRatio:map(function(p: number)
		return getColorStyleWithTransparency(v.Color.Content.Emphasis, p)
	end)

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = FFlagMomentsActionRailSpacing and "col align-x-center align-y-center gap-small size-1200-1200 auto-xy radius-medium" or "col align-x-center align-y-center gap-xsmall size-1200-1200 radius-medium",
		isDisabled = props.isDisabled,
		onActivated = props.onActivated,
		ref = props.nativeRef,
		testId = props.testId
	}
	local slot

	if type(props.slot) == "string" then
		slot = React.createElement(Icon, {
			LayoutOrder = nextOrder(),
			name = props.slot,
			size = IconSize.Large,
			style = mapped
		})
	else
		slot = React.createElement(View, {
			tag = "auto-xy",
			Active = props.isDisabled ~= false,
			LayoutOrder = nextOrder()
		}, props.slot)
	end

	local count2

	if count then
		count2 = React.createElement(Text, {
			LayoutOrder = nextOrder(),
			tag = "auto-xy text-caption-large text-align-x-center content-emphasis",
			Text = count:map(function(p: number?)
				return formatCount(p, props.countIsCapped == true)
			end),
			Visible = count:map(function(p: number?): boolean
				return p ~= nil
			end),
			textStyle = mapped
		})
	end

	return createElement(View, v2, { Slot = slot, Count = count2 })
end

return React.memo(RailItem)

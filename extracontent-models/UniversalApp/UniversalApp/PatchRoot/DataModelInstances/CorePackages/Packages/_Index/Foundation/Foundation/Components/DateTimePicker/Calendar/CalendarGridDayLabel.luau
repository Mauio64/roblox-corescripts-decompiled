local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local ControlState = require(Foundation.Enums.ControlState)

local StateLayerMode = require(Foundation.Enums.StateLayerMode)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function buildDayTags(flag: boolean, bandRadiusTag: string?) -- 1 equivalent call inferred from this helper
	local dayTags = {
		["size-full text-title-small text-align-x-center text-align-y-center"] = true,
		["radius-circle"] = not flag
	}

	if flag and bandRadiusTag and bandRadiusTag ~= "" then
		dayTags[bandRadiusTag] = true
	end

	return dayTags
end

local function CalendarGridDayLabel(props)
	local v = useTokens()
	local color3

	if props.isSelected then
		color3 = v.Inverse.Content.Emphasis.Color3
	elseif props.isSelectable and props.emphasizeText then
		color3 = v.Color.Content.Emphasis.Color3
	else
		color3 = v.Color.Content.Muted.Color3
	end

	local transparency = (props.isSelected or props.isSelectable and props.emphasizeText) and 0
		or Constants.DISABLED_TRANSPARENCY

	local dayTags = buildDayTags(props.highlight == true and not props.isSelected, props.bandRadiusTag) -- inferred equivalent call

	local onStateChanged = React.useMemo(function()
		if props.onHoverEnter == nil then
			return nil
		end

		return function(p)
			if p == ControlState.Hover then
				props.onHoverEnter()
			end
		end
	end, { props.onHoverEnter })

	local createElement = React.createElement
	local backgroundStyle

	if props.isSelected then
		backgroundStyle = v.Color.System.Contrast
	elseif props.highlight then
		backgroundStyle = v.Color.ActionStandard.Background
	end

	local onActivated

	if props.isSelectable then
		onActivated = props.onActivated
	end

	if not props.isSelectable then
		onStateChanged = nil
	end

	local v2 = {
		backgroundStyle = backgroundStyle,
		onActivated = onActivated,
		onStateChanged = onStateChanged,
		RichText = not props.isSelectable,
		stateLayer = 0,
		tag = 0,
		testId = 0,
		Text = 0,
		textStyle = 0
	}
	local mode

	if props.isSelected then
		mode = StateLayerMode.Inverse
	else
		mode = StateLayerMode.Default
	end

	v2.stateLayer = { mode = mode }

	v2.tag = dayTags
	v2.testId = props.testId
	local text

	if props.isSelectable then
		text = props.label
	else
		text = `<s>{props.label}</s>`
	end

	v2.Text = text
	v2.textStyle = { Color3 = color3, Transparency = transparency }
	local element = createElement(Text, v2)

	local createElement2 = React.createElement
	local v3 = { LayoutOrder = props.LayoutOrder, tag = "size-full" }
	local band

	if props.bandPosition and props.bandSize then
		local createElement3 = React.createElement
		local v4 = {
			backgroundStyle = v.Color.ActionStandard.Background,
			Position = props.bandPosition,
			Size = props.bandSize,
			tag = 0,
			ZIndex = 0
		}
		local tag

		if props.bandRadiusTag and props.bandRadiusTag ~= "" then
			tag = props.bandRadiusTag
		end

		v4.tag = tag
		band = createElement3(View, v4)
	end

	return createElement2(View, v3, { Band = band, Day = element })
end

return CalendarGridDayLabel

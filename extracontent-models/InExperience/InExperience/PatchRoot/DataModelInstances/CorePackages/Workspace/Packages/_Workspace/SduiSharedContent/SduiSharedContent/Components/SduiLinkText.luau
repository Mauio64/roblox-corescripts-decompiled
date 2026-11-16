local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)
local CollectionViews = require(parent.CollectionViews)
local checkAndFormatPossibleLink = CollectionViews.checkAndFormatPossibleLink
local SduiText = require(script.Parent.SduiText)

local useTokens = Foundation.Hooks.useTokens

local FFlagSduiLinkTextStyleOverride = require(SduiSharedContent.Flags.FFlagSduiLinkTextStyleOverride)

local function SduiLinkText(props)
	local v = useTokens()
	local text = props.text
	local richText = props.richText

	if text then
		local color3

		if props.linkStyle and props.linkStyle.Color3 then
			color3 = props.linkStyle.Color3
		else
			color3 = v.Color.Content.Link.Color3
		end

		local v2 = string.format(
			"rgb(%d, %d, %d)",
			math.round(color3.R * 255),
			math.round(color3.G * 255),
			(math.round(color3.B * 255))
		)

		local v3 = not FFlagSduiLinkTextStyleOverride or props.isLinkBold ~= false
		local v4

		if FFlagSduiLinkTextStyleOverride then
			v4 = props.isLinkUnderlined == true
		else
			v4 = false
		end

		local v5 = `<font color="{v2}">`
		local v6 = "</font>"

		if v4 then
			v5 ..= "<u>"
			v6 = "</u>" .. v6
		end

		if v3 then
			v5 ..= "<b>"
			v6 = "</b>" .. v6
		end

		local v7, v8 = checkAndFormatPossibleLink(text, nil, nil, v5, v6)

		if v7 then
			text = v8
			richText = true
		end
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v2 = {
		text = text,
		richText = richText,
		linkStyle = Cryo.None,
		isLinkBold = 0,
		isLinkUnderlined = 0
	}
	local isLinkBold

	if FFlagSduiLinkTextStyleOverride then
		isLinkBold = Cryo.None
	end

	v2.isLinkBold = isLinkBold
	local isLinkUnderlined

	if FFlagSduiLinkTextStyleOverride then
		isLinkUnderlined = Cryo.None
	end

	v2.isLinkUnderlined = isLinkUnderlined
	return createElement(SduiText, join(props, v2))
end

return SduiLinkText

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local module2 = require("@luauforge/bundled/hxh")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local view = Foundation.View
local inlineLayout = module2.Components.InlineLayout
local linkElement = module2.Components.InlineLayoutElements.LinkElement
local textElement = module2.Components.InlineLayoutElements.TextElement

local v5 = {
	{ name = "u", attributes = {} }
}

local function LinkedText(props)
	local text = props.text
	local fontStyle = props.fontStyle
	local textStyle = props.textStyle
	local linkTextStyle = props.linkTextStyle
	local onLinkActivated = props.onLinkActivated
	local testId = props.testId

	local v6 = React.useMemo(function()
		local v7, v8, v9 = string.match(text, "^(.*)<a>(.*)</a>(.*)$")

		if v8 == nil then
			return { textElement.new({
					Text = text,
					fontStyle = fontStyle,
					textStyle = textStyle
				}) }
		end

		return {
			textElement.new({ Text = v7, fontStyle = fontStyle, textStyle = textStyle }),
			linkElement.new({ textElement.new({
					Text = v8,
					fontStyle = fontStyle,
					textStyle = linkTextStyle,
					EngineTags = v5,
					testId = `{testId}-link-text`
				}) }, { key = `{testId}-link`, onActivated = onLinkActivated }),
			textElement.new({ Text = v9, fontStyle = fontStyle, textStyle = textStyle })
		}
	end, { text, fontStyle, textStyle, linkTextStyle, onLinkActivated, testId })

	return React.createElement(
		view,
		{ LayoutOrder = props.LayoutOrder, tag = "size-full-0 auto-y", testId = testId },
		{
			Layout = React.createElement(inlineLayout, {
				Elements = v6,
				VerticalPadding = UDim.new(0, 0)
			})
		}
	)
end

return { LinkedText = React.memo(LinkedText), LINK_START = "<a>", LINK_END = "</a>" }

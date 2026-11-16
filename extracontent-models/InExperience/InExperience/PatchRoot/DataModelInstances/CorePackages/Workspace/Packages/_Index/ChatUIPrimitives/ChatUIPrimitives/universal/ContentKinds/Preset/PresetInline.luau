local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)
require(script.Parent.PresetTypes)
local getPresetIconRichText = require(script.Parent.getPresetIconRichText)

local function PresetInline(p)
	local v = Foundation.Hooks.useTokens()
	local v2 = SignalsReact.useSignalBinding(p.getContent)
	local v3 = React.useMemo(function()
		return getPresetIconRichText(v.Typography.BodyLarge.FontSize)
	end, { v })

	return React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-wrap text-align-x-left text-align-y-top",
		Text = v2:map(function(p2)
			return `{escapeRichText(p2.displayText)} {v3}`
		end),
		RichText = true,
		LayoutOrder = p.LayoutOrder
	})
end

return PresetInline

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)
local formatInlineIcon = require(ChatUIPrimitives.Utils.formatInlineIcon)
local SystemContentModel = require(script.Parent.Parent.ContentKinds.System.SystemContentModel)
local Sizing = require(script.Parent.Parent.Sizing)
require(script.Parent.groupMessages)

local function systemRichText(p)
	local content = p.message.contents[1]
	local v

	if content ~= nil then
		v = SystemContentModel.getDetail(content)
	end

	if v == nil then
		return ""
	end

	local v2 = escapeRichText(v.text)

	if v.iconName == nil then
		return v2
	end

	return `{formatInlineIcon(v.iconName, { weight = "600" })} {v2}`
end

local function SystemItem(p)
	local text = SignalsReact.useSignalBinding(function(p2)
		return systemRichText(p.itemSignal(p2))
	end)

	local v = Sizing.useSizing()
	local tag = Foundation.Hooks.useDefaultTags(
		v.system.tag,
		"size-full-0 auto-y text-wrap text-align-x-center content-muted"
	)

	return React.createElement(Foundation.Text, {
		tag = tag,
		Text = text,
		RichText = true,
		testId = "message-system"
	})
end

return SystemItem

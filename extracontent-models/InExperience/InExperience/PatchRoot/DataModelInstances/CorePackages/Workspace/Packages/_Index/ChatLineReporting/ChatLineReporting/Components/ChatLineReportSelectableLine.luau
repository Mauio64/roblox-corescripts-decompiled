local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local ExpChatShared = require(parent.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local isPresetMessage = ExpChatShared.isPresetMessage

local getMessageText = require(ChatLineReporting.Common.getMessageText)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local Constants = require(ChatLineReporting.Common.Constants)
local ChatLineReportEyebrow = require(ChatLineReporting.Components.ChatLineReportEyebrow)

local function ChatLineReportSelectableLine(props)
	local state, setState = React.useState(nil)
	local messageText = getMessageText(props.message.useTranslation, props.message.translation, props.message.text)
	local prefixText = props.message.prefixText or ""
	local v = state or prefixText
	local userId = props.message.userId

	if userId and userId.data then
		local names = userId.data.userProfiles[1].names
		setState((string.gsub(v, names.displayName, names.combinedName)))
	end

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(0, props.scrollViewSizeX - Constants.SelectableLineScrollbarOffset, 1, 0),
		LayoutOrder = 2,
		tag = "col"
	}

	local v3 = {
		eyebrow = React.createElement(ChatLineReportEyebrow, {
			message = props.message,
			localizedText = props.localizedText
		}),
		chatText = 0
	}

	local createElement2 = React.createElement
	local text

	if FFlagExpChatPresetChatEnabled and isPresetMessage(props.message) then
		text = `{v} {messageText} {getPresetIconRichText(18)}`
	else
		text = `{v} {messageText}`
	end

	v3.chatText = createElement2(Text, {
		Text = text,
		RichText = true,
		tag = "auto-xy text-wrap text-align-x-left",
		LayoutOrder = 2
	})
	return createElement(View, v2, v3)
end

return ChatLineReportSelectableLine

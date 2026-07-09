local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local ExpChatShared = require(ChatLineReportingParent.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local isPresetMessage = ExpChatShared.isPresetMessage
local getMessageText = require(ChatLineReporting.Common.getMessageText)
local React = require(ChatLineReportingParent.React)
local Foundation = require(ChatLineReportingParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Constants = require(ChatLineReporting.Common.Constants)
local ChatLineReportEyebrow = require(ChatLineReporting.Components.ChatLineReportEyebrow)

local function ChatLineReportSelectableLine(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), getMessageText (copy), View (copy), Constants (copy), ChatLineReportEyebrow (copy), FoundationText (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconRichText (copy)
	local v16, v17 = React.useState(nil)
	local v18 = getMessageText(t1.message.useTranslation, t1.message.translation, t1.message.text)
	local v19 = t1.message.prefixText or ""
	local v20 = v16 or v19
	local userId = t1.message.userId

	if userId and userId.data then
		local names = userId.data.userProfiles[1].names

		v17((string.gsub(v20, names.displayName, names.combinedName)))
	end

	return React.createElement(View, {
		LayoutOrder = 2,
		Size = if not t1.chatLineReportingReworkEnabled then UDim2.new(0, t1.scrollViewSizeX - Constants.SelectableLineScrollbarOffset, 1, 0) else nil,
		tag = not t1.chatLineReportingReworkEnabled and "col" or `col auto-xy { t1.tag }`
	}, {
		eyebrow = React.createElement(ChatLineReportEyebrow, {
			message = t1.message,
			localizedText = t1.localizedText
		}),
		chatText = React.createElement(FoundationText, {
			RichText = true,
			tag = "auto-xy text-wrap text-align-x-left",
			LayoutOrder = 2,
			Text = if not FFlagExpChatPresetChatEnabled or not isPresetMessage(t1.message) then `{ v20 } { v18 }` else `{ v20 } { v18 } { getPresetIconRichText(18) }`
		})
	})
end

return ChatLineReportSelectableLine

local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local Constants = require(ChatLineReporting.Common.Constants)
local React = require(ChatLineReportingParent.React)
local Foundation = require(ChatLineReportingParent.Foundation)
local View = Foundation.View
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local FFlagEnableGlobalChatAbuseReporting = require(ChatLineReportingParent.SharedFlags).FFlagEnableGlobalChatAbuseReporting

local function getEyebrowText(s1: string, t1: {[any]: any}) -- line: 20
	-- upvalues: Constants (copy)
	if string.match(s1, Constants.ChannelTypes.Whisper) then
		return t1.localizedText.ChatEyebrowSentPrivately
	end

	return t1.localizedText.ChatEyebrowSentInAnotherChat
end
local function ChatLineReportEyebrow(t2: {[any]: any}) -- line: 28
	-- upvalues: FFlagEnableGlobalChatAbuseReporting (copy), Constants (copy), React (copy), View (copy), InputLabel (copy), InputLabelSize (copy)
	if (not FFlagEnableGlobalChatAbuseReporting or t2.message.textChannel) and t2.message.textChannel.Name ~= Constants.ChannelTypes.General then
		local createElement = React.createElement
		local v16 = View
		local t3 = {
			tag = "auto-xy bg-shift-200 padding-left-xsmall padding-right-xsmall radius-small",
			LayoutOrder = 1
		}
		local t4 = {}
		local createElement2 = React.createElement
		local v20 = InputLabel
		local t5 = {
			RichText = true
		}
		local textChannelName = t2.message.textChannel.Name

		t5.Text = if not string.match(textChannelName, Constants.ChannelTypes.Whisper) then t2.localizedText.ChatEyebrowSentInAnotherChat else t2.localizedText.ChatEyebrowSentPrivately
		t5.size = InputLabelSize.Small
		t4.eyebrowLabel = createElement2(v20, t5)

		return (createElement(v16, t3, t4))
	end

	return nil
end

return ChatLineReportEyebrow

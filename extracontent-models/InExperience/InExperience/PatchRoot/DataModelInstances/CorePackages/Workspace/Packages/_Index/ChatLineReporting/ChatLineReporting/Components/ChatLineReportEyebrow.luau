local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local Constants = require(ChatLineReporting.Common.Constants)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGlobalChatAbuseReporting = SharedFlags.FFlagEnableGlobalChatAbuseReporting

local function getEyebrowText(name: string, p) -- 1 equivalent call inferred from this helper
	if string.match(name, Constants.ChannelTypes.Whisper) then
		return p.localizedText.ChatEyebrowSentPrivately
	end

	return p.localizedText.ChatEyebrowSentInAnotherChat
end

local function ChatLineReportEyebrow(p)
	if
		FFlagEnableGlobalChatAbuseReporting and not p.message.textChannel
		or p.message.textChannel.Name == Constants.ChannelTypes.General
	then
		return nil
	end

	return (React.createElement(
		View,
		{
			tag = "auto-xy bg-shift-200 padding-left-xsmall padding-right-xsmall radius-small",
			LayoutOrder = 1
		},
		{
			eyebrowLabel = React.createElement(InputLabel, {
				Text = getEyebrowText(p.message.textChannel.Name, p), -- inferred equivalent call
				RichText = true,
				size = InputLabelSize.Small
			})
		}
	))
end

return ChatLineReportEyebrow

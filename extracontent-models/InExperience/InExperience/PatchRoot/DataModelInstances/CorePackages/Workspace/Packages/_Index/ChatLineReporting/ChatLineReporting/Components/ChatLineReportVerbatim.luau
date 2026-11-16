local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local Constants = require(ChatLineReporting.Common.Constants)
local getMessageText = require(ChatLineReporting.Common.getMessageText)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local function ChatLineReportVerbatim(p)
	local state, setState = React.useState(nil)
	local messageText = getMessageText(
		p.selectedMessage.useTranslation,
		p.selectedMessage.translation,
		p.selectedMessage.text
	)

	local prefixText = p.selectedMessage.prefixText or ""
	local v = state or prefixText
	local userId = p.selectedMessage.userId

	if userId and userId.data then
		local names = userId.data.userProfiles[1].names
		setState((string.gsub(v, names.displayName, names.combinedName)))
	end

	return React.createElement(
		View,
		{
			Size = UDim2.new(1, 0, 0, Constants.SelectableChatLineHeight),
			tag = "radius-medium padding-left-medium padding-right-medium stroke-neutral stroke-standard"
		},
		{
			messageFrame = React.createElement(View, {
				tag = "auto-xy position-center-left anchor-center-left"
			}, {
				messageText = React.createElement(Text, {
					Text = `{v} {messageText}`,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextScaled = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					RichText = true,
					tag = "auto-xy content-muted"
				})
			})
		}
	)
end

return ChatLineReportVerbatim

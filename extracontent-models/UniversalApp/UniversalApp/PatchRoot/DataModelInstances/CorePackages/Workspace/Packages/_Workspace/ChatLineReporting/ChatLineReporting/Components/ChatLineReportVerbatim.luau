local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local Constants = require(ChatLineReporting.Common.Constants)
local getMessageText = require(ChatLineReporting.Common.getMessageText)
local React = require(ChatLineReportingParent.React)
local Foundation = require(ChatLineReportingParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

local function ChatLineReportVerbatim(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), getMessageText (copy), View (copy), Constants (copy), FoundationText (copy)
	local v11, v12 = React.useState(nil)
	local v13 = getMessageText(t1.selectedMessage.useTranslation, t1.selectedMessage.translation, t1.selectedMessage.text)
	local v14 = t1.selectedMessage.prefixText or ""
	local v15 = v11 or v14
	local userId = t1.selectedMessage.userId

	if userId and userId.data then
		local names = userId.data.userProfiles[1].names

		v12((string.gsub(v15, names.displayName, names.combinedName)))
	end

	return React.createElement(View, {
		tag = "radius-medium padding-left-medium padding-right-medium stroke-neutral stroke-standard",
		Size = UDim2.new(1, 0, 0, Constants.SelectableChatLineHeight)
	}, {
		messageFrame = React.createElement(View, {
			tag = "auto-xy position-center-left anchor-center-left"
		}, {
			messageText = React.createElement(FoundationText, {
				TextScaled = false,
				RichText = true,
				tag = "auto-xy content-muted",
				Text = `{ v15 } { v13 }`,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	})
end

return ChatLineReportVerbatim

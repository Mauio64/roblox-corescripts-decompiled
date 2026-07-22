local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local UIBlox = require(ExpChatParent.UIBlox)
local summaryMessageRichText = require(ExpChat.summaryMessageRichText)
local v5 = game:DefineFastFlag("ExpChatAlignSystemMessageStyling", false)

local function generateRichSystemMessageTextFormat(s1: string, b1: boolean?, p1: ((...any) -> ...any)?) -- line: 10
	-- upvalues: v5 (copy), summaryMessageRichText (copy), UIBlox (copy)
	if v5 and (not b1 and p1 == nil) then
		return summaryMessageRichText.wrapInSummaryMutedStyle(s1)
	end

	local v10 = string.format("<font color=\"#%s\">%s</font>", if not b1 then UIBlox.App.Style.Colors.LightGrey:ToHex() else UIBlox.App.Style.Colors.Red:ToHex(), s1)

	if p1 then
		v10 = p1(v10)
	end

	return v10
end

return generateRichSystemMessageTextFormat

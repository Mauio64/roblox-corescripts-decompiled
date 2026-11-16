local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local UIBlox = require(parent.UIBlox)

local summaryMessageRichText = require(ExpChat.summaryMessageRichText)

local defineFastFlag = game:DefineFastFlag("ExpChatAlignSystemMessageStyling", false)

local function generateRichSystemMessageTextFormat(p: string, flag: boolean?, callback)
	if defineFastFlag and not flag and callback == nil then
		return summaryMessageRichText.wrapInSummaryMutedStyle(p)
	end

	local v

	if flag then
		v = UIBlox.App.Style.Colors.Red:ToHex()
	else
		v = UIBlox.App.Style.Colors.LightGrey:ToHex()
	end

	local v2 = string.format("<font color=\"#%s\">%s</font>", v, p)

	if callback then
		return (callback(v2))
	end

	return v2
end

return generateRichSystemMessageTextFormat

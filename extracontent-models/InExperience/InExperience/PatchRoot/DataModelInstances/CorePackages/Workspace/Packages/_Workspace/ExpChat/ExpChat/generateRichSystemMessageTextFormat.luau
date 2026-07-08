local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local UIBlox = require(ExpChatParent.UIBlox)
local FFlagExpChatEnablePostProcessRichSystemMessageTextFormat = require(ExpChat.Flags.FFlagExpChatEnablePostProcessRichSystemMessageTextFormat)

local function generateRichSystemMessageTextFormat(s1: string, b1: boolean?, p1: ((...any) -> ...any)?) -- line: 9
	-- upvalues: FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), UIBlox (copy)
	if FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then
		local v9 = string.format("<font color=\"#%s\">%s</font>", if not b1 then UIBlox.App.Style.Colors.LightGrey:ToHex() else UIBlox.App.Style.Colors.Red:ToHex(), s1)

		if p1 then
			v9 = p1(v9)
		end

		return v9
	end

	return string.format("<font color=\"#%s\">%s</font>", if not b1 then UIBlox.App.Style.Colors.LightGrey:ToHex() else UIBlox.App.Style.Colors.Red:ToHex(), s1)
end

return generateRichSystemMessageTextFormat

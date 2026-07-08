local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local ArgCheck = require(AppChatParent.ArgCheck)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local formatMessages = require(script.Parent.formatMessages)
local separateRobloxUrlsFromText = require(script.Parent.RobloxUrlUtils.separateRobloxUrlsFromText)

return function(p1, p2) -- line: 15
	-- upvalues: ArgCheck (copy), EnumMessageTypes (copy), Cryo (copy), formatMessages (copy), separateRobloxUrlsFromText (copy)
	ArgCheck.isType(p1, "table", "filterForLinks.text")
	ArgCheck.isType(p2, "table", "filterForLinks.whitelistedDomains")

	if p1.messageType == EnumMessageTypes.System then
		return { p1 }
	end

	if p1.messageType == EnumMessageTypes.Link and (not p1.gameLink or not p1.gameLink.universeId) then
		return { Cryo.Dictionary.join(p1, {
			messageType = Cryo.None
		}) }
	end

	if not p1.content or p1.moderated or not p1.content:lower():match("%/games[^%d]*(%d+)/?") and not p1.content:match("%/share%?.*code=([%w%-]+)") then
		return { p1 }
	end

	return formatMessages(separateRobloxUrlsFromText(p1.content), p1)
end

local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local addMessage = require(script.Parent.Parent.Parent.Utils.addMessage)
local RobloxUrlMap = require(script.Parent.RobloxUrlMap)
local Constants = require(script.Parent.Constants)
local FFlagAppChatFullPlaintextBeforeGameCards = require(AppChat.Flags.FFlagAppChatFullPlaintextBeforeGameCards)
local UrlMatching = require(AppChatParent.UrlMatching)
local Cryo = require(AppChatParent.Cryo)
local Text = require(AppChatParent.AppCommonLib).Text
local UrlProcessor = UrlMatching.UrlProcessor
local Constants2 = UrlMatching.Constants
local Regex = UrlMatching.Regex
local v13 = Regex.DASH .. Constants.LOCALE_COUNTRY_PATTERN
local v14 = Regex.zeroOrOneOf(Regex.SLASH .. Constants.LOCALE_LANGUAGE_PATTERN .. Regex.zeroOrOneOf(v13))
local v15 = Cryo.List.map(Constants.ROBLOX_DOMAIN_PATTERNS, function(s1: string) -- line: 21
	-- upvalues: v14 (copy)
	return s1 .. v14
end)
local v16 = UrlProcessor.new({
	protocolStrict = false,
	subdomainStrict = false,
	trimPunctuation = true,
	domainsPatterns = v15,
	subdomainPatterns = { Constants2.ANY_DOMAIN_NAME }
}, RobloxUrlMap)

return function(s2: string) -- line: 32
	-- upvalues: v16 (copy), FFlagAppChatFullPlaintextBeforeGameCards (copy), addMessage (copy), Text (copy)
	local t1 = {}
	local v20 = v16:process(s2)

	if FFlagAppChatFullPlaintextBeforeGameCards then
		local v21 = addMessage(t1, s2)

		for _, v23 in v20 do
			table.insert(v21, v23.result)
		end

		return v21
	end

	if v20 == nil or #v20 == 0 then
		return addMessage(t1, s2)
	end

	local n1 = 1

	for _, v26 in v20 do
		t1 = addMessage(t1, Text.Trim(s2:sub(n1, v26.startIndex - 1)))
		table.insert(t1, v26.result)
		n1 = v26.endIndex + 1
	end

	return addMessage(t1, Text.Trim(s2:sub(n1)))
end

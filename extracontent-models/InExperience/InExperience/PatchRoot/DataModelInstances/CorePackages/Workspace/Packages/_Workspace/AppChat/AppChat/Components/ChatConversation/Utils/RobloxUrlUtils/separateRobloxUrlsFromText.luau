local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local addMessage = require(script.Parent.Parent.Parent.Utils.addMessage)

local RobloxUrlMap = require(script.Parent.RobloxUrlMap)
local Constants = require(script.Parent.Constants)
local FFlagAppChatFullPlaintextBeforeGameCards = require(AppChat.Flags.FFlagAppChatFullPlaintextBeforeGameCards)
local FFlagAppChatShareLinkV2Fallbacks = require(AppChat.Flags.FFlagAppChatShareLinkV2Fallbacks)

local UrlMatching = require(parent.UrlMatching)
local Cryo = require(parent.Cryo)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

local UrlProcessor = UrlMatching.UrlProcessor
local constants = UrlMatching.Constants
local Regex = UrlMatching.Regex

local v = Regex.DASH .. Constants.LOCALE_COUNTRY_PATTERN

local zeroOrOne = Regex.zeroOrOneOf(Regex.SLASH .. Constants.LOCALE_LANGUAGE_PATTERN .. Regex.zeroOrOneOf(v))
local mapped = Cryo.List.map(Constants.ROBLOX_DOMAIN_PATTERNS, function(p: string)
	return p .. zeroOrOne
end)

local v2 = UrlProcessor.new({
	domainsPatterns = mapped,
	protocolStrict = false,
	subdomainPatterns = { constants.ANY_DOMAIN_NAME },
	subdomainStrict = false,
	trimPunctuation = true
}, RobloxUrlMap)

local function prepareMatchesForMessages(p, value: string) -- 1 equivalent call inferred from this helper
	return Cryo.List.filterMap(p, function(data)
		local result = data.result

		if result == nil then
			return nil
		end

		if result.shareLink and result.shareLink.version == 2 then
			return Cryo.Dictionary.join(data, {
				result = Cryo.Dictionary.join(result, {
					shareLink = Cryo.Dictionary.join(result.shareLink, {
						url = value:sub(data.startIndex, data.endIndex)
					})
				})
			})
		end

		return data
	end)
end

return function(value: string)
	local v3 = {}
	local v4 = v2:process(value)

	if FFlagAppChatShareLinkV2Fallbacks then
		v4 = prepareMatchesForMessages(v4, value) -- inferred equivalent call
	end

	if FFlagAppChatFullPlaintextBeforeGameCards then
		local result = addMessage(v3, value)

		for _, v5 in v4 do
			table.insert(result, v5.result)
		end

		return result
	else
		if v4 == nil or #v4 == 0 then
			return addMessage(v3, value)
		end

		local v5 = 1

		for _, v6 in v4 do
			v3 = addMessage(v3, Text.Trim(value:sub(v5, v6.startIndex - 1)))

			table.insert(v3, v6.result)
			v5 = v6.endIndex + 1
		end

		return addMessage(v3, Text.Trim(value:sub(v5)))
	end
end

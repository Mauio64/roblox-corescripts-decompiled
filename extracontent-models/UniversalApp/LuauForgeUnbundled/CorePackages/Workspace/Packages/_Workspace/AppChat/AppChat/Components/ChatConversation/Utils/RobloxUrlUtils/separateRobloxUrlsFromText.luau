local addMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/addMessage")

local RobloxUrlMap = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/RobloxUrlMap")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/Constants")
local FFlagAppChatFullPlaintextBeforeGameCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFullPlaintextBeforeGameCards")
local FFlagAppChatShareLinkV2Fallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatShareLinkV2Fallbacks")

local UrlMatching = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UrlMatching")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text

local urlProcessor = UrlMatching.UrlProcessor
local constants = UrlMatching.Constants
local regex = UrlMatching.Regex

local v5 = regex.DASH .. Constants.LOCALE_COUNTRY_PATTERN

local zeroOrOne = regex.zeroOrOneOf(regex.SLASH .. Constants.LOCALE_LANGUAGE_PATTERN .. regex.zeroOrOneOf(v5))
local mapped = Cryo.List.map(Constants.ROBLOX_DOMAIN_PATTERNS, function(p2)
	return p2 .. zeroOrOne
end)

local v6 = urlProcessor.new({
	domainsPatterns = mapped,
	protocolStrict = false,
	subdomainPatterns = { constants.ANY_DOMAIN_NAME },
	subdomainStrict = false,
	trimPunctuation = true
}, RobloxUrlMap)

local function prepareMatchesForMessages(p2, value)
	return Cryo.List.filterMap(p2, function(data)
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

return function(value)
	local v7 = {}
	local v8 = v6:process(value)

	if FFlagAppChatShareLinkV2Fallbacks then
		v8 = Cryo.List.filterMap(v8, function(data)
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

	if FFlagAppChatFullPlaintextBeforeGameCards then
		local result = addMessage(v7, value)

		for k, v9 in v8 do
			table.insert(result, v9.result)
		end

		return result
	else
		if v8 == nil or #v8 == 0 then
			return addMessage(v7, value)
		end

		local v9 = 1

		for k, v10 in v8 do
			v7 = addMessage(v7, text.Trim(value:sub(v9, v10.startIndex - 1)))

			table.insert(v7, v10.result)
			v9 = v10.endIndex + 1
		end

		return addMessage(v7, text.Trim(value:sub(v9)))
	end
end

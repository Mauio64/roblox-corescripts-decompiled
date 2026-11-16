local HttpService = game:GetService("HttpService")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")

return {
	isCompletedEligibilityToolCall = function(data): boolean
		return data ~= nil
			and data.title == "check_ad_campaign_eligibility"
			and data.status == "completed"
			and type(data.toolCallId) == "string"
			and data.toolCallId ~= ""
	end,
	decodeCompletedEligibility = function(data)
		local v5

		if
			data == nil
			or data.title ~= "check_ad_campaign_eligibility"
			or data.status ~= "completed"
			or type(data.toolCallId) ~= "string"
		then
			v5 = false
		else
			v5 = data.toolCallId ~= ""
		end

		if not v5 or data.content == nil then
			return nil
		end

		for k, v6 in data.content do
			local content = v6.content

			if not (v6.type == "content" and content ~= nil and content.type == "text" and type(content.text) == "string") then
				continue
			end

			local success, result = pcall(HttpService.JSONDecode, HttpService, content.text)

			if not success then
				continue
			end

			local decodeAdCampaignEligibilityResult = CreatorAgentChat.decodeAdCampaignEligibilityResult(result)

			if decodeAdCampaignEligibilityResult ~= nil then
				return decodeAdCampaignEligibilityResult
			end
		end

		return nil
	end,
	getCardOffers = function(data)
		if data == nil or not data.userEligible or not data.universeEligible or data.cardType == "none" then
			return nil
		end

		return adCampaignEligibilityUtils.getSelectableOffers(data)
	end
}

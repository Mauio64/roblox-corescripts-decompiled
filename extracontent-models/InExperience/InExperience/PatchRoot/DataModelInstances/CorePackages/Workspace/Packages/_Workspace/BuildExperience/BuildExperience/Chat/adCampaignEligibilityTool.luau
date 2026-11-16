local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local HttpService = game:GetService("HttpService")

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)

local function isCompletedEligibilityToolCall(data): boolean -- 1 equivalent call inferred from this helper
	return data ~= nil
		and data.title == "check_ad_campaign_eligibility"
		and data.status == "completed"
		and type(data.toolCallId) == "string"
		and data.toolCallId ~= ""
end

local AdCampaignEligibilityTool = {}
AdCampaignEligibilityTool.isCompletedEligibilityToolCall = isCompletedEligibilityToolCall

function AdCampaignEligibilityTool.decodeCompletedEligibility(data)
	if not isCompletedEligibilityToolCall(data) or data.content == nil then -- inferred equivalent call
		return nil
	end

	for _, v in data.content do
		local content = v.content

		if not (v.type == "content" and content ~= nil and content.type == "text" and type(content.text) == "string") then
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
end

function AdCampaignEligibilityTool.getCardOffers(data)
	if data == nil or not data.userEligible or not data.universeEligible or data.cardType == "none" then
		return nil
	end

	return adCampaignEligibilityUtils.getSelectableOffers(data)
end

return AdCampaignEligibilityTool

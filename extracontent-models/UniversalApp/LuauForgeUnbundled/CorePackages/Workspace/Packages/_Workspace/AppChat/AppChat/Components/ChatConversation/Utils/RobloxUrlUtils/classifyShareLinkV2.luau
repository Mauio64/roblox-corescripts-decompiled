local HttpService = game:GetService("HttpService")

local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NetworkingShareLinks")
local ShareLinkClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/ShareLinkClassification")

local FFlagAppChatPlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralAssetCard")
local shareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function getTargetIdType(p2)
	if p2 == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

	if success and type(result) == "table" and result.targetIdType == shareLinkTargetIdType.FeedItemId then
		return shareLinkTargetIdType.FeedItemId
	end

	return nil
end

local function classifyShareLinkV2(data)
	if data.status ~= "Valid" then
		return { type = ShareLinkClassification.Invalid }
	end

	if data.linkType == "Moments" then
		local v5 = { type = ShareLinkClassification.Moment, momentId = data.targetId, targetIdType = 0 }
		local customData = data.customData
		local feedItemId

		if customData ~= "" then
			local success, result = pcall(HttpService.JSONDecode, HttpService, customData)

			if
				success
				and type(result) == "table"
				and result.targetIdType == shareLinkTargetIdType.FeedItemId
			then
				feedItemId = shareLinkTargetIdType.FeedItemId
			end
		end

		v5.targetIdType = feedItemId
		return v5
	elseif FFlagAppChatPlusReferralAssetCard and data.linkType == "Referral" then
		return { type = ShareLinkClassification.PlusReferral, referrerId = data.targetId }
	else
		return { type = ShareLinkClassification.Unhandled }
	end
end

return classifyShareLinkV2

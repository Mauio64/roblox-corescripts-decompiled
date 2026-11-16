local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local HttpService = game:GetService("HttpService")

local MomentsTypes = require(parent.MomentsTypes)
require(parent.ShareLinksNetworking)
local ShareLinkClassification = require(script.Parent.ShareLinkClassification)

local FFlagAppChatPlusReferralAssetCard = require(AppChat.Flags.FFlagAppChatPlusReferralAssetCard)
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function getTargetIdType(customData: string) -- 1 equivalent call inferred from this helper
	if customData == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, customData)

	if success and type(result) == "table" and result.targetIdType == ShareLinkTargetIdType.FeedItemId then
		return ShareLinkTargetIdType.FeedItemId
	end

	return nil
end

local function classifyShareLinkV2(data)
	if data.status ~= "Valid" then
		return { type = ShareLinkClassification.Invalid }
	end

	if data.linkType == "Moments" then
		return {
			type = ShareLinkClassification.Moment,
			momentId = data.targetId,
			targetIdType = getTargetIdType(data.customData) -- inferred equivalent call
		}
	elseif FFlagAppChatPlusReferralAssetCard and data.linkType == "Referral" then
		return { type = ShareLinkClassification.PlusReferral, referrerId = data.targetId }
	else
		return { type = ShareLinkClassification.Unhandled }
	end
end

return classifyShareLinkV2

local AppChat = script:FindFirstAncestor("AppChat")

local ShareLinkClassification = require(AppChat.Components.ChatConversation.Utils.RobloxUrlUtils.ShareLinkClassification)

local FFlagAppChatPlusReferralAssetCard = require(AppChat.Flags.FFlagAppChatPlusReferralAssetCard)
local FFlagAppChatMomentAssetCard = require(AppChat.Flags.FFlagAppChatMomentAssetCard)

local function isAssetCardClassification(p): boolean
	if p == nil then
		return false
	end

	if
		FFlagAppChatPlusReferralAssetCard and p.type == ShareLinkClassification.PlusReferral
		or FFlagAppChatMomentAssetCard and p.type == ShareLinkClassification.Moment
	then
		return true
	end

	return false
end

return isAssetCardClassification

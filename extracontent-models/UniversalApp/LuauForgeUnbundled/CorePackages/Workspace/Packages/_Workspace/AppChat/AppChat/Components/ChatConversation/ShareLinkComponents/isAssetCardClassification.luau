local ShareLinkClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/ShareLinkClassification")

local FFlagAppChatPlusReferralAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralAssetCard")
local FFlagAppChatMomentAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentAssetCard")

local function isAssetCardClassification(p2): boolean
	if p2 == nil then
		return false
	end

	if FFlagAppChatPlusReferralAssetCard and p2.type == ShareLinkClassification.PlusReferral or FFlagAppChatMomentAssetCard and p2.type == ShareLinkClassification.Moment then
		return true
	end

	return false
end

return isAssetCardClassification

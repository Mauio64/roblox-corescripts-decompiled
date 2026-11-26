local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")

local ShareLinkClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/ShareLinkClassification")
local ShareLinkV2Presentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/ShareLinkV2Presentation")
local isAssetCardClassification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/isAssetCardClassification")
local FFlagAppChatMomentShareCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCard")

local dataStatus = DataHydration.DataStatus

local function getShareLinkV2Presentation(p2, p3)
	if p2 == nil then
		if p3 == dataStatus.NotReady then
			return ShareLinkV2Presentation.Loading
		end
	elseif FFlagAppChatMomentShareCard and p2.type == ShareLinkClassification.Moment or isAssetCardClassification(p2) then
		return ShareLinkV2Presentation.Card
	end

	return ShareLinkV2Presentation.Fallback
end

return getShareLinkV2Presentation

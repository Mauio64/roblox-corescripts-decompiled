local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local AssetCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardView")
local usePlusReferralAssetCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/PlusReferralAssetCard/usePlusReferralAssetCardViewModel")

local function PlusReferralAssetCard(p2)
	local v5 = usePlusReferralAssetCardViewModel(p2)
	return React.createElement(AssetCardView, v5)
end

return React.memo(PlusReferralAssetCard)

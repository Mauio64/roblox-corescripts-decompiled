local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)

local AssetCardView = require(AppChat.Components.ChatConversation.AssetCardView.AssetCardView)
local usePlusReferralAssetCardViewModel = require(script.Parent.usePlusReferralAssetCardViewModel)

local function PlusReferralAssetCard(p)
	local v = usePlusReferralAssetCardViewModel(p)
	return React.createElement(AssetCardView, v)
end

return React.memo(PlusReferralAssetCard)

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)

local ShareLinkClassification = require(AppChat.Components.ChatConversation.Utils.RobloxUrlUtils.ShareLinkClassification)
local ShareLinkV2Presentation = require(script.Parent.ShareLinkV2Presentation)
local isAssetCardClassification = require(script.Parent.isAssetCardClassification)
local FFlagAppChatMomentShareCard = require(AppChat.Flags.FFlagAppChatMomentShareCard)

local DataStatus = DataHydration.DataStatus

local function getShareLinkV2Presentation(p, p2)
	if p == nil then
		if p2 == DataStatus.NotReady then
			return ShareLinkV2Presentation.Loading
		end
	elseif FFlagAppChatMomentShareCard and p.type == ShareLinkClassification.Moment or isAssetCardClassification(p) then
		return ShareLinkV2Presentation.Card
	end

	return ShareLinkV2Presentation.Fallback
end

return getShareLinkV2Presentation

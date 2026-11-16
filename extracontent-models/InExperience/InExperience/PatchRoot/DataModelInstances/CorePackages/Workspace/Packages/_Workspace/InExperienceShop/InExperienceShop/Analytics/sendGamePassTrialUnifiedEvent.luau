local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("InExperienceShop").Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local MarketplaceUnifiedActionNumbers = UnifiedEventLogEnums.MarketplaceUnifiedActionNumbers
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType
local sendPassthroughUnifiedEventLog = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog

local getShopUnifiedLoggingSurface = require(script.Parent.getShopUnifiedLoggingSurface)

return {
	send = function(data)
		local v = {
			action = data.action,
			surface = getShopUnifiedLoggingSurface(data.shopPageType),
			itemId = data.itemId,
			itemType = MarketplaceUnifiedItemType.GAME_PASS,
			elementName = data.elementName,
			universeId = 0
		}
		local universeId

		if data.universeId == nil then
			universeId = game.GameId
		else
			universeId = data.universeId
		end

		v.universeId = universeId

		if data.trialStatus ~= nil then
			v.trialStatus = data.trialStatus
		end

		if data.metadata ~= nil then
			v.elementMetadata = HttpService:JSONEncode(data.metadata)
		end

		if AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads then
			sendPassthroughUnifiedEventLog(v)
		else
			sendUnifiedEventLog(v)
		end
	end,
	clickAction = MarketplaceUnifiedActionNumbers.UI_ELEMENT_CLICK,
	impressionAction = MarketplaceUnifiedActionNumbers.UI_ELEMENT_IMPRESSION,
	successAction = 12,
	failureAction = 13,
	trialElement = "GAME_PASS_TRIAL"
}

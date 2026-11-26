local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hdq")
local module3 = require("@luauforge/deferred/hdl")
local module4 = require("@luauforge/deferred/hdN")
local fFlagAXUnifiedEventStrictPayloads = require("@luauforge/deferred/hcQ").FFlagAXUnifiedEventStrictPayloads

local sendUnifiedEventLog = module2.sendUnifiedEventLog
local unifiedEventLogEnums = module2.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module2.Enums.UnifiedLoggingElementNameEnums
local unifiedEventLoggingUtils = module2.Utils.UnifiedEventLoggingUtils
local unifiedLoggingSurface = module3.Enums.UnifiedLoggingSurface

local frozen = table.freeze({
	MarketplaceBanner = "marketplace_banner",
	InventoryHeader = "inventory_header",
	InventoryCreateTile = "inventory_create_tile",
	InventoryExclusiveTile = "inventory_exclusive_tile"
})

local v5 = {
	[frozen.MarketplaceBanner] = frozen.MarketplaceBanner,
	[frozen.InventoryHeader] = frozen.InventoryHeader,
	[frozen.InventoryCreateTile] = frozen.InventoryCreateTile,
	[frozen.InventoryExclusiveTile] = frozen.InventoryExclusiveTile
}

local function getSurface(p2)
	if p2 == frozen.MarketplaceBanner then
		return unifiedLoggingSurface.CATALOG
	end

	return unifiedLoggingSurface.CUSTOMIZE
end

local function getUpsellMetadata(p2, p3, p4)
	return HttpService:JSONEncode({
		entry_source = p2,
		item_id = p3,
		purchase_flow_uuid = p4
	})
end

return {
	EntrySource = frozen,
	setUpsellTargetAttributes = function(instance, AX_BACKGROUNDS_PLUS_ENTRY_SOURCE, AX_BACKGROUNDS_PLUS_ITEM_ID)
		instance:SetAttribute("AX_BACKGROUNDS_PLUS_ENTRY_SOURCE", AX_BACKGROUNDS_PLUS_ENTRY_SOURCE)
		instance:SetAttribute("AX_BACKGROUNDS_PLUS_ITEM_ID", AX_BACKGROUNDS_PLUS_ITEM_ID)
	end,
	useUpsellImpressionTarget = function(p2, p3, p4, p5)
		return module4(p4, p5, (module.useCallback(function(instance, p6)
			local v7 = if p6 then p2 else nil
			local v8 = if p6 then p3 else nil
			instance:SetAttribute("AX_BACKGROUNDS_PLUS_ENTRY_SOURCE", v7)
			instance:SetAttribute("AX_BACKGROUNDS_PLUS_ITEM_ID", v8)
		end, { p2, p3 })))
	end,
	reportVisibleUpsellImpression = function(p2)
		local AX_BACKGROUNDS_PLUS_ENTRY_SOURCE = p2.visibleInstance:GetAttribute("AX_BACKGROUNDS_PLUS_ENTRY_SOURCE")
		local v6

		if type(AX_BACKGROUNDS_PLUS_ENTRY_SOURCE) == "string" then
			v6 = v5[AX_BACKGROUNDS_PLUS_ENTRY_SOURCE]
		end

		if not v6 then
			return
		end

		local AX_BACKGROUNDS_PLUS_ITEM_ID = p2.visibleInstance:GetAttribute("AX_BACKGROUNDS_PLUS_ITEM_ID")

		if fFlagAXUnifiedEventStrictPayloads then
			local screenSize = unifiedEventLoggingUtils.getScreenSize(p2.visibleInstance)
			local elementSizeAndPosition = unifiedEventLoggingUtils.getElementSizeAndPosition(p2.visibleInstance)
			local v8 = {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
				surface = 0,
				elementName = 0,
				elementMetadata = 0,
				screenSizeWidth = 0,
				screenSizeHeight = 0,
				elementSizeWidth = 0,
				elementSizeHeight = 0,
				elementCoordinatesX = 0,
				elementCoordinatesY = 0,
				elementRelativePositionX = 0,
				elementRelativePositionY = 0
			}
			local v9 = if v6 == frozen.MarketplaceBanner then unifiedLoggingSurface.CATALOG else unifiedLoggingSurface.CUSTOMIZE

			v8.surface = v9
			v8.elementName = unifiedLoggingElementNameEnums.BACKGROUNDS.PLUS.UPSELL_ENTRY
			v8.elementMetadata = HttpService:JSONEncode({
				entry_source = v6,
				item_id = AX_BACKGROUNDS_PLUS_ITEM_ID,
				purchase_flow_uuid = nil
			})
			v8.screenSizeWidth = screenSize.screenSizeWidth
			v8.screenSizeHeight = screenSize.screenSizeHeight
			v8.elementSizeWidth = elementSizeAndPosition.elementSizeWidth
			v8.elementSizeHeight = elementSizeAndPosition.elementSizeHeight
			v8.elementCoordinatesX = elementSizeAndPosition.elementCoordinatesX
			v8.elementCoordinatesY = elementSizeAndPosition.elementCoordinatesY
			v8.elementRelativePositionX = elementSizeAndPosition.elementRelativePositionX
			v8.elementRelativePositionY = elementSizeAndPosition.elementRelativePositionY
			sendUnifiedEventLog(v8, p2.visibleInstance)
		else
			local screenSize = unifiedEventLoggingUtils.getScreenSize(p2.visibleInstance)
			local elementSizeAndPosition = unifiedEventLoggingUtils.getElementSizeAndPosition(p2.visibleInstance)

			for k, v7 in elementSizeAndPosition do
				screenSize[k] = v7
			end

			screenSize.action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION
			local v7 = if v6 == frozen.MarketplaceBanner then unifiedLoggingSurface.CATALOG else unifiedLoggingSurface.CUSTOMIZE

			screenSize.surface = v7
			screenSize.elementName = unifiedLoggingElementNameEnums.BACKGROUNDS.PLUS.UPSELL_ENTRY
			screenSize.elementMetadata = HttpService:JSONEncode({
				entry_source = v6,
				item_id = AX_BACKGROUNDS_PLUS_ITEM_ID,
				purchase_flow_uuid = nil
			})
			sendUnifiedEventLog(screenSize, p2.visibleInstance)
		end
	end,
	sendUpsellClick = function(p2, p3, p4)
		local v7 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = 0,
			elementName = 0,
			elementMetadata = 0
		}
		local v8 = if p2 == frozen.MarketplaceBanner then unifiedLoggingSurface.CATALOG else unifiedLoggingSurface.CUSTOMIZE

		v7.surface = v8
		v7.elementName = unifiedLoggingElementNameEnums.BACKGROUNDS.PLUS.UPSELL_ENTRY
		v7.elementMetadata = HttpService:JSONEncode({
			entry_source = p2,
			item_id = p3,
			purchase_flow_uuid = p4
		})
		sendUnifiedEventLog(v7)
	end,
	sendExclusiveTileInteraction = function(p2, p3, p4)
		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.CUSTOMIZE,
			elementName = unifiedLoggingElementNameEnums.BACKGROUNDS.PLUS.EXCLUSIVE_TILE_INTERACTION,
			elementMetadata = HttpService:JSONEncode({
				item_id = p2,
				interaction_state = p3,
				has_active_subscription = tostring(p4)
			})
		})
	end
}

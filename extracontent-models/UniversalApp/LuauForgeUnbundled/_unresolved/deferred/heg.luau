local HttpService = game:GetService("HttpService")

require("@luauforge/deferred/hcS")
local module = require("@luauforge/deferred/hdq")
local module2 = require("@luauforge/deferred/hdl")
local module3 = require("@luauforge/deferred/hdN")
require("@luauforge/deferred/hdp")
local fFlagAXUnifiedEventStrictPayloads = require("@luauforge/deferred/hcQ").FFlagAXUnifiedEventStrictPayloads

local sendUnifiedEventLog = module.sendUnifiedEventLog
local unifiedEventLogEnums = module.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module.Enums.UnifiedLoggingElementNameEnums
local unifiedEventLoggingUtils = module.Utils.UnifiedEventLoggingUtils
local unifiedLoggingSurface = module2.Enums.UnifiedLoggingSurface

local function sendClick(p2, p3, p4)
	local v6 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = p2,
		elementName = p3,
		elementMetadata = 0
	}

	local v7 = if p4 then HttpService:JSONEncode(p4) else nil
	v6.elementMetadata = v7
	sendUnifiedEventLog(v6)
end

local function setCreateTileTargetAttributes(instance, p2)
	instance:SetAttribute("AX_BACKGROUNDS_GENERATION_ENTRY", p2 and "create_tile" or nil)
end

return {
	PublishStage = table.freeze({
		ResultMenu = "result_menu",
		DetailsSheet = "details_sheet",
		ConfirmationDialog = "confirmation_dialog"
	}),
	useCreateTileImpressionTarget = function(p2)
		return module3(p2, true, setCreateTileTargetAttributes)
	end,
	reportVisibleCreateTileImpression = function(p2)
		if p2.visibleInstance:GetAttribute("AX_BACKGROUNDS_GENERATION_ENTRY") ~= "create_tile" then
			return
		end

		if fFlagAXUnifiedEventStrictPayloads then
			local screenSize = unifiedEventLoggingUtils.getScreenSize(p2.visibleInstance)
			local elementSizeAndPosition = unifiedEventLoggingUtils.getElementSizeAndPosition(p2.visibleInstance)
			sendUnifiedEventLog({
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
				surface = unifiedLoggingSurface.CUSTOMIZE,
				elementName = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.CREATE_TILE,
				screenSizeWidth = screenSize.screenSizeWidth,
				screenSizeHeight = screenSize.screenSizeHeight,
				elementSizeWidth = elementSizeAndPosition.elementSizeWidth,
				elementSizeHeight = elementSizeAndPosition.elementSizeHeight,
				elementCoordinatesX = elementSizeAndPosition.elementCoordinatesX,
				elementCoordinatesY = elementSizeAndPosition.elementCoordinatesY,
				elementRelativePositionX = elementSizeAndPosition.elementRelativePositionX,
				elementRelativePositionY = elementSizeAndPosition.elementRelativePositionY
			}, p2.visibleInstance)
		else
			local screenSize = unifiedEventLoggingUtils.getScreenSize(p2.visibleInstance)
			local elementSizeAndPosition = unifiedEventLoggingUtils.getElementSizeAndPosition(p2.visibleInstance)

			for k, v5 in elementSizeAndPosition do
				screenSize[k] = v5
			end

			screenSize.action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION
			screenSize.surface = unifiedLoggingSurface.CUSTOMIZE
			screenSize.elementName = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.CREATE_TILE
			sendUnifiedEventLog(screenSize, p2.visibleInstance)
		end
	end,
	sendCreateTileClick = function()
		local customize = unifiedLoggingSurface.CUSTOMIZE
		local CREATE_TILE = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.CREATE_TILE
		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = customize,
			elementName = CREATE_TILE,
			elementMetadata = nil
		})
	end,
	sendGenerateClick = function(p2)
		local BACKGROUND_GENERATION = unifiedLoggingSurface.BACKGROUND_GENERATION
		local GENERATE_BUTTON = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.GENERATE_BUTTON
		local v5 = { generation_state_before_click = p2 }
		local v7 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = BACKGROUND_GENERATION,
			elementName = GENERATE_BUTTON,
			elementMetadata = 0
		}

		local v8 = if v5 then HttpService:JSONEncode(v5) else nil
		v7.elementMetadata = v8
		sendUnifiedEventLog(v7)
	end,
	sendPublishClick = function(p2)
		local BACKGROUND_GENERATION = unifiedLoggingSurface.BACKGROUND_GENERATION
		local PUBLISH_BUTTON = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.PUBLISH_BUTTON
		local v5 = { publish_stage = p2 }
		local v7 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = BACKGROUND_GENERATION,
			elementName = PUBLISH_BUTTON,
			elementMetadata = 0
		}

		local v8 = if v5 then HttpService:JSONEncode(v5) else nil
		v7.elementMetadata = v8
		sendUnifiedEventLog(v7)
	end,
	sendDiscardClick = function()
		local BACKGROUND_GENERATION = unifiedLoggingSurface.BACKGROUND_GENERATION
		local DISCARD_BUTTON = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.DISCARD_BUTTON
		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = BACKGROUND_GENERATION,
			elementName = DISCARD_BUTTON,
			elementMetadata = nil
		})
	end,
	sendBackClick = function(p2)
		local BACKGROUND_GENERATION = unifiedLoggingSurface.BACKGROUND_GENERATION
		local BACK_BUTTON = unifiedLoggingElementNameEnums.BACKGROUNDS.GENERATION.BACK_BUTTON
		local v5 = { generation_state_before_click = p2 }
		local v7 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = BACKGROUND_GENERATION,
			elementName = BACK_BUTTON,
			elementMetadata = 0
		}

		local v8 = if v5 then HttpService:JSONEncode(v5) else nil
		v7.elementMetadata = v8
		sendUnifiedEventLog(v7)
	end
}

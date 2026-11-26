local itemDetailsSduiHost = require("@luauforge/bundled/dTF").ItemDetailsSduiHost
local module = require("@luauforge/bundled/dTs")
local avatarScreen = module.Enums.AvatarScreen
local navigateDownToAvatarScreen = module.Thunks.NavigateDownToAvatarScreen
local unifiedLoggingSurface = module.Enums.UnifiedLoggingSurface
local module2 = require("@luauforge/bundled/dTw")
local marketplaceSurfaceType = module2.Enums.ImpressionEnums.MarketplaceSurfaceType
local marketplaceUnifiedAction = module2.UnifiedEventLogEnums.MarketplaceUnifiedAction
local marketplaceUnifiedItemType = module2.UnifiedEventLogEnums.MarketplaceUnifiedItemType
local unifiedEventLoggingUtils = module2.Utils.UnifiedEventLoggingUtils
local sendUnifiedEventLog = module2.sendUnifiedEventLog
local appPage = require("@luauforge/bundled/dUh").AppPage
local fFlagAXUnifiedEventStrictPayloads = require("@luauforge/bundled/dTp").FFlagAXUnifiedEventStrictPayloads
local fFlagAXSduiCatalogItemTypeIds = require("@luauforge/bundled/dTp").FFlagAXSduiCatalogItemTypeIds

local module3 = require("@luauforge/bundled/dTq")
local sduiActionType = module3.SduiActionType
local sduiErrorType = module3.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = module3.getActionTelemetryFieldValue
local reportUnifiedLoggingAction = module3.reportUnifiedLoggingAction

local module4 = require("@luauforge/bundled/dUi")

local set = {}
local v5 = { Asset = true, Bundle = true }

for k, v6 in avatarScreen do
	if typeof(v6) == "string" then
		set[v6] = true
	end
end

local v6 = {
	[appPage.Home] = {
		purchase = marketplaceSurfaceType.DISCOVERY_HOMEPAGE,
		click = unifiedLoggingSurface.DISCOVERY_HOMEPAGE
	},
	[appPage.SearchPage] = {
		purchase = marketplaceSurfaceType.DISCOVERY_SEARCH_RESULTS,
		click = unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
	}
}

local readOptionalId = module4.readOptionalId
local getItemSubTypeId = module4.getItemSubTypeId
local getUnifiedEventSubType = module4.getUnifiedEventSubType

local function addFields(p2, items)
	if items == nil then
		return
	end

	for k, item in items do
		p2[k] = item
	end
end

local function sendItemSelected(p2, guiObject, click, itemId, p3)
	local v7 = {}
	local ancestorAnalyticsData = p2.ancestorAnalyticsData

	if ancestorAnalyticsData ~= nil then
		for k, v8 in ancestorAnalyticsData do
			v7[k] = v8
		end
	end

	local analyticsData = p2.analyticsData

	if analyticsData ~= nil then
		for k, v8 in analyticsData do
			v7[k] = v8
		end
	end

	local itemPosition = if fFlagAXUnifiedEventStrictPayloads then tonumber(v7.itemPosition) else nil
	local itemsPerRow = if fFlagAXUnifiedEventStrictPayloads then tonumber(v7.itemsPerRow) else nil
	local v8 = if fFlagAXUnifiedEventStrictPayloads then itemPosition else v7.itemPosition
	v7.itemPosition = v8

	local v9 = if fFlagAXUnifiedEventStrictPayloads then tonumber(v7.organicItemPrice) else v7.organicItemPrice
	v7.organicItemPrice = v9
	local v10

	if fFlagAXUnifiedEventStrictPayloads then
		v10 = tonumber(v7.gridPositionRow)

		if not v10 then
			if itemPosition and itemsPerRow and itemsPerRow > 0 then
				v10 = math.ceil(itemPosition / itemsPerRow)
			else
				v10 = itemPosition and 1 or nil
			end
		end
	else
		v10 = v7.gridPositionRow
	end

	v7.gridPositionRow = v10
	local v11

	if fFlagAXUnifiedEventStrictPayloads then
		v11 = tonumber(v7.gridPositionColumn)

		if not v11 then
			if itemPosition and itemsPerRow and itemsPerRow > 0 then
				v11 = (itemPosition - 1) % itemsPerRow + 1
			else
				v11 = itemPosition
			end
		end
	else
		v11 = v7.gridPositionColumn
	end

	v7.gridPositionColumn = v11

	if fFlagAXSduiCatalogItemTypeIds then
		v7.assetType = getUnifiedEventSubType(v7.assetType, "Asset")
		v7.bundleType = getUnifiedEventSubType(v7.bundleType, "Bundle")
	end

	v7.action = marketplaceUnifiedAction.ITEM_SELECTED
	v7.surface = click
	v7.itemId = itemId
	local v12 = if p3 == "Bundle" then marketplaceUnifiedItemType.BUNDLE else marketplaceUnifiedItemType.ASSET
	v7.itemType = v12

	if guiObject ~= nil and (guiObject:IsA("GuiButton") or guiObject:IsA("Frame")) then
		for k, v13 in unifiedEventLoggingUtils.getScreenSize(guiObject) do
			if typeof(k) == "string" then
				v7[k] = v13
			end
		end

		for k, v13 in unifiedEventLoggingUtils.getElementSizeAndPosition(guiObject) do
			if typeof(k) == "string" then
				v7[k] = v13
			end
		end
	end

	sendUnifiedEventLog(v7, guiObject)
end

local function openFromOutsideAvatarExperience(p2, p3, data, p4, p5, itemType, p6)
	local v7 = v6[data.appPage]

	reportUnifiedLoggingAction(data, p2, p3)

	if v7 ~= nil then
		sendItemSelected(p3, p4, v7.click, p5, itemType)
	end

	local dispatch = data.dependencies.dispatch
	local itemDetails = avatarScreen.ItemDetails
	local v9 = itemType .. p5

	local v11 = if v7 ~= nil then v7.purchase else nil
	dispatch(navigateDownToAvatarScreen(itemDetails, v9, {
		itemId = p5,
		itemType = itemType,
		itemSubType = p6,
		mountAsFullView = true,
		mountAnimation = false,
		itemDetailsPeekViewRefs = {},
		isFirstItemDetails = true,
		fromSurface = v11,
		shouldNavigateDown = true
	}))
end

local function SduiOpenCatalogItemDetailsAction(p2, p3, data, p4)
	local actionParams = if p2 then p2.actionParams else nil

	if p2 == nil or actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenCatalogItemDetails,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	local v7 = readOptionalId(actionParams.itemId)

	if v7 == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenCatalogItemDetails,
				message = "Missing actionParam: itemId",
				propName = "itemId"
			},
			data.appPage
		)
		return
	end

	local itemType = actionParams.itemType

	if typeof(itemType) ~= "string" or not v5[itemType] then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenCatalogItemDetails,
				message = `Invalid or missing itemType: {itemType}`,
				propName = "itemType"
			},
			data.appPage
		)
		return
	end

	local v8 = readOptionalId(actionParams.itemSubType)
	local v9 = if v8 ~= nil then getItemSubTypeId(v8, itemType) else nil

	if v8 ~= nil and v9 == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenCatalogItemDetails,
				message = `Unrecognized itemSubType: {v8}`,
				propName = "itemSubType"
			},
			data.appPage
		)
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "itemPosition")
	local v10 = if actionTelemetryFieldValue ~= nil then tonumber(actionTelemetryFieldValue) else nil

	local v11 = itemDetailsSduiHost.get(data.configKey)
	local v12 = v11 == nil and not set[data.appPage]

	if v10 == nil and not v12 then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidItemAnalyticsData,
			{
				name = sduiActionType.OpenCatalogItemDetails,
				message = "Missing itemPosition, so the item click is not logged",
				propName = "itemPosition"
			},
			data.appPage
		)
	end

	if v12 then
		openFromOutsideAvatarExperience(p2, p3, data, p4, v7, itemType, v9)
	elseif v11 == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.OpenCatalogItemDetails,
				message = "No Item Details page is mounted for this configKey"
			},
			data.appPage
		)
	else
		v11.openCatalogItemDetails(
			{ itemId = v7, itemType = itemType, itemSubType = v9, itemPosition = v10 },
			data.dependencies.dispatch
		)
	end
end

return SduiOpenCatalogItemDetailsAction

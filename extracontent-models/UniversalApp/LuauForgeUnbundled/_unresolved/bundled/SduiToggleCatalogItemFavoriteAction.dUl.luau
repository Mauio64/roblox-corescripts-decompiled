local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dTx")
local module2 = require("@luauforge/bundled/dUm")
local setCurrentToastMessage = module2.Actions.SetCurrentToastMessage
local toastType = module2.Enums.ToastType
local setNetworkingErrorToast = require("@luauforge/bundled/dUn").Thunks.SetNetworkingErrorToast

local module3 = require("@luauforge/bundled/dTw")
local eventStream = module3.AnalyticsService.EventStream
local sendUnifiedEventLog = module3.sendUnifiedEventLog
local unifiedEventLogEnums = module3.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module3.Enums.UnifiedLoggingElementNameEnums
local getMarketplaceUnifiedItemType = module3.Utils.getMarketplaceUnifiedItemType
local getUnifiedLoggingSurfaceForAppPage = module3.Utils.getUnifiedLoggingSurfaceForAppPage
local fFlagAXLogFavoritePillToggle = require("@luauforge/bundled/dTp").FFlagAXLogFavoritePillToggle

local module4 = require("@luauforge/bundled/dTq")
local sduiActionType = module4.SduiActionType
local sduiErrorType = module4.SduiErrors.SduiErrorType

local v5 = {
	Asset = module.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore,
	Bundle = module.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore
}

local function readOptionalId(value)
	if typeof(value) == "number" then
		return (tostring(value))
	end

	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function logFavoriteWrite(itemId, itemType, p2, p3)
	eventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", {
		feature = "LuaAvatarExperience",
		itemID = itemId,
		itemType = itemType,
		btn = "Favorite",
		cstm = "Shop",
		checked = p2
	})

	if not fFlagAXLogFavoritePillToggle then
		return
	end

	local unifiedLoggingSurfaceForAppPage = getUnifiedLoggingSurfaceForAppPage(p3.appPage)

	if unifiedLoggingSurfaceForAppPage == nil then
		return
	end

	sendUnifiedEventLog({
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = unifiedLoggingElementNameEnums.ITEM_DETAILS_FAVORITE_BUTTON,
		surface = unifiedLoggingSurfaceForAppPage,
		itemId = itemId,
		itemType = getMarketplaceUnifiedItemType(itemType),
		elementMetadata = HttpService:JSONEncode({
			change_from_favorited_status = tostring(not p2),
			change_to_favorited_status = tostring(p2)
		})
	})
end

local function showSettledToast(p2, p3)
	if p2.type == "error" then
		p3.dependencies.dispatch(setNetworkingErrorToast({
			HttpError = Enum.HttpError.OK
		}))
	else
		p3.dependencies.dispatch(setCurrentToastMessage({
			toastMessage = p2.isFavorited and "Feature.Catalog.Toast.AddedToFavorites" or "Feature.Catalog.Toast.RemovedFromFavorites",
			toastType = toastType.SuccessConfirmation
		}))
	end
end

local function SduiToggleCatalogItemFavoriteAction(p2, p3, p4, p5)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleCatalogItemFavorite,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local itemId = actionParams.itemId

	if typeof(itemId) == "number" then
		itemId = tostring(itemId)
	elseif typeof(itemId) ~= "string" or itemId == "" then
		itemId = nil
	end

	if itemId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleCatalogItemFavorite,
				message = "Missing actionParam: itemId",
				propName = "itemId"
			},
			p4.appPage
		)
		return
	end

	local itemType = actionParams.itemType
	local v6 = if typeof(itemType) == "string" then v5[itemType] else nil

	if v6 == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleCatalogItemFavorite,
				message = `Invalid or missing itemType: {itemType}`,
				propName = "itemType"
			},
			p4.appPage
		)
	elseif not v6(false).toggleFavorite(itemId, {
		onWriteStart = function(p6)
			logFavoriteWrite(itemId, itemType, p6, p4)
		end,
		onSettled = function(p6)
			showSettledToast(p6, p4)
		end
	}) then
		p4.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.ToggleCatalogItemFavorite,
				message = `Favorite state for {itemType} {itemId} has not loaded`
			},
			p4.appPage
		)
	end
end

return SduiToggleCatalogItemFavoriteAction

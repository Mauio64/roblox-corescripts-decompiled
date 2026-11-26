local module = require("@luauforge/bundled/dTh")

local module2 = require("@luauforge/bundled/dTq")
local sduiActionType = module2.SduiActionType
local sduiErrorType = module2.SduiErrors.SduiErrorType

local module3 = require("@luauforge/bundled/dTw")
local sendUnifiedEventLog = module3.sendUnifiedEventLog
local sendUnifiedEventLogForInstance = module3.sendUnifiedEventLogForInstance
local unifiedEventLogEnums = module3.UnifiedEventLogEnums
local getUnifiedLoggingSurfaceForAppPage = module3.Utils.getUnifiedLoggingSurfaceForAppPage

local module4 = require("@luauforge/bundled/dTx")

local v5 = { Recommended = "All" }

local function emitCategoryClickUnifiedEvent(categoryId, p2, p3)
	local marketplaceCatalogCategory = module4.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(categoryId)
	local v6

	if marketplaceCatalogCategory and marketplaceCatalogCategory.data then
		v6 = marketplaceCatalogCategory.data(false)
	end

	local name = if v6 and typeof(v6.name) == "string" and v6.name ~= "" then v6.name else nil

	if name == nil then
		return
	end

	local v7 = v5[categoryId] or name

	local unifiedLoggingSurfaceForAppPage = getUnifiedLoggingSurfaceForAppPage(p2.appPage)

	if unifiedLoggingSurfaceForAppPage == nil then
		return
	end

	local v8 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = "SELECT_CATEGORY_" .. string.upper(v7),
		surface = unifiedLoggingSurfaceForAppPage
	}

	if p3 == nil then
		sendUnifiedEventLog(v8)
	else
		sendUnifiedEventLogForInstance(p3, v8)
	end
end

local function SduiSelectMarketplaceCatalogCategoryAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceCatalogCategory,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local categoryId = actionParams.categoryId

	if typeof(categoryId) ~= "string" or categoryId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceCatalogCategory,
				message = `Invalid or missing categoryId: {categoryId}`
			},
			p4.appPage
		)
		return
	end

	emitCategoryClickUnifiedEvent(categoryId, p4, p5)

	module.selectCategory(categoryId)
end

return SduiSelectMarketplaceCatalogCategoryAction

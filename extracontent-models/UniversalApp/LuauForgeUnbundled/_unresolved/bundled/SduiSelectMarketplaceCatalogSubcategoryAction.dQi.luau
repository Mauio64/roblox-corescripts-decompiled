local module = require("@luauforge/bundled/dPR")

local module2 = require("@luauforge/bundled/dQa")
local sduiActionType = module2.SduiActionType
local sduiErrorType = module2.SduiErrors.SduiErrorType

local module3 = require("@luauforge/bundled/dQg")
local sendUnifiedEventLog = module3.sendUnifiedEventLog
local sendUnifiedEventLogForInstance = module3.sendUnifiedEventLogForInstance
local unifiedEventLogEnums = module3.UnifiedEventLogEnums
local getUnifiedLoggingSurfaceForAppPage = module3.Utils.getUnifiedLoggingSurfaceForAppPage

local module4 = require("@luauforge/bundled/dQh")

local function emitSubcategoryClickUnifiedEvent(subcategoryId, p2, p3)
	local marketplaceCatalogCategory = module4.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(subcategoryId)
	local v5

	if marketplaceCatalogCategory and marketplaceCatalogCategory.data then
		v5 = marketplaceCatalogCategory.data(false)
	end

	local name = if v5 and typeof(v5.name) == "string" and v5.name ~= "" then v5.name else nil

	if name == nil then
		return
	end

	local unifiedLoggingSurfaceForAppPage = getUnifiedLoggingSurfaceForAppPage(p2.appPage)

	if unifiedLoggingSurfaceForAppPage == nil then
		return
	end

	local v6 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = "SELECT_SUBCATEGORY_" .. string.upper(name),
		surface = unifiedLoggingSurfaceForAppPage
	}

	if p3 == nil then
		sendUnifiedEventLog(v6)
	else
		sendUnifiedEventLogForInstance(p3, v6)
	end
end

local function SduiSelectMarketplaceCatalogSubcategoryAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceCatalogSubcategory,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local subcategoryId = actionParams.subcategoryId

	if typeof(subcategoryId) ~= "string" or subcategoryId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceCatalogSubcategory,
				message = `Invalid or missing subcategoryId: {subcategoryId}`
			},
			p4.appPage
		)
		return
	end

	emitSubcategoryClickUnifiedEvent(subcategoryId, p4, p5)

	module.selectSubcategory(subcategoryId)
end

return SduiSelectMarketplaceCatalogSubcategoryAction

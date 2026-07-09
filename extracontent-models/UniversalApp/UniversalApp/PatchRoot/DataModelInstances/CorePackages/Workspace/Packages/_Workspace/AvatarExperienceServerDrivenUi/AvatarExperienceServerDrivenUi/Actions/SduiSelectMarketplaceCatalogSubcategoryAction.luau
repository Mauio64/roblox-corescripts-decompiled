local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local MarketplaceCatalogSduiSelectionBridge = require(AvatarExperienceServerDrivenUi.System.MarketplaceCatalogSduiSelectionBridge)
local SduiCoreSystem = require(AvatarExperienceServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local AvatarExperienceAnalytics = require(AvatarExperienceServerDrivenUiParent.AvatarExperienceAnalytics)
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUnifiedLoggingSurfaceForAppPage = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurfaceForAppPage
local DataHydration = require(AvatarExperienceServerDrivenUiParent.DataHydration)

local function emitSubcategoryClickUnifiedEvent(s1: string, p1, p2) -- line: 24
	-- upvalues: DataHydration (copy), getUnifiedLoggingSurfaceForAppPage (copy), UnifiedEventLogEnums (copy), sendUnifiedEventLogForInstance (copy), sendUnifiedEventLog (copy)
	local v18 = DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(s1)
	local v19 = if not v18 or not v18.data then nil else v18.data(false)
	local v20 = if not v19 or (typeof(v19.name) ~= "string" or v19.name == "") then nil else v19.name

	if v20 == nil then
		return
	end

	local v21 = getUnifiedLoggingSurfaceForAppPage(p1.appPage)

	if v21 == nil then
		return
	end

	local t1 = {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = "SELECT_SUBCATEGORY_" .. string.upper(v20),
		surface = v21
	}

	if p2 ~= nil then
		sendUnifiedEventLogForInstance(p2, t1)

		return
	end

	sendUnifiedEventLog(t1)
end
local function SduiSelectMarketplaceCatalogSubcategoryAction(p3, _, p5, p6) -- line: 63
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), emitSubcategoryClickUnifiedEvent (copy), MarketplaceCatalogSduiSelectionBridge (copy)
	local v27 = p3 and p3.actionParams or nil

	if v27 == nil then
		p5.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.SelectMarketplaceCatalogSubcategory
		}, p5.appPage)

		return
	end

	local subcategoryId = v27.subcategoryId

	if typeof(subcategoryId) ~= "string" or subcategoryId == "" then
		p5.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.SelectMarketplaceCatalogSubcategory,
			message = `Invalid or missing subcategoryId: { subcategoryId }`
		}, p5.appPage)

		return
	end

	emitSubcategoryClickUnifiedEvent(subcategoryId, p5, p6)
	MarketplaceCatalogSduiSelectionBridge.selectSubcategory(subcategoryId)
end

return SduiSelectMarketplaceCatalogSubcategoryAction

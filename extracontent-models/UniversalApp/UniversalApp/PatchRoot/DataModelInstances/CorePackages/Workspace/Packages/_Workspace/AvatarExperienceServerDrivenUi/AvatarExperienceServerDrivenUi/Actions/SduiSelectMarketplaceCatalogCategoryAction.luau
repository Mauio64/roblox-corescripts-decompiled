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
local t1 = {
	Recommended = "All"
}

local function emitCategoryClickUnifiedEvent(s1: string, p1, p2) -- line: 26
	-- upvalues: DataHydration (copy), t1 (copy), getUnifiedLoggingSurfaceForAppPage (copy), UnifiedEventLogEnums (copy), sendUnifiedEventLogForInstance (copy), sendUnifiedEventLog (copy)
	local v19 = DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(s1)
	local v20 = if not v19 or not v19.data then nil else v19.data(false)
	local v21 = if not v20 or (typeof(v20.name) ~= "string" or v20.name == "") then nil else v20.name

	if v21 == nil then
		return
	end

	local v22 = t1[s1] or v21
	local v23 = getUnifiedLoggingSurfaceForAppPage(p1.appPage)

	if v23 == nil then
		return
	end

	local t2 = {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = "SELECT_CATEGORY_" .. string.upper(v22),
		surface = v23
	}

	if p2 ~= nil then
		sendUnifiedEventLogForInstance(p2, t2)

		return
	end

	sendUnifiedEventLog(t2)
end
local function SduiSelectMarketplaceCatalogCategoryAction(p3, _, p5, p6) -- line: 66
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), emitCategoryClickUnifiedEvent (copy), MarketplaceCatalogSduiSelectionBridge (copy)
	local v29 = p3 and p3.actionParams or nil

	if v29 == nil then
		p5.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.SelectMarketplaceCatalogCategory
		}, p5.appPage)

		return
	end

	local categoryId = v29.categoryId

	if typeof(categoryId) ~= "string" or categoryId == "" then
		p5.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.SelectMarketplaceCatalogCategory,
			message = `Invalid or missing categoryId: { categoryId }`
		}, p5.appPage)

		return
	end

	emitCategoryClickUnifiedEvent(categoryId, p5, p6)
	MarketplaceCatalogSduiSelectionBridge.selectCategory(categoryId)
end

return SduiSelectMarketplaceCatalogCategoryAction

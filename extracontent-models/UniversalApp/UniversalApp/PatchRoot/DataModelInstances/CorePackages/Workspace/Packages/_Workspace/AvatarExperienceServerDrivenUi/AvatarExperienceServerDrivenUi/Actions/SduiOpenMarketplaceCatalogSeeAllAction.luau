local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local MarketplaceCatalogSduiSelectionBridge = require(AvatarExperienceServerDrivenUi.System.MarketplaceCatalogSduiSelectionBridge)
local SduiCoreSystem = require(AvatarExperienceServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function readOptionalString(p1) -- line: 14
	if typeof(p1) == "string" and p1 ~= "" then
		return p1
	end

	return nil
end
local function SduiOpenMarketplaceCatalogSeeAllAction(p2, _, p4, _) -- line: 21
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), MarketplaceCatalogSduiSelectionBridge (copy)
	local v14 = p2 and p2.actionParams or nil

	if v14 == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenMarketplaceCatalogSeeAll
		}, p4.appPage)

		return
	end

	local sortId = v14.sortId

	if typeof(sortId) ~= "string" or sortId == "" then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = SduiActionType.OpenMarketplaceCatalogSeeAll,
			message = `Invalid or missing sortId: { sortId }`
		}, p4.appPage)

		return
	end

	local requestFocusedSort = MarketplaceCatalogSduiSelectionBridge.requestFocusedSort
	local t1 = {
		sortId = sortId
	}
	local title = v14.title

	t1.title = if typeof(title) ~= "string" or title == "" then nil else title

	local description = v14.description

	t1.description = if typeof(description) ~= "string" or description == "" then nil else description

	local tooltipText = v14.tooltipText

	t1.tooltipText = if typeof(tooltipText) ~= "string" or tooltipText == "" then nil else tooltipText
	requestFocusedSort(t1)
end

return SduiOpenMarketplaceCatalogSeeAllAction

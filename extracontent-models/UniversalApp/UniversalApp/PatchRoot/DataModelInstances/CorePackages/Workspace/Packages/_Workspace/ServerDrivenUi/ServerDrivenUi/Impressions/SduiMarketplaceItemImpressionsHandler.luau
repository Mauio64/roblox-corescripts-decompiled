local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local AvatarExperienceAnalytics = require(ServerDrivenUiParent.AvatarExperienceAnalytics)
local AXUnifiedEventFilter = AvatarExperienceAnalytics.AXUnifiedEventFilter
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local UnifiedEventLoggingUtils = AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils
local UnifiedLoggingSurface = require(ServerDrivenUiParent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local findCollectionItemInstances = require(ServerDrivenUi.Analytics.findCollectionItemInstances)
local t1 = {}
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType

local function gridPosition(n1: number, n2: number?) -- line: 29
	if not n2 or n2 <= 0 then
		return 1, n1
	end

	return math.ceil(n1 / n2), (n1 - 1) % n2 + 1
end
local function SduiMarketplaceItemImpressionsHandler(p1, t2: {[any]: any}, t3: {[any]: any}, p2, n3: number?, s1: string?) -- line: 47
	-- upvalues: t1 (copy), SduiLogger (copy), SduiErrors (copy), findAnalyticsFieldInAncestors (copy), UnifiedLoggingSurface (copy), MarketplaceUnifiedItemType (copy), findCollectionItemInstances (copy), MarketplaceUnifiedAction (copy), UnifiedEventLoggingUtils (copy), AXUnifiedEventFilter (copy), sendUnifiedEventLog (copy)
	if #t2 == 0 or #(t3 or t1) == 0 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions, {
			name = "SduiMarketplaceItemImpressionsHandler",
			message = `No entries to log: impressionIndexes={ #t2 }, itemAnalyticsDatas={ #(t3 or t1) }`
		}, p1.appPage)

		return 0
	end

	local t4 = {
		analyticsData = p2
	}
	local v28 = findAnalyticsFieldInAncestors("surface", t4)
	local v29 = findAnalyticsFieldInAncestors("itemType", t4)
	local v30 = findAnalyticsFieldInAncestors("universeId", t4)
	local v31 = findAnalyticsFieldInAncestors("itemsPerRow", t4)
	local v32 = if v30 == nil then nil else tonumber(v30)
	local v33 = if v31 == nil then nil else tonumber(v31)
	local v34 = if v28 == nil then nil else UnifiedLoggingSurface[v28]
	local v35 = if v29 == nil then nil else MarketplaceUnifiedItemType[v29]

	if not v34 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions, {
			name = "SduiMarketplaceItemImpressionsHandler",
			message = `Missing or unknown surface on analytics data: { tostring(v28) }`
		}, p1.appPage)

		return 0
	end

	if not v35 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions, {
			name = "SduiMarketplaceItemImpressionsHandler",
			message = `Missing or unknown itemType on analytics data: { tostring(v29) }`
		}, p1.appPage)

		return 0
	end

	local v36 = findCollectionItemInstances(s1)
	local n4 = 0

	for _, v39 in t2 do
		local v40 = t3[v39]

		if v40 ~= nil then
			local v41 = (n3 or 0) + v39
			local n5

			if not v33 or v33 <= 0 then
				n5 = 1
			else
				n5 = math.ceil(v41 / v33)
				v41 = (v41 - 1) % v33 + 1
			end

			local t5 = {
				action = MarketplaceUnifiedAction.ITEM_IMPRESSION,
				surface = v34,
				itemType = v35,
				itemId = v40.id,
				universeId = v32,
				gridPositionRow = n5,
				gridPositionColumn = v41
			}
			local v44 = v36[v39]

			if v44 then
				for v45, v46 in (UnifiedEventLoggingUtils.getScreenSize(v44)) do
					t5[v45] = v46
				end

				for v47, v48 in (UnifiedEventLoggingUtils.getElementSizeAndPosition(v44)) do
					t5[v47] = v48
				end
			end

			AXUnifiedEventFilter.filter(t5)
			sendUnifiedEventLog(t5)
			n4 += 1
		end
	end

	if n4 == 0 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions, {
			name = "SduiMarketplaceItemImpressionsHandler",
			message = "No valid items found for impression indexes"
		}, p1.appPage)
	end

	return n4
end

return SduiMarketplaceItemImpressionsHandler

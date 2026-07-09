local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local UnifiedLogging = require(SduiCoreSystemParent.UnifiedLogging)
local SduiCollectionAnalyticsBuilder = require(SduiCoreSystem.Analytics.SduiCollectionAnalyticsBuilder)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local FFlagSduiErrorCleanup = require(SduiCoreSystemParent.SharedFlags).FFlagSduiErrorCleanup

local function reportUnifiedLoggingAction(p1, p2, p3) -- line: 18
	-- upvalues: FFlagSduiErrorCleanup (copy), SduiCollectionAnalyticsBuilder (copy), SduiErrors (copy), UnifiedLogging (copy)
	local u11 = nil

	if FFlagSduiErrorCleanup then
		u11 = p3.getCollectionData and p3.getCollectionData() or nil
	end

	local v12 = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(p1, p3.analyticsData, p3.ancestorAnalyticsData, nil, p2.actionType, function(_: string?) -- line: 34
		-- upvalues: FFlagSduiErrorCleanup (copy), u11 (ref), p1 (copy), SduiErrors (copy), p2 (copy)
		if not FFlagSduiErrorCleanup or u11 ~= nil then
			p1.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.LogActionInvalidItemData, {
				name = p2.actionType
			})
		end
	end)

	assert(v12, "itemAnalyticsData must exist")

	if not FFlagSduiErrorCleanup then
		u11 = p3.getCollectionData and p3.getCollectionData() or nil
	end

	if not u11 then
		if not FFlagSduiErrorCleanup then
			p1.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.LogActionMissingCollectionData, {
				name = p2.actionType
			})
		end

		u11 = SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA
	end

	assert(u11, "collectionAnalyticsData must exist")
	UnifiedLogging.SendItemActionEvent.sendFromServerDrivenUi(p1.dependencies.eventIngest, v12, v12.itemPosition, u11, p1.appPage, u11.collectionId, u11.contentType, u11.itemsPerRow, u11.collectionPosition, u11.totalNumberOfItems, nil, p2.actionType, p2.actionParams, u11.startRowNumber)
end

return reportUnifiedLoggingAction

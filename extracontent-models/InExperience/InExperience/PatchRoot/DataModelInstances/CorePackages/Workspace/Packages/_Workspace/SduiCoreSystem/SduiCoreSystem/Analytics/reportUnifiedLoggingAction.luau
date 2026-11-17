local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local UnifiedLogging = require(parent.UnifiedLogging)

local SduiCollectionAnalyticsBuilder = require(SduiCoreSystem.Analytics.SduiCollectionAnalyticsBuilder)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)

local function reportUnifiedLoggingAction(p, p2, data)
	local v

	if data.getCollectionData then
		v = data.getCollectionData() or nil
	else
		v = nil
	end

	local v2 = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(
		p,
		data.analyticsData,
		data.ancestorAnalyticsData,
		nil,
		p2.actionType,
		function(_: string?)
			if v ~= nil then
				p.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.LogActionInvalidItemData, {
					name = p2.actionType
				})
			end
		end
	)

	assert(v2, "itemAnalyticsData must exist")

	if not v then
		v = SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA
	end

	assert(v, "collectionAnalyticsData must exist")

	local sendFromServerDrivenUi = UnifiedLogging.SendItemActionEvent.sendFromServerDrivenUi
	local eventIngest = p.dependencies.eventIngest

	local itemPosition = v2.itemPosition
	local v3 = v
	sendFromServerDrivenUi(
		eventIngest,
		v2,
		itemPosition,
		v3,
		p.appPage,
		v.collectionId,
		v.contentType,
		v.itemsPerRow,
		v.collectionPosition,
		v.totalNumberOfItems,
		nil,
		p2.actionType,
		p2.actionParams,
		v.startRowNumber
	)
end

return reportUnifiedLoggingAction

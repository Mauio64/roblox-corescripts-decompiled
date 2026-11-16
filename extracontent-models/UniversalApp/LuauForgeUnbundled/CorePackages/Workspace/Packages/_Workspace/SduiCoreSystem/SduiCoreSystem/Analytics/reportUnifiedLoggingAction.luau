local UnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/UnifiedLogging")

local SduiCollectionAnalyticsBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiCollectionAnalyticsBuilder")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")

local function reportUnifiedLoggingAction(p2, p3, data)
	local v5 = if data.getCollectionData then data.getCollectionData() or nil else nil

	local v6 = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(
		p2,
		data.analyticsData,
		data.ancestorAnalyticsData,
		nil,
		p3.actionType,
		function(p4)
			if v5 ~= nil then
				p2.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.LogActionInvalidItemData, {
					name = p3.actionType
				})
			end
		end
	)

	assert(v6, "itemAnalyticsData must exist")

	if not v5 then
		v5 = SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA
	end

	assert(v5, "collectionAnalyticsData must exist")

	local sendFromServerDrivenUi = UnifiedLogging.SendItemActionEvent.sendFromServerDrivenUi
	local eventIngest = p2.dependencies.eventIngest

	local itemPosition = v6.itemPosition
	local v7 = v5
	sendFromServerDrivenUi(
		eventIngest,
		v6,
		itemPosition,
		v7,
		p2.appPage,
		v5.collectionId,
		v5.contentType,
		v5.itemsPerRow,
		v5.collectionPosition,
		v5.totalNumberOfItems,
		nil,
		p3.actionType,
		p3.actionParams,
		v5.startRowNumber
	)
end

return reportUnifiedLoggingAction

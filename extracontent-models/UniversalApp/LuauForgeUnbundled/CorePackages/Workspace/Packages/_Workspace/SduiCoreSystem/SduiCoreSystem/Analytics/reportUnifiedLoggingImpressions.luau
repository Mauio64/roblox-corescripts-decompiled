local UnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/UnifiedLogging")

local SduiCollectionAnalyticsBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiCollectionAnalyticsBuilder")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local getSduiImpressionHandlerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiImpressionHandlerRegistry")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiImpressionEventType")

local function reportUnifiedLoggingImpressions(p2, p3, p4, p5, p6, p7, p8, p9)
	if not p5 then
		p2.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.LogImpressionsMissingCollectionData,
			{},
			p2.appPage
		)
	end

	local v5 = p5 or SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA
	assert(v5, "collectionAnalyticsData must exist")
	local v6

	if p7 then
		v6 = getSduiImpressionHandlerRegistry().getImpressionHandlerConfig(p7)

		if v6 then
			if v6.handler then
				v6.handler(p2, p3, p4, v5, p6, p9)
			end
		else
			UnifiedLogging.SendItemImpressions.sendFromServerDrivenUi(
				p2.dependencies.eventIngest,
				p3,
				p4,
				v5,
				p2.appPage,
				v5.collectionId,
				v5.contentType,
				v5.itemsPerRow,
				v5.collectionPosition,
				p6,
				p7
			)
		end
	end

	if p8 == nil then
		if v6 and v6.skipItemImpressionsLog then
			return
		end
	elseif p8 then
		return
	end

	UnifiedLogging.SendItemImpressions.sendFromServerDrivenUi(
		p2.dependencies.eventIngest,
		p3,
		p4,
		v5,
		p2.appPage,
		v5.collectionId,
		v5.contentType,
		v5.itemsPerRow,
		v5.collectionPosition,
		p6
	)
end

return reportUnifiedLoggingImpressions

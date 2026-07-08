local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local UnifiedLogging = require(SduiCoreSystemParent.UnifiedLogging)
local SduiCollectionAnalyticsBuilder = require(SduiCoreSystem.Analytics.SduiCollectionAnalyticsBuilder)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local getSduiImpressionHandlerRegistry = require(SduiCoreSystem.getSduiImpressionHandlerRegistry)

require(SduiCoreSystem.SduiImpressionEventType)

local FFlagSduiEdpStoreImpressionsLogging = require(SduiCoreSystemParent.SharedFlags).FFlagSduiEdpStoreImpressionsLogging

local function reportUnifiedLoggingImpressions(p1, t1: {[any]: any}, t2: {[any]: any}, p2, n1: number?, s1: string?, b1: boolean?, s2: string?) -- line: 28
	-- upvalues: SduiErrors (copy), SduiCollectionAnalyticsBuilder (copy), getSduiImpressionHandlerRegistry (copy), FFlagSduiEdpStoreImpressionsLogging (copy), UnifiedLogging (copy)
	if not p2 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.LogImpressionsMissingCollectionData, {}, p1.appPage)
	end

	local v17 = p2 or SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA

	assert(v17, "collectionAnalyticsData must exist")

	local v18 = nil

	if s1 then
		v18 = getSduiImpressionHandlerRegistry().getImpressionHandlerConfig(s1)

		if v18 then
			if v18.handler then
				v18.handler(p1, t1, t2, v17, n1, if not FFlagSduiEdpStoreImpressionsLogging then nil else s2)
			end
		else
			UnifiedLogging.SendItemImpressions.sendFromServerDrivenUi(p1.dependencies.eventIngest, t1, t2, v17, p1.appPage, v17.collectionId, v17.contentType, v17.itemsPerRow, v17.collectionPosition, n1, s1)
		end
	end

	if b1 ~= nil then
		if b1 then
			return
		end
	elseif v18 and v18.skipItemImpressionsLog then
		return
	end

	UnifiedLogging.SendItemImpressions.sendFromServerDrivenUi(p1.dependencies.eventIngest, t1, t2, v17, p1.appPage, v17.collectionId, v17.contentType, v17.itemsPerRow, v17.collectionPosition, n1)
end

return reportUnifiedLoggingImpressions

local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local UnifiedLogging = require(parent.UnifiedLogging)

local SduiCollectionAnalyticsBuilder = require(SduiCoreSystem.Analytics.SduiCollectionAnalyticsBuilder)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local getSduiImpressionHandlerRegistry = require(SduiCoreSystem.getSduiImpressionHandlerRegistry)
require(SduiCoreSystem.SduiImpressionEventType)

local function reportUnifiedLoggingImpressions(p, p2, p3, p4, p5: number?, p6: string?, flag: boolean?, p7: string?)
	if not p4 then
		p.dependencies.logger.reportError(SduiErrors.SduiErrorType.LogImpressionsMissingCollectionData, {}, p.appPage)
	end

	local v = p4 or SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA
	assert(v, "collectionAnalyticsData must exist")
	local v2

	if p6 then
		v2 = getSduiImpressionHandlerRegistry().getImpressionHandlerConfig(p6)

		if v2 then
			if v2.handler then
				v2.handler(p, p2, p3, v, p5, p7)
			end
		else
			UnifiedLogging.SendItemImpressions.sendFromServerDrivenUi(
				p.dependencies.eventIngest,
				p2,
				p3,
				v,
				p.appPage,
				v.collectionId,
				v.contentType,
				v.itemsPerRow,
				v.collectionPosition,
				p5,
				p6
			)
		end
	end

	if flag == nil then
		if v2 and v2.skipItemImpressionsLog then
			return
		end
	elseif flag then
		return
	end

	UnifiedLogging.SendItemImpressions.sendFromServerDrivenUi(
		p.dependencies.eventIngest,
		p2,
		p3,
		v,
		p.appPage,
		v.collectionId,
		v.contentType,
		v.itemsPerRow,
		v.collectionPosition,
		p5
	)
end

return reportUnifiedLoggingImpressions

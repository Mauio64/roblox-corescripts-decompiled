local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local Cryo = require(parent.Cryo)
local UnifiedLogging = require(parent.UnifiedLogging)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local validateInterface = require(SduiCoreSystem.validateInterface)
local analyticsConstants = require(SduiCoreSystem.Analytics.analyticsConstants)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiSkipFeedAnalyticsPosition = SharedFlags2.FFlagSduiSkipFeedAnalyticsPosition

local v = {}

local fn = FFlagSduiSkipFeedAnalyticsPosition and function(p)
	p[analyticsConstants.DoesNotAdvanceStartRow] = nil
end or nil

local v2 = { index = -1, id = "unknown", itemComponentType = "unknown" }

local v3 = {
	collectionId = -1,
	contentType = "unknown",
	itemsPerRow = -1,
	collectionPosition = -1,
	totalNumberOfItems = -1,
	startRowNumber = -1,
	collectionComponentType = "unknown",
	refId = "unknown"
}
local SduiCollectionAnalyticsBuilder = {}

function SduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(p, p2, p3, collectionComponentType, itemsPerRow: number, totalNumberOfItems: number, _: number?, name: string, startRowNumber: number?)
	local joined = Cryo.Dictionary.join(p2 or v, p3 or v)

	if FFlagSduiSkipFeedAnalyticsPosition then
		fn(joined)
	end

	joined.collectionId = tonumber(joined.collectionId) or joined.collectionId
	joined.collectionPosition = tonumber(joined.collectionPosition)
	joined.itemsPerRow = itemsPerRow
	joined.startRowNumber = startRowNumber
	joined.totalNumberOfItems = totalNumberOfItems
	joined.collectionComponentType = collectionComponentType
	local v4, message = validateInterface(
		joined,
		UnifiedLogging.SduiAnalyticsTypes.CollectionAnalyticsDataInterface,
		true
	)

	if not v4 then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.InvalidCollectionAnalyticsData,
			{ componentType = collectionComponentType, name = name, message = message },
			p.appPage
		)

		joined = Cryo.Dictionary.join(v3, joined)
	end

	return joined
end

function SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(p, p2, p3, p4, name: string, callback, p5)
	local joined = Cryo.Dictionary.join(p3 or v, p2 or v, p4 or v)

	if FFlagSduiSkipFeedAnalyticsPosition then
		fn(joined)
	end

	local v4, message = validateInterface(joined, UnifiedLogging.SduiAnalyticsTypes.ItemAnalyticsDataInterface, true)

	if v4 then
		return joined
	end

	if callback then
		callback(message)
	else
		local v5 = { name = name, message = message }

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v5, p5)
		end

		p.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidItemAnalyticsData, v5, p.appPage)
	end

	joined = Cryo.Dictionary.join(v2, joined)

	return joined
end

SduiCollectionAnalyticsBuilder.DUMMY_COLLECTION_DATA = v3
SduiCollectionAnalyticsBuilder.DUMMY_ITEM_DATA = v2
return SduiCollectionAnalyticsBuilder

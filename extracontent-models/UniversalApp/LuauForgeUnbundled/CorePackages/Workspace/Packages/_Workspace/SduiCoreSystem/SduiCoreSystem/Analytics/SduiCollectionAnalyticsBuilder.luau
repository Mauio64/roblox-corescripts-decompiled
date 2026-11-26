local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local UnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/UnifiedLogging")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")

local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local validateInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/validateInterface")
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/analyticsConstants")

local fFlagSduiSkipFeedAnalyticsPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSkipFeedAnalyticsPosition

local v5 = {}

local fn = fFlagSduiSkipFeedAnalyticsPosition and function(p2)
	p2[analyticsConstants.DoesNotAdvanceStartRow] = nil
end or nil

local v6 = { index = -1, id = "unknown", itemComponentType = "unknown" }

local v7 = {
	collectionId = -1,
	contentType = "unknown",
	itemsPerRow = -1,
	collectionPosition = -1,
	totalNumberOfItems = -1,
	startRowNumber = -1,
	collectionComponentType = "unknown",
	refId = "unknown"
}

return {
	buildAndValidateCollectionAnalyticsData = function(p2, p3, p4, collectionComponentType, itemsPerRow, totalNumberOfItems, p5, p6, startRowNumber)
		local joined = Cryo.Dictionary.join(p3 or v5, p4 or v5)

		if fFlagSduiSkipFeedAnalyticsPosition then
			fn(joined)
		end

		joined.collectionId = tonumber(joined.collectionId) or joined.collectionId
		joined.collectionPosition = tonumber(joined.collectionPosition)
		joined.itemsPerRow = itemsPerRow
		joined.startRowNumber = startRowNumber
		joined.totalNumberOfItems = totalNumberOfItems
		joined.collectionComponentType = collectionComponentType
		local v8, v9 = validateInterface(joined, UnifiedLogging.SduiAnalyticsTypes.CollectionAnalyticsDataInterface, true)

		if not v8 then
			p2.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidCollectionAnalyticsData,
				{ componentType = collectionComponentType, name = p6, message = v9 },
				p2.appPage
			)

			joined = Cryo.Dictionary.join(v7, joined)
		end

		return joined
	end,
	buildAndValidateItemAnalyticsData = function(p2, p3, p4, p5, p6, callback, p7)
		local joined = Cryo.Dictionary.join(p4 or v5, p3 or v5, p5 or v5)

		if fFlagSduiSkipFeedAnalyticsPosition then
			fn(joined)
		end

		local v8, v9 = validateInterface(joined, UnifiedLogging.SduiAnalyticsTypes.ItemAnalyticsDataInterface, true)

		if v8 then
			return joined
		end

		if callback then
			callback(v9)
		else
			local v10 = { name = p6, message = v9 }

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v10, p7)
			end

			p2.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidItemAnalyticsData,
				v10,
				p2.appPage
			)
		end

		joined = Cryo.Dictionary.join(v6, joined)

		return joined
	end,
	DUMMY_COLLECTION_DATA = v7,
	DUMMY_ITEM_DATA = v6
}

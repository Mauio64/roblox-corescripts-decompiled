local TopicContentsRodux = script:FindFirstAncestor("TopicContentsRodux")
local TopicContentsEntryModel = require(TopicContentsRodux.TopicContentsEntryModel)
local TopicContentsRoduxParent = TopicContentsRodux.Parent
local DiscoveryTypes = require(TopicContentsRoduxParent.DiscoveryTypes)
local DiscoveryUtils = require(TopicContentsRoduxParent.DiscoveryUtils)
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local GameCollectionItemType = DiscoveryTypes.GameCollectionItemTypes.GameCollectionItemType
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local FFlagLuaAppEnableHomepageOneByTwoTile = require(TopicContentsRoduxParent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local t1 = {
	new = function() -- line: 17
		return {
			entries = {},
			rowsRequested = 0,
			hasMoreRows = false,
			nextPageExclusiveStartId = 0,
			updatedTimestamp = nil,
			nextPageToken = ""
		}
	end
}

function t1.mock() -- line: 31
	-- upvalues: t1 (copy), TopicContentsEntryModel (copy)
	local v11 = t1.new()

	v11.entries = { TopicContentsEntryModel.mock() }
	v11.rowsRequested = 1
	v11.hasMoreRows = false
	v11.nextPageExclusiveStartId = 0
	v11.updatedTimestamp = nil
	v11.nextPageToken = ""

	return v11
end
function t1.fromData(p1) -- line: 45
	return {
		entries = p1.entries,
		rowsRequested = p1.rowsRequested,
		hasMoreRows = p1.hasMoreRows,
		nextPageExclusiveStartId = p1.nextPageExclusiveStartId,
		updatedTimestamp = p1.updatedTimestamp,
		nextPageToken = not p1.nextPageToken and "" or p1.nextPageToken
	}
end
function t1.fromContentList(t2: {[any]: any}?, p2, p3, n1: number?) -- line: 59
	-- upvalues: t1 (copy), TopicContentsEntryModel (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), GameCollectionItemType (copy), DiscoveryEventErrorLogger (copy), OmniRecommendationsContentType (copy)
	local v17 = t1.new()

	v17.updatedTimestamp = n1
	v17.entries = {}
	v17.hasMoreRows = false

	if t2 then
		for _, v in ipairs(t2) do
			if v17.hasMoreRows then
				return v17
			end

			TopicContentsEntryModel.fromOmniRecommendations(v):match(function(p4) -- line: 78
				-- upvalues: FFlagLuaAppEnableHomepageOneByTwoTile (copy), GameCollectionItemType (copy), DiscoveryEventErrorLogger (copy), OmniRecommendationsContentType (copy), v17 (copy), v (copy), p2 (copy), p3 (copy)
				if FFlagLuaAppEnableHomepageOneByTwoTile and p4.componentType == GameCollectionItemType.OneByTwoTile and (not p4.primaryVideoAssetId or not p4.primaryImageAssetId) then
					DiscoveryEventErrorLogger.reportError("TopicContentsModel_OneByTwoTileMissingAssets", "OneByTwoTile entry dropped: missing primaryVideoAssetId or primaryImageAssetId", {
						contentType = tostring(p4.contentType),
						hasVideo = p4.primaryVideoAssetId ~= nil,
						hasImage = p4.primaryImageAssetId ~= nil
					})

					return
				end

				if FFlagLuaAppEnableHomepageOneByTwoTile and p4.contentType == OmniRecommendationsContentType.AdLink then
					if p4.universeId ~= nil then
						DiscoveryEventErrorLogger.reportError("TopicContentsModel_AdLinkUnexpectedUniverseId", "AdLink entry unexpectedly has universe ID")
					end

					table.insert(v17.entries, p4)

					return
				end

				local contentType = v.contentType
				local v22 = p2(contentType)

				if v22 ~= nil then
					local v23 = p3(p4, v22)

					if v23 ~= nil then
						table.insert(v17.entries, v23)

						return
					end

					v17.hasMoreRows = true
				end
			end):matchError(function(p5) -- line: 121
				warn(p5)
			end)
		end
	end

	return v17
end

return t1

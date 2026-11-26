local TopicContentsEntryModel = require("@game/CorePackages/Workspace/Packages/_Index/TopicContentsRodux/TopicContentsRodux/TopicContentsEntryModel")

local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/DiscoveryTypes")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/DiscoveryUtils")
local omniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local gameCollectionItemType = DiscoveryTypes.GameCollectionItemTypes.GameCollectionItemType
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/TopicContentsRodux/SharedFlags").FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local v5 = {}

function v5.new()
	return {
		entries = {},
		rowsRequested = 0,
		hasMoreRows = false,
		nextPageExclusiveStartId = 0,
		["updatedTimestamp"] = nil,
		nextPageToken = ""
	}
end

function v5.mock()
	local v6 = v5.new()

	v6.entries = { TopicContentsEntryModel.mock() }
	v6.rowsRequested = 1
	v6.hasMoreRows = false
	v6.nextPageExclusiveStartId = 0
	v6.updatedTimestamp = nil

	v6.nextPageToken = ""

	return v6
end

function v5.fromData(data)
	return {
		["entries"] = data.entries,
		rowsRequested = data.rowsRequested,
		hasMoreRows = data.hasMoreRows,
		nextPageExclusiveStartId = data.nextPageExclusiveStartId,
		updatedTimestamp = data.updatedTimestamp,
		nextPageToken = not data.nextPageToken and "" or data.nextPageToken
	}
end

function v5.fromContentList(list, callback, callback2, updatedTimestamp, p2)
	local v6 = v5.new()

	v6.updatedTimestamp = updatedTimestamp
	v6.entries = {}
	v6.hasMoreRows = false

	if not list then
		return v6
	end

	for i, item in ipairs(list) do
		if v6.hasMoreRows then
			return v6
		end

		local fromOmniRecommendations = TopicContentsEntryModel.fromOmniRecommendations
		local v7 = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then p2 else nil
		fromOmniRecommendations(item, v7):match(function(data)
			if
				fFlagLuaAppEnableNxMRoduxApportioning
				and data.componentType == gameCollectionItemType.OneByTwoTile
				and not (data.primaryVideoAssetId and data.primaryImageAssetId)
			then
				discoveryEventErrorLogger.reportError(
					"TopicContentsModel_OneByTwoTileMissingAssets",
					"OneByTwoTile entry dropped: missing primaryVideoAssetId or primaryImageAssetId",
					{
						contentType = tostring(data.contentType),
						hasVideo = data.primaryVideoAssetId ~= nil,
						hasImage = data.primaryImageAssetId ~= nil
					}
				)
			elseif
				fFlagLuaAppEnableNxMRoduxApportioning
				and data.contentType == omniRecommendationsContentType.AdLink
			then
				if not data.clickoutUrl or data.clickoutUrl == "" then
					discoveryEventErrorLogger.reportError(
						"TopicContentsModel_AdLinkMissingClickoutUrl",
						"AdLink entry dropped: missing clickoutUrl"
					)

					return
				end

				if data.universeId ~= nil then
					discoveryEventErrorLogger.reportError(
						"TopicContentsModel_AdLinkUnexpectedUniverseId",
						"AdLink entry unexpectedly has universe ID"
					)
				end

				table.insert(v6.entries, data)
			else
				local v8 = callback(item.contentType)

				if v8 ~= nil then
					local v9 = callback2(data, v8)

					if v9 == nil then
						v6.hasMoreRows = true
					else
						table.insert(v6.entries, v9)
					end
				end
			end
		end):matchError(function(p3)
			warn(p3)
		end)
	end

	return v6
end

return v5

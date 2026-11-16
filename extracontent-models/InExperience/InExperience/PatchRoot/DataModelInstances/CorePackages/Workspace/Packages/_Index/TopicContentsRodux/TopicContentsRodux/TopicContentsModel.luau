local TopicContentsRodux = script:FindFirstAncestor("TopicContentsRodux")
local TopicContentsEntryModel = require(TopicContentsRodux.TopicContentsEntryModel)

local parent = TopicContentsRodux.Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local GameCollectionItemType = DiscoveryTypes.GameCollectionItemTypes.GameCollectionItemType
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags2.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local TopicContentsModel = {}

function TopicContentsModel.new()
	return {
		entries = {},
		rowsRequested = 0,
		hasMoreRows = false,
		nextPageExclusiveStartId = 0,
		["updatedTimestamp"] = nil,
		nextPageToken = ""
	}
end

function TopicContentsModel.mock()
	local v = TopicContentsModel.new()

	v.entries = { TopicContentsEntryModel.mock() }
	v.rowsRequested = 1
	v.hasMoreRows = false
	v.nextPageExclusiveStartId = 0
	v.updatedTimestamp = nil

	v.nextPageToken = ""

	return v
end

function TopicContentsModel.fromData(data)
	return {
		["entries"] = data.entries,
		rowsRequested = data.rowsRequested,
		hasMoreRows = data.hasMoreRows,
		nextPageExclusiveStartId = data.nextPageExclusiveStartId,
		updatedTimestamp = data.updatedTimestamp,
		nextPageToken = not data.nextPageToken and "" or data.nextPageToken
	}
end

function TopicContentsModel.fromContentList(list, callback, callback2, updatedTimestamp: number?, p: string?)
	local v = TopicContentsModel.new()

	v.updatedTimestamp = updatedTimestamp
	v.entries = {}
	v.hasMoreRows = false

	if not list then
		return v
	end

	for _, item in ipairs(list) do
		if v.hasMoreRows then
			return v
		end

		local fromOmniRecommendations = TopicContentsEntryModel.fromOmniRecommendations
		local v2

		if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
			v2 = p
		end

		fromOmniRecommendations(item, v2):match(function(data)
			if
				FFlagLuaAppEnableHomepageOneByTwoTile
				and data.componentType == GameCollectionItemType.OneByTwoTile
				and not (data.primaryVideoAssetId and data.primaryImageAssetId)
			then
				DiscoveryEventErrorLogger.reportError(
					"TopicContentsModel_OneByTwoTileMissingAssets",
					"OneByTwoTile entry dropped: missing primaryVideoAssetId or primaryImageAssetId",
					{
						contentType = tostring(data.contentType),
						hasVideo = data.primaryVideoAssetId ~= nil,
						hasImage = data.primaryImageAssetId ~= nil
					}
				)
			elseif
				FFlagLuaAppEnableHomepageOneByTwoTile
				and data.contentType == OmniRecommendationsContentType.AdLink
			then
				if not data.clickoutUrl or data.clickoutUrl == "" then
					DiscoveryEventErrorLogger.reportError(
						"TopicContentsModel_AdLinkMissingClickoutUrl",
						"AdLink entry dropped: missing clickoutUrl"
					)

					return
				end

				if data.universeId ~= nil then
					DiscoveryEventErrorLogger.reportError(
						"TopicContentsModel_AdLinkUnexpectedUniverseId",
						"AdLink entry unexpectedly has universe ID"
					)
				end

				table.insert(v.entries, data)
			else
				local v3 = callback(item.contentType)

				if v3 ~= nil then
					local v4 = callback2(data, v3)

					if v4 == nil then
						v.hasMoreRows = true
					else
						table.insert(v.entries, v4)
					end
				end
			end
		end):matchError(function(p2)
			warn(p2)
		end)
	end

	return v
end

return TopicContentsModel

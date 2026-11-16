local GameCollections = script:FindFirstAncestor("GameCollections")
local parent = GameCollections.Parent

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local calculateGridLayout = require(GameCollections.calculateGridLayout)
local renderEmphasisTile = require(GameCollections.renderEmphasisTile)
local SponsoredTiles = require(parent.SponsoredTiles)
local renderTwoByOneTile = SponsoredTiles.renderTwoByOneTile
local renderOneByTwoTile = SponsoredTiles.renderOneByTwoTile
local renderBlankTile = require(GameCollections.renderBlankTile)
local Cryo = require(parent.Cryo)
require(parent.React)
local GridLayoutTelemetry = require(GameCollections.GridLayoutTelemetry)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local DiscoveryUtils2 = require(parent.DiscoveryUtils)
local ApportioningDiagnosticTelemetry = DiscoveryUtils2.ApportioningDiagnosticTelemetry

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixTotalColsBound = SharedFlags.FFlagLuaAppFixTotalColsBound
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local FFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags.FFlagLuaAppEnableNxMApportioningExtraLogging

local v = {
	[GameCollectionItemTypes.GameCollectionItemType.EmphasisTile] = renderEmphasisTile,
	[GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile] = renderTwoByOneTile,
	[GameCollectionItemTypes.GameCollectionItemType.Blank] = renderBlankTile
}

if FFlagLuaAppEnableHomepageOneByTwoTile then
	v[GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile] = renderOneByTwoTile
end

local spanForItemType

if FFlagLuaAppEnableNxMRoduxApportioning then
	spanForItemType = GameCollectionItemTypes.SpanForItemType
else
	spanForItemType = nil
end

return {
	BuildCollectionEntries = function(list, itemsPerRow: number, items, componentTypes, flag: boolean?, pageContext: string, sortIndex: number?, topicId: string?, list2)
		local collectionEntries = {}

		if FFlagLuaAppEnableNxMRoduxApportioning then
			componentTypes = {}
			items = {}

			for k, item in list do
				if not (item and item.componentType) then
					continue
				end

				if v[item.componentType] then
					componentTypes[k] = item.componentType
				end

				local v2 = spanForItemType[item.componentType]

				if v2 then
					items[k] = {
						colSpan = v2.colSpan,
						rowSpan = v2.rowSpan,
						alignmentType = item.alignmentType,
						minRowPadding = tonumber(item.minRowPadding) or 0
					}
				end
			end
		end

		local totalCols = nil
		local totalRows

		if FFlagLuaAppEnableNxMRoduxApportioning and list2 then
			totalRows = #list2
		else
			if FFlagLuaAppEnableNxMApportioningExtraLogging and items then
				local count = 0
				local spanOverrideMaxKey = 0
				local count2 = 0

				for k, _ in items do
					count += 1

					if spanOverrideMaxKey < k then
						spanOverrideMaxKey = k
					end

					if #list < k then
						count2 += 1
					end
				end

				if count2 > 0 then
					ApportioningDiagnosticTelemetry.log("LegacySpanOverridesMismatch", {
						entriesCount = #list,
						itemsPerRow = itemsPerRow,
						spanOverrideCount = count,
						spanOverrideOutOfRangeCount = count2,
						spanOverrideMaxKey = spanOverrideMaxKey,
						pageContext = pageContext,
						sortIndex = sortIndex,
						topicId = topicId,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end
			end

			local v2 = calculateGridLayout(#list, itemsPerRow, items)
			list2 = v2.layout
			totalRows = v2.totalRows
			totalCols = v2.totalCols
		end

		local v2 = FFlagLuaAppEnableNxMApportioningExtraLogging
			and { realTileCount = 0, blankStaleCount = 0, blankShadowOrEmptyCount = 0 }
			or nil
		local set = {}

		for i = 1, totalRows do
			local v3

			if FFlagLuaAppEnableNxMRoduxApportioning or FFlagLuaAppFixTotalColsBound then
				v3 = itemsPerRow
			else
				v3 = totalCols
			end

			for j = 1, v3 do
				local entryIndex = list2[i] and list2[i][j]

				if entryIndex and entryIndex > 0 then
					local gameCollectionItemTypeOverride

					if componentTypes then
						gameCollectionItemTypeOverride = componentTypes[entryIndex] or nil
					end

					local v4

					if FFlagLuaAppEnableNxMRoduxApportioning then
						v4 = list[entryIndex]
					end

					if gameCollectionItemTypeOverride then
						set[entryIndex] = true

						if FFlagLuaAppEnableNxMRoduxApportioning then
							local v5 = #collectionEntries + 1
							GridLayoutTelemetry.logTilePlaced(
								v4 and v4.adId,
								v4 and v4.universeId,
								gameCollectionItemTypeOverride,
								pageContext,
								itemsPerRow,
								totalRows,
								entryIndex,
								v5,
								sortIndex,
								topicId,
								nil
							)
						else
							local item = list[entryIndex]

							local v5 = #collectionEntries + 1
							local logTilePlaced = GridLayoutTelemetry.logTilePlaced
							local adId = item and item.adId
							local universeId = item and item.universeId
							local v6

							if FFlagLuaAppFixTotalColsBound then
								v6 = totalCols
							end

							logTilePlaced(
								adId,
								universeId,
								gameCollectionItemTypeOverride,
								pageContext,
								itemsPerRow,
								totalRows,
								entryIndex,
								v5,
								sortIndex,
								topicId,
								v6
							)
						end
					end

					if FFlagLuaAppEnableNxMRoduxApportioning and not v4 then
						DiscoveryEventErrorLogger.reportError(
							"GameCollectionItemBuilder_StaleLayoutEntry",
							"layout entryIndex points past end of entries",
							{
								entryIndex = entryIndex,
								entriesCount = #list,
								pageContext = pageContext,
								sortIndex = sortIndex,
								topicId = topicId
							}
						)

						table.insert(collectionEntries, {
							gameCollectionItemTypeOverride = GameCollectionItemTypes.GameCollectionItemType.Blank,
							customRenderFunction = renderBlankTile
						})

						if FFlagLuaAppEnableNxMApportioningExtraLogging and v2 then
							v2.blankStaleCount += 1
						end
					else
						local join = Cryo.Dictionary.join

						if not FFlagLuaAppEnableNxMRoduxApportioning then
							v4 = list[entryIndex]
						end

						local spanOverride

						if items then
							spanOverride = items[entryIndex] or nil
						end

						local v5 = {
							spanOverride = spanOverride,
							gameCollectionItemTypeOverride = gameCollectionItemTypeOverride,
							tileType = gameCollectionItemTypeOverride or GameCollectionItemTypes.GameCollectionItemType.GameTile,
							showDescription = gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.EmphasisTile and flag or nil,
							customRenderFunction = gameCollectionItemTypeOverride and v[gameCollectionItemTypeOverride] or nil
						}
						table.insert(collectionEntries, join(v4, v5))

						if FFlagLuaAppEnableNxMApportioningExtraLogging and v2 then
							v2.realTileCount += 1
						end
					end
				else
					table.insert(collectionEntries, {
						gameCollectionItemTypeOverride = GameCollectionItemTypes.GameCollectionItemType.Blank,
						customRenderFunction = renderBlankTile
					})

					if FFlagLuaAppEnableNxMApportioningExtraLogging and v2 then
						v2.blankShadowOrEmptyCount += 1
					end
				end
			end
		end

		if FFlagLuaAppEnableNxMApportioningExtraLogging and v2 then
			ApportioningDiagnosticTelemetry.log("DerivedEntriesComposed", {
				realTileCount = v2.realTileCount,
				blankStaleCount = v2.blankStaleCount,
				blankShadowOrEmptyCount = v2.blankShadowOrEmptyCount,
				entriesCount = #list,
				totalRows = totalRows,
				totalCols = totalCols,
				itemsPerRow = itemsPerRow,
				pageContext = pageContext,
				sortIndex = sortIndex,
				topicId = topicId,
				nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
			})
		end

		if not componentTypes then
			return collectionEntries
		end

		for k, item in componentTypes do
			if set[k] then
				continue
			end

			local item2 = list[k]
			GridLayoutTelemetry.logTileSkipped(
				item2 and item2.adId,
				item2 and item2.universeId,
				item,
				pageContext,
				itemsPerRow,
				totalRows,
				k,
				sortIndex,
				topicId
			)
		end

		return collectionEntries
	end
}

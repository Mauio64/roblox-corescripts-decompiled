local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes

local calculateGridLayout = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/calculateGridLayout")
local renderEmphasisTile = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/renderEmphasisTile")
local SponsoredTiles = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SponsoredTiles")
local renderTwoByOneTile = SponsoredTiles.renderTwoByOneTile
local renderOneByTwoTile = SponsoredTiles.renderOneByTwoTile
local renderBlankTile = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/renderBlankTile")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local GridLayoutTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GridLayoutTelemetry")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").DiscoveryEventErrorLogger
local apportioningDiagnosticTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").ApportioningDiagnosticTelemetry

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags")
local fFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags.FFlagLuaAppEnableNxMApportioningExtraLogging

local v5 = {
	[gameCollectionItemTypes.GameCollectionItemType.EmphasisTile] = renderEmphasisTile,
	[gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile] = renderTwoByOneTile,
	[gameCollectionItemTypes.GameCollectionItemType.Blank] = renderBlankTile
}

if fFlagLuaAppEnableNxMRoduxApportioning then
	v5[gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile] = renderOneByTwoTile
end

local spanForItemType

if fFlagLuaAppEnableNxMRoduxApportioning then
	spanForItemType = gameCollectionItemTypes.SpanForItemType
else
	spanForItemType = nil
end

return {
	BuildCollectionEntries = function(list, p2, items, componentTypes, p3, p4, p5, p6, list2)
		local collectionEntries = {}

		if fFlagLuaAppEnableNxMRoduxApportioning then
			componentTypes = {}
			items = {}

			for k, item in list do
				if not (item and item.componentType) then
					continue
				end

				if v5[item.componentType] then
					componentTypes[k] = item.componentType
				end

				local v6 = spanForItemType[item.componentType]

				if v6 then
					items[k] = {
						colSpan = v6.colSpan,
						rowSpan = v6.rowSpan,
						alignmentType = item.alignmentType,
						minRowPadding = tonumber(item.minRowPadding) or 0
					}
				end
			end
		end

		local totalCols = nil
		local v6

		if fFlagLuaAppEnableNxMRoduxApportioning and list2 then
			v6 = #list2
		else
			if fFlagLuaAppEnableNxMApportioningExtraLogging and items then
				local count = 0
				local v7 = 0
				local count2 = 0

				for k, item in items do
					count += 1

					if v7 < k then
						v7 = k
					end

					if #list < k then
						count2 += 1
					end
				end

				if count2 > 0 then
					apportioningDiagnosticTelemetry.log("LegacySpanOverridesMismatch", {
						entriesCount = #list,
						itemsPerRow = p2,
						spanOverrideCount = count,
						spanOverrideOutOfRangeCount = count2,
						spanOverrideMaxKey = v7,
						pageContext = p4,
						sortIndex = p5,
						topicId = p6,
						nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
					})
				end
			end

			local v7 = calculateGridLayout(#list, p2, items)
			list2 = v7.layout
			v6 = v7.totalRows
			totalCols = v7.totalCols
		end

		local v7 = fFlagLuaAppEnableNxMApportioningExtraLogging
			and { realTileCount = 0, blankStaleCount = 0, blankShadowOrEmptyCount = 0 }
			or nil
		local set = {}

		for i = 1, v6 do
			for j = 1, p2 do
				local v8 = list2[i] and list2[i][j]

				if v8 and v8 > 0 then
					local v9 = if componentTypes then componentTypes[v8] or nil else nil

					local v10 = if fFlagLuaAppEnableNxMRoduxApportioning then list[v8] else nil

					if v9 then
						set[v8] = true

						if fFlagLuaAppEnableNxMRoduxApportioning then
							local v11 = #collectionEntries + 1
							GridLayoutTelemetry.logTilePlaced(
								v10 and v10.adId,
								v10 and v10.universeId,
								v9,
								p4,
								p2,
								v6,
								v8,
								v11,
								p5,
								p6,
								nil
							)
						else
							local item = list[v8]

							local v11 = #collectionEntries + 1
							GridLayoutTelemetry.logTilePlaced(
								item and item.adId,
								item and item.universeId,
								v9,
								p4,
								p2,
								v6,
								v8,
								v11,
								p5,
								p6,
								totalCols
							)
						end
					end

					if fFlagLuaAppEnableNxMRoduxApportioning and not v10 then
						discoveryEventErrorLogger.reportError(
							"GameCollectionItemBuilder_StaleLayoutEntry",
							"layout entryIndex points past end of entries",
							{
								entryIndex = v8,
								entriesCount = #list,
								pageContext = p4,
								sortIndex = p5,
								topicId = p6
							}
						)

						table.insert(collectionEntries, {
							gameCollectionItemTypeOverride = gameCollectionItemTypes.GameCollectionItemType.Blank,
							customRenderFunction = renderBlankTile
						})

						if fFlagLuaAppEnableNxMApportioningExtraLogging and v7 then
							v7.blankStaleCount += 1
						end
					else
						local join = Cryo.Dictionary.join

						if not fFlagLuaAppEnableNxMRoduxApportioning then
							v10 = list[v8]
						end

						local v12 = if items then items[v8] or nil else nil
						local v11 = {
							spanOverride = v12,
							gameCollectionItemTypeOverride = v9,
							tileType = v9 or gameCollectionItemTypes.GameCollectionItemType.GameTile,
							showDescription = v9 == gameCollectionItemTypes.GameCollectionItemType.EmphasisTile and p3 or nil,
							customRenderFunction = v9 and v5[v9] or nil
						}
						table.insert(collectionEntries, join(v10, v11))

						if fFlagLuaAppEnableNxMApportioningExtraLogging and v7 then
							v7.realTileCount += 1
						end
					end
				else
					table.insert(collectionEntries, {
						gameCollectionItemTypeOverride = gameCollectionItemTypes.GameCollectionItemType.Blank,
						customRenderFunction = renderBlankTile
					})

					if fFlagLuaAppEnableNxMApportioningExtraLogging and v7 then
						v7.blankShadowOrEmptyCount += 1
					end
				end
			end
		end

		if fFlagLuaAppEnableNxMApportioningExtraLogging and v7 then
			apportioningDiagnosticTelemetry.log("DerivedEntriesComposed", {
				realTileCount = v7.realTileCount,
				blankStaleCount = v7.blankStaleCount,
				blankShadowOrEmptyCount = v7.blankShadowOrEmptyCount,
				entriesCount = #list,
				totalRows = v6,
				totalCols = totalCols,
				itemsPerRow = p2,
				pageContext = p4,
				sortIndex = p5,
				topicId = p6,
				nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
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
				p4,
				p2,
				v6,
				k,
				p5,
				p6
			)
		end

		return collectionEntries
	end
}

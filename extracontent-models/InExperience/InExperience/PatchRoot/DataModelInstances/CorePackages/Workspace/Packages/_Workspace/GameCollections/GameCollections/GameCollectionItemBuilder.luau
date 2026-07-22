local GameCollections = script:FindFirstAncestor("GameCollections")
local GameCollectionsParent = GameCollections.Parent
local GameCollectionItemTypes = require(GameCollectionsParent.DiscoveryTypes).GameCollectionItemTypes
local calculateGridLayout = require(GameCollections.calculateGridLayout)
local renderEmphasisTile = require(GameCollections.renderEmphasisTile)
local renderTwoByOneTile = require(GameCollections.renderTwoByOneTile)
local renderOneByTwoTile = require(GameCollections.renderOneByTwoTile)
local renderBlankTile = require(GameCollections.renderBlankTile)
local Cryo = require(GameCollectionsParent.Cryo)

require(GameCollectionsParent.React)

local GridLayoutTelemetry = require(GameCollections.GridLayoutTelemetry)
local DiscoveryEventErrorLogger = require(GameCollectionsParent.DiscoveryUtils).DiscoveryEventErrorLogger
local ApportioningDiagnosticTelemetry = require(GameCollectionsParent.DiscoveryUtils).ApportioningDiagnosticTelemetry
local SharedFlags = require(GameCollectionsParent.SharedFlags)
local FFlagLuaAppFixTotalColsBound = SharedFlags.FFlagLuaAppFixTotalColsBound
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local FFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags.FFlagLuaAppEnableNxMApportioningExtraLogging
local t1 = {
	[GameCollectionItemTypes.GameCollectionItemType.EmphasisTile] = renderEmphasisTile,
	[GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile] = renderTwoByOneTile,
	[GameCollectionItemTypes.GameCollectionItemType.Blank] = renderBlankTile
}

if FFlagLuaAppEnableHomepageOneByTwoTile then
	t1[GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile] = renderOneByTwoTile
end

local v19 = if not FFlagLuaAppEnableNxMRoduxApportioning then nil else GameCollectionItemTypes.SpanForItemType

return {
	BuildCollectionEntries = function(t2: {[any]: any}, n1: number, t3: {[any]: any}?, t4: {[any]: any}?, b1: boolean?, s1: string, n2: number?, s2: string?, t5: {[any]: any}?) -- line: 48
		-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), t1 (copy), v19 (copy), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), ApportioningDiagnosticTelemetry (copy), calculateGridLayout (copy), FFlagLuaAppFixTotalColsBound (copy), GridLayoutTelemetry (copy), DiscoveryEventErrorLogger (copy), GameCollectionItemTypes (copy), renderBlankTile (copy), Cryo (copy)
		local t6 = {}

		if FFlagLuaAppEnableNxMRoduxApportioning then
			t4 = {}
			t3 = {}

			for v30, v31 in t2 do
				if v31 and v31.componentType then
					if t1[v31.componentType] then
						t4[v30] = v31.componentType
					end

					local v32 = v19[v31.componentType]

					if v32 then
						t3[v30] = {
							colSpan = v32.colSpan,
							rowSpan = v32.rowSpan,
							alignmentType = v31.alignmentType,
							minRowPadding = tonumber(v31.minRowPadding) or 0
						}
					end
				end
			end
		end

		local totalCols = nil
		local v34

		if FFlagLuaAppEnableNxMRoduxApportioning and t5 then
			v34 = #t5
		else
			if FFlagLuaAppEnableNxMApportioningExtraLogging and t3 then
				local n3 = 0
				local n4 = 0
				local n5 = 0

				for v38, _ in t3 do
					n3 += 1

					if n5 < v38 then
						n5 = v38
					end

					if v38 > #t2 then
						n4 += 1
					end
				end

				if n4 > 0 then
					ApportioningDiagnosticTelemetry.log("LegacySpanOverridesMismatch", {
						entriesCount = #t2,
						itemsPerRow = n1,
						spanOverrideCount = n3,
						spanOverrideOutOfRangeCount = n4,
						spanOverrideMaxKey = n5,
						pageContext = s1,
						sortIndex = n2,
						topicId = s2,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end
			end

			local v40 = calculateGridLayout(#t2, n1, t3)

			t5 = v40.layout
			v34 = v40.totalRows
			totalCols = v40.totalCols
		end

		local t7 = {}
		local v42 = if not FFlagLuaAppEnableNxMApportioningExtraLogging then nil else {
			realTileCount = 0,
			blankStaleCount = 0,
			blankShadowOrEmptyCount = 0
		}

		for i = 1, v34 do
			for j = 1, if not FFlagLuaAppEnableNxMRoduxApportioning and not FFlagLuaAppFixTotalColsBound then totalCols else n1 do
				local v45 = t5[i] and t5[i][j]

				if v45 and v45 > 0 then
					local v46 = t4 and t4[v45] or nil
					local v47 = if not FFlagLuaAppEnableNxMRoduxApportioning then nil else t2[v45]

					if v46 then
						t7[v45] = true

						if FFlagLuaAppEnableNxMRoduxApportioning then
							local v48 = #t6 + 1

							GridLayoutTelemetry.logTilePlaced(v47 and v47.adId, v47 and v47.universeId, v46, s1, n1, v34, v45, v48, n2, s2, nil)
						else
							local v49 = t2[v45]
							local v50 = #t6 + 1

							GridLayoutTelemetry.logTilePlaced(v49 and v49.adId, v49 and v49.universeId, v46, s1, n1, v34, v45, v50, n2, s2, if not FFlagLuaAppFixTotalColsBound then nil else totalCols)
						end
					end

					if FFlagLuaAppEnableNxMRoduxApportioning and not v47 then
						DiscoveryEventErrorLogger.reportError("GameCollectionItemBuilder_StaleLayoutEntry", "layout entryIndex points past end of entries", {
							entryIndex = v45,
							entriesCount = #t2,
							pageContext = s1,
							sortIndex = n2,
							topicId = s2
						})
						table.insert(t6, {
							gameCollectionItemTypeOverride = GameCollectionItemTypes.GameCollectionItemType.Blank,
							customRenderFunction = renderBlankTile
						})

						if FFlagLuaAppEnableNxMApportioningExtraLogging and v42 then
							v42.blankStaleCount = v42.blankStaleCount + 1
						end
					else
						table.insert(t6, Cryo.Dictionary.join(if not FFlagLuaAppEnableNxMRoduxApportioning then t2[v45] else v47, {
							spanOverride = t3 and t3[v45] or nil,
							gameCollectionItemTypeOverride = v46,
							tileType = v46 or GameCollectionItemTypes.GameCollectionItemType.GameTile,
							showDescription = v46 == GameCollectionItemTypes.GameCollectionItemType.EmphasisTile and b1 or nil,
							customRenderFunction = v46 and t1[v46] or nil
						}))

						if FFlagLuaAppEnableNxMApportioningExtraLogging and v42 then
							v42.realTileCount = v42.realTileCount + 1
						end
					end
				else
					table.insert(t6, {
						gameCollectionItemTypeOverride = GameCollectionItemTypes.GameCollectionItemType.Blank,
						customRenderFunction = renderBlankTile
					})

					if FFlagLuaAppEnableNxMApportioningExtraLogging and v42 then
						v42.blankShadowOrEmptyCount = v42.blankShadowOrEmptyCount + 1
					end
				end
			end
		end

		if FFlagLuaAppEnableNxMApportioningExtraLogging and v42 then
			ApportioningDiagnosticTelemetry.log("DerivedEntriesComposed", {
				realTileCount = v42.realTileCount,
				blankStaleCount = v42.blankStaleCount,
				blankShadowOrEmptyCount = v42.blankShadowOrEmptyCount,
				entriesCount = #t2,
				totalRows = v34,
				totalCols = totalCols,
				itemsPerRow = n1,
				pageContext = s1,
				sortIndex = n2,
				topicId = s2,
				nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
			})
		end

		if t4 then
			for v51, v52 in t4 do
				if not t7[v51] then
					local v53 = t2[v51]

					GridLayoutTelemetry.logTileSkipped(v53 and v53.adId, v53 and v53.universeId, v52, s1, n1, v34, v51, n2, s2)
				end
			end
		end

		return t6
	end
}

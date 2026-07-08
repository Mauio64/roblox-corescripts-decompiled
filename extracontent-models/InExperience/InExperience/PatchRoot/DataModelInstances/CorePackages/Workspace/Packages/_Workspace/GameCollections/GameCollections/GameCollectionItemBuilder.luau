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
local SharedFlags = require(GameCollectionsParent.SharedFlags)
local FFlagLuaAppFixTotalColsBound = SharedFlags.FFlagLuaAppFixTotalColsBound
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local t1 = {
	[GameCollectionItemTypes.GameCollectionItemType.EmphasisTile] = renderEmphasisTile,
	[GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile] = renderTwoByOneTile,
	[GameCollectionItemTypes.GameCollectionItemType.Blank] = renderBlankTile
}

if FFlagLuaAppEnableHomepageOneByTwoTile then
	t1[GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile] = renderOneByTwoTile
end

local v17 = if not FFlagLuaAppEnableNxMRoduxApportioning then nil else GameCollectionItemTypes.SpanForItemType

return {
	BuildCollectionEntries = function(t2: {[any]: any}, n1: number, t3: {[any]: any}?, t4: {[any]: any}?, b1: boolean?, s1: string, n2: number?, s2: string?, t5: {[any]: any}?) -- line: 46
		-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), t1 (copy), v17 (copy), calculateGridLayout (copy), FFlagLuaAppFixTotalColsBound (copy), GridLayoutTelemetry (copy), DiscoveryEventErrorLogger (copy), GameCollectionItemTypes (copy), renderBlankTile (copy), Cryo (copy)
		local t6 = {}

		if FFlagLuaAppEnableNxMRoduxApportioning then
			t4 = {}
			t3 = {}

			for v28, v29 in t2 do
				if v29 and v29.componentType then
					if t1[v29.componentType] then
						t4[v28] = v29.componentType
					end

					local v30 = v17[v29.componentType]

					if v30 then
						t3[v28] = {
							colSpan = v30.colSpan,
							rowSpan = v30.rowSpan,
							alignmentType = v29.alignmentType,
							minRowPadding = tonumber(v29.minRowPadding) or 0
						}
					end
				end
			end
		end

		local totalCols = nil
		local v32

		if FFlagLuaAppEnableNxMRoduxApportioning and t5 then
			v32 = #t5
		else
			local v33 = calculateGridLayout(#t2, n1, t3)

			t5 = v33.layout
			v32 = v33.totalRows
			totalCols = v33.totalCols
		end

		local t7 = {}

		for i = 1, v32 do
			for j = 1, if not FFlagLuaAppEnableNxMRoduxApportioning and not FFlagLuaAppFixTotalColsBound then totalCols else n1 do
				local v37 = t5[i] and t5[i][j]

				if v37 and v37 > 0 then
					local v38 = t4 and t4[v37] or nil
					local v39 = if not FFlagLuaAppEnableNxMRoduxApportioning then nil else t2[v37]

					if v38 then
						t7[v37] = true

						if FFlagLuaAppEnableNxMRoduxApportioning then
							local v40 = #t6 + 1

							GridLayoutTelemetry.logTilePlaced(v39 and v39.adId, v39 and v39.universeId, v38, s1, n1, v32, v37, v40, n2, s2, nil)
						else
							local v41 = t2[v37]
							local v42 = #t6 + 1

							GridLayoutTelemetry.logTilePlaced(v41 and v41.adId, v41 and v41.universeId, v38, s1, n1, v32, v37, v42, n2, s2, if not FFlagLuaAppFixTotalColsBound then nil else totalCols)
						end
					end

					if FFlagLuaAppEnableNxMRoduxApportioning and not v39 then
						DiscoveryEventErrorLogger.reportError("GameCollectionItemBuilder_StaleLayoutEntry", "layout entryIndex points past end of entries", {
							entryIndex = v37,
							entriesCount = #t2,
							pageContext = s1,
							sortIndex = n2,
							topicId = s2
						})
						table.insert(t6, {
							gameCollectionItemTypeOverride = GameCollectionItemTypes.GameCollectionItemType.Blank,
							customRenderFunction = renderBlankTile
						})
					else
						table.insert(t6, Cryo.Dictionary.join(if not FFlagLuaAppEnableNxMRoduxApportioning then t2[v37] else v39, {
							spanOverride = t3 and t3[v37] or nil,
							gameCollectionItemTypeOverride = v38,
							tileType = v38 or GameCollectionItemTypes.GameCollectionItemType.GameTile,
							showDescription = v38 == GameCollectionItemTypes.GameCollectionItemType.EmphasisTile and b1 or nil,
							customRenderFunction = v38 and t1[v38] or nil
						}))
					end
				else
					table.insert(t6, {
						gameCollectionItemTypeOverride = GameCollectionItemTypes.GameCollectionItemType.Blank,
						customRenderFunction = renderBlankTile
					})
				end
			end
		end

		if t4 then
			for v43, v44 in t4 do
				if not t7[v43] then
					local v45 = t2[v43]

					GridLayoutTelemetry.logTileSkipped(v45 and v45.adId, v45 and v45.universeId, v44, s1, n1, v32, v43, n2, s2)
				end
			end
		end

		return t6
	end
}

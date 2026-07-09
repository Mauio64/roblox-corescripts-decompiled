local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local CollectionViews = require(DiscoveryMonolithParent.CollectionViews)
local Cryo = require(DiscoveryMonolithParent.Cryo)

require(DiscoveryMonolithParent.DiscoveryTypes)

local GameCollections = require(DiscoveryMonolithParent.GameCollections)
local FFlagLuaAppEnableNxMRoduxApportioning = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEnableNxMRoduxApportioning
local GameCollectionItemTypes = GameCollections.GameCollectionItemTypes
local SpanForItemType = GameCollectionItemTypes.SpanForItemType
local calculateSpanAwareGrids = CollectionViews.calculateSpanAwareGrids
local Modules = DiscoveryMonolith.Modules
local SetGameGridFlexFeedItemInput = require(Modules.Personalization.OmniFeed.DataStore.SetGameGridFlexFeedItemInput)
local ClearGameGridFlexFeedItemBounds = require(Modules.Personalization.OmniFeed.DataStore.ClearGameGridFlexFeedItemBounds)
local FFlagLuaAppApportioningInCollectionViews = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppApportioningInCollectionViews
local t1 = {
	[GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile] = {
		colSpan = 2,
		rowSpan = 1
	}
}

local function getSpanConfig(p1) -- line: 26
	-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), SpanForItemType (copy), t1 (copy)
	local v19 = p1 and if not FFlagLuaAppEnableNxMRoduxApportioning then t1[p1.componentType] else SpanForItemType[p1.componentType]

	if not v19 then
		return nil
	end

	return {
		colSpan = v19.colSpan,
		rowSpan = not FFlagLuaAppEnableNxMRoduxApportioning and 1 or v19.rowSpan,
		minRowPadding = tonumber(p1.minRowPadding) or 0,
		alignmentType = p1.alignmentType
	}
end
local function countPlacedTiles(t2: {[any]: any}) -- line: 46
	local n1 = 0

	for _, v23 in t2 do
		for _, v25 in v23 do
			if v25 > 0 then
				n1 += 1
			end
		end
	end

	return n1
end
local function recalculateFlexBounds(p2, p3, t3: {[any]: any}, n2: number) -- line: 58
	-- upvalues: Cryo (copy), calculateSpanAwareGrids (copy), FFlagLuaAppApportioningInCollectionViews (copy), getSpanConfig (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), countPlacedTiles (copy)
	local v30 = Cryo.Dictionary.join(p2 or {})
	local t4 = {}

	for _, v in ipairs(p3) do
		table.insert(t4, {
			sortKey = v.sortKey,
			maxRows = v.numberOfRows
		})
	end

	local v34 = calculateSpanAwareGrids(t3, t4, n2, if not FFlagLuaAppApportioningInCollectionViews then nil else getSpanConfig)
	local n3 = 1

	for _, v in ipairs(t4) do
		local sortKey = v.sortKey
		local v39 = v34[sortKey]

		if v39 then
			if FFlagLuaAppEnableNxMRoduxApportioning then
				local v40 = v39.layout or {}

				v30[sortKey] = {
					firstIndex = n3,
					layout = v40
				}
				n3 += countPlacedTiles(v40)
			else
				v30[sortKey] = {
					entryIndices = v39.entryIndices,
					firstIndex = n3
				}
				n3 += #v39.entryIndices
			end
		end
	end

	return v30
end

return function(p4, p5) -- line: 101
	-- upvalues: SetGameGridFlexFeedItemInput (copy), recalculateFlexBounds (copy), Cryo (copy), ClearGameGridFlexFeedItemBounds (copy)
	local v43 = p4 or {}

	if p5.type == SetGameGridFlexFeedItemInput.name then
		local v44 = v43[p5.topicId] or {}
		local v45 = v44.flexItemsInput or {}
		local t5 = {}
		local v47 = false

		for _, v in ipairs(v45) do
			if not v47 then
				if v.sortKey == p5.sortIndex then
					table.insert(t5, {
						sortKey = p5.sortIndex,
						numberOfRows = p5.numberOfRows
					})
					v47 = true
				elseif v.sortKey > p5.sortIndex then
					table.insert(t5, {
						sortKey = p5.sortIndex,
						numberOfRows = p5.numberOfRows
					})
					table.insert(t5, v)
					v47 = true
				else
					table.insert(t5, v)
				end
			else
				table.insert(t5, v)
			end
		end

		if not v47 then
			table.insert(t5, {
				sortKey = p5.sortIndex,
				numberOfRows = p5.numberOfRows
			})
		end

		local v50 = recalculateFlexBounds(v44.flexItemsBounds, t5, p5.entries, p5.itemsPerRow)

		return (Cryo.Dictionary.join(v43, {
			[p5.topicId] = {
				flexItemsInput = t5,
				flexItemsBounds = v50
			}
		}))
	end

	if p5.type == ClearGameGridFlexFeedItemBounds.name then
		local v51 = v43[p5.topicId] or {}
		local v52 = v51.flexItemsInput or {}
		local t6 = {}

		for _, v in ipairs(v52) do
			if v.sortKey ~= p5.sortIndex then
				table.insert(t6, v)
			end
		end

		local v56 = recalculateFlexBounds(v51.flexItemsBounds, t6, p5.entries, p5.itemsPerRow)

		v43 = Cryo.Dictionary.join(v43, {
			[p5.topicId] = {
				flexItemsInput = t6,
				flexItemsBounds = v56
			}
		})
	end

	return v43
end

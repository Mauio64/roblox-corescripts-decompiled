local EventNames = require(script.Parent.EventNames)
local getTileRowInSort = require(script.Parent.getTileRowInSort)

return function(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 18
	-- upvalues: getTileRowInSort (copy), EventNames (copy)
	local impressions = t1.impressions
	local entries = t1.entries
	local startRowNumber = t1.startRowNumber
	local itemsPerRow = t1.itemsPerRow

	if not entries then
		return
	end

	local t2 = {}
	local t3 = {}
	local t4 = {}
	local t5 = {}

	for i = 1, #impressions do
		local v14 = impressions[i]
		local v15 = entries[v14]

		if v15 then
			table.insert(t2, v14)
			table.insert(t3, v15.id)
			table.insert(t4, v15.name)
			table.insert(t5, (getTileRowInSort(v14, startRowNumber, itemsPerRow)))
		end
	end

	p1(EventNames.PlayerTileImpressions, {
		tilePos = t2,
		playerId = t3,
		playerName = t4,
		rowInSort = t5
	})
end

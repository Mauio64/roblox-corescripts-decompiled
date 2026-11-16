local EventNames = require(script.Parent.EventNames)
local getTileRowInSort = require(script.Parent.getTileRowInSort)

return function(data, callback)
	local impressions = data.impressions
	local entries = data.entries
	local startRowNumber = data.startRowNumber
	local itemsPerRow = data.itemsPerRow

	if not entries then
		return
	end

	local impressions2 = {}
	local ids = {}
	local names = {}
	local rowInSort = {}

	for i = 1, #impressions do
		local impression = impressions[i]
		local entry = entries[impression]

		if not entry then
			continue
		end

		table.insert(impressions2, impression)
		table.insert(ids, entry.id)
		table.insert(names, entry.name)

		table.insert(rowInSort, (getTileRowInSort(impression, startRowNumber, itemsPerRow)))
	end

	callback(EventNames.PlayerTileImpressions, {
		tilePos = impressions2,
		playerId = ids,
		playerName = names,
		rowInSort = rowInSort
	})
end

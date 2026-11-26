require("@luauforge/deferred/hfO")

local function getEntriesAsRows(items, p2, p3)
	local entriesAsRows = {}

	for i = 1, p2 do
		entriesAsRows[i] = {}
	end

	for k, item in items do
		local entriesAsRow = entriesAsRows[math.ceil(k / p3)]

		if entriesAsRow then
			table.insert(entriesAsRow, item)
		end
	end

	return entriesAsRows
end

return getEntriesAsRows

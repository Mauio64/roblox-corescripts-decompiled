local function getItemCountForRow(p: number, p2: number)
	return (math.floor(p / math.max(1, p2)))
end

return getItemCountForRow

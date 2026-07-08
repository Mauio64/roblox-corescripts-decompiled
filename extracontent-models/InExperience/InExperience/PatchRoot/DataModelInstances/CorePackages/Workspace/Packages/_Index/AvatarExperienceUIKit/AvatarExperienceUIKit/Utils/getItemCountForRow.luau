local function getItemCountForRow(n1: number, n2: number) -- line: 1
	return (math.floor(n1 / math.max(1, n2)))
end

return getItemCountForRow

local function getItemCountForRow(p2, p3)
	return (math.floor(p2 / math.max(1, p3)))
end

return getItemCountForRow

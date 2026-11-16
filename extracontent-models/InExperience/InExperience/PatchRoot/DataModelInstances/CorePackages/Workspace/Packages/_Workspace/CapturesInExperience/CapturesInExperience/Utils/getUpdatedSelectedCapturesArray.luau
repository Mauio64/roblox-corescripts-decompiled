function getUpdatedSelectedCapturesArray(list, p)
	local updatedSelectedCapturesArray = {}
	local v = false

	for _, item in ipairs(list) do
		if item == p then
			v = true
		else
			table.insert(updatedSelectedCapturesArray, item)
		end
	end

	if not v then
		table.insert(updatedSelectedCapturesArray, p)
	end

	return updatedSelectedCapturesArray
end

return getUpdatedSelectedCapturesArray

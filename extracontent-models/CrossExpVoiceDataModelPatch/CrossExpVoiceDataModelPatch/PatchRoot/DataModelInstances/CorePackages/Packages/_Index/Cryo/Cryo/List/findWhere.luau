local function findWhere(list, callback)
	for i = 1, #list do
		if callback(list[i], i) then
			return i
		end
	end

	return nil
end

return findWhere

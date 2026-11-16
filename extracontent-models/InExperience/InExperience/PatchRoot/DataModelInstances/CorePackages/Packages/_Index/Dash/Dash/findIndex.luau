local function findIndex(list, callback)
	for i, item in ipairs(list) do
		if callback(item, i) then
			return i
		end
	end

	return nil
end

return findIndex

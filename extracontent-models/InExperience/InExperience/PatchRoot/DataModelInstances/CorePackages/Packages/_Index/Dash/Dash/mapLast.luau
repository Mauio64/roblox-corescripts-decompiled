local function mapLast(list, callback)
	for i = #list, 1, -1 do
		local v = callback(list[i], i)

		if v ~= nil then
			return v
		end
	end

	return nil
end

return mapLast

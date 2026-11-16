local function mapFirst(list, callback)
	for i, item in ipairs(list) do
		local v = callback(item, i)

		if v ~= nil then
			return v
		end
	end

	return nil
end

return mapFirst

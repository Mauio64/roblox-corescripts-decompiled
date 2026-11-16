local function mapOne(items, callback)
	for k, item in items do
		if callback then
			item = callback(item, k)
		end

		if item ~= nil then
			return item
		end
	end

	return nil
end

return mapOne

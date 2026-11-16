local function find(items, callback)
	for k, item in items do
		if callback(item, k) then
			return item
		end
	end

	return nil
end

return find

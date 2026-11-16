local function shallowEqual(items, items2): boolean
	for k, item in items do
		if items2[k] ~= item then
			return false
		end
	end

	for k, item in items2 do
		if items[k] ~= item then
			return false
		end
	end

	return true
end

return shallowEqual

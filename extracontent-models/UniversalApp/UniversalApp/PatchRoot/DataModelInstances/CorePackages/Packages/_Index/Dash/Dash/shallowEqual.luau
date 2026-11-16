local function shallowEqual(list, list2): boolean
	if list == list2 then
		return true
	end

	if typeof(list) ~= "table" or typeof(list2) ~= "table" or #list ~= #list2 then
		return false
	end

	if list == nil or list2 == nil then
		return false
	end

	for k, item in list do
		if list2[k] ~= item then
			return false
		end
	end

	for k, item in list2 do
		if list[k] ~= item then
			return false
		end
	end

	return true
end

return shallowEqual

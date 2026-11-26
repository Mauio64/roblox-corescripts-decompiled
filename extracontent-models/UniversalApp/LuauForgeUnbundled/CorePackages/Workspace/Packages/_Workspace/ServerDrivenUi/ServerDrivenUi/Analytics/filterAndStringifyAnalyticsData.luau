return function(items)
	if not items or type(items) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in items do
		if type(k) ~= "string" then
			continue
		end

		if not (type(item) == "string" or type(item) == "number" or type(item) == "boolean") then
			continue
		end

		result[k] = tostring(item)
	end

	if next(result) then
		return result
	end

	return nil
end

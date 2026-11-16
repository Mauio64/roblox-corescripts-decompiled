return function(value, items)
	if type(value) ~= "string" then
		return ""
	end

	if type(items) ~= "table" then
		return value
	end

	for k, item in pairs(items) do
		if not (type(k) == "string" and type(item) == "string") then
			continue
		end

		value = string.gsub(value, k, item)
	end

	return value
end

local function getAQEmotePartData(items)
	if not items then
		return nil
	end

	for k, item in pairs(items) do
		if k ~= "measurement_score" and type(item) == "table" then
			return item
		end
	end

	return nil
end

return getAQEmotePartData

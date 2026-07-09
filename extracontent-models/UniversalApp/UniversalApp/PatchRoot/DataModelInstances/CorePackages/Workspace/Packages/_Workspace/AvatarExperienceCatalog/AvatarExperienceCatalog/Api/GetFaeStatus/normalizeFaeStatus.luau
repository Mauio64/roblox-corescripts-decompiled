local function normalizeFaeStatus(p1) -- line: 10
	if type(p1) ~= "table" then
		return nil, `Type table required, got { type(p1) }.`
	end

	local features = p1.features

	if type(features) ~= "table" then
		return nil, `features field is required and must be a table, got { type(features) }.`
	end

	local t1 = {}

	for _, v6 in features do
		if type(v6) == "table" and type(v6.featureName) == "string" and type(v6.access) == "string" then
			table.insert(t1, {
				featureName = v6.featureName,
				access = v6.access
			})
		end
	end

	return {
		features = t1
	}, nil
end

return normalizeFaeStatus

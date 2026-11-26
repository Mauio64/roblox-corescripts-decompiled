local function normalizeFaeStatus(p2)
	if type(p2) ~= "table" then
		return nil, `Type table required, got {type(p2)}.`
	end

	local features = p2.features

	if type(features) ~= "table" then
		return nil, `features field is required and must be a table, got {type(features)}.`
	end

	local v5 = {}

	for k, feature in features do
		if not (type(feature) == "table" and type(feature.featureName) == "string" and type(feature.access) == "string") then
			continue
		end

		table.insert(v5, { featureName = feature.featureName, access = feature.access })
	end

	return { features = v5 }, nil
end

return normalizeFaeStatus

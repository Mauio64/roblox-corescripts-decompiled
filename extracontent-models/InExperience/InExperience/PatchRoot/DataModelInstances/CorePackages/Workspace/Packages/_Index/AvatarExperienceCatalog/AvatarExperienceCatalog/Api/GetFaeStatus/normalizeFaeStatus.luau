local function normalizeFaeStatus(p)
	if type(p) ~= "table" then
		return nil, `Type table required, got {type(p)}.`
	end

	local features = p.features

	if type(features) ~= "table" then
		return nil, `features field is required and must be a table, got {type(features)}.`
	end

	local features2 = {}

	for _, feature in features do
		if not (type(feature) == "table" and type(feature.featureName) == "string" and type(feature.access) == "string") then
			continue
		end

		table.insert(features2, { featureName = feature.featureName, access = feature.access })
	end

	return { features = features2 }, nil
end

return normalizeFaeStatus

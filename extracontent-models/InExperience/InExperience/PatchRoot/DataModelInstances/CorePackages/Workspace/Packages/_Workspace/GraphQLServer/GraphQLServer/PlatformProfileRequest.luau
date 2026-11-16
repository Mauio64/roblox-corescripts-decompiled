local PlatformProfileRequest = {}

function PlatformProfileRequest.hasPlatformFields(list): boolean
	return table.find(list, "names.platformName") ~= nil or table.find(list, "platformProfileId") ~= nil
end

function PlatformProfileRequest.normalizeProfiles(items, list)
	local v = table.find(list, "names.platformName") ~= nil
	local v2 = table.find(list, "platformProfileId") ~= nil

	if not (v or v2) then
		return items
	end

	local clones = {}

	for _, item in items do
		local clone = table.clone(item)

		if v then
			local names = type(item.names) ~= "table" and {} or table.clone(item.names)

			if type(names.platformName) ~= "string" then
				names.platformName = ""
			end

			clone.names = names
		end

		if v2 and type(clone.platformProfileId) ~= "string" then
			clone.platformProfileId = ""
		end

		table.insert(clones, clone)
	end

	return clones
end

return PlatformProfileRequest

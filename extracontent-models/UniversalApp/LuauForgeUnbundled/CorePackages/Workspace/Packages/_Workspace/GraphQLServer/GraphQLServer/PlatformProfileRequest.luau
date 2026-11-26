return {
	hasPlatformFields = function(list): boolean
		return table.find(list, "names.platformName") ~= nil or table.find(list, "platformProfileId") ~= nil
	end,
	normalizeProfiles = function(items, list)
		local v5 = table.find(list, "names.platformName") ~= nil
		local v6 = table.find(list, "platformProfileId") ~= nil

		if not (v5 or v6) then
			return items
		end

		local clones = {}

		for k, item in items do
			local clone = table.clone(item)

			if v5 then
				local v7 = type(item.names) ~= "table" and {} or table.clone(item.names)

				if type(v7.platformName) ~= "string" then
					v7.platformName = ""
				end

				clone.names = v7
			end

			if v6 and type(clone.platformProfileId) ~= "string" then
				clone.platformProfileId = ""
			end

			table.insert(clones, clone)
		end

		return clones
	end
}

local BuildExperience = script:FindFirstAncestor("BuildExperience")
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)

local function getLibraryMatches(items, p, value: string, p2: string?, flag: boolean)
	local libraryMatches = {}
	local v = string.lower(value)
	local folderIdsById = {}

	if flag and p2 ~= nil then
		for _, item in items do
			if item.className == "Folder" and item.folderId ~= nil then
				folderIdsById[item.id] = item.folderId
			end
		end
	end

	for _, item in items do
		local v2 = item.folderId == p2

		if flag then
			local v3 = item.folderId

			while p2 ~= nil and v3 ~= nil and v3 ~= p2 do
				v3 = folderIdsById[v3]
			end

			if item.className == "Folder" then
				v2 = false
			else
				v2 = p2 == nil or v3 == p2
			end
		end

		if not ((p == nil or item.kind == p) and v2) then
			continue
		end

		if not (v == "" or string.find(string.lower(item.displayName), v, 1, true) ~= nil) then
			continue
		end

		table.insert(libraryMatches, item)
	end

	return libraryMatches
end

return getLibraryMatches

require(script.Parent.LibraryTypes)
local function getFolderPreview(data, items)
	if data.className ~= "Folder" then
		return nil
	end

	local v = {}

	for _, item in items do
		if not (item.folderId == data.id and item.kind == data.kind) then
			continue
		end

		if item.className ~= "Folder" then
			return item
		end

		table.insert(v, item)
	end

	for _, v2 in v do
		local v3 = getFolderPreview(v2, items)

		if v3 ~= nil then
			return v3
		end
	end

	return nil
end

return getFolderPreview

require("@luauforge/deferred/gND")

local function decodeFolder(data)
	return {
		id = data.id,
		name = data.name,
		itemIds = data.itemIds or {}
	}
end

return decodeFolder

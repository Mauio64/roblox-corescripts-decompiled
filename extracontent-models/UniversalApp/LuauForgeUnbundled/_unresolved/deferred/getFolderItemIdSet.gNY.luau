require("@luauforge/deferred/gND")

local function getFolderItemIdSet(p2)
	local folderItemIdSet = {}

	for k, itemId in p2.itemIds do
		folderItemIdSet[tostring(itemId)] = true
	end

	return folderItemIdSet
end

return getFolderItemIdSet

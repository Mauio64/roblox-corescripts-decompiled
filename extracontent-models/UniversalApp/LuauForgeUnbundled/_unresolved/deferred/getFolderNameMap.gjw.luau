require("@luauforge/deferred/giX")

local function getFolderNameMap(items)
	local nameSet = {}

	for k, item in items do
		nameSet[item.name] = true
	end

	return nameSet
end

return getFolderNameMap

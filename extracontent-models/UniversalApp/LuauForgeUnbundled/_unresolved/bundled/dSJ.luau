require("@luauforge/bundled/dPs")
local module = require("@luauforge/bundled/dPN")

local v5 = {}

function v5.new()
	return { items = {} }
end

function v5.mock()
	local v6 = v5.new()

	v6.items = {
		{ id = "123", type = module.ItemType.Asset }
	}

	v6.keyword = ""
	v6.previousPageCursor = ""
	v6.nextPageCursor = ""

	return v6
end

function v5.fromSearchItemsDetails(data)
	local v6 = v5.new()

	v6.items = {}

	for k, v7 in data.data do
		table.insert(v6.items, {
			id = tostring(v7.id),
			type = v7.itemType,
			productId = tostring(v7.productId)
		})
	end

	v6.keyword = data.keyword
	v6.previousPageCursor = data.previousPageCursor
	v6.nextPageCursor = data.nextPageCursor

	return v6
end

return v5

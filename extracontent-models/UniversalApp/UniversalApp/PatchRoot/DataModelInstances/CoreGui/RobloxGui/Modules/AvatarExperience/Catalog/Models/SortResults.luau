local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local t1 = {
	new = function() -- line: 36
		return {
			items = {}
		}
	end
}

function t1.mock() -- line: 44
	-- upvalues: t1 (copy), Constants (copy)
	local v4 = t1.new()

	v4.items = {{
		id = "123",
		type = Constants.ItemType.Asset
	}}
	v4.keyword = ""
	v4.previousPageCursor = ""
	v4.nextPageCursor = ""

	return v4
end
function t1.fromSearchItemsDetails(p1) -- line: 62
	-- upvalues: t1 (copy)
	local v6 = t1.new()

	v6.items = {}

	for _, v8 in p1.data do
		table.insert(v6.items, {
			id = tostring(v8.id),
			type = v8.itemType,
			productId = tostring(v8.productId)
		})
	end

	v6.keyword = p1.keyword
	v6.previousPageCursor = p1.previousPageCursor
	v6.nextPageCursor = p1.nextPageCursor

	return v6
end

return t1

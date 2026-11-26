local module = require("@luauforge/bundled/dtg")

local module2 = require("@luauforge/bundled/dwE")
local module3 = require("@luauforge/bundled/dvE")

return function(p2, list, p3, p4)
	assert(type(list) == "table", "sortCategories should be a table")
	assert(#list >= 1, "Need more than 1 sortCategories")

	return function(object)
		local v5 = {}

		for i, item in ipairs(list) do
			table.insert(v5, object:dispatch(module3(p2, item, nil)))
		end

		return module.all(v5):andThen(function()
			local v6 = {}

			for i, item in ipairs(list) do
				table.insert(v6, object:dispatch(module2(p2, item, p3, p4, nil)))
			end

			return module.all(v6)
		end)
	end
end

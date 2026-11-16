local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dCb")
local module2 = require("@luauforge/bundled/dCd")

local module3 = require("@luauforge/bundled/dwM")
local paginationMethod = require("@luauforge/bundled/dpZ").Modules.LuaApp.Enum.PaginationMethod

return function(options, data)
	local joined = options or {}

	if data.type == module.name then
		local v5 = if data.searchUuid then data.searchUuid else data.keyword

		local v6 = joined[v5] or {}
		local nextPageCursor = v6.nextPageCursor
		local v7

		if nextPageCursor and nextPageCursor ~= "" and nextPageCursor == data.curPageCursor then
			v7 = Cryo.List.join(v6.entries or {}, data.entries)
		else
			v7 = data.entries
		end

		if data.paginationMethod then
			local v8 = paginationMethod[data.paginationMethod]
			module3.assert(v8, `Unknown pagination method: {v8}`)
		end

		return (Cryo.Dictionary.join(joined, {
			[v5] = Cryo.Dictionary.join(v6, {
				nextPageCursor = data.nextPageCursor or Cryo.None,
				keyword = data.keyword,
				entries = v7,
				paginationMethod = data.paginationMethod
			})
		}))
	else
		if data.type ~= module2.name then
			return joined
		end

		local v5 = if data.searchUuid then data.searchUuid else data.keyword

		joined = Cryo.Dictionary.join(joined, { [v5] = Cryo.None })

		return joined
	end
end

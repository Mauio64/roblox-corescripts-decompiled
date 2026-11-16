local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPt")

local module = require("@luauforge/bundled/dPu")

return Rodux.createReducer({}, {
	[module.name] = function(p2, data)
		local v6 = p2[data.searchUuid]

		if v6 and not data.forceUpdate then
			local v7 = {
				items = Cryo.List.join(v6.items, data.sortResults.items),
				initialStorageTime = v6.initialStorageTime,
				nextPageCursor = data.sortResults.nextPageCursor,
				previousPageCursor = data.sortResults.previousPageCursor,
				keyword = data.sortResults.keyword
			}

			return Cryo.Dictionary.join(p2, { [data.searchUuid] = v7 })
		else
			local joined = Cryo.Dictionary.join(data.sortResults, {
				initialStorageTime = tick()
			})

			return Cryo.Dictionary.join(p2, { [data.searchUuid] = joined })
		end
	end
})

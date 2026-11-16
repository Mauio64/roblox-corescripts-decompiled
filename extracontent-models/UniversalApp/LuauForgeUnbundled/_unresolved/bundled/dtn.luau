local module = require("@luauforge/bundled/dqd")

local module2 = require("@luauforge/bundled/dqP")
local module3 = require("@luauforge/bundled/dqQ")
local module4 = require("@luauforge/bundled/dtl")

local v5 = {
	Games = module4.new(),
	GamesSeeAll = module4.new(),
	HomeGames = module4.new(),
	GamesList = module4.new(),
	SearchLandingPage = module4.new()
}

return function(p2, data)
	local v6 = p2 or v5
	assert(v6, "")

	if data.type == module3.name then
		if not v6[data.groupId] then
			return v6
		end

		local joined = module.Dictionary.join(v6[data.groupId], {
			sorts = data.sorts,
			pageId = data.pageId
		})

		return (module.Dictionary.join(v6, { [data.groupId] = joined }))
	else
		if data.type ~= module2.name or not v6[data.groupId] then
			return v6
		end

		local v7 = v6[data.groupId]
		local sorts = data.sorts

		if v7.sorts then
			sorts = module.List.join(v7.sorts, sorts)
		end

		local joined = module.Dictionary.join(v7, { sorts = sorts, pageId = "" })

		v6 = module.Dictionary.join(v6, { [data.groupId] = joined })

		return v6
	end
end

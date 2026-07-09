local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Promise = require(DiscoveryMonolithParent.Promise)
local Modules = DiscoveryMonolith.Modules
local ApiFetchGamesData = require(Modules.LuaApp.Thunks.Games.ApiFetchGamesData)
local ApiFetchSortTokens = require(Modules.LuaApp.Thunks.Games.ApiFetchSortTokens)

return function(p1, p2, p3, p4) -- line: 20
	-- upvalues: ApiFetchSortTokens (copy), Promise (copy), ApiFetchGamesData (copy)
	assert(type(p2) == "table", "sortCategories should be a table")
	assert(#p2 >= 1, "Need more than 1 sortCategories")

	return function(p5) -- line: 24
		-- upvalues: p2 (copy), ApiFetchSortTokens (copy), p1 (copy), Promise (copy), ApiFetchGamesData (copy), p3 (copy), p4 (copy)
		local t1 = {}

		for _, v in ipairs(p2) do
			table.insert(t1, p5:dispatch(ApiFetchSortTokens(p1, v, nil)))
		end

		return Promise.all(t1):andThen(function() -- line: 31
			-- upvalues: p2 (copy), p5 (copy), ApiFetchGamesData (copy), p1 (copy), p3 (copy), p4 (copy), Promise (copy)
			local t2 = {}

			for _, v in ipairs(p2) do
				table.insert(t2, p5:dispatch(ApiFetchGamesData(p1, v, p3, p4, nil)))
			end

			return Promise.all(t2)
		end)
	end
end

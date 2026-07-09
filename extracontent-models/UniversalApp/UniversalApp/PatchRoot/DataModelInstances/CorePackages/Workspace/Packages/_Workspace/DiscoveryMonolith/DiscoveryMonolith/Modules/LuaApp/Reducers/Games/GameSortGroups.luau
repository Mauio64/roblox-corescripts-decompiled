local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Modules = DiscoveryMonolith.Modules
local AppendGameSortsInGroup = require(Modules.LuaApp.Actions.Games.AppendGameSortsInGroup)
local SetGameSortsInGroup = require(Modules.LuaApp.Actions.Games.SetGameSortsInGroup)
local GameSortGroup = require(Modules.LuaApp.Models.GameSortGroup)
local FFlagSearchOmniAutocompletePage = require(DiscoveryMonolithParent.SharedFlags).FFlagSearchOmniAutocompletePage
local t1 = {
	Games = GameSortGroup.new(),
	GamesSeeAll = GameSortGroup.new(),
	HomeGames = GameSortGroup.new(),
	GamesList = GameSortGroup.new(),
	SearchLandingPage = if not FFlagSearchOmniAutocompletePage then nil else GameSortGroup.new()
}

return function(p1, p2) -- line: 22
	-- upvalues: t1 (copy), SetGameSortsInGroup (copy), Cryo (copy), AppendGameSortsInGroup (copy)
	local v12 = p1 or t1

	assert(v12, "")

	if p2.type == SetGameSortsInGroup.name then
		if v12[p2.groupId] then
			local v13 = Cryo.Dictionary.join(v12[p2.groupId], {
				sorts = p2.sorts,
				pageId = p2.pageId
			})

			return (Cryo.Dictionary.join(v12, {
				[p2.groupId] = v13
			}))
		end
	elseif p2.type == AppendGameSortsInGroup.name and v12[p2.groupId] then
		local v14 = v12[p2.groupId]
		local sorts = p2.sorts

		if v14.sorts then
			sorts = Cryo.List.join(v14.sorts, sorts)
		end

		local v16 = Cryo.Dictionary.join(v14, {
			pageId = "",
			sorts = sorts
		})

		v12 = Cryo.Dictionary.join(v12, {
			[p2.groupId] = v16
		})
	end

	return v12
end

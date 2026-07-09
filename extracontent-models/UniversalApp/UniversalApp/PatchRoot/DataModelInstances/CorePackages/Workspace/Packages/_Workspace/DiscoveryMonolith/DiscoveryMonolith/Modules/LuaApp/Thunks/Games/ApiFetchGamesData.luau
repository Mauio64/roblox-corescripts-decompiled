local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local TopicInfosReducer = require(DiscoveryMonolithParent.TopicInfosRodux).TopicInfosReducer
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local Promise = require(DiscoveryMonolithParent.Promise)
local PromiseUtilities = require(DiscoveryMonolithParent.AppCommonLib).Utils.PromiseUtilities
local Modules = DiscoveryMonolith.Modules
local ApiFetchGamesInSort = require(Modules.LuaApp.Thunks.Games.ApiFetchGamesInSort)

return function(p1, p2, p3, p4, n1: number?) -- line: 12
	-- upvalues: GameSortGroups (copy), TopicInfosReducer (copy), ApiFetchGamesInSort (copy), Promise (copy), PromiseUtilities (copy)
	local u14 = p2 or GameSortGroups.Games

	assert(u14, "not nil")

	return function(p5) -- line: 19
		-- upvalues: p3 (copy), u14 (ref), n1 (copy), TopicInfosReducer (copy), ApiFetchGamesInSort (copy), p1 (copy), p4 (copy), Promise (copy), PromiseUtilities (copy)
		local t1 = {}
		local v17 = p5:getState()

		if not p3 then
			local v18 = #v17.GameSortGroups[u14].sorts

			if n1 ~= nil then
				v18 = math.min(n1, v18)
			end

			for i = 1, v18 do
				local v20 = v17.GameSortGroups[u14].sorts[i]
				local v21 = v17.Personalization[TopicInfosReducer.key][v20]

				table.insert(t1, (p5:dispatch(ApiFetchGamesInSort(p1, v21, nil, p4))))
			end
		elseif v17.Personalization[TopicInfosReducer.key][p3] then
			table.insert(t1, (p5:dispatch(ApiFetchGamesInSort(p1, v17.Personalization[TopicInfosReducer.key][p3], nil, p4))))
		else
			Promise.reject()
		end

		return PromiseUtilities.Batch(t1)
	end
end

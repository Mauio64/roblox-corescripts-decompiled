local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

local module2 = require("@luauforge/deferred/gBI")

local v5 = {}

return function(p2, p3)
	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local v8 = useSelector(function(p4)
		return p2 and module2.GetFetchingStatus(p4, p2) or nil
	end)

	local v9 = useSelector(function(p4)
		local v10 = p4.RecommendedGameEntries and p4.RecommendedGameEntries[p2] or nil

		if v10 then
			return v10
		end

		return v5
	end)

	local v10 = React.useCallback(function() end, { v6, v7, p2, p3 })

	React.useEffect(function() end, { v10, p3 })

	return { fetchStatus = v8, refetchRecommendedGames = v10, recommendedGames = v9 }
end

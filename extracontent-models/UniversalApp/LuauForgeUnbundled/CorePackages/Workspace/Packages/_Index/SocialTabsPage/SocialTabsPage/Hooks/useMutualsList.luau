local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local useSignalProfileInsightsByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/ProfileInsights").useSignalProfileInsightsByUserId

local usePageSize = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/usePageSize")

local function useMutualsList(p2)
	local v5 = usePageSize()

	local v6, v7 = useSignalProfileInsightsByUserId({
		userId = p2,
		rankingStrategy = "tc_info_boost"
	})

	local v8 = not (v6 and v6.mutualFriends) and {} or v6.mutualFriends

	local state, setState = React.useState(v5)

	React.useEffect(function()
		setState(v5)
	end, { p2, v5 })

	return {
		mutualFriends = React.useMemo(function()
			local result = {}

			for i = 1, math.min(state, #v8) do
				table.insert(result, v8[i])
			end

			return result
		end, { v8, state }),
		isLoading = v7,
		hasMore = state < #v8,
		loadMore = React.useCallback(function()
			setState(function(p3)
				return (math.min(p3 + v5, #v8))
			end)
		end, { v8, v5 }),
		totalCount = #v8
	}
end

return useMutualsList

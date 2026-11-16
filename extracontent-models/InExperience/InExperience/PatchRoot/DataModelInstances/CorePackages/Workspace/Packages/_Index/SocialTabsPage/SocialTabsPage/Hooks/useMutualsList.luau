local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local ProfileInsights = require(parent.ProfileInsights)
local useSignalProfileInsightsByUserId = ProfileInsights.useSignalProfileInsightsByUserId

local usePageSize = require(SocialTabsPage.Hooks.usePageSize)

local function useMutualsList(userId: string)
	local v = usePageSize()

	local v2, isLoading = useSignalProfileInsightsByUserId({
		userId = userId,
		rankingStrategy = "tc_info_boost"
	})

	local v3 = not (v2 and v2.mutualFriends) and {} or v2.mutualFriends

	local state, setState = React.useState(v)

	React.useEffect(function()
		setState(v)
	end, { userId, v })

	return {
		mutualFriends = React.useMemo(function()
			local result = {}

			for i = 1, math.min(state, #v3) do
				table.insert(result, v3[i])
			end

			return result
		end, { v3, state }),
		isLoading = isLoading,
		hasMore = state < #v3,
		loadMore = React.useCallback(function()
			setState(function(p: number)
				return (math.min(p + v, #v3))
			end)
		end, { v3, v }),
		totalCount = #v3
	}
end

return useMutualsList

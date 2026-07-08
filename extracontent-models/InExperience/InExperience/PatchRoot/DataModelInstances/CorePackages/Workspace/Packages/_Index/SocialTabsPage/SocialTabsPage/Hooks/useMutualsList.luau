local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local useSignalProfileInsightsByUserId = require(SocialTabsPageParent.ProfileInsights).useSignalProfileInsightsByUserId
local usePageSize = require(SocialTabsPage.Hooks.usePageSize)

local function useMutualsList(s1: string) -- line: 24
	-- upvalues: usePageSize (copy), useSignalProfileInsightsByUserId (copy), React (copy)
	local v8 = usePageSize()
	local v9, v10 = useSignalProfileInsightsByUserId({
		rankingStrategy = "tc_info_boost",
		userId = s1
	})
	local v11 = if not v9 or not v9.mutualFriends then {} else v9.mutualFriends
	local v12, v13 = React.useState(v8)

	React.useEffect(function() -- line: 38
		-- upvalues: v13 (copy), v8 (copy)
		v13(v8)
	end, {
		s1,
		v8
	})

	local v14 = React.useMemo(function() -- line: 42
		-- upvalues: v12 (copy), v11 (copy)
		local t1 = {}

		for i = 1, math.min(v12, #v11) do
			table.insert(t1, v11[i])
		end

		return t1
	end, {
		v11,
		v12
	})
	local v15 = v12 < #v11
	local v16 = React.useCallback(function() -- line: 52
		-- upvalues: v13 (copy), v8 (copy), v11 (copy)
		v13(function(n1: number) -- line: 53
			-- upvalues: v8 (copy), v11 (copy)
			return (math.min(n1 + v8, #v11))
		end)
	end, {
		v11,
		v8
	})

	return {
		mutualFriends = v14,
		isLoading = v10,
		hasMore = v15,
		loadMore = v16,
		totalCount = #v11
	}
end

return useMutualsList

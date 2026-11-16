local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local createSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)

local function useDefaultSearchQuery(p)
	local v = React.useMemo(function()
		return p or createSearchQueryStore()
	end, { p })
	local query = v.useDraftQuery()
	local debouncedQuery = v.useDebouncedQuery()

	React.useEffect(function()
		return function()
			if p == nil then
				v.destroy()
			end
		end
	end, { v, p })

	return {
		clear = v.clear,
		debouncedQuery = debouncedQuery,
		query = query,
		setQuery = v.setQuery
	}
end

return useDefaultSearchQuery

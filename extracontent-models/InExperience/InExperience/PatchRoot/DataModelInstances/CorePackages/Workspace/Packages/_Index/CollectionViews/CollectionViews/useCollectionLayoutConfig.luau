local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local CollectionItemSize = require(CollectionViews.CollectionViewTypes).CollectionItemSize
local useCollectionLayoutParamsComputed = require(CollectionViews.useCollectionLayoutParamsComputed)

local function useCollectionLayoutConfig(p1, n1: number?) -- line: 15
	-- upvalues: useCollectionLayoutParamsComputed (copy), React (copy), CollectionItemSize (copy)
	local v9 = useCollectionLayoutParamsComputed(p1, n1)

	return (React.useMemo(function() -- line: 21
		-- upvalues: CollectionItemSize (copy), v9 (copy)
		local t1 = {}

		for _, v12 in CollectionItemSize do
			t1[v12] = v9(v12)
		end

		return t1
	end, { v9 }))
end

return useCollectionLayoutConfig

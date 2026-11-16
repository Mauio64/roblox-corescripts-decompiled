local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)
local CollectionViewTypes = require(CollectionViews.CollectionViewTypes)
local CollectionItemSize = CollectionViewTypes.CollectionItemSize

local useCollectionLayoutParamsComputed = require(CollectionViews.useCollectionLayoutParamsComputed)

local function useCollectionLayoutConfig(p, p2: number?)
	local v = useCollectionLayoutParamsComputed(p, p2)

	return (React.useMemo(function()
		local result = {}

		for _, v2 in CollectionItemSize do
			result[v2] = v(v2)
		end

		return result
	end, { v }))
end

return useCollectionLayoutConfig

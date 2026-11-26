local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes").CollectionItemSize

local useCollectionLayoutParamsComputed = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionLayoutParamsComputed")

local function useCollectionLayoutConfig(p2, p3)
	local v5 = useCollectionLayoutParamsComputed(p2, p3)

	return (React.useMemo(function()
		local result = {}

		for k, v6 in collectionItemSize do
			result[v6] = v5(v6)
		end

		return result
	end, { v5 }))
end

return useCollectionLayoutConfig

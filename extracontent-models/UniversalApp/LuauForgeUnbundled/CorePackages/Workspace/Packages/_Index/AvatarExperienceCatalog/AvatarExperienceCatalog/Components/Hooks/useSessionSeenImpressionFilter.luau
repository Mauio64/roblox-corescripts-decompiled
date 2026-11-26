local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local seenImpressionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").Store.SeenImpressionsStore
local category = seenImpressionsStore.Category

local function useSessionSeenImpressionFilter(p2)
	return React.useCallback(function(p3): boolean
		local v5 = "CatalogSort_" .. p2 .. "_" .. p3

		if seenImpressionsStore.hasSeen(category.WidgetItems, v5) then
			return false
		end

		seenImpressionsStore.markSeen(category.WidgetItems, v5)
		return true
	end, { p2 })
end

return useSessionSeenImpressionFilter

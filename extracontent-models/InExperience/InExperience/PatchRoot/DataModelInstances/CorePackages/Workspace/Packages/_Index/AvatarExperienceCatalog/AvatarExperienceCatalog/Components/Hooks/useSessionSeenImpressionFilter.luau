local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local SeenImpressionsStore = AvatarExperienceAnalytics.Store.SeenImpressionsStore
local Category = SeenImpressionsStore.Category

local function useSessionSeenImpressionFilter(p: string)
	return React.useCallback(function(p2: number): boolean
		local v = "CatalogSort_" .. p .. "_" .. p2

		if SeenImpressionsStore.hasSeen(Category.WidgetItems, v) then
			return false
		end

		SeenImpressionsStore.markSeen(Category.WidgetItems, v)
		return true
	end, { p })
end

return useSessionSeenImpressionFilter

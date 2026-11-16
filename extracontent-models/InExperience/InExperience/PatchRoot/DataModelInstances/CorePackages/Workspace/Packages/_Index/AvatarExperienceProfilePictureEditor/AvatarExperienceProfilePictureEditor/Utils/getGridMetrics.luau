local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local UIBlox = require(parent.UIBlox)

local v = { minimumItemsPerRow = 4, minimumItemWidth = 140 }
local customMetricsGetter = UIBlox.App.Grid.GridMetrics.makeCustomMetricsGetter(v)

local function getGridMetrics(data)
	local v2 = math.max(0, math.max(0, data.containerWidth - data.horizontalPadding * 2) - data.strokeInset * 2)

	if v2 <= 0 then
		return { itemsPerRow = v.minimumItemsPerRow, itemWidth = data.minTileSize }
	end

	local v3 = customMetricsGetter(v2, data.gap)

	if v3.itemWidth < v.minimumItemWidth then
		return { itemsPerRow = v3.itemsPerRow, itemWidth = v.minimumItemWidth }
	end

	return v3
end

return getGridMetrics

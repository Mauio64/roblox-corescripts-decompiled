local v5 = { minimumItemsPerRow = 4, minimumItemWidth = 140 }
local customMetricsGetter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/UIBlox").App.Grid.GridMetrics.makeCustomMetricsGetter(v5)

local function getGridMetrics(data)
	local v6 = math.max(
		0,
		math.max(0, data.containerWidth - 2 * data.horizontalPadding) - 2 * data.strokeInset
	)

	if v6 <= 0 then
		return { itemsPerRow = v5.minimumItemsPerRow, itemWidth = data.minTileSize }
	end

	local v7 = customMetricsGetter(v6, data.gap)

	if v7.itemWidth < v5.minimumItemWidth then
		return { itemsPerRow = v7.itemsPerRow, itemWidth = v5.minimumItemWidth }
	end

	return v7
end

return getGridMetrics

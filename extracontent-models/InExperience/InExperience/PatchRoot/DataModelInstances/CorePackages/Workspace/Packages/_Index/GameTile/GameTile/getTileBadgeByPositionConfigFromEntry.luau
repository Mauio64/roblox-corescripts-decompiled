local GameTile = script:FindFirstAncestor("GameTile")

require(GameTile.GameTileTypes)

local function getTileBadgeByPositionConfigFromEntry(t1: {[any]: any}) -- line: 14
	if t1.badgePosition and (t1.badgeAnalyticsId and t1.badgeType) and (t1.badgeText or t1.badgeIcon) then
		return {
			[t1.badgePosition] = {{
				analyticsId = t1.badgeAnalyticsId,
				tileBadgeType = t1.badgeType,
				text = t1.badgeText,
				icons = if not t1.badgeIcon then nil else { t1.badgeIcon },
				tileBadgeComponentType = t1.badgeComponentType
			}}
		}
	end

	return nil
end

return getTileBadgeByPositionConfigFromEntry

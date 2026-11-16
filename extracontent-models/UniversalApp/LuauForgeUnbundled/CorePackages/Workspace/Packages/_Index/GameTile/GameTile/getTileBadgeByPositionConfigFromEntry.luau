require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local function getTileBadgeByPositionConfigFromEntry(data)
	if
		data.badgePosition
		and data.badgeAnalyticsId
		and data.badgeType
		and (data.badgeText or data.badgeIcon)
	then
		return {
			[data.badgePosition] = {
				{
					analyticsId = data.badgeAnalyticsId,
					tileBadgeType = data.badgeType,
					text = data.badgeText,
					icons = data.badgeIcon and { data.badgeIcon } or nil,
					tileBadgeComponentType = data.badgeComponentType
				}
			}
		}
	end

	return nil
end

return getTileBadgeByPositionConfigFromEntry

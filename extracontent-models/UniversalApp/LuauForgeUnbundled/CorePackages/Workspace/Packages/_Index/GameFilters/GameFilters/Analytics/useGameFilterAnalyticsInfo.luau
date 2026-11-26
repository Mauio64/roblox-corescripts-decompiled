require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")
local topicInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/TopicInfosRodux").TopicInfosReducer

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RoactUtils").Hooks.RoactRodux.useSelector

local function useGameFilterAnalyticsInfo(p2, p3)
	local v5 = useSelector(function(p4)
		return p4.Personalization[topicInfosReducer.key][p2]
	end)

	return React.useMemo(function()
		if v5 then
			return {
				gameSetTypeId = v5.gameSetTypeId,
				gameSetTargetId = v5.gameSetTargetId,
				sortPos = p3
			}
		end

		return {}
	end, { v5, p3 })
end

return useGameFilterAnalyticsInfo

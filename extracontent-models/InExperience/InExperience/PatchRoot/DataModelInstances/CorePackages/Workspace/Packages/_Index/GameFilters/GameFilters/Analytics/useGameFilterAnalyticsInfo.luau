local parent = script:FindFirstAncestor("GameFilters").Parent
require(parent.DiscoveryTypes)
local React = require(parent.React)
local TopicInfosRodux = require(parent.TopicInfosRodux)
local TopicInfosReducer = TopicInfosRodux.TopicInfosReducer

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useGameFilterAnalyticsInfo(p: string, sortPos: number)
	local v = useSelector(function(p2)
		return p2.Personalization[TopicInfosReducer.key][p]
	end)

	return React.useMemo(function()
		if v then
			return {
				gameSetTypeId = v.gameSetTypeId,
				gameSetTargetId = v.gameSetTargetId,
				sortPos = sortPos
			}
		end

		return {}
	end, { v, sortPos })
end

return useGameFilterAnalyticsInfo

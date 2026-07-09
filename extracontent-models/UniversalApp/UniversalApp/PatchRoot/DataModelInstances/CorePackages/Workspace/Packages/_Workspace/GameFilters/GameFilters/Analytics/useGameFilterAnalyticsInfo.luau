local Parent = script:FindFirstAncestor("GameFilters").Parent

require(Parent.DiscoveryTypes)

local React = require(Parent.React)
local TopicInfosReducer = require(Parent.TopicInfosRodux).TopicInfosReducer
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

local function useGameFilterAnalyticsInfo(s1: string, n1: number) -- line: 10
	-- upvalues: useSelector (copy), TopicInfosReducer (copy), React (copy)
	local v8 = useSelector(function(p1) -- line: 11
		-- upvalues: TopicInfosReducer (copy), s1 (copy)
		return p1.Personalization[TopicInfosReducer.key][s1]
	end)

	return React.useMemo(function() -- line: 15
		-- upvalues: v8 (copy), n1 (copy)
		if v8 then
			return {
				gameSetTypeId = v8.gameSetTypeId,
				gameSetTargetId = v8.gameSetTargetId,
				sortPos = n1
			}
		end

		return {}
	end, {
		v8,
		n1
	})
end

return useGameFilterAnalyticsInfo

local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local RecommendationSourceCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/RecommendationSourceCreated")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local v5 = {}

return function(p2)
	return Rodux.createReducer(v5, {
		[RecommendationSourceCreated.name] = function(p3, p4)
			local source = p4.payload.source
			local recommendationIds = p4.payload.recommendationIds or {}

			local reduced = llama.List.reduce(recommendationIds, function(p5, p6)
				p5[tostring(p6)] = true
				return p5
			end, {})

			return llama.Dictionary.join(p3, { [source] = reduced })
		end
	})
end

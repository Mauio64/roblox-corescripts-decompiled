local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

local actions = parent.Actions
local RecommendationSourceCreated = require(actions.RecommendationSourceCreated)

require(parent.roduxFriendsTypes)

local v = {}

return function(_)
	return Rodux.createReducer(v, {
		[RecommendationSourceCreated.name] = function(p, p2)
			local source = p2.payload.source
			local recommendationIds = p2.payload.recommendationIds or {}

			local reduced = llama.List.reduce(recommendationIds, function(p3, p4)
				p3[tostring(p4)] = true
				return p3
			end, {})

			return llama.Dictionary.join(p, { [source] = reduced })
		end
	})
end

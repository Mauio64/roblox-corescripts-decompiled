local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)
local Actions = ParentParent.Actions
local RecommendationSourceCreated = require(Actions.RecommendationSourceCreated)

require(ParentParent.roduxFriendsTypes)

local t1 = {}

return function(_) -- line: 14
	-- upvalues: Rodux (copy), t1 (copy), RecommendationSourceCreated (copy), llama (copy)
	return Rodux.createReducer(t1, {
		[RecommendationSourceCreated.name] = function(p2, p3) -- line: 16
			-- upvalues: llama (copy)
			local source = p3.payload.source
			local v12 = p3.payload.recommendationIds or {}
			local v13 = llama.List.reduce(v12, function(p4, p5) -- line: 23
				p4[tostring(p5)] = true

				return p4
			end, {})

			return llama.Dictionary.join(p2, {
				[source] = v13
			})
		end
	})
end

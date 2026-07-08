local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParent.roduxFriendsTypes)

local selectRecommendationsForUserId = require(script.Parent.selectRecommendationsForUserId)
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local function v7(p1, p2) -- line: 13
	return (p1.rank or 0) - (p2.rank or 0)
end

return function(p3) -- line: 19
	-- upvalues: selectRecommendationsForUserId (copy), Array (copy), Object (copy), v7 (copy)
	return function(p4) -- line: 20
		-- upvalues: selectRecommendationsForUserId (copy), p3 (copy), Array (copy), Object (copy), v7 (copy)
		return function(s1: string, t1: {[any]: any}?) -- line: 21
			-- upvalues: selectRecommendationsForUserId (copy), p3 (copy), p4 (copy), Array (copy), Object (copy), v7 (copy)
			local v14 = selectRecommendationsForUserId(p3)(p4)(s1, t1)

			return Array.map(Array.sort(Object.values(v14), v7), function(p5) -- line: 28
				return p5.id
			end)
		end
	end
end

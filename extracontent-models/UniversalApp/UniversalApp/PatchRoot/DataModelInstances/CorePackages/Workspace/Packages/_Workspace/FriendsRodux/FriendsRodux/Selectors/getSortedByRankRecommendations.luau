local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local llama = require(ParentParentParent.llama)

require(ParentParent.roduxFriendsTypes)

local getDeepValue = require(ParentParent.getDeepValue)

local function v5(p1, p2) -- line: 10
	return p1.rank < p2.rank
end

return function(p3) -- line: 18
	-- upvalues: getDeepValue (copy), llama (copy), v5 (copy)
	local keyPath = p3.keyPath

	return function(p4, p5) -- line: 20
		-- upvalues: getDeepValue (copy), keyPath (copy), llama (copy), v5 (copy)
		local v12 = getDeepValue(p4, string.format("%s.recommendations.byUserId.%s", keyPath, p5)) or {}

		return llama.List.sort(llama.Dictionary.values(v12), v5)
	end
end

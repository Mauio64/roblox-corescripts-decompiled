local ParentParent = script.Parent.Parent
local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local llama = require(Parent.llama)
local getDeepValue = require(ParentParent.getDeepValue)

return function(p1) -- line: 8
	-- upvalues: getDeepValue (copy), llama (copy)
	local keyPath = p1.keyPath

	return function(p2, p3, p4) -- line: 10
		-- upvalues: getDeepValue (copy), keyPath (copy), llama (copy)
		local v10 = getDeepValue(p2, keyPath .. ".byUserId")

		if v10[p3] ~= nil and llama.List.find(v10[p3], p4) then
			return true
		end

		return false
	end
end

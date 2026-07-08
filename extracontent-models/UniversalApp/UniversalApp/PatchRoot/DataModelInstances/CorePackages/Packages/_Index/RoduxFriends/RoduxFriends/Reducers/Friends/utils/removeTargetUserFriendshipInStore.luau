local Parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(Parent.llama)
local removeUser = require(script.Parent.removeUser)

return function(p1, p2) -- line: 9
	-- upvalues: llama (copy), removeUser (copy)
	local str = tostring(p2.additionalData.currentUserId)
	local str2 = tostring(p2.namedIds.users)
	local v8 = llama.Dictionary.join(p1, {
		[str] = removeUser(p1[str], str2),
		[str2] = removeUser(p1[str2], str)
	})

	v8[str2] = nil

	return v8
end

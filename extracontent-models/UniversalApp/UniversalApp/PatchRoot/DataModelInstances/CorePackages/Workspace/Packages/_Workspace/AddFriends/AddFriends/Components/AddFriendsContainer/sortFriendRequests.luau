local Parent = script:FindFirstAncestor("AddFriends").Parent
local llama = require(Parent.llama)
local t = require(Parent.t)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: t (copy), llama (copy)
	assert(t.table(t1))

	return llama.List.sort(t1, function(p1, p2) -- line: 19
		local v7 = p1.sentAt and p1.sentAt.UnixTimestampMillis or 0
		local v8 = p2.sentAt and p2.sentAt.UnixTimestampMillis or 0

		if v7 ~= v8 then
			return v8 < v7
		end

		if p1.displayName and not p2.displayName then
			return true
		end

		if not p1.displayName and p2.displayName then
			return false
		end

		if p1.displayName and p2.displayName and string.lower(p1.displayName) ~= string.lower(p2.displayName) then
			return string.lower(p1.displayName) < string.lower(p2.displayName)
		end

		if p1.username and p2.username then
			return string.lower(p1.username) < string.lower(p2.username)
		end

		if p1.username and not p2.username then
			return true
		end

		return false
	end)
end

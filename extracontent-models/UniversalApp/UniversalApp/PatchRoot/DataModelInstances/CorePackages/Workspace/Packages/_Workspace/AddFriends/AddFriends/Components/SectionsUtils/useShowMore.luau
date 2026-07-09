local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local FFlagAddFriendsUserListEnabled = require(Parent.SharedFlags).FFlagAddFriendsUserListEnabled

return function(n1: number, n2: number, n3: number, p1: ((...any) -> ...any)) -- line: 8
	-- upvalues: React (copy), FFlagAddFriendsUserListEnabled (copy)
	local v8, v9 = React.useState(n1 or 0)

	if FFlagAddFriendsUserListEnabled then
		React.useEffect(function() -- line: 16
			-- upvalues: v9 (copy), n1 (copy)
			v9(n1 or 0)
		end, { n1 })
	end

	local v10, v11 = React.useState(1)

	return React.useCallback(function() -- line: 23
		-- upvalues: p1 (copy), v11 (copy), v8 (copy), n3 (copy), n2 (copy), v9 (copy)
		p1()
		v11(v8 * n3 + 1)

		local v12 = math.ceil(n2 / n3) - 2

		if v12 <= 0 then
			v12 = math.floor(n2 / n3)
		end

		v9(v8 + v12)
	end, {
		v8,
		n2,
		p1,
		n3
	}), v8, v10
end

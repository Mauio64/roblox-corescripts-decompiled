local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local UserModel = require(Parent.UserLib).Models.UserModel
local UpdateUsers = require(Parent.UserLib).Thunks.UpdateUsers

local function v4(p1) -- line: 6
	-- upvalues: UserModel (copy)
	local t1 = {}

	for k, v in pairs(p1) do
		v.isFriend = true
		v.friendRank = k

		local v9 = UserModel.fromDataTable(v)

		t1[v9.id] = v9
	end

	return t1
end

return function(p2, p3) -- line: 18
	-- upvalues: v4 (copy), UpdateUsers (copy)
	return function(p4) -- line: 19
		-- upvalues: v4 (copy), p2 (copy), p3 (copy), UpdateUsers (copy)
		local v13 = v4(p2)

		if p3 and (p3.mockedActions and p3.mockedActions.UpdateUsers) then
			p3.mockedActions.UpdateUsers(v13)

			return
		end

		p4:dispatch(UpdateUsers(v13))
	end
end

local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local useSelector = require(UserListParent.RoactUtils).Hooks.RoactRodux.useSelector

require(UserList.Common.Enums)

return function() -- line: 11
	-- upvalues: useSelector (copy)
	return {
		formFactor = useSelector(function(p1) -- line: 12
			return p1.FormFactor
		end)
	}
end

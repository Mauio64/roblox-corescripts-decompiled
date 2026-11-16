local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
require(UserList.Common.Enums)

return function()
	return {
		formFactor = useSelector(function(p)
			return p.FormFactor
		end)
	}
end

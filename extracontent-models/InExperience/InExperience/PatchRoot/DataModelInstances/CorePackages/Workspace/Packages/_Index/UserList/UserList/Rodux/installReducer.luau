local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local Rodux = require(parent.Rodux)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)

return function()
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end

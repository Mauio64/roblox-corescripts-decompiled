local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local RoduxNetworking = require(ParentParent.Networking.RoduxNetworking)

return function() -- line: 6
	-- upvalues: Rodux (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		NetworkStatus = RoduxNetworking.installReducer()
	})
end

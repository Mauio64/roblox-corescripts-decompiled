local parent = script:FindFirstAncestor("RoduxUsers").Parent
local Rodux = require(parent.Rodux)

local byUserId = require(script.Users.byUserId)
local byUsername = require(script.Users.byUsername)

return function(p)
	return Rodux.combineReducers({ byUserId = byUserId(p), byUsername = byUsername(p) })
end

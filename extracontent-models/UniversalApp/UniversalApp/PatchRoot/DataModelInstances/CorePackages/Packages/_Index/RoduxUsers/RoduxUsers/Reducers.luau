local Parent = script:FindFirstAncestor("RoduxUsers").Parent
local Rodux = require(Parent.Rodux)
local byUserId = require(script.Users.byUserId)
local byUsername = require(script.Users.byUsername)

return function(p1) -- line: 8
	-- upvalues: Rodux (copy), byUserId (copy), byUsername (copy)
	return Rodux.combineReducers({
		byUserId = byUserId(p1),
		byUsername = byUsername(p1)
	})
end

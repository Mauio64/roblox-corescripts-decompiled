local Parent = script:FindFirstAncestor("AppChat").Parent
local MockUser = require(Parent.UserLib).Models.MockUser

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: MockUser (copy)
	local v4 = MockUser.new()

	v4.name = t1.name
	v4.displayName = t1.displayName
	v4.id = t1.id
	v4.isFriend = t1.isFriend or true

	return v4
end

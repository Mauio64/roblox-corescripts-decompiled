local Players = game:GetService("Players")

return function(object, value, value2, value3, value4, value5, p2)
	assert(type(value) == "string", "Expected buttonName to be a string")
	assert(type(value2) == "string", "Expected friendId to be a string")
	assert(type(value3) == "number", "Expected position to be a number")
	assert(value4 == nil or type(value4) == "string", "Expected context to be nil or string")
	assert(type(value5) == "number", "Expected absolutePosition to be a number")
	assert(p2 == nil or type(p2) == "table", "Expected extraArgs to be nil or table")

	local v7 = {
		uid = tostring(Players.LocalPlayer.UserId),
		friendId = value2,
		position = value3,
		btn = value,
		absolutePosition = value5,
		universeId = 0,
		source = 0
	}

	local v8 = if p2 then p2.universeId else nil
	v7.universeId = v8
	local v9 = if p2 then p2.source else nil
	v7.source = v9
	object:setRBXEventStream(value4 or "contactFriendFinder", "buttonClick", v7)
end

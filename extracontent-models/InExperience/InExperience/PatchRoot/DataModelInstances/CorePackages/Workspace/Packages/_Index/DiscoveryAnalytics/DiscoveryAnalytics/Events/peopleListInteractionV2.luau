local Players = game:GetService("Players")

return function(object, btn, value, value2, value3, value4, p)
	assert(type(btn) == "string", "Expected buttonName to be a string")
	assert(type(value) == "string", "Expected friendId to be a string")
	assert(type(value2) == "number", "Expected position to be a number")
	assert(value3 == nil or type(value3) == "string", "Expected context to be nil or string")
	assert(type(value4) == "number", "Expected absolutePosition to be a number")
	assert(p == nil or type(p) == "table", "Expected extraArgs to be nil or table")

	local v = {
		uid = tostring(Players.LocalPlayer.UserId),
		friendId = value,
		position = value2,
		btn = btn,
		absolutePosition = value4,
		universeId = 0,
		source = 0
	}
	local universeId

	if p then
		universeId = p.universeId
	end

	v.universeId = universeId
	local source

	if p then
		source = p.source
	end

	v.source = source
	object:setRBXEventStream(value3 or "contactFriendFinder", "buttonClick", v)
end

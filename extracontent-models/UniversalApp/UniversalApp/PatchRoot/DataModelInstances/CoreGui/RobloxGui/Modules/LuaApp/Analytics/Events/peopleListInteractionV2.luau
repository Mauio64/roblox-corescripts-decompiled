local Players = game:GetService("Players")

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 4
	-- upvalues: Players (copy)
	assert(type(p2) == "string", "Expected buttonName to be a string")
	assert(type(p3) == "string", "Expected friendId to be a string")
	assert(type(p4) == "number", "Expected position to be a number")
	assert(p5 == nil or type(p5) == "string", "Expected context to be nil or string")
	assert(type(p6) == "number", "Expected absolutePosition to be a number")
	assert(p7 == nil or type(p7) == "table", "Expected extraArgs to be nil or table")
	p1:setRBXEventStream(p5 or "contactFriendFinder", "buttonClick", {
		uid = tostring(Players.LocalPlayer.UserId),
		friendId = p3,
		position = p4,
		btn = p2,
		absolutePosition = p6,
		universeId = if not p7 then nil else p7.universeId,
		source = if not p7 then nil else p7.source
	})
end

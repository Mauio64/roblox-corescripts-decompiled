local Parent = script:FindFirstAncestor("AppChat").Parent
local ArgCheck = require(Parent.ArgCheck)

return function(p1, p2, b1: boolean?) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "addMessage.messages")
	ArgCheck.isType(p2, "string", "addMessage.value")

	if p2 == "" then
		return p1
	end

	table.insert(p1, b1 and {
		placeId = p2
	} or {
		content = p2
	})

	return p1
end

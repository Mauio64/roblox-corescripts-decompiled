local parent = script:FindFirstAncestor("AppChat").Parent

local ArgCheck = require(parent.ArgCheck)

return function(list, p, flag: boolean?)
	ArgCheck.isType(list, "table", "addMessage.messages")
	ArgCheck.isType(p, "string", "addMessage.value")

	if p == "" then
		return list
	end

	local v

	if flag then
		v = { placeId = p } or { content = p }
	else
		v = { content = p }
	end

	table.insert(list, v)

	return list
end

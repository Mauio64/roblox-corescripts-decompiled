local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")

return function(list, p2, p3)
	ArgCheck.isType(list, "table", "addMessage.messages")
	ArgCheck.isType(p2, "string", "addMessage.value")

	if p2 == "" then
		return list
	end

	local v5 = if p3 then { placeId = p2 } or { content = p2 } else { content = p2 }
	table.insert(list, v5)

	return list
end

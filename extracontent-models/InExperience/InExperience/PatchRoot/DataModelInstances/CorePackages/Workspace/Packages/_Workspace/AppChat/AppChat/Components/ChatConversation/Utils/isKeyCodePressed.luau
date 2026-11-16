local parent = script:FindFirstAncestor("AppChat").Parent

local ArgCheck = require(parent.ArgCheck)

return function(list, ...): boolean
	ArgCheck.isType(list, "table", "isKeyCodePressed.pressedKeys")

	local v = { ... }

	for _, item in ipairs(list) do
		for _, v2 in ipairs(v) do
			if item.KeyCode == v2 then
				return true
			end
		end
	end

	return false
end

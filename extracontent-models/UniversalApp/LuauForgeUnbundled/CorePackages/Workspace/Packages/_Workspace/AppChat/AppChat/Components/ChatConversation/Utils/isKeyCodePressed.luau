local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")

return function(list, ...): boolean
	ArgCheck.isType(list, "table", "isKeyCodePressed.pressedKeys")

	local v5 = { ... }

	for i, item in ipairs(list) do
		for j, v6 in ipairs(v5) do
			if item.KeyCode == v6 then
				return true
			end
		end
	end

	return false
end

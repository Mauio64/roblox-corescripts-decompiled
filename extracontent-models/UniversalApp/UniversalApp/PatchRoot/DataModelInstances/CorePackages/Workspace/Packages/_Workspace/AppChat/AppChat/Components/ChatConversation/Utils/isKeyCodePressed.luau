local Parent = script:FindFirstAncestor("AppChat").Parent
local ArgCheck = require(Parent.ArgCheck)

return function(p1, ...) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "isKeyCodePressed.pressedKeys")

	for _, v in ipairs(p1) do
		for _, v2 in ipairs({ ... }) do
			if v2 == v.KeyCode then
				return true
			end
		end
	end

	return false
end

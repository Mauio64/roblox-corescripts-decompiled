local scriptParent = script.Parent
local assertEqual = require(scriptParent.assertEqual)

local function isLowercase(s1: string) -- line: 15
	-- upvalues: assertEqual (copy)
	assertEqual(#s1 > 0, true, "Attempted to call Dash.isLowercase with an empty string")

	local v5 = s1:sub(1, 1)

	return v5 == v5:lower()
end

return isLowercase

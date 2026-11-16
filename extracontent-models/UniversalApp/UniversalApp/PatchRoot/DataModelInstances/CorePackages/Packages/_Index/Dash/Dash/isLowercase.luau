local parent = script.Parent
local assertEqual = require(parent.assertEqual)

local function isLowercase(value: string): boolean
	assertEqual(#value > 0, true, "Attempted to call Dash.isLowercase with an empty string")
	local v = value:sub(1, 1)
	return v == v:lower()
end

return isLowercase

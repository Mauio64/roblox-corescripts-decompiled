local parent = script.Parent
local assertEqual = require(parent.assertEqual)

local function isUppercase(value: string): boolean
	assertEqual(#value > 0, true, "Attempted to call Dash.isUppercase with an empty string")
	local v = value:sub(1, 1)
	return v == v:upper()
end

return isUppercase

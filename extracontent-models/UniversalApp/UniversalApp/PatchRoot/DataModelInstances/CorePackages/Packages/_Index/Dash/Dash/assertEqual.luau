local parent = script.Parent

local function assertEqual(left, right, p: string?)
	if left ~= right then
		local Error = require(parent.Error)

		Error.new("AssertError", p or `Left "{left}" does not equal right "{right}"`):throw({
			left = left,
			right = right
		})
	end
end

return assertEqual

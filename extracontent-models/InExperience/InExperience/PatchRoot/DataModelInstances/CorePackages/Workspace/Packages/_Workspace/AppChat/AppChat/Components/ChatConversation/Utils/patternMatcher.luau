local Parent = script:FindFirstAncestor("AppChat").Parent
local ArgCheck = require(Parent.ArgCheck)

return function(p1, p2) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "patternMatcher.string")
	ArgCheck.isType(p2, "string", "patternMatcher.pattern")

	local start, stop = p1:lower():find(p2)

	if not start then
		return false, nil
	end

	return true, {
		prefix = p1:sub(1, start - 1),
		suffix = p1:sub(stop + 1)
	}
end

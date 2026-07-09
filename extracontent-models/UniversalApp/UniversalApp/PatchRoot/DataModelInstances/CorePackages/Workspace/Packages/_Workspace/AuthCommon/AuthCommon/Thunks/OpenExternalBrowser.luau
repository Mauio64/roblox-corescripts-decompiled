local Parent = script:FindFirstAncestor("AuthCommon").Parent
local ArgCheck = require(Parent.ArgCheck)

return function(p1, p2) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isNotNil(p1, "linking")
	ArgCheck.isType(p2, "string", "url")
	p1:openURL(p2)
end

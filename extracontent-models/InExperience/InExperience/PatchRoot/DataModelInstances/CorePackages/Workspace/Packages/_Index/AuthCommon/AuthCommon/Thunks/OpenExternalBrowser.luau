local parent = script:FindFirstAncestor("AuthCommon").Parent
local ArgCheck = require(parent.ArgCheck)

return function(object, p)
	ArgCheck.isNotNil(object, "linking")
	ArgCheck.isType(p, "string", "url")

	object:openURL(p)
end

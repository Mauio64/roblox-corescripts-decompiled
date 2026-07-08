local ParentParent = script.Parent.Parent
local RequestType = require(ParentParent.Enums.RequestType)

return function(p1) -- line: 5
	-- upvalues: RequestType (copy)
	return p1.promptRequest.requestType ~= RequestType.None
end

local parent = script.Parent.Parent

local RequestType = require(parent.Enums.RequestType)

return function(p): boolean
	return p.promptRequest.requestType ~= RequestType.None
end

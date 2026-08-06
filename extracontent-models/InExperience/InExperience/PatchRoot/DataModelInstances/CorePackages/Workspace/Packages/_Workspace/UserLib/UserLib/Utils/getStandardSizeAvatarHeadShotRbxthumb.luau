local getRbxthumbWithTypeSizeAndOptions = require(script.Parent.getRbxthumbWithTypeSizeAndOptions)
local Constants = require(script.Parent.Constants)

return function(s1: string, b1: boolean?) -- line: 8
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy)
	return getRbxthumbWithTypeSizeAndOptions(s1, Constants.RbxthumbTypes.AvatarHeadShot, 150, nil, nil, b1)
end

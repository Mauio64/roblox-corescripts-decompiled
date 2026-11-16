local getRbxthumbWithTypeSizeAndOptions = require(script.Parent.getRbxthumbWithTypeSizeAndOptions)
local Constants = require(script.Parent.Constants)

return function(p: string, flag: boolean?)
	return getRbxthumbWithTypeSizeAndOptions(p, Constants.RbxthumbTypes.AvatarHeadShot, 150, nil, nil, flag)
end

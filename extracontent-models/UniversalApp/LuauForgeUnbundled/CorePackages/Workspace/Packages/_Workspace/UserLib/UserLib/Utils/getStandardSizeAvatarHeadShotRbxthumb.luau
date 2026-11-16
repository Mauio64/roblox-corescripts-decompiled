local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/getRbxthumbWithTypeSizeAndOptions")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/Constants")

return function(p2, p3)
	return getRbxthumbWithTypeSizeAndOptions(p2, Constants.RbxthumbTypes.AvatarHeadShot, 150, nil, nil, p3)
end

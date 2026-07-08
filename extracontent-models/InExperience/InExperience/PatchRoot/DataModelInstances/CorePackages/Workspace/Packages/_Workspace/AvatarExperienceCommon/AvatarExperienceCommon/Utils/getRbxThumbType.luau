local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Constants = require(Parent.UserLib).Utils.Constants

local function getRbxThumbType(s1: string) -- line: 7
	-- upvalues: Constants (copy)
	if s1 == "Bundle" then
		return Constants.RbxthumbTypes.BundleThumbnail
	end

	if s1 == "Asset" then
		return Constants.RbxthumbTypes.Asset
	end

	return nil
end

return getRbxThumbType

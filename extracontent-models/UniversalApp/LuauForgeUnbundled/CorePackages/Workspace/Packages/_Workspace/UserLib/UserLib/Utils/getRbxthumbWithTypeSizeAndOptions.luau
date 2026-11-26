local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/Constants")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags")

local v5 = {
	[Constants.RbxthumbTypes.Avatar] = SharedFlags.FFlagAXBackgroundsInAvatarThumbnails,
	[Constants.RbxthumbTypes.AvatarBust] = SharedFlags.FFlagAXBackgroundsInAvatarBustThumbnails,
	[Constants.RbxthumbTypes.AvatarHeadShot] = SharedFlags.FFlagAXBackgroundsInHeadshotThumbnails,
	[Constants.RbxthumbTypes.Outfit] = SharedFlags.FFlagAXBackgroundsInOutfitThumbnails
}

return function(p2, p3, p4, p5, p6, p7)
	local v6 = string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", p3, tostring(p2), p4, p4)

	if p5 then
		v6 ..= "&filters=circular"
	end

	if p6 then
		v6 ..= "&timestamp=" .. os.time()
	end

	if v5[p3] then
		v6 ..= "&includeBackground=true"
	end

	if p7 and p3 == Constants.RbxthumbTypes.AvatarHeadShot then
		v6 ..= "&includeprofileframe=true"
	end

	return v6
end

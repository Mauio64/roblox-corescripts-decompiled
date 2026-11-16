local parent = script:FindFirstAncestor("UserLib").Parent

local Constants = require(script.Parent.Constants)
local SharedFlags = require(parent.SharedFlags)

local v = {
	[Constants.RbxthumbTypes.Avatar] = SharedFlags.FFlagAXBackgroundsInAvatarThumbnails,
	[Constants.RbxthumbTypes.AvatarBust] = SharedFlags.FFlagAXBackgroundsInAvatarBustThumbnails,
	[Constants.RbxthumbTypes.AvatarHeadShot] = SharedFlags.FFlagAXBackgroundsInHeadshotThumbnails,
	[Constants.RbxthumbTypes.Outfit] = SharedFlags.FFlagAXBackgroundsInOutfitThumbnails
}

return function(p: string, p2, p3: number, flag: boolean?, flag2: boolean?, flag3: boolean?)
	local v2 = string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", p2, tostring(p), p3, p3)

	if flag then
		v2 ..= "&filters=circular"
	end

	if flag2 then
		v2 ..= "&timestamp=" .. os.time()
	end

	if v[p2] then
		v2 ..= "&includeBackground=true"
	end

	if flag3 and p2 == Constants.RbxthumbTypes.AvatarHeadShot then
		return v2 .. "&includeprofileframe=true"
	end

	return v2
end

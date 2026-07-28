local Parent = script:FindFirstAncestor("UserLib").Parent
local Constants = require(script.Parent.Constants)
local SharedFlags = require(Parent.SharedFlags)
local t1 = {
	[Constants.RbxthumbTypes.Avatar] = SharedFlags.FFlagAXBackgroundsInAvatarThumbnails,
	[Constants.RbxthumbTypes.AvatarBust] = SharedFlags.FFlagAXBackgroundsInAvatarBustThumbnails,
	[Constants.RbxthumbTypes.AvatarHeadShot] = SharedFlags.FFlagAXBackgroundsInHeadshotThumbnails,
	[Constants.RbxthumbTypes.Outfit] = SharedFlags.FFlagAXBackgroundsInOutfitThumbnails
}

return function(s1: string, p1, n1: number, b1: boolean?, b2: boolean?, b3: boolean?) -- line: 14
	-- upvalues: t1 (copy), Constants (copy)
	local v11 = string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", p1, tostring(s1), n1, n1)

	if b1 then
		v11 ..= "&filters=circular"
	end

	if b2 then
		v11 ..= "&timestamp=" .. os.time()
	end

	if t1[p1] then
		v11 ..= "&includeBackground=true"
	end

	if b3 and p1 == Constants.RbxthumbTypes.AvatarHeadShot then
		v11 ..= "&includeprofileframe=true"
	end

	return v11
end

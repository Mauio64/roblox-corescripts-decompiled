local Parent = script:FindFirstAncestor("UserLib").Parent
local Constants = require(script.Parent.Constants)
local SharedFlags = require(Parent.SharedFlags)
local t1 = {
	[Constants.RbxthumbTypes.Avatar] = SharedFlags.FFlagAXBackgroundsInAvatarThumbnails,
	[Constants.RbxthumbTypes.AvatarBust] = SharedFlags.FFlagAXBackgroundsInAvatarBustThumbnails,
	[Constants.RbxthumbTypes.AvatarHeadShot] = SharedFlags.FFlagAXBackgroundsInHeadshotThumbnails,
	[Constants.RbxthumbTypes.Outfit] = SharedFlags.FFlagAXBackgroundsInOutfitThumbnails
}

return function(s1: string, p1, n1: number, b1: boolean?, b2: boolean?) -- line: 14
	-- upvalues: t1 (copy)
	local v10 = string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", p1, tostring(s1), n1, n1)

	if b1 then
		v10 ..= "&filters=circular"
	end

	if b2 then
		v10 ..= "&timestamp=" .. os.time()
	end

	if t1[p1] then
		v10 ..= "&includeBackground=true"
	end

	return v10
end

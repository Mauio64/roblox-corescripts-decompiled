local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Logging = require(Parent.AppCommonLib).Logging
local ArgCheck = require(Parent.ArgCheck)
local GameMediaImageType = require(Parent.DiscoveryTypes).GameMediaImageType
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local t1 = {}

for k, v in pairs(GameMediaImageType) do
	t1[v] = k
end

local t2 = {
	new = function() -- line: 44
		return {}
	end
}

function t2.fromJsonData(p1) -- line: 48
	-- upvalues: t2 (copy), ArgCheck (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), GameMediaImageType (copy), t1 (copy), Logging (copy)
	local v11 = t2.new()

	v11.id = p1.id and tostring(ArgCheck.isType(p1.id, "number", "jsonData.id"))
	v11.assetTypeId = ArgCheck.isType(p1.assetTypeId, "number", "jsonData.assetTypeId")
	v11.imageId = p1.imageId and tostring(ArgCheck.isType(p1.imageId, "number", "jsonData.imageId"))
	v11.youTubeVideoHash = p1.videoHash and ArgCheck.isType(p1.videoHash, "string", "jsonData.videoHash")
	v11.youTubeVideoTitle = p1.videoTitle and ArgCheck.isType(p1.videoTitle, "string", "jsonData.videoTitle")
	v11.approved = ArgCheck.isType(p1.approved, "boolean", "jsonData.approved")

	if FFlagLuaAppEdpMediaGalleryVideoPreview and v11.assetTypeId == GameMediaImageType.Video then
		v11.videoId = ArgCheck.isType(p1.videoId, "string", "jsonData.videoId")
	end

	if v11.assetTypeId == GameMediaImageType.GamePreviewVideo then
		v11.videoId = ArgCheck.isType(p1.videoId, "string", "jsonData.videoId")
	end

	if not t1[v11.assetTypeId] then
		Logging.warn("Unrecognized assetTypeId: " .. tostring(v11.assetTypeId))
	end

	return v11
end

return t2

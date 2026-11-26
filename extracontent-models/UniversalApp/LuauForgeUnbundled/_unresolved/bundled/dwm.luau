local logging = require("@luauforge/bundled/dua").Logging
local module = require("@luauforge/bundled/dtG")
local gameMediaImageType = require("@luauforge/bundled/dtp").GameMediaImageType

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@luauforge/bundled/dtD").FFlagLuaAppEdpMediaGalleryVideoPreview

local v5 = {}

for k, v6 in pairs(gameMediaImageType) do
	v5[v6] = k
end

local v6 = {}

function v6.new()
	return {}
end

function v6.fromJsonData(data)
	local v7 = v6.new()
	v7.id = data.id and tostring(module.isType(data.id, "number", "jsonData.id"))

	v7.assetTypeId = module.isType(data.assetTypeId, "number", "jsonData.assetTypeId")
	v7.imageId = data.imageId and tostring(module.isType(data.imageId, "number", "jsonData.imageId"))
	v7.youTubeVideoHash = data.videoHash and module.isType(data.videoHash, "string", "jsonData.videoHash")
	v7.youTubeVideoTitle = data.videoTitle
		and module.isType(data.videoTitle, "string", "jsonData.videoTitle")
	v7.approved = module.isType(data.approved, "boolean", "jsonData.approved")

	if fFlagLuaAppEdpMediaGalleryVideoPreview and v7.assetTypeId == gameMediaImageType.Video then
		v7.videoId = module.isType(data.videoId, "string", "jsonData.videoId")
	end

	if v7.assetTypeId == gameMediaImageType.GamePreviewVideo then
		v7.videoId = module.isType(data.videoId, "string", "jsonData.videoId")
	end

	if not v5[v7.assetTypeId] then
		logging.warn("Unrecognized assetTypeId: " .. tostring(v7.assetTypeId))
	end

	return v7
end

return v6

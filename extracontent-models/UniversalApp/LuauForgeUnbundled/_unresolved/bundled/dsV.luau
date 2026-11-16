local module = require("@luauforge/bundled/dsW")
require("@luauforge/bundled/dsX")

local v5 = {}

function v5.fromBaseJson(data)
	if type(data.assetId) ~= "number" and type(data.assetId) ~= "string" then
		return module.error("SongInfoModel expects assetId to be a number or a string")
	end

	if type(data.title) ~= "string" or data.title == "" then
		return module.error("SongInfoModel expects title to be a non-empty string")
	end

	if type(data.artist) ~= "string" or data.artist == "" then
		return module.error("SongInfoModel expects artist to be a non-empty string")
	end

	local v6 = {
		assetId = tostring(data.assetId),
		title = data.title,
		artist = data.artist
	}

	if type(data.albumArtAssetId) == "number" or type(data.albumArtAssetId) == "string" then
		v6.albumArtAssetId = tostring(data.albumArtAssetId)
	end

	if type(data.duration) == "number" then
		v6.duration = data.duration
	end

	if type(data.album) == "string" and data.album ~= "" then
		v6.album = data.album
	end

	if type(data.isPrivate) == "boolean" then
		v6.isPrivate = data.isPrivate
	end

	return module.success(v6)
end

function v5.fromExploreApi(p2)
	return v5.fromBaseJson(p2)
end

return v5

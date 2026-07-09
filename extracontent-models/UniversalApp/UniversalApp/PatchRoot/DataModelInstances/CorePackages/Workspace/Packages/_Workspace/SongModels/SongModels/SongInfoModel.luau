local Parent = script:FindFirstAncestor("SongModels").Parent
local Result = require(Parent.Result)

require(Parent.DiscoveryTypes)

local t2 = {
	fromBaseJson = function(p1) -- line: 10
		-- upvalues: Result (copy)
		if type(p1.assetId) ~= "number" and type(p1.assetId) ~= "string" then
			return Result.error("SongInfoModel expects assetId to be a number or a string")
		end

		if type(p1.title) ~= "string" or p1.title == "" then
			return Result.error("SongInfoModel expects title to be a non-empty string")
		end

		if type(p1.artist) ~= "string" or p1.artist == "" then
			return Result.error("SongInfoModel expects artist to be a non-empty string")
		end

		local t1 = {
			assetId = tostring(p1.assetId),
			title = p1.title,
			artist = p1.artist
		}

		if type(p1.albumArtAssetId) == "number" or type(p1.albumArtAssetId) == "string" then
			t1.albumArtAssetId = tostring(p1.albumArtAssetId)
		end

		if type(p1.duration) == "number" then
			t1.duration = p1.duration
		end

		if type(p1.album) == "string" and p1.album ~= "" then
			t1.album = p1.album
		end

		if type(p1.isPrivate) == "boolean" then
			t1.isPrivate = p1.isPrivate
		end

		return Result.success(t1)
	end
}

function t2.fromExploreApi(p2) -- line: 46
	-- upvalues: t2 (copy)
	return t2.fromBaseJson(p2)
end

return t2

require("@luauforge/bundled/dzX")

local module = require("@luauforge/bundled/dAr")
return {
	fromJsonData = function(data)
		if type(data.assetId) ~= "number" and type(data.assetId) ~= "string" then
			return module.error("SongDetailModel.fromJsonData expects assetId to be a number or a string")
		end

		if type(data.name) ~= "string" or data.name == "" then
			return module.error("SongDetailModel.fromJsonData expects name to be a non-empty string")
		end

		if type(data.artistName) ~= "string" or data.artistName == "" then
			return module.error("SongDetailModel.fromJsonData expects artistName to be a non-empty string")
		end

		if type(data.creatorName) ~= "string" or data.creatorName == "" then
			return module.error("SongDetailModel.fromJsonData expects creatorName to be a non-empty string")
		end

		if type(data.creatorId) ~= "number" and type(data.creatorId) ~= "string" then
			return module.error("SongDetailModel.fromJsonData expects creatorId to be a number or a string")
		end

		local v6 = {
			assetId = tostring(data.assetId),
			artistName = data.artistName,
			creatorId = tostring(data.creatorId),
			creatorName = data.creatorName,
			name = data.name
		}

		if typeof(data.description) == "string" and data.description ~= "" then
			v6.description = data.description
		end

		if type(data.genre) == "string" and data.genre ~= "" then
			v6.genre = data.genre
		end

		if type(data.durationSeconds) == "number" then
			v6.durationSeconds = data.durationSeconds
		end

		if type(data.uploadedTime) == "string" and data.uploadedTime ~= "" then
			v6.uploadedTime = data.uploadedTime
		end

		if type(data.songMetrics) == "table" then
			local v8 = if type(data.songMetrics.artistSongsCount) == "number" then data.songMetrics.artistSongsCount else nil

			local v9 = if type(data.songMetrics.experiencesPlayed) == "number" then data.songMetrics.experiencesPlayed else nil

			local v10 = if type(data.songMetrics.monthlyListeners) == "number" then data.songMetrics.monthlyListeners else nil
			v6.songMetrics = {
				artistSongsCount = v8,
				experiencesPlayed = v9,
				monthlyListeners = v10
			}
		end

		return module.success(v6)
	end
}

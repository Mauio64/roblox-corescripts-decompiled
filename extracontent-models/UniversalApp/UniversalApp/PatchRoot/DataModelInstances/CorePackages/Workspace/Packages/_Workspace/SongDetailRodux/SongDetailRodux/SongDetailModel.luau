local Parent = script:FindFirstAncestor("SongDetailRodux").Parent

require(Parent.DiscoveryTypes)

local t1 = {}
local Result = require(Parent.Result)

function t1.fromJsonData(p1) -- line: 29
	-- upvalues: Result (copy)
	if type(p1.assetId) ~= "number" and type(p1.assetId) ~= "string" then
		return Result.error("SongDetailModel.fromJsonData expects assetId to be a number or a string")
	end

	if type(p1.name) ~= "string" or p1.name == "" then
		return Result.error("SongDetailModel.fromJsonData expects name to be a non-empty string")
	end

	if type(p1.artistName) ~= "string" or p1.artistName == "" then
		return Result.error("SongDetailModel.fromJsonData expects artistName to be a non-empty string")
	end

	if type(p1.creatorName) ~= "string" or p1.creatorName == "" then
		return Result.error("SongDetailModel.fromJsonData expects creatorName to be a non-empty string")
	end

	if type(p1.creatorId) ~= "number" and type(p1.creatorId) ~= "string" then
		return Result.error("SongDetailModel.fromJsonData expects creatorId to be a number or a string")
	end

	local t2 = {
		assetId = tostring(p1.assetId),
		artistName = p1.artistName,
		creatorId = tostring(p1.creatorId),
		creatorName = p1.creatorName,
		name = p1.name
	}

	if typeof(p1.description) == "string" and p1.description ~= "" then
		t2.description = p1.description
	end

	if type(p1.genre) == "string" and p1.genre ~= "" then
		t2.genre = p1.genre
	end

	if type(p1.durationSeconds) == "number" then
		t2.durationSeconds = p1.durationSeconds
	end

	if type(p1.uploadedTime) == "string" and p1.uploadedTime ~= "" then
		t2.uploadedTime = p1.uploadedTime
	end

	if type(p1.songMetrics) == "table" then
		t2.songMetrics = {
			artistSongsCount = if type(p1.songMetrics.artistSongsCount) ~= "number" then nil else p1.songMetrics.artistSongsCount,
			experiencesPlayed = if type(p1.songMetrics.experiencesPlayed) ~= "number" then nil else p1.songMetrics.experiencesPlayed,
			monthlyListeners = if type(p1.songMetrics.monthlyListeners) ~= "number" then nil else p1.songMetrics.monthlyListeners
		}
	end

	return Result.success(t2)
end

return t1

local function isTime(value): boolean -- 4 equivalent calls inferred from this helper
	return type(value) == "number" and value >= 0 and value < 1e999
end

local function isUnset(p): boolean
	return p == nil or p == "" or p == 0
end

local GetVideoEdits = {}

function GetVideoEdits.getVideoEdits(data)
	local trim = nil
	local trimStartTime = data.trimStartTime
	local music, musicAssetId, musicStartTime, musicAssetId2, startTime, v

	if trimStartTime == nil or trimStartTime == "" or trimStartTime == 0 then
		local trimEndTime = data.trimEndTime

		if trimEndTime == nil or trimEndTime == "" or trimEndTime == 0 then
			musicAssetId = data.musicAssetId

			if musicAssetId == nil or musicAssetId == "" or musicAssetId == 0 then
				musicStartTime = data.musicStartTime

				if musicStartTime == nil or musicStartTime == "" or musicStartTime == 0 then
					return (trim ~= nil or music ~= nil) and { trim = trim, music = music } or nil, true
				end
			end

			musicAssetId2 = data.musicAssetId
			startTime = data.musicStartTime == nil and 0 or data.musicStartTime

			if
				type(musicAssetId2) ~= "string"
				or string.match(musicAssetId2, "^%d+$") == nil
				or (tonumber(musicAssetId2) or 0) <= 0
				or (tonumber(musicAssetId2) or 0) == 1e999
			then
				return nil, false
			end

			v = isTime(startTime) -- inferred equivalent call

			if not v then
				return nil, false
			end

			music = { assetId = musicAssetId2, startTime = startTime }

			return (trim ~= nil or music ~= nil) and { trim = trim, music = music } or nil, true
		end
	end

	if not (isTime(data.trimStartTime) and isTime(data.trimEndTime)) then -- inferred equivalent call
		return nil, false
	end

	local trimStartTime2 = data.trimStartTime
	local trimEndTime = data.trimEndTime

	if trimEndTime <= trimStartTime2 then
		return nil, false
	end

	trim = { startTime = trimStartTime2, endTime = trimEndTime }

	music = nil
	musicAssetId = data.musicAssetId

	if musicAssetId == nil or musicAssetId == "" or musicAssetId == 0 then
		musicStartTime = data.musicStartTime

		if musicStartTime == nil or musicStartTime == "" or musicStartTime == 0 then
			return (trim ~= nil or music ~= nil) and { trim = trim, music = music } or nil, true
		end
	end

	musicAssetId2 = data.musicAssetId
	startTime = data.musicStartTime == nil and 0 or data.musicStartTime

	if
		type(musicAssetId2) ~= "string"
		or string.match(musicAssetId2, "^%d+$") == nil
		or (tonumber(musicAssetId2) or 0) <= 0
		or (tonumber(musicAssetId2) or 0) == 1e999
	then
		return nil, false
	end

	v = isTime(startTime) -- inferred equivalent call

	if not v then
		return nil, false
	end

	music = { assetId = musicAssetId2, startTime = startTime }

	return (trim ~= nil or music ~= nil) and { trim = trim, music = music } or nil, true
end

function GetVideoEdits.getPlaybackRange(p: number, p2)
	local selected = not p2 and 0 or math.min(p2.startTime, p)

	if p2 then
		return selected, (math.min(p2.endTime, p))
	end

	return selected, p
end

return GetVideoEdits

local function isTime(value): boolean
	return type(value) == "number" and value >= 0 and value < 1e999
end

local function isUnset(p2): boolean
	return p2 == nil or p2 == "" or p2 == 0
end

return {
	getVideoEdits = function(data)
		local v5 = nil
		local trimStartTime = data.trimStartTime
		local v6, musicAssetId, musicStartTime, musicAssetId2, v7, v8

		if trimStartTime == nil or trimStartTime == "" or trimStartTime == 0 then
			local trimEndTime = data.trimEndTime

			if trimEndTime == nil or trimEndTime == "" or trimEndTime == 0 then
				musicAssetId = data.musicAssetId

				if musicAssetId == nil or musicAssetId == "" or musicAssetId == 0 then
					musicStartTime = data.musicStartTime

					if musicStartTime == nil or musicStartTime == "" or musicStartTime == 0 then
						return (v5 ~= nil or v6 ~= nil) and { trim = v5, music = v6 } or nil, true
					end
				end

				musicAssetId2 = data.musicAssetId
				v7 = data.musicStartTime == nil and 0 or data.musicStartTime

				if
					type(musicAssetId2) ~= "string"
					or string.match(musicAssetId2, "^%d+$") == nil
					or (tonumber(musicAssetId2) or 0) <= 0
					or (tonumber(musicAssetId2) or 0) == 1e999
				then
					return nil, false
				end

				v8 = type(v7) == "number" and v7 >= 0 and v7 < 1e999

				if not v8 then
					return nil, false
				end

				v6 = { assetId = musicAssetId2, startTime = v7 }

				return (v5 ~= nil or v6 ~= nil) and { trim = v5, music = v6 } or nil, true
			end
		end

		local trimStartTime2 = data.trimStartTime
		local v9 = type(trimStartTime2) == "number" and trimStartTime2 >= 0 and trimStartTime2 < 1e999

		if not v9 then
			return nil, false
		end

		local trimEndTime = data.trimEndTime
		local v10 = type(trimEndTime) == "number" and trimEndTime >= 0 and trimEndTime < 1e999

		if not v10 then
			return nil, false
		end

		local trimStartTime3 = data.trimStartTime
		local trimEndTime2 = data.trimEndTime

		if trimEndTime2 <= trimStartTime3 then
			return nil, false
		end

		v5 = { startTime = trimStartTime3, endTime = trimEndTime2 }

		v6 = nil
		musicAssetId = data.musicAssetId

		if musicAssetId == nil or musicAssetId == "" or musicAssetId == 0 then
			musicStartTime = data.musicStartTime

			if musicStartTime == nil or musicStartTime == "" or musicStartTime == 0 then
				return (v5 ~= nil or v6 ~= nil) and { trim = v5, music = v6 } or nil, true
			end
		end

		musicAssetId2 = data.musicAssetId
		v7 = data.musicStartTime == nil and 0 or data.musicStartTime

		if
			type(musicAssetId2) ~= "string"
			or string.match(musicAssetId2, "^%d+$") == nil
			or (tonumber(musicAssetId2) or 0) <= 0
			or (tonumber(musicAssetId2) or 0) == 1e999
		then
			return nil, false
		end

		v8 = type(v7) == "number" and v7 >= 0 and v7 < 1e999

		if not v8 then
			return nil, false
		end

		v6 = { assetId = musicAssetId2, startTime = v7 }

		return (v5 ~= nil or v6 ~= nil) and { trim = v5, music = v6 } or nil, true
	end,
	getPlaybackRange = function(p2, p3)
		local v5 = not p3 and 0 or math.min(p3.startTime, p2)

		if p3 then
			return v5, (math.min(p3.endTime, p2))
		end

		return v5, p2
	end
}

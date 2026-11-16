local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local function toAssetUri(assetId) -- 1 equivalent call inferred from this helper
	if typeof(assetId) == "string" and string.find(assetId, "://") ~= nil then
		return assetId
	end

	return `rbxassetid://{assetId}`
end

local function createMusicNode(data, p)
	local parent = data.parent
	assert(parent ~= nil, "createMusicNode: spec.parent (the item media folder) is required")

	local content = Content.fromUri(toAssetUri(data.assetId)) -- inferred equivalent call
	local startTime = data.startTime or 0
	local trimmedLen = data.trimmedLen
	local region = { startTime = startTime, endTime = 0 }
	local endTime

	if trimmedLen ~= nil then
		endTime = startTime + trimmedLen
	end

	region.endTime = endTime

	local volume = data.volume or 1

	local audioPlayer = Instance.new("AudioPlayer")
	audioPlayer.Name = `Music_{data.id}`

	audioPlayer.AudioContent = content

	audioPlayer.PlaybackSpeed = 0
	audioPlayer.TimePosition = startTime
	audioPlayer.Parent = parent

	local flag = false

	local function download()
		if flag then
			return
		end

		p.contentProvider:PreloadAsync({ content.Uri })
	end

	local function play()
		if flag then
			return
		end

		audioPlayer.PlaybackSpeed = 1

		if not audioPlayer.IsPlaying then
			audioPlayer:Play()
		end
	end

	local function pause()
		if flag then
			return
		end

		audioPlayer.PlaybackSpeed = 0
	end

	local function seek(p2: number)
		if flag then
			return
		end

		local timePosition = startTime + p2
		local timeLength = audioPlayer.TimeLength

		if timeLength > 0 then
			timePosition = math.clamp(timePosition, 0, timeLength)
		end

		audioPlayer.TimePosition = timePosition
	end

	local function realignToRegionStart()
		if flag then
			return
		end

		audioPlayer.TimePosition = startTime
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		audioPlayer:Destroy()
	end

	return {
		id = data.id,
		kind = "music",
		assets = function()
			return { content }
		end,
		download = download,
		usesDecoder = false,
		getAudioSource = function()
			return audioPlayer
		end,
		audioStem = { stemId = data.id, defaultVolume = volume },
		play = play,
		pause = pause,
		seek = seek,
		realignToRegionStart = realignToRegionStart,
		getRegion = function()
			return region
		end,
		dispose = dispose
	}
end

return { kind = "music", create = createMusicNode }

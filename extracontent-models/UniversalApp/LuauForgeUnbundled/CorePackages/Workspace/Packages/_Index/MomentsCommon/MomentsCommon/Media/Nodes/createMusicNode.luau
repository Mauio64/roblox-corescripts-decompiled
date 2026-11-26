require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")

local function toAssetUri(value)
	if typeof(value) == "string" and string.find(value, "://") ~= nil then
		return value
	end

	return `rbxassetid://{value}`
end

local function createMusicNode(data, p2)
	local parent = data.parent
	assert(parent ~= nil, "createMusicNode: spec.parent (the item media folder) is required")

	local assetId = data.assetId

	if typeof(assetId) ~= "string" or string.find(assetId, "://") == nil then
		assetId = `rbxassetid://{assetId}`
	end

	local content = Content.fromUri(assetId)
	local startTime = data.startTime or 0
	local trimmedLen = data.trimmedLen
	local region = { startTime = startTime, endTime = 0 }

	local v5 = if trimmedLen ~= nil then startTime + trimmedLen else nil
	region.endTime = v5

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

		p2.contentProvider:PreloadAsync({ content.Uri })
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

	local function seek(p3)
		if flag then
			return
		end

		local v6 = startTime + p3
		local timeLength = audioPlayer.TimeLength

		if timeLength > 0 then
			v6 = math.clamp(v6, 0, timeLength)
		end

		audioPlayer.TimePosition = v6
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

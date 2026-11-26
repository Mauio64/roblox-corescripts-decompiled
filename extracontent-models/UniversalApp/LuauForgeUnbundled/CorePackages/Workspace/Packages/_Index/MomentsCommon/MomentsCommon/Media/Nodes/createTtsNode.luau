local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")
local audioDuckingFastInts = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/audioDuckingFastInts")
local FFlagMomentsVideoPermissionContextFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsVideoPermissionContextFix")

local function toAssetUri(assetId, assetAccessContext, p2)
	if typeof(assetId) == "string" and string.find(assetId, "://") ~= nil then
		return assetId
	end

	local formatted = `rbxassetid://{assetId}`

	if assetAccessContext == nil or assetAccessContext == "" then
		return formatted
	end

	local formatted2 = `{formatted}&accessContext={HttpService:UrlEncode(assetAccessContext)}`

	if p2 then
		return formatted2
	end

	return `{formatted2}&permissionContext=ignoreUniverse`
end

local function defaultLoadSpeech(object)
	if game:GetEngineFeature("TextToSpeechPlatformPreview") then
		return object:LoadPlatformAsync()
	end

	return Enum.AssetFetchStatus.Failure
end

local function createTtsNode(data, p2)
	local parent = data.parent
	assert(parent ~= nil, "createTtsNode: spec.parent (the item media folder) is required")

	local assetId = data.assetId
	local assetAccessContext = data.assetAccessContext
	local startTime = data.startTime or 0
	local region = { startTime = startTime, endTime = nil }

	local volume = data.volume or audioDuckingFastInts.getTtsVolume()

	local content = if assetId ~= nil then Content.fromUri(toAssetUri(assetId, assetAccessContext)) else nil
	local v5

	if FFlagMomentsVideoPermissionContextFix and game.GameId == 0 and assetId ~= nil then
		v5 = Content.fromUri(toAssetUri(assetId, assetAccessContext, true))
	else
		v5 = content
	end

	local v6

	if v5 == nil then
		v6 = nil
	else
		v6 = Instance.new("AudioPlayer")
		v6.Name = `Tts_{data.id}`
		v6.AudioContent = v5

		v6.PlaybackSpeed = 0
		v6.TimePosition = 0
		v6.Parent = parent
	end

	local text = data.text
	local audioTextToSpeech

	if v6 == nil and text ~= nil and text ~= "" then
		audioTextToSpeech = Instance.new("AudioTextToSpeech")
		audioTextToSpeech.Name = `Tts_{data.id}`
		audioTextToSpeech.Text = text
		audioTextToSpeech.VoiceId = tostring(data.voiceId)
		audioTextToSpeech.PlaybackSpeed = 0
		audioTextToSpeech.TimePosition = 0
		audioTextToSpeech.Parent = parent
		v6 = audioTextToSpeech
	else
		audioTextToSpeech = nil
	end

	local loadSpeech = p2.loadSpeech or defaultLoadSpeech
	local v7 = audioTextToSpeech == nil
	local v8 = false

	local flag = false

	local function download()
		if flag then
			return
		end

		if audioTextToSpeech ~= nil and not v8 then
			v8 = true

			task.spawn(function()
				local success, result = pcall(loadSpeech, audioTextToSpeech)

				if flag or not success or result ~= Enum.AssetFetchStatus.Success then
					return
				end

				v7 = true
			end)
		end

		if content == nil then
			return
		end

		p2.contentProvider:PreloadAsync({ content.Uri })
	end

	local v9 = false
	local flag2 = false

	local v10 = nil

	local function play()
		if flag or v6 == nil then
			return
		end

		v9 = true
	end

	local function pause()
		if flag or v6 == nil then
			return
		end

		v9 = false
		flag2 = false
		v6.PlaybackSpeed = 0
	end

	local function seek(p3)
		if flag or v6 == nil then
			return
		end

		local v11 = math.max(0, p3 - startTime)
		local timeLength = v6.TimeLength

		if timeLength > 0 then
			v11 = math.clamp(v11, 0, timeLength)
		end

		v6.TimePosition = v11
	end

	local function realignToRegionStart()
		if flag or v6 == nil then
			return
		end

		v6.PlaybackSpeed = 0
		v6.TimePosition = 0
		flag2 = false
	end

	local function syncToClock(p3)
		if flag or v6 == nil or not (v9 and v7) then
			return
		end

		local v11 = v10
		v10 = p3
		local v12 = not (v11 == nil) and v11 < p3

		if startTime <= p3 then
			local v13 = math.max(0, p3 - startTime)

			if flag2 then
				local timeLength = v6.TimeLength

				if timeLength <= 0 or v13 < timeLength then
					local v14 = v13 - v6.TimePosition

					if v14 > 0.1 or v14 < -0.5 then
						v6.TimePosition = v13
					end
				end
			else
				if not v12 then
					return
				end

				local timeLength = v6.TimeLength

				if not (timeLength <= 0 or v13 < timeLength) then
					return
				end

				v6.TimePosition = v13
				v6.PlaybackSpeed = 1

				if not v6.IsPlaying then
					v6:Play()
				end

				flag2 = true
			end
		elseif flag2 then
			v6.PlaybackSpeed = 0
			v6.TimePosition = 0
			flag2 = false
		end
	end

	local function dispose()
		if flag then
			return
		end

		flag = true

		if v6 ~= nil then
			v6:Destroy()
		end
	end

	local ttsNode = {
		id = data.id,
		kind = "tts",
		assets = function()
			if content == nil then
				return {}
			end

			return { content }
		end,
		download = download,
		usesDecoder = false,
		play = play,
		pause = pause,
		seek = seek,
		realignToRegionStart = realignToRegionStart,
		syncToClock = syncToClock,
		getRegion = function()
			return region
		end,
		dispose = dispose
	}

	if v6 ~= nil then
		function ttsNode.getAudioSource()
			return v6
		end

		ttsNode.audioStem = {
			stemId = data.id,
			defaultVolume = volume,
			role = "sidechain"
		}
	end

	return ttsNode
end

return {
	kind = "tts",
	create = createTtsNode,
	hasAudioRemaining = function(p2, p3): boolean
		return p3 <= 0 or p2 < p3
	end
}

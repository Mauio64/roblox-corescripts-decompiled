local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local HttpService = game:GetService("HttpService")

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)
local audioDuckingFastInts = require(MomentsCommon.Media.audioDuckingFastInts)
local FFlagMomentsVideoPermissionContextFix = require(MomentsCommon.Flags.FFlagMomentsVideoPermissionContextFix)

local function toAssetUri(assetId, assetAccessContext: string?, flag: boolean?)
	if typeof(assetId) == "string" and string.find(assetId, "://") ~= nil then
		return assetId
	end

	local formatted = `rbxassetid://{assetId}`

	if assetAccessContext == nil or assetAccessContext == "" then
		return formatted
	end

	local formatted2 = `{formatted}&accessContext={HttpService:UrlEncode(assetAccessContext)}`

	if flag then
		return formatted2
	end

	return `{formatted2}&permissionContext=ignoreUniverse`
end

local function hasAudioRemaining(p: number, timeLength: number): boolean -- 2 equivalent calls inferred from this helper
	return timeLength <= 0 or p < timeLength
end

local function defaultLoadSpeech(object)
	if game:GetEngineFeature("TextToSpeechPlatformPreview") then
		return object:LoadPlatformAsync()
	end

	return Enum.AssetFetchStatus.Failure
end

local function createTtsNode(data, p)
	local parent = data.parent
	assert(parent ~= nil, "createTtsNode: spec.parent (the item media folder) is required")

	local assetId = data.assetId
	local assetAccessContext = data.assetAccessContext
	local startTime = data.startTime or 0
	local region = { startTime = startTime, endTime = nil }

	local volume = data.volume or audioDuckingFastInts.getTtsVolume()
	local content

	if assetId == nil then
		content = nil
	else
		content = Content.fromUri(toAssetUri(assetId, assetAccessContext))
	end

	local audioContent

	if FFlagMomentsVideoPermissionContextFix and game.GameId == 0 and assetId ~= nil then
		audioContent = Content.fromUri(toAssetUri(assetId, assetAccessContext, true))
	else
		audioContent = content
	end

	local v

	if audioContent == nil then
		v = nil
	else
		v = Instance.new("AudioPlayer")
		v.Name = `Tts_{data.id}`
		v.AudioContent = audioContent

		v.PlaybackSpeed = 0
		v.TimePosition = 0
		v.Parent = parent
	end

	local text = data.text
	local audioTextToSpeech

	if v == nil and text ~= nil and text ~= "" then
		audioTextToSpeech = Instance.new("AudioTextToSpeech")
		audioTextToSpeech.Name = `Tts_{data.id}`
		audioTextToSpeech.Text = text
		audioTextToSpeech.VoiceId = tostring(data.voiceId)
		audioTextToSpeech.PlaybackSpeed = 0
		audioTextToSpeech.TimePosition = 0
		audioTextToSpeech.Parent = parent
		v = audioTextToSpeech
	else
		audioTextToSpeech = nil
	end

	local loadSpeech = p.loadSpeech or defaultLoadSpeech
	local v2 = audioTextToSpeech == nil
	local v3 = false

	local flag = false

	local function download()
		if flag then
			return
		end

		if audioTextToSpeech ~= nil and not v3 then
			v3 = true

			task.spawn(function()
				local success, result = pcall(loadSpeech, audioTextToSpeech)

				if flag or not success or result ~= Enum.AssetFetchStatus.Success then
					return
				end

				v2 = true
			end)
		end

		if content == nil then
			return
		end

		p.contentProvider:PreloadAsync({ content.Uri })
	end

	local v4 = false
	local flag2 = false

	local v5 = nil

	local function play()
		if flag or v == nil then
			return
		end

		v4 = true
	end

	local function pause()
		if flag or v == nil then
			return
		end

		v4 = false
		flag2 = false
		v.PlaybackSpeed = 0
	end

	local function seek(p2: number)
		if flag or v == nil then
			return
		end

		local timePosition = math.max(0, p2 - startTime)
		local timeLength = v.TimeLength

		if timeLength > 0 then
			timePosition = math.clamp(timePosition, 0, timeLength)
		end

		v.TimePosition = timePosition
	end

	local function realignToRegionStart()
		if flag or v == nil then
			return
		end

		v.PlaybackSpeed = 0
		v.TimePosition = 0
		flag2 = false
	end

	local function syncToClock(p2: number)
		if flag or v == nil or not (v4 and v2) then
			return
		end

		local v6 = v5
		v5 = p2
		local v7

		if v6 == nil then
			v7 = false
		else
			v7 = v6 < p2
		end

		if startTime <= p2 then
			local timePosition = math.max(0, p2 - startTime)

			if flag2 then
				if hasAudioRemaining(timePosition, v.TimeLength) then -- inferred equivalent call
					local v8 = timePosition - v.TimePosition

					if v8 > 0.1 or v8 < -0.5 then
						v.TimePosition = timePosition
					end
				end
			else
				if not (v7 and hasAudioRemaining(timePosition, v.TimeLength)) then -- inferred equivalent call
					return
				end

				v.TimePosition = timePosition
				v.PlaybackSpeed = 1

				if not v.IsPlaying then
					v:Play()
				end

				flag2 = true
			end
		elseif flag2 then
			v.PlaybackSpeed = 0
			v.TimePosition = 0
			flag2 = false
		end
	end

	local function dispose()
		if flag then
			return
		end

		flag = true

		if v ~= nil then
			v:Destroy()
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

	if v ~= nil then
		function ttsNode.getAudioSource()
			return v
		end

		ttsNode.audioStem = { stemId = data.id, defaultVolume = volume, role = "sidechain" }
	end

	return ttsNode
end

return { kind = "tts", create = createTtsNode, hasAudioRemaining = hasAudioRemaining }

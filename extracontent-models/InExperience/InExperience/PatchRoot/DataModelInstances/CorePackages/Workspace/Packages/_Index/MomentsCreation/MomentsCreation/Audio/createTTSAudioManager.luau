local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)
require(MomentsCreation.Types.CreationFlowTypes)
local classifyTTSError = require(MomentsCreation.Audio.classifyTTSError)
local normalizeWaveform = require(MomentsCreation.Audio.normalizeWaveform)

local GetFIntMomentsTTSWaveformSamplesPerSecond = require(MomentsCreation.Flags.GetFIntMomentsTTSWaveformSamplesPerSecond)
local GetFIntMomentsTTSWaveformMinSamples = require(MomentsCreation.Flags.GetFIntMomentsTTSWaveformMinSamples)
local GetFIntMomentsTTSWaveformMaxSamples = require(MomentsCreation.Flags.GetFIntMomentsTTSWaveformMaxSamples)
local MomentsCommon = require(parent.MomentsCommon)
local audioDuckingFastInts = MomentsCommon.Media.audioDuckingFastInts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local createSignal = Signals.createSignal

local function defaultCreateTtsInstance(parent2)
	if not game:GetEngineFeature("TextToSpeechPlatformPreview") then
		return nil
	end

	if parent2 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return nil
		end

		parent2 = localPlayer:FindFirstChildOfClass("PlayerGui")

		if parent2 == nil then
			return nil
		end
	end

	local ttsSharedGraph = Instance.new("Folder")
	ttsSharedGraph.Name = "TTSSharedGraph"

	local audioTextToSpeech = Instance.new("AudioTextToSpeech")
	audioTextToSpeech.Volume = audioDuckingFastInts.getTtsVolume()
	audioTextToSpeech.Parent = ttsSharedGraph

	local audioDeviceOutput = Instance.new("AudioDeviceOutput")
	audioDeviceOutput.Parent = ttsSharedGraph

	local wire = Instance.new("Wire")
	wire.SourceInstance = audioTextToSpeech
	wire.TargetInstance = audioDeviceOutput
	wire.Parent = ttsSharedGraph

	ttsSharedGraph.Parent = parent2

	return audioTextToSpeech
end

local function createTTSAudioManager(callback, p)
	local v = callback or function()
		return defaultCreateTtsInstance(p)
	end

	local signal, v2 = createSignal("idle")
	local signal2, v3 = createSignal(nil)
	local signal3, v4 = createSignal(0)
	local signal4, v5 = createSignal(0)
	local signal5, v6 = createSignal(false)
	local signal6, v7 = createSignal("")
	local signal7, v8 = createSignal(0)
	local signal8, v9 = createSignal({})

	local v10 = nil
	local parent2 = nil
	local count = 0
	local renderSteppedConnection = nil
	local endedConnection = nil
	local flag = false

	local function stopTimeTracking() -- 7 equivalent calls inferred from this helper
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function startTimeTracking() -- 1 equivalent call inferred from this helper
		stopTimeTracking() -- inferred equivalent call
		renderSteppedConnection = RunService.RenderStepped:Connect(function()
			if v10 then
				v5(v10.TimePosition)
			end
		end)
	end

	local function ensureGraph()
		if v10 ~= nil then
			return v10
		end

		local v11 = v()

		if v11 == nil then
			return nil
		end

		v10 = v11

		parent2 = v11.Parent

		endedConnection = v11.Ended:Connect(function()
			if flag then
				return
			end

			v2("ready")
			v5(0)
			stopTimeTracking() -- inferred equivalent call
		end)

		return v11
	end

	local function failGeneration(p2)
		v7("")
		v8(0)
		v6(false)
		v4(0)
		v9({})
		v3(p2)
		v2("error")
	end

	local function generate(text: string, p2: number)
		if flag or text == signal6(false) and p2 == signal7(false) and signal(false) ~= "error" then
			return
		end

		local v11

		if v10 == nil then
			v11 = v()

			if v11 == nil then
				v11 = nil
			else
				v10 = v11

				parent2 = v11.Parent

				endedConnection = v11.Ended:Connect(function()
					if flag then
						return
					end

					v2("ready")
					v5(0)
					stopTimeTracking() -- inferred equivalent call
				end)
			end
		else
			v11 = v10
		end

		if v11 then
			count += 1
			local v12 = count

			v11:Pause()
			stopTimeTracking() -- inferred equivalent call
			v3(nil)
			v2("loading")
			v5(0)
			v9({})

			v7("")
			v8(0)

			task.spawn(function()
				if flag then
					return
				end

				v11.Text = text
				v11.VoiceId = tostring(p2)

				local success, result = pcall(function()
					return v11:LoadPlatformAsync()
				end)

				if flag or count ~= v12 then
					return
				end

				if not success then
					failGeneration(classifyTTSError(result))
					return
				end

				if result ~= Enum.AssetFetchStatus.Success then
					failGeneration("failure")

					return
				end

				local v13 = math.clamp(
					math.round(v11.TimeLength * GetFIntMomentsTTSWaveformSamplesPerSecond()),
					GetFIntMomentsTTSWaveformMinSamples(),
					GetFIntMomentsTTSWaveformMaxSamples()
				)

				local success2, result2 = pcall(function()
					return v11:GetWaveformAsync(NumberRange.new(0, v11.TimeLength), v13)
				end)

				if flag or count ~= v12 then
					return
				end

				v7(text)
				v8(p2)
				v4(v11.TimeLength)
				v6(true)
				v5(0)

				if success2 and type(result2) == "table" then
					v9(normalizeWaveform(result2))
				end

				v2("ready")
			end)
		else
			v3("failure")
			v2("error")
		end
	end

	local function play()
		if flag then
			return
		end

		local v11 = v10

		if v11 and v11.IsLoaded then
			v11:Play()
			v2("playing")
			startTimeTracking() -- inferred equivalent call
		end
	end

	local function pause()
		if flag then
			return
		end

		local v11 = v10

		if v11 then
			v11:Pause()
			stopTimeTracking() -- inferred equivalent call

			if signal(false) == "playing" then
				v2("ready")
			end
		end
	end

	local function seek(value: number)
		if flag then
			return
		end

		local v11 = v10

		if v11 then
			local timePosition = math.clamp(value, 0, (signal3(false)))
			v11.TimePosition = timePosition
			v5(timePosition)
		end
	end

	local function setVolume(volume: number)
		if flag then
			return
		end

		local v11 = v10

		if v11 then
			v11.Volume = volume
		end
	end

	local function reset()
		if flag then
			return
		end

		count += 1

		if v10 then
			v10:Pause()
		end

		stopTimeTracking() -- inferred equivalent call
		v3(nil)
		v2("idle")
		v5(0)
		v4(0)
		v6(false)
		v7("")
		v8(0)
		v9({})
	end

	local function destroy()
		if flag then
			return
		end

		flag = true
		stopTimeTracking() -- inferred equivalent call

		if endedConnection then
			endedConnection:Disconnect()
			endedConnection = nil
		end

		if parent2 then
			parent2:Destroy()
			parent2 = nil
		end

		v10 = nil
	end

	return {
		getState = signal,
		getErrorReason = signal2,
		getTimeLength = signal3,
		getTimePosition = signal4,
		getIsLoaded = signal5,
		getLoadedText = signal6,
		getLoadedVoiceId = signal7,
		getWaveform = signal8,
		generate = generate,
		play = play,
		pause = pause,
		seek = seek,
		setVolume = setVolume,
		reset = reset,
		destroy = destroy
	}
end

return createTTSAudioManager

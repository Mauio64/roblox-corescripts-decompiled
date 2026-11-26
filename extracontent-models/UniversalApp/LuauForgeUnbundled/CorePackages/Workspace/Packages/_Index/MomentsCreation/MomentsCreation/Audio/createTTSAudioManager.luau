local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local classifyTTSError = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/classifyTTSError")
local normalizeWaveform = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/normalizeWaveform")

local GetFIntMomentsTTSWaveformSamplesPerSecond = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSWaveformSamplesPerSecond")
local GetFIntMomentsTTSWaveformMinSamples = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSWaveformMinSamples")
local GetFIntMomentsTTSWaveformMaxSamples = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSWaveformMaxSamples")
local audioDuckingFastInts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Media.audioDuckingFastInts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local createSignal = Signals.createSignal

local function defaultCreateTtsInstance(parent)
	if not game:GetEngineFeature("TextToSpeechPlatformPreview") then
		return nil
	end

	if parent == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return nil
		end

		parent = localPlayer:FindFirstChildOfClass("PlayerGui")

		if parent == nil then
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

	ttsSharedGraph.Parent = parent

	return audioTextToSpeech
end

local function createTTSAudioManager(p2, p3)
	local v5 = p2 or function()
		return defaultCreateTtsInstance(p3)
	end

	local signal, v6 = createSignal("idle")
	local signal2, v7 = createSignal(nil)
	local signal3, v8 = createSignal(0)
	local signal4, v9 = createSignal(0)
	local signal5, v10 = createSignal(false)
	local signal6, v11 = createSignal("")
	local signal7, v12 = createSignal(0)
	local signal8, v13 = createSignal({})

	local v14 = nil
	local parent = nil
	local count = 0
	local renderSteppedConnection = nil
	local endedConnection = nil
	local flag = false

	local function stopTimeTracking()
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function startTimeTracking()
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end

		renderSteppedConnection = RunService.RenderStepped:Connect(function()
			if v14 then
				v9(v14.TimePosition)
			end
		end)
	end

	local function ensureGraph()
		if v14 ~= nil then
			return v14
		end

		local v15 = v5()

		if v15 == nil then
			return nil
		end

		v14 = v15

		parent = v15.Parent

		endedConnection = v15.Ended:Connect(function()
			if flag then
				return
			end

			v6("ready")
			v9(0)

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end
		end)

		return v15
	end

	local function failGeneration(p4)
		v11("")
		v12(0)
		v10(false)
		v8(0)
		v13({})
		v7(p4)
		v6("error")
	end

	local function generate(text, p4)
		if flag or text == signal6(false) and p4 == signal7(false) and signal(false) ~= "error" then
			return
		end

		local v15

		if v14 == nil then
			v15 = v5()

			if v15 == nil then
				v15 = nil
			else
				v14 = v15

				parent = v15.Parent

				endedConnection = v15.Ended:Connect(function()
					if flag then
						return
					end

					v6("ready")
					v9(0)

					if renderSteppedConnection then
						renderSteppedConnection:Disconnect()
						renderSteppedConnection = nil
					end
				end)
			end
		else
			v15 = v14
		end

		if v15 then
			count += 1
			local v16 = count

			v15:Pause()

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			v7(nil)
			v6("loading")
			v9(0)
			v13({})

			v11("")
			v12(0)

			task.spawn(function()
				if flag then
					return
				end

				v15.Text = text
				v15.VoiceId = tostring(p4)

				local success, result = pcall(function()
					return v15:LoadPlatformAsync()
				end)

				if flag or count ~= v16 then
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

				local v17 = math.clamp(math.round(v15.TimeLength * GetFIntMomentsTTSWaveformSamplesPerSecond()), GetFIntMomentsTTSWaveformMinSamples(), GetFIntMomentsTTSWaveformMaxSamples())

				local success2, result2 = pcall(function()
					return v15:GetWaveformAsync(NumberRange.new(0, v15.TimeLength), v17)
				end)

				if flag or count ~= v16 then
					return
				end

				v11(text)
				v12(p4)
				v8(v15.TimeLength)
				v10(true)
				v9(0)

				if success2 and type(result2) == "table" then
					v13(normalizeWaveform(result2))
				end

				v6("ready")
			end)
		else
			v7("failure")
			v6("error")
		end
	end

	local function play()
		if flag then
			return
		end

		local v15 = v14

		if v15 and v15.IsLoaded then
			v15:Play()
			v6("playing")

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			renderSteppedConnection = RunService.RenderStepped:Connect(function()
				if v14 then
					v9(v14.TimePosition)
				end
			end)
		end
	end

	local function pause()
		if flag then
			return
		end

		local v15 = v14

		if v15 then
			v15:Pause()

			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			if signal(false) == "playing" then
				v6("ready")
			end
		end
	end

	local function seek(value)
		if flag then
			return
		end

		local v15 = v14

		if v15 then
			local v16 = math.clamp(value, 0, (signal3(false)))
			v15.TimePosition = v16
			v9(v16)
		end
	end

	local function setVolume(volume)
		if flag then
			return
		end

		local v15 = v14

		if v15 then
			v15.Volume = volume
		end
	end

	local function reset()
		if flag then
			return
		end

		count += 1

		if v14 then
			v14:Pause()
		end

		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end

		v7(nil)
		v6("idle")
		v9(0)
		v8(0)
		v10(false)
		v11("")
		v12(0)
		v13({})
	end

	local function destroy()
		if flag then
			return
		end

		flag = true

		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end

		if endedConnection then
			endedConnection:Disconnect()
			endedConnection = nil
		end

		if parent then
			parent:Destroy()
			parent = nil
		end

		v14 = nil
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

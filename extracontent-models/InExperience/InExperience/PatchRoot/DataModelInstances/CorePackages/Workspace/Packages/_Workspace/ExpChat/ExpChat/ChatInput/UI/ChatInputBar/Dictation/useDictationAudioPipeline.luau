local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagDictationAudioDeviceInputEnabled = SharedFlags.FFlagDictationAudioDeviceInputEnabled
local finishDictationInput = require(script.Parent.finishDictationInput)
local prepareDictationInput = require(script.Parent.prepareDictationInput)
local setDictationUsageType = require(script.Parent.setDictationUsageType)
local FFlagExpChatDictationExplicitFinish = require(ExpChat.Flags.FFlagExpChatDictationExplicitFinish)

local defineFastFlag = game:DefineFastFlag("EngineAudioSTTIsDictationEnabled", false)
local defineFastFlag2 = game:DefineFastFlag("ExpChatDictationSendUsageType", false)
local FFlagExpChatDictationStreamingAudio = require(ExpChat.Flags.FFlagExpChatDictationStreamingAudio)

local function destroyIfExists(p) -- 4 equivalent calls inferred from this helper
	if p.current then
		p.current:Destroy()
		p.current = nil
	end
end

local function disconnectIfExists(p) -- 3 equivalent calls inferred from this helper
	if p.current then
		p.current:Disconnect()
		p.current = nil
	end
end

local function teardownInstances(data) -- 5 equivalent calls inferred from this helper
	disconnectIfExists(data.textConnection) -- inferred equivalent call
	disconnectIfExists(data.vadConnection) -- inferred equivalent call
	destroyIfExists(data.wire) -- inferred equivalent call
	destroyIfExists(data.audioSTT) -- inferred equivalent call
	destroyIfExists(data.audioDeviceInput) -- inferred equivalent call
	destroyIfExists(data.container) -- inferred equivalent call
end

local function teardownPending(current)
	for k, item in current do
		pcall(task.cancel, item)
		teardownInstances(k) -- inferred equivalent call
		current[k] = nil
	end
end

local function useDictationAudioPipeline()
	local state, setState = React.useState(nil)

	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)

	local v = React.useMemo(function()
		return {
			audioDeviceInput = ref2,
			audioSTT = ref3,
			wire = ref4,
			container = ref5,
			textConnection = ref6,
			vadConnection = ref7
		}
	end, {})

	local stop = React.useCallback(function(flag: boolean?)
		teardownInstances(v) -- inferred equivalent call

		if flag then
			teardownPending(ref.current)
		end

		setState(nil)
	end, { v })

	local drain = React.useCallback(function(duration: number)
		local v2 = {
			audioDeviceInput = { current = v.audioDeviceInput.current },
			audioSTT = { current = v.audioSTT.current },
			wire = { current = v.wire.current },
			container = { current = v.container.current },
			textConnection = { current = v.textConnection.current },
			vadConnection = { current = v.vadConnection.current }
		}

		v.audioDeviceInput.current = nil
		v.audioSTT.current = nil
		v.wire.current = nil
		v.container.current = nil
		v.textConnection.current = nil
		v.vadConnection.current = nil
		disconnectIfExists(v2.vadConnection) -- inferred equivalent call
		ref.current[v2] = task.delay(duration, function()
			ref.current[v2] = nil
			teardownInstances(v2) -- inferred equivalent call
		end)
		setState(nil)
	end, { v })

	local start = React.useCallback(function(p, p2)
		local localPlayer = Players.LocalPlayer

		if not localPlayer then
			error("No local player")
		end

		teardownInstances(v) -- inferred equivalent call
		local v2

		if p2 == nil then
			v2 = false
		else
			v2 = p2.continuous == true
		end

		local expChatDictation = Instance.new("Folder")
		expChatDictation.Name = "ExpChatDictation"
		expChatDictation.Parent = CoreGui
		v.container.current = expChatDictation

		local audioDeviceInput = Instance.new("AudioDeviceInput")

		if FFlagDictationAudioDeviceInputEnabled then
			pcall(function()
				audioDeviceInput.DictationEnabled = true
			end)
		end

		audioDeviceInput.Player = localPlayer
		audioDeviceInput.Muted = false

		if FFlagExpChatDictationStreamingAudio and v2 then
			audioDeviceInput.Streaming = true
		end

		audioDeviceInput.Parent = expChatDictation
		audioDeviceInput.Active = true
		v.audioDeviceInput.current = audioDeviceInput

		local audioSpeechToText = Instance.new("AudioSpeechToText")

		if FFlagExpChatDictationStreamingAudio and v2 then
			audioSpeechToText.Streaming = true
		end

		if defineFastFlag then
			audioSpeechToText.DictationEnabled = true
		end

		if defineFastFlag2 then
			setDictationUsageType(audioSpeechToText, v2)
		end

		if FFlagExpChatDictationExplicitFinish then
			prepareDictationInput(audioSpeechToText)
		end

		audioSpeechToText.Enabled = true
		audioSpeechToText.Parent = expChatDictation
		v.audioSTT.current = audioSpeechToText

		local wire = Instance.new("Wire")
		wire.SourceInstance = audioDeviceInput
		wire.TargetInstance = audioSpeechToText
		wire.Parent = expChatDictation
		v.wire.current = wire

		v.textConnection.current = audioSpeechToText:GetPropertyChangedSignal("Text"):Connect(function()
			local text = audioSpeechToText.Text

			if text and text ~= "" then
				if v2 then
					audioSpeechToText.Text = ""
				end

				p.onTranscription(text)
			end
		end)

		if p.onSpeechStarted then
			local onSpeechStarted = p.onSpeechStarted
			v.vadConnection.current = audioSpeechToText:GetPropertyChangedSignal("VoiceDetected"):Connect(function()
				if audioSpeechToText.VoiceDetected then
					onSpeechStarted()
				end
			end)
		end

		setState(audioDeviceInput)
		return audioDeviceInput
	end, { v })

	React.useEffect(function()
		return function()
			teardownInstances(v) -- inferred equivalent call
			teardownPending(ref.current)
		end
	end, { v })

	return React.useMemo(function()
		return {
			start = start,
			finishInput = function()
				return finishDictationInput(v.audioSTT.current)
			end,
			stop = stop,
			drain = drain,
			discardPending = function()
				teardownPending(ref.current)
			end,
			audioDeviceInput = state,
			audioDeviceInputRef = ref2
		}
	end, { start, stop, drain, state, v })
end

return useDictationAudioPipeline

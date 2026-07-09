local scriptParent = script.Parent
local TextUtility = require(scriptParent.TextUtility)
local Properties = require(scriptParent.Properties)
local TTSHandlerState = require(scriptParent.TTSHandlerState)
local SystemReadoutText = require(scriptParent.SystemReadoutText)
local AudioTTSTape = require(scriptParent.AudioTTSTape)
local CreateLogger = require(scriptParent.CreateLogger)
local v8 = require(scriptParent.getFFlagReadAloudDebugPrintouts)()
local v9 = if not v8 then nil else CreateLogger(script.Name)
local t1 = {}

t1.__index = t1

function t1.SetVolume(t2: {[any]: any}, n1: number) -- line: 64
	local v13 = math.clamp(n1, 0, 3)

	t2.TTSTape:SetVolume(v13)
	t2.systemAudioTTS.Volume = v13
end
function t1.SetVoiceId(t3: {[any]: any}, n2: number) -- line: 69
	local str = tostring((math.clamp(math.round(n2), 1, 8)))

	t3.TTSTape:SetVoiceId(str)
	t3.systemAudioTTS.VoiceId = str
end
function t1.SetPitch(t4: {[any]: any}, n3: number) -- line: 74
	local v19 = math.clamp(n3, -12, 12)

	t4.TTSTape:SetPitch(v19)
	t4.systemAudioTTS.Pitch = v19
end
function t1.SetSpeed(t5: {[any]: any}, n4: number) -- line: 79
	local v22 = math.clamp(n4, 0.5, 2)

	t5.TTSTape:SetSpeed(v22)
	t5.systemAudioTTS.Speed = v22
end
function t1.SetText(t6: {[any]: any}, s1: string) -- line: 85
	-- upvalues: TextUtility (copy)
	t6.originalText = s1
	t6.cleanedText = TextUtility.cleanText(s1)
	t6.splitText = TextUtility.splitTextToReadableChunks(t6.cleanedText)
	t6.TTSTape:SetTextChunks(t6.splitText)
end
function t1.UpdateSettings(t7: {[any]: any}, n5: number?, n6: number?, n7: number?, n8: number?) -- line: 94
	-- upvalues: Properties (copy)
	t7:SetVolume(n5 or Properties.DefaultVolume)
	t7:SetVoiceId(n6 or Properties.DefaultVoiceId)
	t7:SetPitch(n7 or Properties.DefaultPitch)
	t7:SetSpeed(n8 or Properties.DefaultSpeed)
end
function t1.SetState(p1, p2) -- line: 102
	p1.State = p2
	p1.StateChanged:Fire()
end
function t1.Play(p3) -- line: 108
	-- upvalues: TTSHandlerState (copy), v9 (copy), v8 (copy)
	if not p3.TTSTape:IsLoaded() then
		p3:SetState(TTSHandlerState.Loading)

		local v33 = p3.TTSTape:Load()
		local status = v33.status
		local time = v33.time

		if status ~= Enum.AssetFetchStatus.Success then
			v9:error("TTSHandler failed to load audio, with status", status)
			p3.State = "Idle"
			p3:ReadSystemTextFromKey("FailedToRead")

			return
		end

		if v8 then
			v9:info(`Loaded audio in { time } seconds`)
		end
	end

	p3:SetState(TTSHandlerState.Playing)
	p3.TTSTape:Play()
end
function t1.Pause(p4) -- line: 132
	-- upvalues: TTSHandlerState (copy)
	p4:SetState(TTSHandlerState.Paused)
	p4.TTSTape:Pause()
end
function t1.ReadSystemTextFromKey(t8: {[any]: any}, s2: string) -- line: 137
	-- upvalues: SystemReadoutText (copy), v8 (copy), v9 (copy)
	local v39 = SystemReadoutText[s2]

	if v8 then
		v9:info("TTSHandler system is reading", SystemReadoutText[s2])
	end

	t8.systemAudioTTS.Text = v39
	t8.systemAudioTTS:LoadAsync()
	t8.systemAudioTTS:Play()
end
function t1.CleanUp(p5) -- line: 148
	local instanceFolder = p5.instanceFolder

	if instanceFolder then
		p5.instanceFolder = nil
		instanceFolder:Destroy()
	end
end
function t1.__gc(p6) -- line: 155
	p6:CleanUp()
end
function t1.new(n9: number?, n10: number?, n11: number?, n12: number?, n13: number?, n14: number?) -- line: 161
	-- upvalues: t1 (copy), TTSHandlerState (copy), AudioTTSTape (copy), Properties (copy), v8 (copy), v9 (copy)
	local t9 = {}

	setmetatable(t9, t1)
	t9.StateChanged = Instance.new("BindableEvent")
	t9:SetState(TTSHandlerState.Idle)
	t9.originalText = ""
	t9.cleanedText = ""
	t9.splitText = {}

	local Folder = Instance.new("Folder")

	Folder.Name = "Read Aloud"
	Folder.Parent = workspace
	t9.instanceFolder = Folder

	local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

	AudioDeviceOutput.Parent = Folder

	local AudioTextToSpeech = Instance.new("AudioTextToSpeech")

	AudioTextToSpeech.Name = "System Readout"
	AudioTextToSpeech.Parent = Folder
	t9.systemAudioTTS = AudioTextToSpeech

	local Wire = Instance.new("Wire")

	Wire.Parent = AudioTextToSpeech
	Wire.SourceInstance = AudioTextToSpeech
	Wire.TargetInstance = AudioDeviceOutput
	t9.TTSTape = AudioTTSTape.new(n13 or 1 + Properties.NumPreloadedAudioChunks, n14 or Properties.PreloadNextDelay, Folder, AudioDeviceOutput)
	t9.TTSTape.AudioEnded.Event:Connect(function() -- line: 205
		-- upvalues: t9 (copy), TTSHandlerState (copy)
		t9:SetState(TTSHandlerState.Idle)
	end)
	t9:UpdateSettings(n9, n10, n11, n12)

	if v8 then
		t9.StateChanged.Event:Connect(function() -- line: 212
			-- upvalues: v9 (copy), t9 (copy)
			v9:info(`TTSHandler updated state to { t9.State }`)
		end)
	end

	return t9
end

return t1

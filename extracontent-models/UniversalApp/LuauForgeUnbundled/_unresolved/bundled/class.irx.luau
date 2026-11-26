local module = require("@luauforge/bundled/iry")
local module2 = require("@luauforge/bundled/irC")
local module3 = require("@luauforge/bundled/irD")
local module4 = require("@luauforge/bundled/irE")
local module5 = require("@luauforge/bundled/irF")

local module6 = require("@luauforge/bundled/irH")
local v5 = require("@luauforge/bundled/irG")()

local v6 = if v5 then module6("TTSHandler") else nil

local class = {}
class.__index = class

function class:SetVolume(value)
	local v7 = math.clamp(value, 0, 3)
	self.TTSTape:SetVolume(v7)
	self.systemAudioTTS.Volume = v7
end
function class:SetVoiceId(p3)
	local v7 = tostring((math.clamp(math.round(p3), 1, 8)))
	self.TTSTape:SetVoiceId(v7)
	self.systemAudioTTS.VoiceId = v7
end
function class:SetPitch(value)
	local v7 = math.clamp(value, -12, 12)
	self.TTSTape:SetPitch(v7)
	self.systemAudioTTS.Pitch = v7
end
function class:SetSpeed(value)
	local v7 = math.clamp(value, 0.5, 2)
	self.TTSTape:SetSpeed(v7)
	self.systemAudioTTS.Speed = v7
end

function class:SetText(originalText)
	self.originalText = originalText
	self.cleanedText = module.cleanText(originalText)
	self.splitText = module.splitTextToReadableChunks(self.cleanedText)

	self.TTSTape:SetTextChunks(self.splitText)
end
function class:UpdateSettings(p2, p3, p4, p5)
	self:SetVolume(p2 or module2.DefaultVolume)
	self:SetVoiceId(p3 or module2.DefaultVoiceId)
	self:SetPitch(p4 or module2.DefaultPitch)
	self:SetSpeed(p5 or module2.DefaultSpeed)
end

function class:SetState(state)
	self.State = state
	self.StateChanged:Fire()
end

function class:Play()
	if not self.TTSTape:IsLoaded() then
		self:SetState(module3.Loading)
		local loaded = self.TTSTape:Load()
		local status = loaded.status
		local time2 = loaded.time

		if status == Enum.AssetFetchStatus.Success then
			if v5 then
				v6:info(`Loaded audio in {time2} seconds`)
			end
		else
			v6:error("TTSHandler failed to load audio, with status", status)
			self.State = "Idle"
			self:ReadSystemTextFromKey("FailedToRead")
			return
		end
	end

	self:SetState(module3.Playing)
	self.TTSTape:Play()
end

function class:Pause()
	self:SetState(module3.Paused)
	self.TTSTape:Pause()
end

function class.ReadSystemTextFromKey(p2, p3)
	local v7 = module4[p3]

	if v5 then
		v6:info("TTSHandler system is reading", module4[p3])
	end

	p2.systemAudioTTS.Text = v7
	p2.systemAudioTTS:LoadAsync()
	p2.systemAudioTTS:Play()
end

function class:CleanUp()
	local instanceFolder = self.instanceFolder

	if instanceFolder then
		self.instanceFolder = nil
		instanceFolder:Destroy()
	end
end
function class:__gc()
	self:CleanUp()
end

function class.new(p2, p3, p4, p5, p6, p7)
	local class2 = {}
	setmetatable(class2, class)

	class2.StateChanged = Instance.new("BindableEvent")
	class2:SetState(module3.Idle)
	class2.originalText = ""
	class2.cleanedText = ""
	class2.splitText = {}

	local readAloud = Instance.new("Folder")
	readAloud.Name = "Read Aloud"
	readAloud.Parent = workspace
	class2.instanceFolder = readAloud

	local audioDeviceOutput = Instance.new("AudioDeviceOutput")
	audioDeviceOutput.Parent = readAloud

	local systemReadout = Instance.new("AudioTextToSpeech")
	systemReadout.Name = "System Readout"
	systemReadout.Parent = readAloud
	class2.systemAudioTTS = systemReadout

	local wire = Instance.new("Wire")
	wire.Parent = systemReadout
	wire.SourceInstance = systemReadout
	wire.TargetInstance = audioDeviceOutput

	class2.TTSTape = module5.new(
		p6 or 1 + module2.NumPreloadedAudioChunks,
		p7 or module2.PreloadNextDelay,
		readAloud,
		audioDeviceOutput
	)

	class2.TTSTape.AudioEnded.Event:Connect(function()
		class2:SetState(module3.Idle)
	end)

	class2:UpdateSettings(p2, p3, p4, p5)

	if v5 then
		class2.StateChanged.Event:Connect(function()
			v6:info(`TTSHandler updated state to {class2.State}`)
		end)
	end

	return class2
end

return class

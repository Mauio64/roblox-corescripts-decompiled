local v5 = require("@luauforge/bundled/irG")()
local module = require("@luauforge/bundled/irC")
local module2 = require("@luauforge/bundled/irH")

local v6 = if v5 then module2("AudioTTSTape") else nil

local class = {}
class.__index = class

function class:SetVolume(volume)
	local v7 = self.Current

	repeat
		v7.audioTextToSpeech.Volume = volume
		v7 = v7.nextNode
	until v7 == self.Current
end

function class:SetVoiceId(voiceId)
	local v7 = self.Current

	repeat
		v7.audioTextToSpeech.VoiceId = voiceId
		v7 = v7.nextNode
	until v7 == self.Current
end

function class:SetPitch(pitch)
	local v7 = self.Current

	repeat
		v7.audioTextToSpeech.Pitch = pitch
		v7 = v7.nextNode
	until v7 == self.Current
end

function class:SetSpeed(speed)
	local v7 = self.Current

	repeat
		v7.audioTextToSpeech.Speed = speed
		v7 = v7.nextNode
	until v7 == self.Current
end

local function CreateTextTapeAndFillAudioTTSTape(object, list)
	local v7 = { text = list[1], nextNode = nil }

	object.Current.audioTextToSpeech.Text = v7.text
	object.Current.audioTextToSpeech.TimePosition = 0

	local nextNode = object.Current.nextNode
	local v8 = v7
	local v9 = v8

	for i = 2, #list do
		local v11 = { text = list[i], nextNode = nil }

		if nextNode.id ~= object.Current.id then
			nextNode.audioTextToSpeech.Text = v11.text
			nextNode = nextNode.nextNode
			v8 = v11
		end

		v9.nextNode = v11
		v9 = v11
	end

	v9.nextNode = v7
	object._nextAvailableTextNode = v8.nextNode

	while nextNode.id ~= object.Current.id do
		nextNode.audioTextToSpeech.Text = ""
		nextNode = nextNode.nextNode
	end
end

function class:SetTextChunks(list)
	if #list < 1 then
		self._nextAvailableTextNode = nil
		return
	end

	self:_DisconnectCycle()

	CreateTextTapeAndFillAudioTTSTape(self, list)

	self:_ConnectCycle()
end

function class.IsPlaying(p2)
	return p2.Current.audioTextToSpeech.IsPlaying
end

function class:IsLoaded()
	return self.Current.audioTextToSpeech.IsLoaded
end

function class:_CycleNodes()
	if self._nextAvailableTextNode == nil then
		v6:warning("AudioTTSTape tried to cycle, but there is no text being read")
		return
	end

	if self._nextAvailableTextNode.nextNode == self._nextAvailableTextNode then
		return
	end

	local current = self.Current
	local nextNode = self.Current.nextNode

	while nextNode.audioTextToSpeech.Text == "" do
		nextNode = nextNode.nextNode
	end

	current.audioTextToSpeech.Text = self._nextAvailableTextNode.text
	self._nextAvailableTextNode = self._nextAvailableTextNode.nextNode

	if self._preloading then
		current.audioTextToSpeech:Unload()
	else
		local thread = coroutine.create(function()
			if v5 then
				v6:debug("Cycle forcing preload on completed node")
			end

			local lastTime = os.clock()
			local async = current.audioTextToSpeech:LoadAsync()
			local v7 = os.clock() - lastTime

			if async == Enum.AssetFetchStatus.Success then
				if v5 then
					v6:debug("Preloaded node")
				end
			else
				v6:error("Failed to preload a node")
			end

			if v5 then
				v6:info(`Preload results: {async}, {v7}`)
			end
		end)
		task.spawn(thread)
	end

	self:_DisconnectCycle()
	self.Current = nextNode
	self:_ConnectCycle()
end

function class:_ConnectCycle()
	self._currAudioEndedConnection = self.Current.audioTextToSpeech.Ended:Connect(function()
		self.AudioEnded:Fire()
		self:_CycleNodes()
	end)
end

function class:_DisconnectCycle()
	local currAudioEndedConnection = self._currAudioEndedConnection

	if currAudioEndedConnection then
		currAudioEndedConnection:Disconnect()
	end

	self._currAudioEndedConnection = nil
end

local function iteratePreloadCoroutine(state, current, preloadCoroutineID)
	if v5 then
		v6:debug(`Preload coroutine ID {preloadCoroutineID} started`)
	end

	state._preloading = true
	local nextNode = current.nextNode

	while nextNode.id ~= state.Current.id and preloadCoroutineID == state._preloadCoroutineID do
		if nextNode.audioTextToSpeech.Text ~= "" and not nextNode.audioTextToSpeech.IsLoaded then
			local lastTime = os.clock()
			local async = nextNode.audioTextToSpeech:LoadAsync()
			local v7 = os.clock() - lastTime

			if async == Enum.AssetFetchStatus.Success then
				if v5 then
					v6:debug("Preloaded node")
				end
			else
				v6:error("Failed to preload a node")
			end

			if v5 then
				v6:info(`Preload results: {async}, {v7}`)
			end

			task.wait(state.PreloadDelay)
		end

		nextNode = nextNode.nextNode
	end

	state._preloading = false

	if v5 then
		v6:debug(`Preload coroutine ID {preloadCoroutineID} stopped`)
	end
end

function class:InitiatePreload()
	if self._nextAvailableTextNode == nil then
		v6:warning("AudioTTSTape tried to preload audio, but there is no text being read.")
		return
	end

	if self.Current.nextNode.id == self.Current.id then
		return
	end

	self._preloadCoroutineID = (self._preloadCoroutineID + 1) % module.MAX_PRELOAD_COROUTINES
	local thread = coroutine.create(function()
		iteratePreloadCoroutine(self, self.Current, self._preloadCoroutineID)
	end)
	task.spawn(thread)
end

function class:Load()
	if not self._nextAvailableTextNode then
		v6:warning("AudioTTSTape tried to load audio, but there is no text being read.")
		return { status = Enum.AssetFetchStatus.Failure, time = -1 }
	end

	local lastTime = os.clock()
	local async = self.Current.audioTextToSpeech:LoadAsync()
	self:InitiatePreload()
	return {
		status = async,
		time = os.clock() - lastTime
	}
end

function class:Play()
	if not self._nextAvailableTextNode then
		v6:warning("AudioTTSTape tried to play audio, but no text is being read.")

		return
	end

	if not self:IsLoaded() then
		self:Load()
	end

	self.Current.audioTextToSpeech:Play()
end

function class:Pause()
	self.Current.audioTextToSpeech:Pause()
end

function class.new(p2, preloadDelay, parent, targetInstance)
	local object = setmetatable({}, class)

	local v7 = math.max(math.floor(p2), 1)
	object.Length = v7
	object.PreloadDelay = preloadDelay

	object.CurrentAudioLoaded = Instance.new("BindableEvent")
	object.CurrentAudioLoaded.Name = "Current Audio Loaded Event"
	object.CurrentAudioLoaded.Parent = parent

	object._preloadCoroutineID = 0
	object._preloading = false
	local count = 0
	local v8 = nil
	local v9 = nil

	for i = 1, v7 do
		local audioTextToSpeech = Instance.new("AudioTextToSpeech")
		audioTextToSpeech.Parent = parent

		local wire = Instance.new("Wire")
		wire.Parent = audioTextToSpeech
		wire.SourceInstance = audioTextToSpeech
		wire.TargetInstance = targetInstance

		local v10 = {
			audioTextToSpeech = audioTextToSpeech,
			nextNode = nil,
			id = count
		}

		if i == 1 then
			v9 = v10
		end

		if v8 then
			v8.nextNode = v10
		end

		count += 1
		v8 = v10
	end

	v8.nextNode = v9
	object.Current = v8

	object.AudioEnded = Instance.new("BindableEvent")
	object.AudioEnded.Name = "Audio Ended Event"
	object.AudioEnded.Parent = parent

	object:_ConnectCycle()

	return object
end

return class

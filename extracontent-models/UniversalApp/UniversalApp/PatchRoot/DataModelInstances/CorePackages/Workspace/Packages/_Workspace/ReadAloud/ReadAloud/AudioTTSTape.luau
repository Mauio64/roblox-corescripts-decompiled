local scriptParent = script.Parent
local v2 = require(scriptParent.getFFlagReadAloudDebugPrintouts)()
local Properties = require(scriptParent.Properties)
local CreateLogger = require(scriptParent.CreateLogger)
local v5 = if not v2 then nil else CreateLogger(script.Name)
local t1 = {}

t1.__index = t1

function t1.SetVolume(t2: {[any]: any}, n1: number) -- line: 64
	local Current = t2.Current

	repeat
		Current.audioTextToSpeech.Volume = n1
		Current = Current.nextNode
	until Current == t2.Current
end
function t1.SetVoiceId(t3: {[any]: any}, s1: string) -- line: 72
	local Current = t3.Current

	repeat
		Current.audioTextToSpeech.VoiceId = s1
		Current = Current.nextNode
	until Current == t3.Current
end
function t1.SetPitch(t4: {[any]: any}, n2: number) -- line: 80
	local Current = t4.Current

	repeat
		Current.audioTextToSpeech.Pitch = n2
		Current = Current.nextNode
	until Current == t4.Current
end
function t1.SetSpeed(t5: {[any]: any}, n3: number) -- line: 88
	local Current = t5.Current

	repeat
		Current.audioTextToSpeech.Speed = n3
		Current = Current.nextNode
	until Current == t5.Current
end

local function CreateTextTapeAndFillAudioTTSTape(t6: {[any]: any}, t7: {[any]: any}) -- line: 97
	local t8 = {
		nextNode = nil,
		text = t7[1]
	}

	t6.Current.audioTextToSpeech.Text = t8.text
	t6.Current.audioTextToSpeech.TimePosition = 0

	local v24 = t8
	local nextNode = t6.Current.nextNode
	local v26 = t8

	for i = 2, #t7 do
		local t9 = {
			nextNode = nil,
			text = t7[i]
		}

		if nextNode.id ~= t6.Current.id then
			nextNode.audioTextToSpeech.Text = t9.text
			nextNode = nextNode.nextNode
			v24 = t9
		end

		v26.nextNode = t9
		v26 = t9
	end

	v26.nextNode = t8
	t6._nextAvailableTextNode = v24.nextNode

	while nextNode.id ~= t6.Current.id do
		nextNode.audioTextToSpeech.Text = ""
		nextNode = nextNode.nextNode
	end
end

function t1.SetTextChunks(t10: {[any]: any}, t11: {[any]: any}) -- line: 137
	-- upvalues: CreateTextTapeAndFillAudioTTSTape (copy)
	if #t11 < 1 then
		t10._nextAvailableTextNode = nil

		return
	end

	t10:_DisconnectCycle()
	CreateTextTapeAndFillAudioTTSTape(t10, t11)
	t10:_ConnectCycle()
end
function t1.IsPlaying(p1) -- line: 154
	return p1.Current.audioTextToSpeech.IsPlaying
end
function t1.IsLoaded(p2) -- line: 158
	return p2.Current.audioTextToSpeech.IsLoaded
end
function t1._CycleNodes(p3) -- line: 163
	-- upvalues: v5 (copy), v2 (copy)
	if p3._nextAvailableTextNode == nil then
		v5:warning("AudioTTSTape tried to cycle, but there is no text being read")

		return
	end

	if p3._nextAvailableTextNode.nextNode == p3._nextAvailableTextNode then
		return
	end

	local Current = p3.Current
	local nextNode = p3.Current.nextNode

	while nextNode.audioTextToSpeech.Text == "" do
		nextNode = nextNode.nextNode
	end

	Current.audioTextToSpeech.Text = p3._nextAvailableTextNode.text
	p3._nextAvailableTextNode = p3._nextAvailableTextNode.nextNode

	if p3._preloading then
		Current.audioTextToSpeech:Unload()
	else
		local co = coroutine.create(function() -- line: 192
			-- upvalues: v2 (copy), v5 (copy), Current (copy)
			if v2 then
				v5:debug("Cycle forcing preload on completed node")
			end

			local elapsed = os.clock()
			local v68 = Current.audioTextToSpeech:LoadAsync()
			local v69 = os.clock() - elapsed

			if v68 ~= Enum.AssetFetchStatus.Success then
				v5:error("Failed to preload a node")
			elseif v2 then
				v5:debug("Preloaded node")
			end

			if v2 then
				v5:info(`Preload results: { v68 }, { v69 }`)
			end
		end)

		task.spawn(co)
	end

	p3:_DisconnectCycle()
	p3.Current = nextNode
	p3:_ConnectCycle()
end
function t1._ConnectCycle(p4) -- line: 220
	p4._currAudioEndedConnection = p4.Current.audioTextToSpeech.Ended:Connect(function() -- line: 221
		-- upvalues: p4 (copy)
		p4.AudioEnded:Fire()
		p4:_CycleNodes()
	end)
end
function t1._DisconnectCycle(p5) -- line: 228
	local _currAudioEndedConnection = p5._currAudioEndedConnection

	if _currAudioEndedConnection then
		_currAudioEndedConnection:Disconnect()
	end

	p5._currAudioEndedConnection = nil
end

local function iteratePreloadCoroutine(t12: {[any]: any}, t13: {[any]: any}, n4: number) -- line: 237
	-- upvalues: v2 (copy), v5 (copy)
	if v2 then
		v5:debug(`Preload coroutine ID { n4 } started`)
	end

	t12._preloading = true

	local nextNode = t13.nextNode

	while nextNode.id ~= t12.Current.id and n4 == t12._preloadCoroutineID do
		if nextNode.audioTextToSpeech.Text ~= "" and not nextNode.audioTextToSpeech.IsLoaded then
			local elapsed = os.clock()
			local v45 = nextNode.audioTextToSpeech:LoadAsync()
			local v46 = os.clock() - elapsed

			if v45 ~= Enum.AssetFetchStatus.Success then
				v5:error("Failed to preload a node")
			elseif v2 then
				v5:debug("Preloaded node")
			end

			if v2 then
				v5:info(`Preload results: { v45 }, { v46 }`)
			end

			task.wait(t12.PreloadDelay)
		end

		nextNode = nextNode.nextNode
	end

	t12._preloading = false

	if v2 then
		v5:debug(`Preload coroutine ID { n4 } stopped`)
	end
end

function t1.InitiatePreload(p6) -- line: 271
	-- upvalues: v5 (copy), Properties (copy), iteratePreloadCoroutine (copy)
	if p6._nextAvailableTextNode == nil then
		v5:warning("AudioTTSTape tried to preload audio, but there is no text being read.")

		return
	end

	if p6.Current.nextNode.id == p6.Current.id then
		return
	end

	p6._preloadCoroutineID = (p6._preloadCoroutineID + 1) % Properties.MAX_PRELOAD_COROUTINES

	local co = coroutine.create(function() -- line: 284
		-- upvalues: iteratePreloadCoroutine (copy), p6 (copy)
		iteratePreloadCoroutine(p6, p6.Current, p6._preloadCoroutineID)
	end)

	task.spawn(co)
end
function t1.Load(p7) -- line: 290
	-- upvalues: v5 (copy)
	if p7._nextAvailableTextNode then
		local elapsed = os.clock()
		local v51 = p7.Current.audioTextToSpeech:LoadAsync()

		p7:InitiatePreload()

		return {
			status = v51,
			time = os.clock() - elapsed
		}
	end

	v5:warning("AudioTTSTape tried to load audio, but there is no text being read.")

	return {
		time = -1,
		status = Enum.AssetFetchStatus.Failure
	}
end
function t1.Play(p8) -- line: 303
	-- upvalues: v5 (copy)
	if p8._nextAvailableTextNode then
		if not p8:IsLoaded() then
			p8:Load()
		end

		p8.Current.audioTextToSpeech:Play()

		return
	end

	v5:warning("AudioTTSTape tried to play audio, but no text is being read.")
end
function t1.Pause(p9) -- line: 315
	p9.Current.audioTextToSpeech:Pause()
end
function t1.new(n5: number, n6: number, p10, p11) -- line: 320
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)
	local v59 = math.max(math.floor(n5), 1)

	self.Length = v59
	self.PreloadDelay = n6
	self.CurrentAudioLoaded = Instance.new("BindableEvent")
	self.CurrentAudioLoaded.Name = "Current Audio Loaded Event"
	self.CurrentAudioLoaded.Parent = p10
	self._preloadCoroutineID = 0
	self._preloading = false

	local v60 = nil
	local v61 = nil
	local n7 = 0

	for i = 1, v59 do
		local AudioTextToSpeech = Instance.new("AudioTextToSpeech")

		AudioTextToSpeech.Parent = p10

		local Wire = Instance.new("Wire")

		Wire.Parent = AudioTextToSpeech
		Wire.SourceInstance = AudioTextToSpeech
		Wire.TargetInstance = p11

		local t14 = {
			nextNode = nil,
			audioTextToSpeech = AudioTextToSpeech,
			id = n7
		}

		if i == 1 then
			v61 = t14
		end

		if v60 then
			v60.nextNode = t14
		end

		v60 = t14
		n7 += 1
	end

	v60.nextNode = v61
	self.Current = v60
	self.AudioEnded = Instance.new("BindableEvent")
	self.AudioEnded.Name = "Audio Ended Event"
	self.AudioEnded.Parent = p10
	self:_ConnectCycle()

	return self
end

return t1

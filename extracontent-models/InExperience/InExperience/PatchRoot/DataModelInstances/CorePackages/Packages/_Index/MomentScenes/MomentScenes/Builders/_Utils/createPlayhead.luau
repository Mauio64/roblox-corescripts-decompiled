local RunService = game:GetService("RunService")

require(script.Parent.Parent.Parent.Types)

local function defaultClipLength(tracks) -- 1 equivalent call inferred from this helper
	local v = 0

	for _, item in tracks do
		if v < item.Length then
			v = item.Length
		end
	end

	return v
end

local function wrapAction(fn, callback) -- 3 equivalent calls inferred from this helper
	if callback == nil then
		return fn
	end

	return function()
		callback(fn)
	end
end

local function wrapSeek(fn, seek) -- 1 equivalent call inferred from this helper
	if seek == nil then
		return fn
	end

	return function(p: number)
		seek(fn, p)
	end
end

local function wrapBool(fn, getIsPlaying) -- 1 equivalent call inferred from this helper
	if getIsPlaying == nil then
		return fn
	end

	return function()
		return getIsPlaying(fn)
	end
end

local function wrapNumber(fn, getPosition) -- 1 equivalent call inferred from this helper
	if getPosition == nil then
		return fn
	end

	return function()
		return getPosition(fn)
	end
end

local function createPlayhead(data)
	local root = data.root
	local tracks = data.tracks or {}

	local getClipLength = data.getClipLength or function()
		return defaultClipLength(tracks) -- inferred equivalent call
	end

	local getDuration = data.getDuration or getClipLength
	local syncVisuals = data.syncVisuals
	local animator = data.animator
	local canPlay = data.canPlay or function(): boolean
		return getDuration() > 0
	end

	local v = 0
	local v2 = false
	local flag = false
	local heartbeatConnection = nil

	local function stopClock() -- 2 equivalent calls inferred from this helper
		if heartbeatConnection ~= nil then
			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end
	end

	local function poseRig() -- 1 equivalent call inferred from this helper
		if animator ~= nil and not RunService:IsRunning() then
			animator:StepAnimations(0)
		end
	end

	local function applyPlayhead(value: number)
		local duration = getDuration()
		local clipLength = getClipLength()

		if duration <= 0 then
			v = 0
		else
			v = math.clamp(value, 0, duration)

			if clipLength > 0 then
				for _, track in tracks do
					track.TimePosition = v % clipLength
				end
			end
		end

		poseRig() -- inferred equivalent call

		if syncVisuals ~= nil then
			syncVisuals(v)
		end
	end

	local function startClock()
		if heartbeatConnection ~= nil or flag then
			return
		end

		heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
			if flag or not v2 then
				return
			end

			local duration = getDuration()

			if duration <= 0 then
				return
			end

			applyPlayhead((v + dt) % duration)
		end)
	end

	local function fn()
		if flag then
			return
		end

		if not canPlay() then
			v2 = false
			return
		end

		if syncVisuals ~= nil then
			syncVisuals(v)
		end

		for _, track in tracks do
			track:AdjustSpeed(1)

			if not track.IsPlaying then
				track:Play(0)
			end
		end

		applyPlayhead(v)
		v2 = true

		if heartbeatConnection == nil then
			if flag then
				return
			end

			heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
				if flag or not v2 then
					return
				end

				local duration = getDuration()

				if duration <= 0 then
					return
				end

				applyPlayhead((v + dt) % duration)
			end)
		end
	end

	local function fn2()
		if flag then
			return
		end

		stopClock() -- inferred equivalent call

		for _, track in tracks do
			track:AdjustSpeed(0)
		end

		v2 = false
	end

	local function fn3(p: number)
		if flag then
			return
		end

		applyPlayhead(p)
	end

	local function fn4()
		if flag then
			return
		end

		flag = true
		v2 = false
		stopClock() -- inferred equivalent call

		for _, track in tracks do
			track:AdjustSpeed(0)
			track:Stop(0)
		end

		table.clear(tracks)
		root:Destroy()
	end

	applyPlayhead(0)

	local playhead = {
		play = wrapAction(fn, data.play), -- inferred equivalent call
		pause = wrapAction(fn2, data.pause), -- inferred equivalent call
		seek = wrapSeek(fn3, data.seek), -- inferred equivalent call
		dispose = wrapAction(fn4, data.dispose), -- inferred equivalent call
		getIsPlaying = 0,
		getPosition = 0,
		getDuration = 0
	}
	local function fn5()
		return v2
	end

	playhead.getIsPlaying = wrapBool(fn5, data.getIsPlaying) -- inferred equivalent call
	local function fn6()
		return v
	end

	playhead.getPosition = wrapNumber(fn6, data.getPosition) -- inferred equivalent call
	playhead.getDuration = getDuration
	return playhead
end

return createPlayhead

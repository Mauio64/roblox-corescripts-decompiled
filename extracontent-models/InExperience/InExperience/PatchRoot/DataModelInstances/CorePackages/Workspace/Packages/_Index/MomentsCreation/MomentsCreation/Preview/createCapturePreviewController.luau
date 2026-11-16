local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)

require(MomentsCreation.Types.CreationFlowTypes)

local createSignal = Signals.createSignal

local function createCapturePreviewController(p, callback, callback2)
	local signal, setPosition = createSignal(0)
	local signal2, setDuration = createSignal(0)
	local signal3, setTimeLength = createSignal(0)
	local signal4, setIsPlaying = createSignal(true)
	local signal5, v = createSignal(false)
	local signal6, setReadiness = createSignal("Loading")

	local signal7, setMediaController = createSignal(nil)

	local v2 = nil

	local function bindEngine(p2)
		v2 = p2

		if p2 ~= nil then
			if signal4(false) then
				p2.play()
			else
				p2.pause()
			end
		end
	end

	local function play()
		local v3 = signal7(false)

		if v3 == nil then
			if signal4(false) then
				return
			end

			setIsPlaying(true)

			if v2 ~= nil then
				v2.play()
			end
		elseif not v3.getState(false).isPlaying then
			v3.play()
		end
	end

	local function pause() -- 1 equivalent call inferred from this helper
		local v3 = signal7(false)

		if v3 ~= nil then
			v3.pause()
			return
		end

		if not signal4(false) then
			return
		end

		setIsPlaying(false)

		if v2 ~= nil then
			v2.pause()
		end
	end

	local function toggle()
		local v3 = signal7(false)

		if v3 ~= nil then
			v3.toggle()
		elseif signal4(false) then
			pause() -- inferred equivalent call
		else
			play()
		end
	end

	local function setMuted(flag: boolean) -- 1 equivalent call inferred from this helper
		local v3 = signal7(false)

		if v3 ~= nil then
			v3.audio.setMasterMuted(flag)
			return
		end

		v(flag)

		if v2 ~= nil and v2.setMuted ~= nil then
			v2.setMuted(flag)
		end
	end

	local function toggleMute()
		local v3 = signal7(false)
		local v4

		if v3 == nil then
			v4 = signal5(false)
		else
			v4 = v3.getState(false).isMuted
		end

		setMuted(not v4) -- inferred equivalent call
	end

	local function seek(p2: number)
		local v3 = signal7(false)

		if v3 ~= nil then
			v3.seek(p2)
			return
		end

		local v4

		if callback ~= nil then
			v4 = callback(false)
		end

		local v5 = p2 + (v4 == nil and 0 or v4.startTime)
		setPosition(v5)

		if v2 ~= nil then
			v2.seek(v5)
		end
	end

	return {
		getCapture = p.getSelectedCapture,
		getReadiness = function(p2)
			local v3 = signal7(p2)

			if v3 == nil then
				return signal6(p2)
			end

			return v3.getState(p2).readiness
		end,
		playback = {
			getPosition = function(p2)
				local v3 = signal7(p2)

				if v3 ~= nil then
					return v3.getPosition(p2)
				end

				local v4

				if callback ~= nil then
					v4 = callback(p2)
				end

				if v4 == nil then
					return signal(p2)
				end

				local v5 = math.max(0, v4.endTime - v4.startTime)
				return (math.clamp(signal(p2) - v4.startTime, 0, v5))
			end,
			getDuration = function(p2)
				local v3 = signal7(p2)

				if v3 ~= nil then
					return v3.getState(p2).duration
				end

				local v4

				if callback ~= nil then
					v4 = callback(p2)
				end

				if v4 == nil then
					return signal2(p2)
				end

				return (math.max(0, v4.endTime - v4.startTime))
			end,
			getTimeLength = function(p2)
				local v3 = signal7(p2)

				if v3 == nil then
					return signal3(p2)
				end

				return v3.getState(p2).timeLength
			end,
			getRegion = function(p2)
				if callback == nil then
					return nil
				end

				return (callback(p2))
			end,
			getMusic = function(p2)
				if callback2 == nil then
					return nil
				end

				return (callback2(p2))
			end,
			getIsPlaying = function(p2)
				local v3 = signal7(p2)

				if v3 == nil then
					return signal4(p2)
				end

				return v3.getState(p2).isPlaying
			end,
			getIsMuted = function(p2)
				local v3 = signal7(p2)

				if v3 == nil then
					return signal5(p2)
				end

				return v3.getState(p2).isMuted
			end,
			play = play,
			pause = pause,
			toggle = toggle,
			seek = seek,
			setMuted = setMuted,
			toggleMute = toggleMute
		},
		setMediaController = setMediaController,
		setRegion = function(p2)
			local v3 = signal7(false)

			if v3 ~= nil then
				v3.setRegion(p2)
			end
		end,
		bindEngine = bindEngine,
		setPosition = setPosition,
		setDuration = setDuration,
		setTimeLength = setTimeLength,
		setIsPlaying = setIsPlaying,
		setReadiness = setReadiness
	}
end

return createCapturePreviewController

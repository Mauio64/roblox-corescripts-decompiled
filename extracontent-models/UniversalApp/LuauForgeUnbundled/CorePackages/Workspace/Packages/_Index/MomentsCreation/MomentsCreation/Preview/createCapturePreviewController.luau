local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local createSignal = Signals.createSignal

local function createCapturePreviewController(p2, callback, callback2)
	local signal, v5 = createSignal(0)
	local signal2, v6 = createSignal(0)
	local signal3, v7 = createSignal(0)
	local signal4, v8 = createSignal(true)
	local signal5, v9 = createSignal(false)
	local signal6, v10 = createSignal("Loading")

	local signal7, v11 = createSignal(nil)

	local v12 = nil

	local function bindEngine(p3)
		v12 = p3

		if p3 ~= nil then
			if signal4(false) then
				p3.play()
			else
				p3.pause()
			end
		end
	end

	local function play()
		local v13 = signal7(false)

		if v13 == nil then
			if signal4(false) then
				return
			end

			v8(true)

			if v12 ~= nil then
				v12.play()
			end
		elseif not v13.getState(false).isPlaying then
			v13.play()
		end
	end

	local function pause()
		local v13 = signal7(false)

		if v13 ~= nil then
			v13.pause()
			return
		end

		if not signal4(false) then
			return
		end

		v8(false)

		if v12 ~= nil then
			v12.pause()
		end
	end

	local function toggle()
		local v13 = signal7(false)

		if v13 ~= nil then
			v13.toggle()
		elseif signal4(false) then
			local v14 = signal7(false)

			if v14 ~= nil then
				v14.pause()
				return
			end

			if not signal4(false) then
				return
			end

			v8(false)

			if v12 ~= nil then
				v12.pause()
			end
		else
			play()
		end
	end

	local function setMuted(p3)
		local v13 = signal7(false)

		if v13 ~= nil then
			v13.audio.setMasterMuted(p3)
			return
		end

		v9(p3)

		if v12 ~= nil and v12.setMuted ~= nil then
			v12.setMuted(p3)
		end
	end

	local function toggleMute()
		local v13 = signal7(false)
		local v15 = not (if v13 == nil then signal5(false) else v13.getState(false).isMuted)

		local v16 = signal7(false)

		if v16 ~= nil then
			v16.audio.setMasterMuted(v15)
			return
		end

		v9(v15)

		if v12 ~= nil and v12.setMuted ~= nil then
			v12.setMuted(v15)
		end
	end

	local function seek(p3)
		local v13 = signal7(false)

		if v13 ~= nil then
			v13.seek(p3)
			return
		end

		local v14 = if callback ~= nil then callback(false) else nil

		local v15 = p3 + (v14 == nil and 0 or v14.startTime)
		v5(v15)

		if v12 ~= nil then
			v12.seek(v15)
		end
	end

	return {
		getCapture = p2.getSelectedCapture,
		getReadiness = function(p3)
			local v13 = signal7(p3)

			if v13 == nil then
				return signal6(p3)
			end

			return v13.getState(p3).readiness
		end,
		playback = {
			getPosition = function(p3)
				local v13 = signal7(p3)

				if v13 ~= nil then
					return v13.getPosition(p3)
				end

				local v14 = if callback ~= nil then callback(p3) else nil

				if v14 == nil then
					return signal(p3)
				end

				local v15 = math.max(0, v14.endTime - v14.startTime)
				return (math.clamp(signal(p3) - v14.startTime, 0, v15))
			end,
			getDuration = function(p3)
				local v13 = signal7(p3)

				if v13 ~= nil then
					return v13.getState(p3).duration
				end

				local v14 = if callback ~= nil then callback(p3) else nil

				if v14 == nil then
					return signal2(p3)
				end

				return (math.max(0, v14.endTime - v14.startTime))
			end,
			getTimeLength = function(p3)
				local v13 = signal7(p3)

				if v13 == nil then
					return signal3(p3)
				end

				return v13.getState(p3).timeLength
			end,
			getRegion = function(p3)
				if callback == nil then
					return nil
				end

				return (callback(p3))
			end,
			getMusic = function(p3)
				if callback2 == nil then
					return nil
				end

				return (callback2(p3))
			end,
			getIsPlaying = function(p3)
				local v13 = signal7(p3)

				if v13 == nil then
					return signal4(p3)
				end

				return v13.getState(p3).isPlaying
			end,
			getIsMuted = function(p3)
				local v13 = signal7(p3)

				if v13 == nil then
					return signal5(p3)
				end

				return v13.getState(p3).isMuted
			end,
			play = play,
			pause = pause,
			toggle = toggle,
			seek = seek,
			setMuted = setMuted,
			toggleMute = toggleMute
		},
		setMediaController = v11,
		setRegion = function(p3)
			local v13 = signal7(false)

			if v13 ~= nil then
				v13.setRegion(p3)
			end
		end,
		bindEngine = bindEngine,
		setPosition = v5,
		setDuration = v6,
		setTimeLength = v7,
		setIsPlaying = v8,
		setReadiness = v10
	}
end

return createCapturePreviewController

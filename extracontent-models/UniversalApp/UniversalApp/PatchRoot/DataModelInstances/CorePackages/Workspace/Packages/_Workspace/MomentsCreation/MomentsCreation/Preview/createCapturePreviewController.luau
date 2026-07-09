local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Signals = require(MomentsCreationParent.Signals)

require(MomentsCreation.Types.CreationFlowTypes)

local createSignal = Signals.createSignal

local function createCapturePreviewController(t1: {[any]: any}, p1, p2) -- line: 63
	-- upvalues: createSignal (copy)
	local v9, v10 = createSignal(0)
	local v11, v12 = createSignal(0)
	local v13, v14 = createSignal(0)
	local v15, v16 = createSignal(true)
	local v17, v18 = createSignal(false)
	local v19, v20 = createSignal("Loading")
	local v21, v22 = createSignal(nil)
	local u23 = nil

	local function play() -- line: 168
		-- upvalues: v21 (copy), v15 (copy), v16 (copy), u23 (ref)
		local v43 = v21(false)

		if v43 ~= nil then
			if not v43.getState(false).isPlaying then
				v43.play()
			end

			return
		end

		if v15(false) then
			return
		end

		v16(true)

		if u23 ~= nil then
			u23.play()
		end
	end

	return {
		getCapture = t1.getSelectedCapture,
		getReadiness = function(p3) -- line: 160
			-- upvalues: v21 (copy), v19 (copy)
			local v42 = v21(p3)

			if v42 ~= nil then
				return v42.getState(p3).readiness
			end

			return v19(p3)
		end,
		playback = {
			getPosition = function(p4) -- line: 131
				-- upvalues: v21 (copy), p1 (copy), v9 (copy)
				local v34 = v21(p4)

				if v34 ~= nil then
					return v34.getPosition(p4)
				end

				local v35 = if p1 == nil then nil else p1(p4)

				if v35 ~= nil then
					local v36 = math.max(0, v35.endTime - v35.startTime)

					return (math.clamp(v9(p4) - v35.startTime, 0, v36))
				end

				return v9(p4)
			end,
			getDuration = function(p5) -- line: 108
				-- upvalues: v21 (copy), p1 (copy), v11 (copy)
				local v29 = v21(p5)

				if v29 ~= nil then
					return v29.getState(p5).duration
				end

				local v30 = if p1 == nil then nil else p1(p5)

				if v30 ~= nil then
					return (math.max(0, v30.endTime - v30.startTime))
				end

				return v11(p5)
			end,
			getTimeLength = function(p6) -- line: 121
				-- upvalues: v21 (copy), v13 (copy)
				local v32 = v21(p6)

				if v32 ~= nil then
					return v32.getState(p6).timeLength
				end

				return v13(p6)
			end,
			getRegion = function(p7) -- line: 97
				-- upvalues: p1 (copy)
				if p1 ~= nil then
					return (p1(p7))
				end

				return nil
			end,
			getMusic = function(p8) -- line: 102
				-- upvalues: p2 (copy)
				if p2 ~= nil then
					return (p2(p8))
				end

				return nil
			end,
			getIsPlaying = function(p9) -- line: 144
				-- upvalues: v21 (copy), v15 (copy)
				local v38 = v21(p9)

				if v38 ~= nil then
					return v38.getState(p9).isPlaying
				end

				return v15(p9)
			end,
			getIsMuted = function(p10) -- line: 152
				-- upvalues: v21 (copy), v17 (copy)
				local v40 = v21(p10)

				if v40 ~= nil then
					return v40.getState(p10).isMuted
				end

				return v17(p10)
			end,
			play = play,
			pause = function() -- line: 187
				-- upvalues: v21 (copy), v15 (copy), v16 (copy), u23 (ref)
				local v44 = v21(false)

				if v44 ~= nil then
					v44.pause()

					return
				end

				if not v15(false) then
					return
				end

				v16(false)

				if u23 ~= nil then
					u23.pause()
				end
			end,
			toggle = function() -- line: 202
				-- upvalues: v21 (copy), v15 (copy), v16 (copy), u23 (ref), play (copy)
				local v45 = v21(false)

				if v45 ~= nil then
					v45.toggle()

					return
				end

				if v15(false) then
					local v46 = v21(false)

					if v46 ~= nil then
						v46.pause()

						return
					end

					if not v15(false) then
						return
					end

					v16(false)

					if u23 ~= nil then
						u23.pause()

						return
					end
				else
					play()
				end
			end,
			seek = function(n1: number) -- line: 231
				-- upvalues: v21 (copy), p1 (copy), v10 (copy), u23 (ref)
				local v53 = v21(false)

				if v53 ~= nil then
					v53.seek(n1)

					return
				end

				local v54 = if p1 == nil then nil else p1(false)
				local v55 = n1 + (v54 == nil and 0 or v54.startTime)

				v10(v55)

				if u23 ~= nil then
					u23.seek(v55)
				end
			end,
			setMuted = function(b1: boolean) -- line: 215
				-- upvalues: v21 (copy), v18 (copy), u23 (ref)
				local v48 = v21(false)

				if v48 ~= nil then
					v48.audio.setMasterMuted(b1)

					return
				end

				v18(b1)

				if u23 ~= nil and u23.setMuted ~= nil then
					u23.setMuted(b1)
				end
			end,
			toggleMute = function() -- line: 227
				-- upvalues: v21 (copy), v17 (copy), v18 (copy), u23 (ref)
				local v49 = v21(false)
				local v50 = not if v49 == nil then v17(false) else v49.getState(false).isMuted
				local v51 = v21(false)

				if v51 ~= nil then
					v51.audio.setMasterMuted(v50)

					return
				end

				v18(v50)

				if u23 ~= nil and u23.setMuted ~= nil then
					u23.setMuted(v50)
				end
			end
		},
		setMediaController = v22,
		setRegion = function(t2: {[any]: any}?) -- line: 252
			-- upvalues: v21 (copy)
			local v57 = v21(false)

			if v57 ~= nil then
				v57.setRegion(t2)
			end
		end,
		bindEngine = function(t3: {[any]: any}?) -- line: 85
			-- upvalues: u23 (ref), v15 (copy)
			u23 = t3

			if t3 ~= nil then
				if v15(false) then
					t3.play()

					return
				end

				t3.pause()
			end
		end,
		setPosition = v10,
		setDuration = v12,
		setTimeLength = v14,
		setIsPlaying = v16,
		setReadiness = v20
	}
end

return createCapturePreviewController

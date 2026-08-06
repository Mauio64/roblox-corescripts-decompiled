local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Signals = require(MomentsCommonParent.Signals)
local FFlagMomentsAutoplayAmpPolicy = require(MomentsCommonParent.SharedFlags).FFlagMomentsAutoplayAmpPolicy

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.Preload.selectPreloadPolicy)
require(MomentsCommon.Media.Telemetry.mediaTelemetry)

local createMomentMediaController = require(MomentsCommon.Media.createMomentMediaController)
local defaultMediaNodeRegistry = require(MomentsCommon.Media.defaultMediaNodeRegistry)

require(MomentsCommon.Media.mediaNodeRegistry)

local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

local function indexInWindow(n1: number, n2: number, p1) -- line: 88
	return n1 >= n2 - p1.back and n1 <= n2 + p1.forward
end
local function createMediaPreloadCoordinator(p2, p3, p4, p5, p6, t1: {[any]: any}?) -- line: 92
	-- upvalues: defaultMediaNodeRegistry (copy), createMomentMediaController (copy), createSignal (copy), FFlagMomentsAutoplayAmpPolicy (copy), createEffect (copy)
	local v20 = t1 or {}
	local v21 = p6.now or os.clock
	local v22 = v20.registry or defaultMediaNodeRegistry()
	local v23 = v20.createController or function(p7) -- line: 107
		-- upvalues: createMomentMediaController (copy), p6 (copy), p5 (copy), v22 (copy), v20 (copy)
		return createMomentMediaController(p7, {
			services = p6,
			audioDeviceOutput = p5,
			registry = v22,
			parent = v20.parent,
			masterVolume = v20.masterVolume
		})
	end
	local t2 = {}
	local u25 = nil
	local u26 = false
	local v27, v28 = createSignal({})

	local function publishControllerMap() -- line: 125
		-- upvalues: t2 (copy), v28 (copy)
		local t3 = {}

		for v34, v35 in t2 do
			t3[v34] = v35.controller
		end

		v28(t3)
	end
	local function reconcile(p8) -- line: 133
		-- upvalues: p2 (copy), FFlagMomentsAutoplayAmpPolicy (copy), p3 (copy), t2 (copy), u25 (ref), v23 (copy), u26 (ref), v28 (copy), v21 (copy), p4 (copy)
		local v37 = p2.getItems(p8)
		local v38 = p2.getActiveIndex(p8)
		local v39 = p2.getPlaybackActive(p8)
		local v40 = if not FFlagMomentsAutoplayAmpPolicy then nil else p2.getCanAutoPlay(p8)
		local v41 = v37[v38]
		local v42 = if v41 == nil then nil else v41.momentId
		local t4 = {}
		local t5 = {}
		local t6 = {}

		for v46, v47 in v37 do
			local downloadWindow = p3.downloadWindow

			if v46 >= v38 - downloadWindow.back and v46 <= v38 + downloadWindow.forward then
				t4[v47.momentId] = true
				t6[v47.momentId] = v47

				local decodeWindow = p3.decodeWindow

				if v46 >= v38 - decodeWindow.back and v46 <= v38 + decodeWindow.forward then
					t5[v47.momentId] = true
				end
			end
		end

		local v50 = false

		for v51, v52 in t2 do
			if not t4[v51] then
				if v51 == u25 then
					u25 = nil
				end

				v52.controller.dispose()
				t2[v51] = nil
				v50 = true
			end
		end

		for v53 in t4 do
			if t2[v53] == nil then
				local v54 = v23(t6[v53])
				local t7 = {
					active = nil,
					decoded = false,
					recordedTtff = false,
					decodeStartedAt = nil,
					controller = v54
				}

				t2[v53] = t7
				v50 = true
				task.spawn(function() -- line: 189
					-- upvalues: u26 (ref), t2 (copy), v53 (copy), t7 (copy), v54 (copy)
					if u26 or t2[v53] ~= t7 then
						return
					end

					v54.download()
				end)
			end
		end

		if v50 then
			local t8 = {}

			for v57, v58 in t2 do
				t8[v57] = v58.controller
			end

			v28(t8)
		end

		for v59, v60 in t2 do
			local v61 = t5[v59] == true

			if v61 and not v60.decoded then
				v60.decodeStartedAt = v21()
				v60.controller.decode()
				v60.decoded = true
			elseif not v61 and v60.decoded then
				v60.controller.releaseDecoder()
				v60.decoded = false
			end
		end

		for v62, v63 in t2 do
			local v64 = v62 == v42

			if v64 ~= v63.active then
				v63.controller.setActive(v64)
				v63.active = v64
			end
		end

		local v65 = if v42 == nil then nil else t2[v42]
		local v66 = v65 ~= nil and v65.controller.getState(p8).readiness == "Ready"

		if FFlagMomentsAutoplayAmpPolicy then
			if u25 ~= nil and v42 ~= u25 then
				if t2[u25] ~= nil then
					t2[u25].controller.pause()
				end

				u25 = nil
			end

			if v65 ~= nil and v65.controller.getState(p8).isPlaying then
				u25 = v42
			end
		end

		if v39 and v65 ~= nil and v66 then
			if (not FFlagMomentsAutoplayAmpPolicy or v40) and v42 ~= u25 then
				if u25 ~= nil and t2[u25] ~= nil then
					t2[u25].controller.pause()
				end

				u25 = v42
				v65.controller.play()

				if not v65.recordedTtff then
					v65.recordedTtff = true

					local decodeStartedAt = v65.decodeStartedAt

					if decodeStartedAt ~= nil and v42 ~= nil then
						p4.recordTimeToFirstFrame({
							momentId = v42,
							durationSeconds = v21() - decodeStartedAt
						})

						return
					end
				end
			end
		elseif u25 ~= nil then
			if t2[u25] ~= nil then
				t2[u25].controller.pause()
			end

			u25 = nil
		end
	end

	local v31 = createEffect(function(p9) -- line: 280
		-- upvalues: u26 (ref), reconcile (copy)
		if u26 then
			return
		end

		reconcile(p9)
	end)

	return {
		getControllerFor = function(s1: string) -- line: 287
			-- upvalues: t2 (copy)
			local v70 = t2[s1]

			if v70 ~= nil then
				return v70.controller
			end

			return nil
		end,
		getControllerMap = v27,
		dispose = function() -- line: 292
			-- upvalues: u26 (ref), v31 (copy), t2 (copy), u25 (ref), v28 (copy)
			if u26 then
				return
			end

			u26 = true
			v31()

			for _, v72 in t2 do
				v72.controller.dispose()
			end

			table.clear(t2)
			u25 = nil
			v28({})
		end
	}
end

return createMediaPreloadCoordinator

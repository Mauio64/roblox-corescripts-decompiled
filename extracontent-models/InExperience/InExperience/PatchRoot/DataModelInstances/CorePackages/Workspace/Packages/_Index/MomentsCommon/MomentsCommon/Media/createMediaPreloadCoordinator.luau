local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Signals = require(MomentsCommonParent.Signals)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.Preload.selectPreloadPolicy)
require(MomentsCommon.Media.Telemetry.mediaTelemetry)

local createMomentMediaController = require(MomentsCommon.Media.createMomentMediaController)
local defaultMediaNodeRegistry = require(MomentsCommon.Media.defaultMediaNodeRegistry)

require(MomentsCommon.Media.mediaNodeRegistry)

local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

local function indexInWindow(n1: number, n2: number, p1) -- line: 85
	return n1 >= n2 - p1.back and n1 <= n2 + p1.forward
end
local function createMediaPreloadCoordinator(p2, p3, p4, p5, p6, t1: {[any]: any}?) -- line: 89
	-- upvalues: defaultMediaNodeRegistry (copy), createMomentMediaController (copy), createSignal (copy), createEffect (copy)
	local v19 = t1 or {}
	local v20 = p6.now or os.clock
	local v21 = v19.registry or defaultMediaNodeRegistry()
	local v22 = v19.createController or function(p7) -- line: 104
		-- upvalues: createMomentMediaController (copy), p6 (copy), p5 (copy), v21 (copy), v19 (copy)
		return createMomentMediaController(p7, {
			services = p6,
			audioDeviceOutput = p5,
			registry = v21,
			parent = v19.parent,
			masterVolume = v19.masterVolume
		})
	end
	local t2 = {}
	local u24 = nil
	local u25 = false
	local v26, v27 = createSignal({})

	local function publishControllerMap() -- line: 122
		-- upvalues: t2 (copy), v27 (copy)
		local t3 = {}

		for v33, v34 in t2 do
			t3[v33] = v34.controller
		end

		v27(t3)
	end
	local function reconcile(p8) -- line: 130
		-- upvalues: p2 (copy), p3 (copy), t2 (copy), u24 (ref), v22 (copy), u25 (ref), v27 (copy), v20 (copy), p4 (copy)
		local v36 = p2.getItems(p8)
		local v37 = p2.getActiveIndex(p8)
		local v38 = p2.getPlaybackActive(p8)
		local v39 = v36[v37]
		local v40 = if v39 == nil then nil else v39.momentId
		local t4 = {}
		local t5 = {}
		local t6 = {}

		for v44, v45 in v36 do
			local downloadWindow = p3.downloadWindow

			if v44 >= v37 - downloadWindow.back and v44 <= v37 + downloadWindow.forward then
				t4[v45.momentId] = true
				t6[v45.momentId] = v45

				local decodeWindow = p3.decodeWindow

				if v44 >= v37 - decodeWindow.back and v44 <= v37 + decodeWindow.forward then
					t5[v45.momentId] = true
				end
			end
		end

		local v48 = false

		for v49, v50 in t2 do
			if not t4[v49] then
				if v49 == u24 then
					u24 = nil
				end

				v50.controller.dispose()
				t2[v49] = nil
				v48 = true
			end
		end

		for v51 in t4 do
			if t2[v51] == nil then
				local v52 = v22(t6[v51])
				local t7 = {
					active = nil,
					decoded = false,
					recordedTtff = false,
					decodeStartedAt = nil,
					controller = v52
				}

				t2[v51] = t7
				v48 = true
				task.spawn(function() -- line: 185
					-- upvalues: u25 (ref), t2 (copy), v51 (copy), t7 (copy), v52 (copy)
					if u25 or t2[v51] ~= t7 then
						return
					end

					v52.download()
				end)
			end
		end

		if v48 then
			local t8 = {}

			for v55, v56 in t2 do
				t8[v55] = v56.controller
			end

			v27(t8)
		end

		for v57, v58 in t2 do
			local v59 = t5[v57] == true

			if v59 and not v58.decoded then
				v58.decodeStartedAt = v20()
				v58.controller.decode()
				v58.decoded = true
			elseif not v59 and v58.decoded then
				v58.controller.releaseDecoder()
				v58.decoded = false
			end
		end

		for v60, v61 in t2 do
			local v62 = v60 == v40

			if v62 ~= v61.active then
				v61.controller.setActive(v62)
				v61.active = v62
			end
		end

		local v63 = if v40 == nil then nil else t2[v40]
		local v64 = v63 ~= nil and v63.controller.getState(p8).readiness == "Ready"

		if v38 and v63 ~= nil and v64 then
			if v40 ~= u24 then
				if u24 ~= nil and t2[u24] ~= nil then
					t2[u24].controller.pause()
				end

				u24 = v40
				v63.controller.play()

				if not v63.recordedTtff then
					v63.recordedTtff = true

					local decodeStartedAt = v63.decodeStartedAt

					if decodeStartedAt ~= nil and v40 ~= nil then
						p4.recordTimeToFirstFrame({
							momentId = v40,
							durationSeconds = v20() - decodeStartedAt
						})

						return
					end
				end
			end
		elseif u24 ~= nil then
			if t2[u24] ~= nil then
				t2[u24].controller.pause()
			end

			u24 = nil
		end
	end

	local v30 = createEffect(function(p9) -- line: 259
		-- upvalues: u25 (ref), reconcile (copy)
		if u25 then
			return
		end

		reconcile(p9)
	end)

	return {
		getControllerFor = function(s1: string) -- line: 266
			-- upvalues: t2 (copy)
			local v68 = t2[s1]

			if v68 ~= nil then
				return v68.controller
			end

			return nil
		end,
		getControllerMap = v26,
		dispose = function() -- line: 271
			-- upvalues: u25 (ref), v30 (copy), t2 (copy), u24 (ref), v27 (copy)
			if u25 then
				return
			end

			u25 = true
			v30()

			for _, v70 in t2 do
				v70.controller.dispose()
			end

			table.clear(t2)
			u24 = nil
			v27({})
		end
	}
end

return createMediaPreloadCoordinator

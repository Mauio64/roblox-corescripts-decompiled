local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.Preload.selectPreloadPolicy)
require(MomentsCommon.Media.Telemetry.mediaTelemetry)
local createMomentMediaController = require(MomentsCommon.Media.createMomentMediaController)
local defaultMediaNodeRegistry = require(MomentsCommon.Media.defaultMediaNodeRegistry)
require(MomentsCommon.Media.mediaNodeRegistry)
local GetFFlagMomentsRenderPostAssets = require(MomentsCommon.Flags.GetFFlagMomentsRenderPostAssets)

local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

local function indexInWindow(k: number, activeIndex: number, p): boolean -- 2 equivalent calls inferred from this helper
	return activeIndex - p.back <= k and k <= activeIndex + p.forward
end

local function createMediaPreloadCoordinator(data, data2, p, audioDeviceOutput, services, options)
	local v = options or {}
	local fFlagMomentsRenderPostAssets = GetFFlagMomentsRenderPostAssets()
	local now = services.now or os.clock

	local registry = v.registry or defaultMediaNodeRegistry()

	local createController = v.createController or function(p2)
		return createMomentMediaController(p2, {
			services = services,
			audioDeviceOutput = audioDeviceOutput,
			registry = registry,
			parent = v.parent,
			masterVolume = v.masterVolume
		})
	end

	local v2 = {}

	local v3 = nil

	local v4 = nil
	local flag = false

	local signal, v5 = createSignal({})

	local function publishControllerMap() -- 1 equivalent call inferred from this helper
		local controllers = {}

		for k, v6 in v2 do
			controllers[k] = v6.controller
		end

		v5(controllers)
	end

	local function scheduleDecodeRetry(p2: string, state)
		if state.retryScheduled or state.decodeRetries >= data2.maxDecodeRetries then
			return
		end

		state.retryScheduled = true
		task.delay(data2.decodeRetryDelayMs / 1000, function()
			state.retryScheduled = false

			if flag or v2[p2] ~= state or v4 ~= p2 or not state.decoded then
				return
			end

			if not data.getPlaybackActive(false) then
				return
			end

			local readiness = state.controller.getState(false).readiness

			if readiness == "Ready" or readiness == "Failed" then
				return
			end

			state.decodeRetries += 1

			state.controller.releaseDecoder()
			state.controller.decode()
			scheduleDecodeRetry(p2, state)
		end)
	end

	local function reconcile(p2)
		local items = data.getItems(p2)
		local activeIndex = data.getActiveIndex(p2)
		local playbackActive = data.getPlaybackActive(p2)
		local v6

		if FFlagMomentsAutoplayAmpPolicy then
			v6 = data.getCanAutoPlay(p2)
		end

		local item = items[activeIndex]
		local momentId

		if item ~= nil then
			momentId = item.momentId
		end

		v4 = momentId

		local momentIdSet = {}

		local values = {}
		local momentIdSet2 = {}

		for k, resolved in items do
			if not indexInWindow(k, activeIndex, data2.downloadWindow) then -- inferred equivalent call
				continue
			end

			resolved = fFlagMomentsRenderPostAssets and resolved.resolve ~= nil and resolved.resolve(p2) or resolved

			momentIdSet[resolved.momentId] = true
			values[resolved.momentId] = resolved

			if indexInWindow(k, activeIndex, data2.decodeWindow) then -- inferred equivalent call
				momentIdSet2[resolved.momentId] = true
			end
		end

		local flag2 = false

		for k, v7 in v2 do
			local v8 = values[k]

			if not (not momentIdSet[k] or fFlagMomentsRenderPostAssets and v8 ~= nil and v7.sourceKey ~= v8.sourceKey) then
				continue
			end

			if v3 == k then
				v3 = nil
			end

			v7.controller.dispose()
			v2[k] = nil
			flag2 = true
		end

		for k in momentIdSet do
			if v2[k] ~= nil then
				continue
			end

			local controller = createController(values[k])
			local v7 = {
				controller = controller,
				sourceKey = 0,
				active = nil,
				decoded = false,
				recordedTtff = false,
				decodeStartedAt = nil,
				decodeRetries = 0,
				retryScheduled = false
			}
			local sourceKey

			if fFlagMomentsRenderPostAssets then
				sourceKey = values[k].sourceKey
			end

			v7.sourceKey = sourceKey

			v2[k] = v7

			task.spawn(function()
				if flag or v2[k] ~= v7 then
					return
				end

				controller.download()

				if not flag and v2[k] == v7 then
					local v8 = k
					local v9 = v7

					if not v9.retryScheduled then
						if v9.decodeRetries >= data2.maxDecodeRetries then
							return
						end

						v9.retryScheduled = true
						task.delay(data2.decodeRetryDelayMs / 1000, function()
							v9.retryScheduled = false

							if flag or v2[v8] ~= v9 or v4 ~= v8 or not v9.decoded then
								return
							end

							if not data.getPlaybackActive(false) then
								return
							end

							local readiness = v9.controller.getState(false).readiness

							if readiness == "Ready" or readiness == "Failed" then
								return
							end

							v9.decodeRetries += 1

							v9.controller.releaseDecoder()
							v9.controller.decode()
							scheduleDecodeRetry(v8, v9)
						end)
					end
				end
			end)
			flag2 = true
		end

		if flag2 then
			publishControllerMap() -- inferred equivalent call
		end

		for k, v7 in v2 do
			local v8 = momentIdSet2[k] == true

			if v8 and not v7.decoded then
				v7.decodeStartedAt = now()
				v7.controller.decode()
				v7.decoded = true
			elseif not v8 and v7.decoded then
				v7.controller.releaseDecoder()
				v7.decoded = false
			end
		end

		for k, v7 in v2 do
			local active = k == momentId

			if v7.active == active then
				continue
			end

			v7.controller.setActive(active)
			v7.active = active
		end

		local v7

		if momentId ~= nil then
			v7 = v2[momentId]
		end

		local v8

		if v7 == nil then
			v8 = false
		else
			v8 = v7.controller.getState(p2).readiness == "Ready"
		end

		if FFlagMomentsAutoplayAmpPolicy then
			if v3 ~= nil and v3 ~= momentId then
				if v2[v3] ~= nil then
					v2[v3].controller.pause()
				end

				v3 = nil
			end

			local v9

			if v7 == nil then
				v9 = false
			else
				v9 = v7.controller.getState(p2).isPlaying
			end

			if v9 then
				v3 = momentId
			end
		end

		if playbackActive and v7 ~= nil and v8 then
			if (not FFlagMomentsAutoplayAmpPolicy or v6) and v3 ~= momentId then
				if v3 ~= nil and v2[v3] ~= nil then
					v2[v3].controller.pause()
				end

				v3 = momentId
				v7.controller.play()

				if not v7.recordedTtff then
					v7.recordedTtff = true
					local decodeStartedAt = v7.decodeStartedAt

					if decodeStartedAt ~= nil and momentId ~= nil then
						p.recordTimeToFirstFrame({
							momentId = momentId,
							durationSeconds = now() - decodeStartedAt
						})
					end
				end
			end
		elseif v3 ~= nil then
			if v2[v3] ~= nil then
				v2[v3].controller.pause()
			end

			v3 = nil
		end
	end

	local effect = createEffect(function(p2)
		if flag then
			return
		end

		reconcile(p2)
	end)

	return {
		getControllerFor = function(p2: string)
			local v6 = v2[p2]
			return if v6 ~= nil then v6.controller else nil
		end,
		getControllerMap = signal,
		dispose = function()
			if flag then
				return
			end

			flag = true
			effect()

			for _, v6 in v2 do
				v6.controller.dispose()
			end

			table.clear(v2)
			v3 = nil
			v5({})
		end
	}
end

return createMediaPreloadCoordinator

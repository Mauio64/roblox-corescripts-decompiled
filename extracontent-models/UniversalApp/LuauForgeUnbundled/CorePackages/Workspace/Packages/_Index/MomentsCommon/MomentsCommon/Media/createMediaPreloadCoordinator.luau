local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local fFlagMomentsAutoplayAmpPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags").FFlagMomentsAutoplayAmpPolicy

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/selectPreloadPolicy")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Telemetry/mediaTelemetry")
local createMomentMediaController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/createMomentMediaController")
local defaultMediaNodeRegistry = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/defaultMediaNodeRegistry")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsRenderPostAssets")

local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

local function indexInWindow(p2, p3, p4): boolean
	return p3 - p4.back <= p2 and p2 <= p3 + p4.forward
end

local function createMediaPreloadCoordinator(data, data2, p2, p3, p4, options)
	local v5 = options or {}
	local v6 = GetFFlagMomentsRenderPostAssets()
	local now = p4.now or os.clock

	local registry = v5.registry or defaultMediaNodeRegistry()

	local createController = v5.createController or function(p5)
		return createMomentMediaController(p5, {
			services = p4,
			audioDeviceOutput = p3,
			registry = registry,
			parent = v5.parent,
			masterVolume = v5.masterVolume
		})
	end

	local v7 = {}

	local v8 = nil

	local v9 = nil
	local flag = false

	local signal, v10 = createSignal({})

	local function publishControllerMap()
		local controllers = {}

		for k, v11 in v7 do
			controllers[k] = v11.controller
		end

		v10(controllers)
	end

	local function scheduleDecodeRetry(p5, state)
		if state.retryScheduled or state.decodeRetries >= data2.maxDecodeRetries then
			return
		end

		state.retryScheduled = true
		task.delay(data2.decodeRetryDelayMs / 1000, function()
			state.retryScheduled = false

			if flag or v7[p5] ~= state or v9 ~= p5 or not state.decoded then
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
			scheduleDecodeRetry(p5, state)
		end)
	end

	local function reconcile(p5)
		local items = data.getItems(p5)
		local activeIndex = data.getActiveIndex(p5)
		local playbackActive = data.getPlaybackActive(p5)
		local v11 = if fFlagMomentsAutoplayAmpPolicy then data.getCanAutoPlay(p5) else nil

		local item = items[activeIndex]
		local momentId = if item ~= nil then item.momentId else nil
		v9 = momentId

		local momentIdSet = {}

		local values = {}
		local momentIdSet2 = {}

		for k, resolved in items do
			local downloadWindow = data2.downloadWindow
			local v12 = activeIndex - downloadWindow.back <= k and k <= activeIndex + downloadWindow.forward

			if not v12 then
				continue
			end

			resolved = v6 and resolved.resolve ~= nil and resolved.resolve(p5) or resolved

			momentIdSet[resolved.momentId] = true
			values[resolved.momentId] = resolved
			local decodeWindow = data2.decodeWindow
			local v13 = activeIndex - decodeWindow.back <= k and k <= activeIndex + decodeWindow.forward

			if v13 then
				momentIdSet2[resolved.momentId] = true
			end
		end

		local flag2 = false

		for k, v12 in v7 do
			local v13 = values[k]

			if not (not momentIdSet[k] or v6 and v13 ~= nil and v12.sourceKey ~= v13.sourceKey) then
				continue
			end

			if v8 == k then
				v8 = nil
			end

			v12.controller.dispose()
			v7[k] = nil
			flag2 = true
		end

		for k in momentIdSet do
			if v7[k] ~= nil then
				continue
			end

			local controller = createController(values[k])
			local v12 = {
				controller = controller,
				sourceKey = 0,
				active = nil,
				decoded = false,
				recordedTtff = false,
				decodeStartedAt = nil,
				decodeRetries = 0,
				retryScheduled = false
			}

			local v13 = if v6 then values[k].sourceKey else nil
			v12.sourceKey = v13

			v7[k] = v12

			task.spawn(function()
				if flag or v7[k] ~= v12 then
					return
				end

				controller.download()

				if not flag and v7[k] == v12 then
					local v14 = k
					local v15 = v12

					if not v15.retryScheduled then
						if v15.decodeRetries >= data2.maxDecodeRetries then
							return
						end

						v15.retryScheduled = true
						task.delay(data2.decodeRetryDelayMs / 1000, function()
							v15.retryScheduled = false

							if flag or v7[v14] ~= v15 or v9 ~= v14 or not v15.decoded then
								return
							end

							if not data.getPlaybackActive(false) then
								return
							end

							local readiness = v15.controller.getState(false).readiness

							if readiness == "Ready" or readiness == "Failed" then
								return
							end

							v15.decodeRetries += 1

							v15.controller.releaseDecoder()
							v15.controller.decode()
							scheduleDecodeRetry(v14, v15)
						end)
					end
				end
			end)
			flag2 = true
		end

		if flag2 then
			local controllers = {}

			for k, v12 in v7 do
				controllers[k] = v12.controller
			end

			v10(controllers)
		end

		for k, v12 in v7 do
			local v13 = momentIdSet2[k] == true

			if v13 and not v12.decoded then
				v12.decodeStartedAt = now()
				v12.controller.decode()
				v12.decoded = true
			elseif not v13 and v12.decoded then
				v12.controller.releaseDecoder()
				v12.decoded = false
			end
		end

		for k, v12 in v7 do
			local v13 = k == momentId

			if v12.active == v13 then
				continue
			end

			v12.controller.setActive(v13)
			v12.active = v13
		end

		local v12 = if momentId ~= nil then v7[momentId] else nil
		local v13 = not (v12 == nil) and v12.controller.getState(p5).readiness == "Ready"

		if fFlagMomentsAutoplayAmpPolicy then
			if v8 ~= nil and v8 ~= momentId then
				if v7[v8] ~= nil then
					v7[v8].controller.pause()
				end

				v8 = nil
			end

			local v14 = not (v12 == nil) and v12.controller.getState(p5).isPlaying

			if v14 then
				v8 = momentId
			end
		end

		if playbackActive and v12 ~= nil and v13 then
			if (not fFlagMomentsAutoplayAmpPolicy or v11) and v8 ~= momentId then
				if v8 ~= nil and v7[v8] ~= nil then
					v7[v8].controller.pause()
				end

				v8 = momentId
				v12.controller.play()

				if not v12.recordedTtff then
					v12.recordedTtff = true
					local decodeStartedAt = v12.decodeStartedAt

					if decodeStartedAt ~= nil and momentId ~= nil then
						p2.recordTimeToFirstFrame({
							momentId = momentId,
							durationSeconds = now() - decodeStartedAt
						})
					end
				end
			end
		elseif v8 ~= nil then
			if v7[v8] ~= nil then
				v7[v8].controller.pause()
			end

			v8 = nil
		end
	end

	local effect = createEffect(function(p5)
		if flag then
			return
		end

		reconcile(p5)
	end)

	return {
		getControllerFor = function(p5)
			local v11 = v7[p5]

			if v11 == nil then
				return nil
			end

			return v11.controller
		end,
		getControllerMap = signal,
		dispose = function()
			if flag then
				return
			end

			flag = true
			effect()

			for k, v11 in v7 do
				v11.controller.dispose()
			end

			table.clear(v7)
			v8 = nil
			v10({})
		end
	}
end

return createMediaPreloadCoordinator

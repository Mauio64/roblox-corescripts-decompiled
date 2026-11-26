local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/HttpClient")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local createMomentsUsageHeartbeat = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/createMomentsUsageHeartbeat")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")

local FIntMomentsUsageHeartbeatIntervalSec = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FIntMomentsUsageHeartbeatIntervalSec")
local FIntMomentsUsageResumePollSec = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FIntMomentsUsageResumePollSec")

local analytics = MomentsCommon.Analytics

local function defaultPostHeartbeat()
	local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsPostMomentsUsageHeartbeat")
	return HttpClient.asPromise(module7())
end

local function defaultGetUsage()
	local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUsage")
	return HttpClient.asPromise(module7())
end

local function defaultGetHasDailyLimit(p2)
	return MomentsCommon.Stores.GetMomentsCapabilities(false).getHasDailyLimit(p2)
end

local function defaultGetIsInExperience(p2)
	return require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")(false).getIsTeleporting(p2)
end

local function defaultLifecycleObserver()
	local success, result = pcall(function()
		return game:GetService("AppLifecycleObserverService")
	end)

	if success then
		return result
	end

	return nil
end

local function createMomentsUsageStore(options)
	local v5 = options or {}
	local postHeartbeat = v5.postHeartbeat or defaultPostHeartbeat
	local getUsage = v5.getUsage or defaultGetUsage
	local getHasDailyLimit = v5.getHasDailyLimit or defaultGetHasDailyLimit
	local getIsInExperience = v5.getIsInExperience or defaultGetIsInExperience

	local signal, v6 = Signals.createSignal(false)
	local signal2, v7 = Signals.createSignal(0)

	local v8 = false
	local v9 = true
	local v10 = false
	local v11 = false
	local flag = false

	local v12 = nil
	local v13 = nil

	local function reconcile()
		local v14 = signal(false)
		v12.setSuspended(v14 or not v8)
		local v15 = v14 and v12.getIsWatching()

		if v15 ~= v11 then
			v11 = v15

			if v15 then
				v13.start("time_limit_poll")
			else
				v13.stop()
			end
		end
	end

	local function applyUsage(p2)
		if flag then
			return
		end

		if p2.limitSeconds >= 0 and p2.remainingSeconds <= 0 then
			v7(p2.limitSeconds)
			v6(true)
			reconcile()
		elseif signal(false) then
			v6(false)
			reconcile()
		end
	end

	local function ignoreFailure() end

	local function sendHeartbeat()
		postHeartbeat():andThen(applyUsage):catch(ignoreFailure)
	end

	local function checkUsage()
		getUsage():andThen(applyUsage):catch(ignoreFailure)
	end

	v12 = createMomentsUsageHeartbeat(FIntMomentsUsageHeartbeatIntervalSec, sendHeartbeat, function(p2)
		if p2 and signal(false) then
			getUsage():andThen(applyUsage):catch(ignoreFailure)
		end
	end, v5.scheduler, v5.clock)

	v13 = analytics.createMomentsSessionHeartbeat(FIntMomentsUsageResumePollSec, function(p2)
		getUsage():andThen(applyUsage):catch(ignoreFailure)
	end, v5.scheduler)

	local function applyForeground()
		v12.setForegrounded(v9 and not v10)
		reconcile()
	end

	local effect = Signals.createEffect(function(p2)
		v8 = getHasDailyLimit(p2)
		reconcile()
	end)
	local effect2 = Signals.createEffect(function(p2)
		v10 = getIsInExperience(p2)
		v12.setForegrounded(v9 and not v10)
		reconcile()
	end)

	local function setTabFocused(p2)
		v12.setTabFocused(p2)
		reconcile()
	end

	local function setForegrounded(p2)
		v9 = p2
		v12.setForegrounded(v9 and not v10)
		reconcile()
	end

	local v14 = 0
	local function retainWatching()
		v14 += 1
		v12.setTabFocused(true)
		reconcile()

		local flag2 = false
		return function()
			if flag2 then
				return
			end

			flag2 = true
			v14 -= 1
			local v15 = v14 > 0
			v12.setTabFocused(v15)
			reconcile()
		end
	end

	local result = v5.lifecycleObserver

	if not result then
		local success
		success, result = pcall(function()
			return game:GetService("AppLifecycleObserverService")
		end)

		if not success then
			result = nil
		end
	end

	local connections = {}

	if result ~= nil then
		table.insert(connections, result.OnHide:Connect(function()
			v9 = false
			v12.setForegrounded(v9 and not v10)
			reconcile()
		end))

		table.insert(connections, result.OnUnhide:Connect(function()
			v9 = true
			v12.setForegrounded(v9 and not v10)
			reconcile()
		end))
	end

	return {
		getIsLimitReached = signal,
		getLimitSeconds = signal2,
		markLimitReached = function(p2)
			v7(p2)
			v6(true)
			reconcile()
		end,
		checkForMoreTime = function()
			if signal(false) then
				getUsage():andThen(applyUsage):catch(ignoreFailure)
			end
		end,
		setTabFocused = setTabFocused,
		setForegrounded = setForegrounded,
		retainWatching = retainWatching,
		dispose = function()
			flag = true
			effect()
			effect2()
			v12.stop()
			v13.stop()

			for k, connection in connections do
				connection:Disconnect()
			end
		end
	}
end

return createMomentsUsageStore

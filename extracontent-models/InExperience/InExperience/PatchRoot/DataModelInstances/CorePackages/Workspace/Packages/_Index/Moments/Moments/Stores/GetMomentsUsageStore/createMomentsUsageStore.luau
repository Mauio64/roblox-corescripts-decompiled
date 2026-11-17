local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local HttpClient = require(parent.HttpClient)
local MomentsCommon = require(parent.MomentsCommon)
local createMomentsUsageHeartbeat = require(parent.MomentsCommon.createMomentsUsageHeartbeat)
local Signals = require(parent.Signals)
require(parent.DataHydration.MomentsStoreTypes)

local FIntMomentsUsageHeartbeatIntervalSec = require(Moments.Flags.FIntMomentsUsageHeartbeatIntervalSec)
local FIntMomentsUsageResumePollSec = require(Moments.Flags.FIntMomentsUsageResumePollSec)

local Analytics = MomentsCommon.Analytics

local function defaultPostHeartbeat()
	local MomentsPostMomentsUsageHeartbeat = require(parent.DataHydration.MomentsPostMomentsUsageHeartbeat)
	return HttpClient.asPromise(MomentsPostMomentsUsageHeartbeat())
end

local function defaultGetUsage()
	local MomentsGetMomentsUsage = require(parent.DataHydration.MomentsGetMomentsUsage)
	return HttpClient.asPromise(MomentsGetMomentsUsage())
end

local function defaultGetHasDailyLimit(p)
	return MomentsCommon.Stores.GetMomentsCapabilities(false).getHasDailyLimit(p)
end

local function defaultGetIsInExperience(p)
	local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
	return GetMomentsPreferencesStore(false).getIsTeleporting(p)
end

local function defaultLifecycleObserver()
	local success, result = pcall(function()
		return game:GetService("AppLifecycleObserverService")
	end)
	return if success then result else nil
end

local function createMomentsUsageStore(options)
	local v = options or {}
	local postHeartbeat = v.postHeartbeat or defaultPostHeartbeat
	local getUsage = v.getUsage or defaultGetUsage
	local getHasDailyLimit = v.getHasDailyLimit or defaultGetHasDailyLimit
	local getIsInExperience = v.getIsInExperience or defaultGetIsInExperience

	local signal, v2 = Signals.createSignal(false)
	local signal2, v3 = Signals.createSignal(0)

	local v4 = false
	local v5 = true
	local v6 = false
	local v7 = false
	local flag = false

	local v8 = nil
	local v9 = nil

	local function reconcile()
		local v10 = signal(false)
		v8.setSuspended(v10 or not v4)
		local v11 = v10 and v8.getIsWatching()

		if v11 ~= v7 then
			v7 = v11

			if v11 then
				v9.start("time_limit_poll")
			else
				v9.stop()
			end
		end
	end

	local function markLimitReached(limitSeconds: number) -- 1 equivalent call inferred from this helper
		v3(limitSeconds)
		v2(true)
		reconcile()
	end

	local function applyUsage(p)
		if flag then
			return
		end

		if p.limitSeconds >= 0 and p.remainingSeconds <= 0 then
			markLimitReached(p.limitSeconds) -- inferred equivalent call
		elseif signal(false) then
			v2(false)
			reconcile()
		end
	end

	local function ignoreFailure() end

	local function sendHeartbeat()
		postHeartbeat():andThen(applyUsage):catch(ignoreFailure)
	end

	local function checkUsage() -- 3 equivalent calls inferred from this helper
		getUsage():andThen(applyUsage):catch(ignoreFailure)
	end

	v8 = createMomentsUsageHeartbeat(FIntMomentsUsageHeartbeatIntervalSec, sendHeartbeat, function(flag2: boolean)
		if flag2 and signal(false) then
			checkUsage() -- inferred equivalent call
		end
	end, v.scheduler, v.clock)

	v9 = Analytics.createMomentsSessionHeartbeat(FIntMomentsUsageResumePollSec, function(_: string)
		checkUsage() -- inferred equivalent call
	end, v.scheduler)

	local function applyForeground() -- 2 equivalent calls inferred from this helper
		v8.setForegrounded(v5 and not v6)
		reconcile()
	end

	local effect = Signals.createEffect(function(p)
		v4 = getHasDailyLimit(p)
		reconcile()
	end)
	local effect2 = Signals.createEffect(function(p)
		v6 = getIsInExperience(p)
		applyForeground() -- inferred equivalent call
	end)

	local function setTabFocused(flag2: boolean) -- 2 equivalent calls inferred from this helper
		v8.setTabFocused(flag2)
		reconcile()
	end

	local function setForegrounded(flag2: boolean) -- 2 equivalent calls inferred from this helper
		v5 = flag2
		applyForeground() -- inferred equivalent call
	end

	local v10 = 0
	local function retainWatching()
		v10 += 1
		setTabFocused(true) -- inferred equivalent call
		local flag2 = false
		return function()
			if flag2 then
				return
			end

			flag2 = true
			v10 -= 1
			setTabFocused(v10 > 0) -- inferred equivalent call
		end
	end

	local result = v.lifecycleObserver

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
			setForegrounded(false) -- inferred equivalent call
		end))

		table.insert(connections, result.OnUnhide:Connect(function()
			setForegrounded(true) -- inferred equivalent call
		end))
	end

	return {
		getIsLimitReached = signal,
		getLimitSeconds = signal2,
		markLimitReached = markLimitReached,
		checkForMoreTime = function()
			if signal(false) then
				checkUsage() -- inferred equivalent call
			end
		end,
		setTabFocused = setTabFocused,
		setForegrounded = setForegrounded,
		retainWatching = retainWatching,
		dispose = function()
			flag = true
			effect()
			effect2()
			v8.stop()
			v9.stop()

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	}
end

return createMomentsUsageStore

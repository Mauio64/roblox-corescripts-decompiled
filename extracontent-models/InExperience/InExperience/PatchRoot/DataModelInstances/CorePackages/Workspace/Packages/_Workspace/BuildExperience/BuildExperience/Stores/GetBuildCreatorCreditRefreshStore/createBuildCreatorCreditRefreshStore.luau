local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local Signals = require(parent.Signals)
local CreatorCreditConfig = require(BuildExperience.CreatorCreditConfig)

local function createBuildCreatorCreditRefreshStore(options)
	local v = options or {}
	local getCreditStore = v.getCreditStore or function()
		return CreatorCredit.getCreatorCreditStore(false)
	end

	local getUserId = v.getUserId or localUserIdStore.getCurrentUserId
	local onUnhide = v.onUnhide

	if not onUnhide then
		local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
		onUnhide = AppLifecycleObserverService.OnUnhide
	end

	local now = v.now or function()
		return DateTime.now().UnixTimestamp
	end

	local v2 = 0
	local fn = nil
	local thread = nil
	local thread2 = nil
	local thread3 = nil
	local set = {}

	local function cancelTimers() -- 2 equivalent calls inferred from this helper
		if thread then
			task.cancel(thread)
			thread = nil
		end

		if thread2 then
			task.cancel(thread2)
			thread2 = nil
		end

		if thread3 then
			task.cancel(thread3)
			thread3 = nil
		end
	end

	local function refresh() -- 2 equivalent calls inferred from this helper
		if thread then
			return
		end

		local userId = getUserId(false)
		local creditStore = getCreditStore()
		thread = task.defer(function()
			thread = nil

			if userId ~= getUserId(false) or creditStore ~= getCreditStore() then
				return
			end

			creditStore.refreshQuotaSummary():catch(function() end)
			local v3 = assert(creditStore.refreshTierQuotaSummary, "Model picker requires tier quotas")
			v3("PRODUCT_BUILD", "default")
			v3("PRODUCT_BUILD", "advanced")
		end)
	end

	return {
		acquire = function()
			v2 += 1

			if v2 == 1 then
				local creditStore = getCreditStore()
				local v3 = nil
				local effect = Signals.createEffect(function(p)
					local userId = getUserId(p)

					if userId ~= v3 then
						cancelTimers() -- inferred equivalent call
						set = {}
						v3 = userId
					end

					if thread3 then
						task.cancel(thread3)
						thread3 = nil
					end

					local unixTimestampsByNextResetEligibleTime = {}

					for _, v4 in { "default", "advanced" } do
						local data = assert(creditStore.getTierQuotaSummarySignals, "Model picker requires tier quotas")(
							"PRODUCT_BUILD",
							v4
						).data(p)
						local nextResetEligibleTime

						if data then
							nextResetEligibleTime = data.nextResetEligibleTime
						end

						if not (typeof(nextResetEligibleTime) == "string" and nextResetEligibleTime ~= "") then
							continue
						end

						local dateTime = DateTime.fromIsoDate(nextResetEligibleTime)

						if dateTime then
							unixTimestampsByNextResetEligibleTime[nextResetEligibleTime] = dateTime.UnixTimestamp
						end
					end

					local function scheduleReset()
						local v4 = nil
						local v5 = nil

						for k, v6 in unixTimestampsByNextResetEligibleTime do
							if set[k] or not (v4 == nil or v6 < v4) then
								continue
							end

							v5 = k
							v4 = v6
						end

						if v4 and v5 then
							thread3 = task.delay(
								math.max(1, v4 - now() + CreatorCreditConfig.FIntResetRefreshBufferSeconds),
								function()
									thread3 = nil
									set[v5] = true
									scheduleReset()
									refresh() -- inferred equivalent call
								end
							)
						end
					end
					scheduleReset()
				end)
				local connection = onUnhide:Connect(refresh)
				fn = function()
					connection:Disconnect()
					effect()
					cancelTimers() -- inferred equivalent call
				end
			end

			local flag = false
			return function()
				if flag then
					return
				end

				flag = true
				v2 -= 1

				if v2 == 0 and fn then
					fn()
					fn = nil
				end
			end
		end,
		refresh = refresh,
		settled = function()
			if thread2 then
				task.cancel(thread2)
			end

			local userId = getUserId(false)
			thread2 = task.delay(CreatorCreditConfig.FIntPostTurnRefreshDelaySeconds, function()
				thread2 = nil

				if userId == getUserId(false) then
					refresh() -- inferred equivalent call
				end
			end)
		end
	}
end

return createBuildCreatorCreditRefreshStore

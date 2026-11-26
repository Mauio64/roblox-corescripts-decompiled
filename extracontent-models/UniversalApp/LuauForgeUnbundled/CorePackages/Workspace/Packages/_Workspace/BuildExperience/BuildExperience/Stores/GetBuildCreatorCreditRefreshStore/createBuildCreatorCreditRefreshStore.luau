local CreatorCredit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local CreatorCreditConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/CreatorCreditConfig")

local function createBuildCreatorCreditRefreshStore(options)
	local v5 = options or {}
	local getCreditStore = v5.getCreditStore or function()
		return CreatorCredit.getCreatorCreditStore(false)
	end

	local getUserId = v5.getUserId or localUserIdStore.getCurrentUserId
	local onUnhide = v5.onUnhide

	if not onUnhide then
		local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
		onUnhide = AppLifecycleObserverService.OnUnhide
	end

	local now = v5.now or function()
		return DateTime.now().UnixTimestamp
	end

	local v6 = 0
	local fn = nil
	local thread = nil
	local thread2 = nil
	local thread3 = nil
	local set = {}

	local function cancelTimers()
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

	local function refresh()
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
			local v7 = assert(creditStore.refreshTierQuotaSummary, "Model picker requires tier quotas")
			v7("PRODUCT_BUILD", "default")
			v7("PRODUCT_BUILD", "advanced")
		end)
	end

	return {
		acquire = function()
			v6 += 1

			if v6 == 1 then
				local creditStore = getCreditStore()
				local v7 = nil
				local effect = Signals.createEffect(function(p2)
					local userId = getUserId(p2)

					if userId ~= v7 then
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

						set = {}
						v7 = userId
					end

					if thread3 then
						task.cancel(thread3)
						thread3 = nil
					end

					local unixTimestampsByNextResetEligibleTime = {}

					for k, v8 in { "default", "advanced" } do
						local data = assert(
							creditStore.getTierQuotaSummarySignals,
							"Model picker requires tier quotas"
						)(
							"PRODUCT_BUILD",
							v8
						).data(p2)
						local nextResetEligibleTime = if data then data.nextResetEligibleTime else nil

						if not (typeof(nextResetEligibleTime) == "string" and nextResetEligibleTime ~= "") then
							continue
						end

						local dateTime = DateTime.fromIsoDate(nextResetEligibleTime)

						if dateTime then
							unixTimestampsByNextResetEligibleTime[nextResetEligibleTime] = dateTime.UnixTimestamp
						end
					end

					local function scheduleReset()
						local v8 = nil
						local v9 = nil

						for k, v10 in unixTimestampsByNextResetEligibleTime do
							if set[k] or not (v8 == nil or v10 < v8) then
								continue
							end

							v9 = k
							v8 = v10
						end

						if v8 and v9 then
							thread3 = task.delay(
								math.max(1, v8 - now() + CreatorCreditConfig.FIntResetRefreshBufferSeconds),
								function()
									thread3 = nil
									set[v9] = true
									scheduleReset()

									if thread then
										return
									end

									local userId2 = getUserId(false)
									local creditStore2 = getCreditStore()
									thread = task.defer(function()
										thread = nil

										if
											userId2 ~= getUserId(false)
											or creditStore2 ~= getCreditStore()
										then
											return
										end

										creditStore2.refreshQuotaSummary():catch(function() end)
										local v10 = assert(
											creditStore2.refreshTierQuotaSummary,
											"Model picker requires tier quotas"
										)
										v10("PRODUCT_BUILD", "default")
										v10("PRODUCT_BUILD", "advanced")
									end)
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
			end

			local flag = false
			return function()
				if flag then
					return
				end

				flag = true
				v6 -= 1

				if v6 == 0 and fn then
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
					if thread then
						return
					end

					local userId2 = getUserId(false)
					local creditStore = getCreditStore()
					thread = task.defer(function()
						thread = nil

						if userId2 ~= getUserId(false) or creditStore ~= getCreditStore() then
							return
						end

						creditStore.refreshQuotaSummary():catch(function() end)
						local v7 = assert(
							creditStore.refreshTierQuotaSummary,
							"Model picker requires tier quotas"
						)
						v7("PRODUCT_BUILD", "default")
						v7("PRODUCT_BUILD", "advanced")
					end)
				end
			end)
		end
	}
end

return createBuildCreatorCreditRefreshStore

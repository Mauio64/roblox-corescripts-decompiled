local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsUtils").createSessionScopedSignal
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")
local canCreateCampaign = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils").canCreateCampaign
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local fFlagBuildAdsNotificationRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildAdsNotificationRouting

local function createAdsCampaignDeepLinkStore()
	local v5 = {}

	local sessionScopedSignal, v6 = createSessionScopedSignal(nil)

	local sessionScopedSignal2, v7 = createSessionScopedSignal("idle")
	local sessionScopedSignal3, v8 = createSessionScopedSignal(function()
		return {}
	end)

	local sessionScopedSignal4, v9 = createSessionScopedSignal(nil)

	return {
		getRequest = sessionScopedSignal,
		getStatus = sessionScopedSignal2,
		hasVisibleChat = function(p2): boolean
			for k in v5 do
				local v10 = k(false)

				if v10 ~= nil and v10.isPageVisible and v10.universeId == p2 then
					return true
				end
			end

			return false
		end,
		begin = function(p2, p3): boolean
			local v10 = sessionScopedSignal3(false)

			if v10[p2] then
				return false
			end

			local clone = table.clone(v10)
			clone[p2] = true
			v8(clone)
			v7(p3 == nil and "idle" or "pending")

			v6(p3 ~= nil and {
				id = p2,
				universeId = p3,
				expiresAt = os.clock() + 10
			} or nil)

			return true
		end,
		claim = function(p2): boolean
			local v10 = sessionScopedSignal(false)

			if v10 == nil or v10.id ~= p2 or sessionScopedSignal4(false) == p2 then
				return false
			end

			v9(p2)
			return true
		end,
		finish = function(p2)
			local v10 = sessionScopedSignal(false)

			if v10 ~= nil and v10.id == p2 then
				local v11 = sessionScopedSignal2(false)

				if v11 == "pending" or v11 == "refreshing" then
					v7("cancelled")
				end

				v6(nil)
			end
		end,
		createChat = function()
			local sessionScopedSignal5, v10 = createSessionScopedSignal(nil)
			local signal, v11 = Signals.createSignal(0)

			local sessionScopedSignal6, v12 = createSessionScopedSignal(nil)

			local sessionScopedSignal7, v13 = createSessionScopedSignal(nil)

			return {
				getScopeRevision = signal,
				updateScope = function(p2, p3, p4, p5)
					local v14 = sessionScopedSignal5(false)
					local v15 = {
						universeId = p2,
						sessionId = p3,
						isPageVisible = p4,
						canPresent = p5
					}

					if v14 ~= nil then
						local v16 = v14.universeId ~= p2 or v14.sessionId ~= p3

						if not v16 and v14.isPageVisible == p4 and v14.canPresent == p5 then
							return
						end

						if v16 then
							local v17

							if
								v14.universeId == p2
								and (v14.sessionId == nil or v14.sessionId == "")
								and p3 ~= nil
								and p3 ~= ""
							then
								v17 = sessionScopedSignal6(false) ~= nil
							else
								v17 = false
							end

							if v17 then
								local v18 = sessionScopedSignal7(false)

								if
									v18 ~= nil
									and v18.universeId == p2
									and v18.sessionId == v14.sessionId
								then
									v13(v15)
								end
							else
								v12(nil)
								v11(function(p6)
									return p6 + 1
								end)
							end
						end
					end

					v10(v15)
				end,
				connect = function(p2, callback, callback2)
					if fFlagBuildAdsNotificationRouting then
						v5[sessionScopedSignal5] = true
					end

					local v14 = nil
					local v15 = nil
					local v16 = nil
					local v17 = false
					local thread = nil
					local thread2 = nil

					local function complete(p3): boolean
						local v18 = v14

						if v18 == nil then
							return false
						end

						v14 = nil

						if thread2 ~= nil then
							task.cancel(thread2)
							thread2 = nil
						end

						if thread ~= nil then
							task.cancel(thread)
							thread = nil
						end

						local v19 = sessionScopedSignal(false)
						local v20 = (v19 == nil or v19.id ~= v18.id) and "cancelled"
							or p3 == "eligible" and os.clock() >= v18.expiresAt and "timeout"
							or p3

						if v19 ~= nil and v19.id == v18.id then
							v7(v20)
							local id = v18.id
							local v21 = sessionScopedSignal(false)

							if v21 ~= nil and v21.id == id then
								local v22 = sessionScopedSignal2(false)

								if v22 == "pending" or v22 == "refreshing" then
									v7("cancelled")
								end

								v6(nil)
							end
						end

						callback("AD_CAMPAIGN_DEEP_LINK_ELIGIBILITY", {
							universeId = v18.universeId
						}, {
							requestId = v18.id,
							outcome = v20
						})

						return v20 == "eligible"
					end

					local effect = Signals.createEffect(function(p3)
						local v18 = sessionScopedSignal(p3)
						local v19 = sessionScopedSignal5(p3)
						local v20

						if v19 == nil then
							v20 = false
						else
							v20 = v19.isPageVisible

							if v20 then
								v20 = not (v18 == nil) and v19.universeId == v18.universeId
							end
						end

						if v14 ~= nil and (not v20 or v18 == nil or v18.id ~= v14.id) then
							complete("cancelled")
						end

						if not v20 or v18 == nil then
							return
						end

						local eligibility = p2.getEligibility(v18.universeId)
						local data = eligibility.data(p3)
						local status = eligibility.status(p3)

						if v14 == nil then
							local id = v18.id
							local v21 = sessionScopedSignal(false)
							local v22

							if v21 == nil or v21.id ~= id or sessionScopedSignal4(false) == id then
								v22 = false
							else
								v9(id)
								v22 = true
							end

							if not v22 then
								return
							end

							v14 = v18
							v15 = data
							v16 = status
							v17 = status == "NotReady"
							local v23 = v18.expiresAt - os.clock()

							if v23 <= 0 then
								complete("timeout")
								return
							end

							v7("refreshing")
							thread = task.delay(v23, function()
								thread = nil
								complete("timeout")
							end)

							if fFlagBuildAdsNotificationRouting then
								thread2 = task.defer(function()
									thread2 = nil

									if v14 == nil or v14.id ~= v18.id then
										return
									end

									local eligibility2 = p2.fetchEligibility(v18.universeId)
									v17 = v17 or eligibility2.status(false) == "NotReady"
								end)
								return
							end

							local eligibility2 = p2.fetchEligibility(v18.universeId)
							v17 = v17 or eligibility2.status(false) == "NotReady"
						elseif status == "NotReady" then
							v17 = true
						elseif status == "Ready" then
							if
								v16 == "Ready" and data == v15
								or fFlagBuildAdsNotificationRouting
								and v19 ~= nil
								and v19.canPresent == false
								and canCreateCampaign(data)
							then
								return
							end

							if
								complete(canCreateCampaign(data) and "eligible" or "ineligible")
								and callback2(data)
							then
								v12(v18.id)
								callback(
									"AD_CAMPAIGN_DEEP_LINK_PRESENTED",
									{ universeId = v18.universeId },
									{ requestId = v18.id }
								)
							end
						elseif status == "Failed" and (v16 ~= "Failed" or v17) then
							complete("failed")
						end
					end)

					return function()
						v5[sessionScopedSignal5] = nil
						effect()
						complete("cancelled")
					end
				end,
				clearPresentedRequest = function()
					v12(nil)
				end,
				getPresentedRequestId = function()
					return sessionScopedSignal6(false)
				end,
				startCreate = function()
					v13(sessionScopedSignal5(false))
				end,
				finishCreate = function(): boolean
					local v14 = sessionScopedSignal7(false)
					local v15 = sessionScopedSignal5(false)
					v13(nil)

					return v14 ~= nil
						and v15 ~= nil
						and v14.universeId == v15.universeId
						and v14.sessionId == v15.sessionId
				end
			}
		end,
		reset = function()
			v6(nil)
			v7("idle")
			v8({})
			v9(nil)
		end
	}
end

return createAdsCampaignDeepLinkStore

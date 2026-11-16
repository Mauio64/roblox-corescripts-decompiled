local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
require(parent.DataHydration.AdCampaignEligibility)
local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)
local canCreateCampaign = adCampaignEligibilityUtils.canCreateCampaign
require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildAdsNotificationRouting = SharedFlags.FFlagBuildAdsNotificationRouting

local function createAdsCampaignDeepLinkStore()
	local v = {}

	local sessionScopedSignal, v2 = createSessionScopedSignal(nil)

	local sessionScopedSignal2, v3 = createSessionScopedSignal("idle")
	local sessionScopedSignal3, v4 = createSessionScopedSignal(function()
		return {}
	end)

	local sessionScopedSignal4, v5 = createSessionScopedSignal(nil)

	local function claim(id: string): boolean -- 1 equivalent call inferred from this helper
		local v6 = sessionScopedSignal(false)

		if v6 == nil or v6.id ~= id or sessionScopedSignal4(false) == id then
			return false
		end

		v5(id)
		return true
	end

	local function finish(id: string) -- 1 equivalent call inferred from this helper
		local v6 = sessionScopedSignal(false)

		if v6 ~= nil and v6.id == id then
			local v7 = sessionScopedSignal2(false)

			if v7 == "pending" or v7 == "refreshing" then
				v3("cancelled")
			end

			v2(nil)
		end
	end

	return {
		getRequest = sessionScopedSignal,
		getStatus = sessionScopedSignal2,
		hasVisibleChat = function(p): boolean
			for k in v do
				local v6 = k(false)

				if v6 ~= nil and v6.isPageVisible and v6.universeId == p then
					return true
				end
			end

			return false
		end,
		begin = function(id, universeId): boolean
			local v6 = sessionScopedSignal3(false)

			if v6[id] then
				return false
			end

			local clone = table.clone(v6)
			clone[id] = true
			v4(clone)
			v3(universeId == nil and "idle" or "pending")

			v2(universeId ~= nil and {
				id = id,
				universeId = universeId,
				expiresAt = os.clock() + 10
			} or nil)

			return true
		end,
		claim = claim,
		finish = finish,
		createChat = function()
			local sessionScopedSignal5, v6 = createSessionScopedSignal(nil)
			local signal, v7 = Signals.createSignal(0)

			local sessionScopedSignal6, v8 = createSessionScopedSignal(nil)

			local sessionScopedSignal7, v9 = createSessionScopedSignal(nil)

			return {
				getScopeRevision = signal,
				updateScope = function(universeId: number?, sessionId: string?, isPageVisible: boolean, canPresent: boolean?)
					local v10 = sessionScopedSignal5(false)
					local v11 = {
						universeId = universeId,
						sessionId = sessionId,
						isPageVisible = isPageVisible,
						canPresent = canPresent
					}

					if v10 ~= nil then
						local v12 = v10.universeId ~= universeId or v10.sessionId ~= sessionId

						if not v12 and v10.isPageVisible == isPageVisible and v10.canPresent == canPresent then
							return
						end

						if v12 then
							local v13

							if
								v10.universeId == universeId
								and (v10.sessionId == nil or v10.sessionId == "")
								and sessionId ~= nil
								and sessionId ~= ""
							then
								v13 = sessionScopedSignal6(false) ~= nil
							else
								v13 = false
							end

							if v13 then
								local v14 = sessionScopedSignal7(false)

								if v14 ~= nil and v14.universeId == universeId and v14.sessionId == v10.sessionId then
									v9(v11)
								end
							else
								v8(nil)
								v7(function(p)
									return p + 1
								end)
							end
						end
					end

					v6(v11)
				end,
				connect = function(p, callback, callback2)
					if FFlagBuildAdsNotificationRouting then
						v[sessionScopedSignal5] = true
					end

					local v10 = nil
					local v11 = nil
					local v12 = nil
					local v13 = false
					local thread = nil
					local thread2 = nil

					local function complete(p2: string): boolean
						local v14 = v10

						if v14 == nil then
							return false
						end

						v10 = nil

						if thread2 ~= nil then
							task.cancel(thread2)
							thread2 = nil
						end

						if thread ~= nil then
							task.cancel(thread)
							thread = nil
						end

						local v15 = sessionScopedSignal(false)
						local outcome = (v15 == nil or v15.id ~= v14.id) and "cancelled"
							or p2 == "eligible" and os.clock() >= v14.expiresAt and "timeout"
							or p2

						if v15 ~= nil and v15.id == v14.id then
							v3(outcome)
							finish(v14.id) -- inferred equivalent call
						end

						callback("AD_CAMPAIGN_DEEP_LINK_ELIGIBILITY", {
							universeId = v14.universeId
						}, {
							requestId = v14.id,
							outcome = outcome
						})

						return outcome == "eligible"
					end

					local effect = Signals.createEffect(function(p2)
						local v14 = sessionScopedSignal(p2)
						local v15 = sessionScopedSignal5(p2)
						local v16

						if v15 == nil then
							v16 = false
						else
							v16 = v15.isPageVisible

							if v16 then
								if v14 == nil then
									v16 = false
								else
									v16 = v15.universeId == v14.universeId
								end
							end
						end

						if v10 ~= nil and (not v16 or v14 == nil or v14.id ~= v10.id) then
							complete("cancelled")
						end

						if not v16 or v14 == nil then
							return
						end

						local eligibility = p.getEligibility(v14.universeId)
						local data = eligibility.data(p2)
						local status = eligibility.status(p2)

						if v10 == nil then
							if not claim(v14.id) then -- inferred equivalent call
								return
							end

							v10 = v14
							v11 = data
							v12 = status
							v13 = status == "NotReady"
							local v17 = v14.expiresAt - os.clock()

							if v17 <= 0 then
								complete("timeout")
								return
							end

							v3("refreshing")
							thread = task.delay(v17, function()
								thread = nil
								complete("timeout")
							end)

							if FFlagBuildAdsNotificationRouting then
								thread2 = task.defer(function()
									thread2 = nil

									if v10 == nil or v10.id ~= v14.id then
										return
									end

									local eligibility2 = p.fetchEligibility(v14.universeId)
									v13 = v13 or eligibility2.status(false) == "NotReady"
								end)
								return
							end

							local eligibility2 = p.fetchEligibility(v14.universeId)
							v13 = v13 or eligibility2.status(false) == "NotReady"
						elseif status == "NotReady" then
							v13 = true
						elseif status == "Ready" then
							if
								v12 == "Ready" and data == v11
								or FFlagBuildAdsNotificationRouting
								and v15 ~= nil
								and v15.canPresent == false
								and canCreateCampaign(data)
							then
								return
							end

							if complete(canCreateCampaign(data) and "eligible" or "ineligible") and callback2(data) then
								v8(v14.id)
								callback("AD_CAMPAIGN_DEEP_LINK_PRESENTED", {
									universeId = v14.universeId
								}, {
									requestId = v14.id
								})
							end
						elseif status == "Failed" and (v12 ~= "Failed" or v13) then
							complete("failed")
						end
					end)

					return function()
						v[sessionScopedSignal5] = nil
						effect()
						complete("cancelled")
					end
				end,
				clearPresentedRequest = function()
					v8(nil)
				end,
				getPresentedRequestId = function()
					return sessionScopedSignal6(false)
				end,
				startCreate = function()
					v9(sessionScopedSignal5(false))
				end,
				finishCreate = function(): boolean
					local v10 = sessionScopedSignal7(false)
					local v11 = sessionScopedSignal5(false)
					v9(nil)

					return v10 ~= nil
						and v11 ~= nil
						and v10.universeId == v11.universeId
						and v10.sessionId == v11.sessionId
				end
			}
		end,
		reset = function()
			v2(nil)
			v3("idle")
			v4({})
			v5(nil)
		end
	}
end

return createAdsCampaignDeepLinkStore

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Http")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/DataHydration")
local queueExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SocialExperiments").QueueExperimentation
local CachedPolicyService = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/CachedPolicyService")

local MarketplaceGetMarketplaceAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/DataHydration/MarketplaceGetMarketplaceAssetStore")
local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")

local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local fFlagEnableLuaAppsFollowUserId = SharedFlags.FFlagEnableLuaAppsFollowUserId

local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local engineFeature = game:GetEngineFeature("QueuePositionEnabled")
local v5 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and fFlagEnableLuaAppsFollowUserId

local engineFeature2 = game:GetEngineFeature("PlaceJoinStateEnabled")

local internalWrapper = Http.NetworkLayers.requestInternalWrapper(HttpService)

local function defaultFetchUniverseId(p2)
	local v7, v8 = internalWrapper(
		string.format("%suniverses/v1/places/%d/universe", Http.Url.APIS_URL, p2),
		"GET"
	):await()

	if v7 and v8 and v8.responseBody then
		return v8.responseBody.universeId
	end

	return nil
end

local function defaultFetchProductInfo(p2)
	return MarketplaceService:GetProductInfoAsync(p2)
end

local function defaultFetchPlayerLocalizationChoice(p2)
	return internalWrapper(
		string.format(
			"%sv1/user-localization-settings/player-choice/%s",
			Http.Url.GAME_INTERNATIONALIZATION_URL,
			p2
		),
		"GET"
	):andThen(function(p3)
		if not (p3 and p3.responseBody) then
			error({
				responseCode = p3 and p3.responseCode,
				errorType = "PlayerLocalizationChoiceResponseError",
				errorMessage = p3 and "Missing response body" or "No response",
				customFields = { universeId = p2 }
			})
		end

		local responseBody = p3.responseBody

		if responseBody.IsPlayerChoiceEnabled == nil then
			error({
				responseCode = p3.responseCode,
				errorType = "PlayerLocalizationChoiceMissingKey",
				errorMessage = "Missing IsPlayerChoiceEnabled in response body",
				customFields = { universeId = p2, responseBody = responseBody }
			})
		end

		return responseBody
	end)
end

local function getQueueTreatment()
	if not engineFeature2 then
		return nil
	end

	if queueExperimentation.getIsAutoJoinNewServerEnabled() then
		return Constants.AUTO_JOIN_TREATMENT
	end

	if queueExperimentation.getIsJoinNewServerButtonEnabled() then
		return Constants.JOIN_NEW_SERVER_TREATMENT
	end

	return nil
end

local function createTiltLoadingScreenModel(p2, data, p3)
	local v6 = if data and data.dataModel then data.dataModel else game
	local v7 = if data and data.experienceService then data.experienceService else ExperienceService

	local v8 = if data and data.guiService then data.guiService else GuiService
	local fetchUniverseId = data and data.fetchUniverseId or defaultFetchUniverseId
	local fetchProductInfo = data and data.fetchProductInfo or defaultFetchProductInfo
	local fetchIsSubjectToChinaPolicies = data and data.fetchIsSubjectToChinaPolicies or function()
		return CachedPolicyService:IsSubjectToChinaPolicies()
	end

	local fetchPlayerLocalizationChoice = data and data.fetchPlayerLocalizationChoice
		or defaultFetchPlayerLocalizationChoice

	local function readServerStatusText()
		if not v8.GetUiMessage then
			return ""
		end

		local success, uiMessage = pcall(v8.GetUiMessage, v8)

		if success and type(uiMessage) == "string" then
			return uiMessage
		end

		return ""
	end

	local v9 = MarketplaceGetMarketplaceAssetStore(false)
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p4)
			if type(p4) == "table" then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					responseCode = p4.responseCode,
					errorType = p4.errorType
				})
			else
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					errorType = "PlayerLocalizationChoiceFetchError"
				})
			end
		end,
		fetchFn = function(p4)
			return fetchPlayerLocalizationChoice(p4)
		end
	})

	if p3 == nil and not (p2 > 0) then
		p2 = v6.PlaceId
	end

	local signal, v10 = Signals.createSignal(not (p2 > 0) and 0 or p2)
	local v11 = if p3 == nil then v6.GameId else p3
	local signal2, v12 = Signals.createSignal(not (v11 > 0) and 0 or v11)
	local v13

	if p3 == nil and engineFeature2 then
		if queueExperimentation.getIsAutoJoinNewServerEnabled() then
			v13 = Constants.AUTO_JOIN_TREATMENT
		elseif queueExperimentation.getIsJoinNewServerButtonEnabled() then
			v13 = Constants.JOIN_NEW_SERVER_TREATMENT
		else
			v13 = nil
		end
	else
		v13 = nil
	end

	local signal3 = Signals.createSignal(v13)
	local signal4, v14 = Signals.createSignal("")
	local signal5, v15 = Signals.createSignal(nil)

	local createSignal = Signals.createSignal
	local v16

	if p3 == nil and v8.GetUiMessage then
		local success, uiMessage = pcall(v8.GetUiMessage, v8)
		v16 = (not success or type(uiMessage) ~= "string") and "" or uiMessage
	else
		v16 = ""
	end

	local signal6, v17 = createSignal(v16)
	local signal7, v18 = Signals.createSignal(0)
	local signal8, v19 = Signals.createSignal(false)
	local computed = Signals.createComputed(function(p4)
		local v20 = signal(p4)

		if v20 <= 0 then
			return nil
		end

		local data2 = v9.getMarketplaceAssetInfo((tostring(v20))).data(p4)

		if data2 then
			return {
				name = data2.name,
				creatorName = data2.creatorName,
				creatorHasVerifiedBadge = data2.creatorHasVerifiedBadge
			}
		end

		return nil
	end)

	local v20 = false
	local computed2 = Signals.createComputed(function(p4)
		local v21 = signal2(p4)

		if v21 <= 0 then
			if not v20 then
				v20 = true
				LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()
			end

			return nil
		else
			local data2 = dataResolver.getAndFetchItem((tostring(v21))).data(p4)

			if data2 then
				return data2.IsPlayerChoiceEnabled
			end

			return nil
		end
	end)

	local v21 = false
	local flag = false
	local placeIdChangedConnection = nil
	local gameIdChangedConnection = nil
	local placeJoinStateChangedConnection = nil
	local queuePositionChangedConnection = nil
	local uiMessageChangedConnection = nil
	local thread = nil
	local thread2 = nil
	local thread3 = nil
	local v22 = false
	local v23 = false

	local function cancel(p4)
		if p4 and coroutine.status(p4) ~= "dead" then
			task.cancel(p4)
		end
	end

	local function disconnect(connection): nil
		if connection then
			connection:Disconnect()
		end

		return nil
	end

	local function readFollowUserId()
		if not (v5 and v7.GetFollowUserId) then
			return 0
		end

		local success, followUserId = pcall(v7.GetFollowUserId, v7)

		if success and type(followUserId) == "number" then
			return followUserId
		end

		return 0
	end

	local function readExposureFollowUserId()
		if not v7.GetFollowUserId then
			return 0
		end

		local success, followUserId = pcall(v7.GetFollowUserId, v7)

		if success and type(followUserId) == "number" then
			return followUserId
		end

		return 0
	end

	local function readQueuePosition()
		if not (engineFeature and v7.GetQueuePosition) then
			return nil
		end

		local success, queuePosition = pcall(v7.GetQueuePosition, v7)

		if success and type(queuePosition) == "number" then
			return queuePosition
		end

		return nil
	end

	local function updateQueuePosition()
		local queuePosition

		if engineFeature and v7.GetQueuePosition then
			local success
			success, queuePosition = pcall(v7.GetQueuePosition, v7)

			if not success or type(queuePosition) ~= "number" then
				queuePosition = nil
			end
		end

		v15(queuePosition)
	end

	local function logQueueExposureIfNeeded(p4)
		if not v22 and p4 == Constants.QUEUED_STATE and not (signal(false) <= 0) then
			local v24

			if v7.GetFollowUserId then
				local success, followUserId = pcall(v7.GetFollowUserId, v7)
				v24 = (not success or type(followUserId) ~= "number") and 0 or followUserId
			else
				v24 = 0
			end

			if not (v24 <= 0) and queueExperimentation.isInExperiment() then
				v22 = true
				queueExperimentation.logExposure()
			end
		end
	end

	local function updateJoinState(value)
		if type(value) ~= "string" then
			return
		end

		v14(value)

		if value ~= Constants.QUEUED_STATE then
			v15(nil)
		end

		if not v22 and value == Constants.QUEUED_STATE and not (signal(false) <= 0) then
			local v24

			if v7.GetFollowUserId then
				local success, followUserId = pcall(v7.GetFollowUserId, v7)
				v24 = (not success or type(followUserId) ~= "number") and 0 or followUserId
			else
				v24 = 0
			end

			if not (v24 <= 0) then
				if not queueExperimentation.isInExperiment() then
					return
				end

				v22 = true
				queueExperimentation.logExposure()
			end
		end
	end

	local function resolveUniverseId(p4)
		if flag or p4 <= 0 or signal2(false) > 0 then
			return
		end

		v12(p4)
		local connection = gameIdChangedConnection

		if connection then
			connection:Disconnect()
		end

		gameIdChangedConnection = nil
	end

	local function watchUniverseId()
		local connection = gameIdChangedConnection

		if connection then
			connection:Disconnect()
		end

		gameIdChangedConnection = nil

		if flag or signal2(false) > 0 then
			return
		end

		gameIdChangedConnection = v6:GetPropertyChangedSignal("GameId"):Connect(function()
			local gameId = v6.GameId

			if not (flag or gameId <= 0) then
				if signal2(false) > 0 then
					return
				end

				v12(gameId)
				local connection2 = gameIdChangedConnection

				if connection2 then
					connection2:Disconnect()
				end

				gameIdChangedConnection = nil
			end
		end)
		local gameId = v6.GameId

		if not (flag or gameId <= 0) then
			if signal2(false) > 0 then
				return
			end

			v12(gameId)
			local connection2 = gameIdChangedConnection

			if connection2 then
				connection2:Disconnect()
			end

			gameIdChangedConnection = nil
		end
	end

	local function fetchUniverseIdForPlace(p4)
		if signal2(false) > 0 then
			return
		end

		local v24 = thread2

		if v24 and coroutine.status(v24) ~= "dead" then
			task.cancel(v24)
		end

		thread2 = task.defer(function()
			local success, result = pcall(fetchUniverseId, p4)

			if
				not flag
				and p4 == signal(false)
				and success
				and type(result) == "number"
				and not (flag or result <= 0)
			then
				if signal2(false) > 0 then
					return
				end

				v12(result)
				local connection = gameIdChangedConnection

				if connection then
					connection:Disconnect()
				end

				gameIdChangedConnection = nil
			end
		end)
	end

	local function fetchGameDataForPlace(p4)
		local v24 = thread

		if v24 and coroutine.status(v24) ~= "dead" then
			task.cancel(v24)
		end

		thread = task.defer(function()
			local success, result = pcall(fetchProductInfo, p4)

			if not success then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))
				return
			end

			if flag or p4 ~= signal(false) then
				return
			end

			local creator = result.Creator
			local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
			local v25 = tostring(p4)
			local v26 = {
				name = result.Name or "",
				creatorName = creator and creator.Name or "",
				creatorHasVerifiedBadge = 0
			}
			local v27 = if creator then creator.HasVerifiedBadge == true else false
			v26.creatorHasVerifiedBadge = v27
			updateMarketplaceAssetInfo(v25, v26)
		end)
	end

	local function resolveChinaPolicy()
		local v24 = thread3

		if v24 and coroutine.status(v24) ~= "dead" then
			task.cancel(v24)
		end

		thread3 = task.defer(function()
			local success, result = pcall(fetchIsSubjectToChinaPolicies)

			if not flag and success and type(result) == "boolean" then
				v19(result)
			end
		end)
	end

	local function beginRequests(p4)
		if p4 <= 0 then
			return
		end

		local v24 = thread

		if v24 and coroutine.status(v24) ~= "dead" then
			task.cancel(v24)
		end

		thread = task.defer(function()
			local success, result = pcall(fetchProductInfo, p4)

			if not success then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))
				return
			end

			if flag or p4 ~= signal(false) then
				return
			end

			local creator = result.Creator
			local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
			local v25 = tostring(p4)
			local v26 = {
				name = result.Name or "",
				creatorName = creator and creator.Name or "",
				creatorHasVerifiedBadge = 0
			}
			local v27 = if creator then creator.HasVerifiedBadge == true else false
			v26.creatorHasVerifiedBadge = v27
			updateMarketplaceAssetInfo(v25, v26)
		end)

		if signal2(false) > 0 then
			return
		end

		local v25 = thread2

		if v25 and coroutine.status(v25) ~= "dead" then
			task.cancel(v25)
		end

		thread2 = task.defer(function()
			local success, result = pcall(fetchUniverseId, p4)

			if
				not flag
				and p4 == signal(false)
				and success
				and type(result) == "number"
				and not (flag or result <= 0)
			then
				if signal2(false) > 0 then
					return
				end

				v12(result)
				local connection = gameIdChangedConnection

				if connection then
					connection:Disconnect()
				end

				gameIdChangedConnection = nil
			end
		end)
	end

	local function resolvePlaceId(p4)
		if flag or p4 <= 0 or signal(false) == p4 then
			return
		end

		v10(p4)
		local connection = placeIdChangedConnection

		if connection then
			connection:Disconnect()
		end

		placeIdChangedConnection = nil

		if p4 <= 0 then
			return
		end

		local v24 = thread

		if v24 and coroutine.status(v24) ~= "dead" then
			task.cancel(v24)
		end

		thread = task.defer(function()
			local success, result = pcall(fetchProductInfo, p4)

			if not success then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))
				return
			end

			if flag or p4 ~= signal(false) then
				return
			end

			local creator = result.Creator
			local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
			local v25 = tostring(p4)
			local v26 = {
				name = result.Name or "",
				creatorName = creator and creator.Name or "",
				creatorHasVerifiedBadge = 0
			}
			local v27 = if creator then creator.HasVerifiedBadge == true else false
			v26.creatorHasVerifiedBadge = v27
			updateMarketplaceAssetInfo(v25, v26)
		end)

		if signal2(false) > 0 then
			return
		end

		local v25 = thread2

		if v25 and coroutine.status(v25) ~= "dead" then
			task.cancel(v25)
		end

		thread2 = task.defer(function()
			local success, result = pcall(fetchUniverseId, p4)

			if
				not flag
				and p4 == signal(false)
				and success
				and type(result) == "number"
				and not (flag or result <= 0)
			then
				if signal2(false) > 0 then
					return
				end

				v12(result)
				local connection2 = gameIdChangedConnection

				if connection2 then
					connection2:Disconnect()
				end

				gameIdChangedConnection = nil
			end
		end)
	end

	return {
		getAssetInfo = computed,
		getFollowUserId = signal7,
		getIsAutoTranslated = computed2,
		getIsSubjectToChinaPolicies = signal8,
		getJoinState = signal4,
		getQueuePosition = signal5,
		getQueueTreatment = signal3,
		getServerStatusText = signal6,
		getUniverseId = signal2,
		launchExperience = function()
			local v24 = signal(false)

			if v24 > 0 and v7.LaunchExperience then
				v7:LaunchExperience({ placeId = v24 })
			end
		end,
		logQueuedStateButtonClick = function(p4, timeElapsedMs)
			if not v13 then
				return
			end

			local logQueuedStateButtonClick2 = LoadingScreenTelemetry.logQueuedStateButtonClick

			local v25 = if v5 then signal7(false) else nil
			local v24 = {
				buttonName = p4,
				joinTargetUserId = v25,
				placeId = signal(false),
				positionInQueue = 0,
				timeElapsedMs = 0,
				universeId = 0
			}
			local v26 = if engineFeature then signal5(false) else nil
			v24.positionInQueue = v26
			v24.timeElapsedMs = timeElapsedMs
			v24.universeId = signal2(false)
			logQueuedStateButtonClick2(v24)
		end,
		showConnectionHealth = function()
			if v8.ShowStatsBasedOnInputString then
				v23 = true
				v8:ShowStatsBasedOnInputString("ConnectionHealth")
			end
		end,
		start = function()
			if v21 or flag then
				return
			end

			v21 = true

			if p3 == nil then
				if signal(false) <= 0 then
					placeIdChangedConnection = v6:GetPropertyChangedSignal("PlaceId"):Connect(function()
						local placeId = v6.PlaceId

						if not (flag or placeId <= 0) then
							if signal(false) == placeId then
								return
							end

							v10(placeId)
							local connection = placeIdChangedConnection

							if connection then
								connection:Disconnect()
							end

							placeIdChangedConnection = nil

							if placeId <= 0 then
								return
							end

							local v24 = thread

							if v24 and coroutine.status(v24) ~= "dead" then
								task.cancel(v24)
							end

							thread = task.defer(function()
								local success, result = pcall(fetchProductInfo, placeId)

								if not success then
									print(string.format(
										"LoadingScreen:GetGameProductInfo: %s",
										(tostring(result))
									))
									return
								end

								if flag or placeId ~= signal(false) then
									return
								end

								local creator = result.Creator
								local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
								local v25 = tostring(placeId)
								local v26 = {
									name = result.Name or "",
									creatorName = creator and creator.Name or "",
									creatorHasVerifiedBadge = 0
								}
								local v27 = if creator then creator.HasVerifiedBadge == true else false
								v26.creatorHasVerifiedBadge = v27
								updateMarketplaceAssetInfo(v25, v26)
							end)

							if signal2(false) > 0 then
								return
							end

							local v25 = thread2

							if v25 and coroutine.status(v25) ~= "dead" then
								task.cancel(v25)
							end

							thread2 = task.defer(function()
								local success, result = pcall(fetchUniverseId, placeId)

								if
									not flag
									and placeId == signal(false)
									and success
									and type(result) == "number"
									and not (flag or result <= 0)
								then
									if signal2(false) > 0 then
										return
									end

									v12(result)
									local connection2 = gameIdChangedConnection

									if connection2 then
										connection2:Disconnect()
									end

									gameIdChangedConnection = nil
								end
							end)
						end
					end)
				end

				watchUniverseId()
				local v24 = thread3

				if v24 and coroutine.status(v24) ~= "dead" then
					task.cancel(v24)
				end

				thread3 = task.defer(function()
					local success, result = pcall(fetchIsSubjectToChinaPolicies)

					if not flag and success and type(result) == "boolean" then
						v19(result)
					end
				end)
				local v26

				if v5 and v7.GetFollowUserId then
					local success, followUserId = pcall(v7.GetFollowUserId, v7)
					v26 = (not success or type(followUserId) ~= "number") and 0 or followUserId
				else
					v26 = 0
				end

				v18(v26)

				if v8.UiMessageChanged then
					uiMessageChangedConnection = v8.UiMessageChanged:Connect(function(p4, value)
						if p4 == Enum.UiMessageType.UiMessageInfo and type(value) == "string" then
							v17(value)
						end
					end)
				end

				local v28

				if v8.GetUiMessage then
					local success, uiMessage = pcall(v8.GetUiMessage, v8)
					v28 = (not success or type(uiMessage) ~= "string") and "" or uiMessage
				else
					v28 = ""
				end

				v17(v28)

				if queueExperimentation.isInExperiment() then
					if v7.GetPlaceJoinState then
						local success, placeJoinState = pcall(v7.GetPlaceJoinState, v7)

						if success and type(placeJoinState) == "string" then
							v14(placeJoinState)

							if placeJoinState ~= Constants.QUEUED_STATE then
								v15(nil)
							end

							if
								not v22
								and placeJoinState == Constants.QUEUED_STATE
								and not (signal(false) <= 0)
							then
								local v29

								if v7.GetFollowUserId then
									local success2, followUserId = pcall(v7.GetFollowUserId, v7)
									v29 = (not success2 or type(followUserId) ~= "number") and 0
										or followUserId
								else
									v29 = 0
								end

								if not (v29 <= 0) and queueExperimentation.isInExperiment() then
									v22 = true
									queueExperimentation.logExposure()
								end
							end
						end
					end

					if v7.PlaceJoinStateChanged then
						placeJoinStateChangedConnection = v7.PlaceJoinStateChanged:Connect(updateJoinState)
					end

					if engineFeature and v7.QueuePositionChanged then
						queuePositionChangedConnection = v7.QueuePositionChanged:Connect(updateQueuePosition)
					end

					if engineFeature then
						local queuePosition

						if engineFeature and v7.GetQueuePosition then
							local success
							success, queuePosition = pcall(v7.GetQueuePosition, v7)

							if not success or type(queuePosition) ~= "number" then
								queuePosition = nil
							end
						end

						v15(queuePosition)
					end
				end

				if signal(false) <= 0 then
					local placeId = v6.PlaceId

					if not (flag or placeId <= 0) then
						if signal(false) == placeId then
							return
						end

						v10(placeId)
						local connection = placeIdChangedConnection

						if connection then
							connection:Disconnect()
						end

						placeIdChangedConnection = nil

						if placeId <= 0 then
							return
						end

						local v29 = thread

						if v29 and coroutine.status(v29) ~= "dead" then
							task.cancel(v29)
						end

						thread = task.defer(function()
							local success, result = pcall(fetchProductInfo, placeId)

							if not success then
								print(string.format(
									"LoadingScreen:GetGameProductInfo: %s",
									(tostring(result))
								))
								return
							end

							if flag or placeId ~= signal(false) then
								return
							end

							local creator = result.Creator
							local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
							local v30 = tostring(placeId)
							local v31 = {
								name = result.Name or "",
								creatorName = creator and creator.Name or "",
								creatorHasVerifiedBadge = 0
							}
							local v32 = if creator then creator.HasVerifiedBadge == true else false
							v31.creatorHasVerifiedBadge = v32
							updateMarketplaceAssetInfo(v30, v31)
						end)

						if signal2(false) > 0 then
							return
						end

						local v30 = thread2

						if v30 and coroutine.status(v30) ~= "dead" then
							task.cancel(v30)
						end

						thread2 = task.defer(function()
							local success, result = pcall(fetchUniverseId, placeId)

							if
								not flag
								and placeId == signal(false)
								and success
								and type(result) == "number"
								and not (flag or result <= 0)
							then
								if signal2(false) > 0 then
									return
								end

								v12(result)
								local connection2 = gameIdChangedConnection

								if connection2 then
									connection2:Disconnect()
								end

								gameIdChangedConnection = nil
							end
						end)
					end
				else
					local v29 = signal(false)

					if v29 <= 0 then
						return
					end

					local v30 = thread

					if v30 and coroutine.status(v30) ~= "dead" then
						task.cancel(v30)
					end

					thread = task.defer(function()
						local success, result = pcall(fetchProductInfo, v29)

						if not success then
							print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))
							return
						end

						if flag or v29 ~= signal(false) then
							return
						end

						local creator = result.Creator
						local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
						local v31 = tostring(v29)
						local v32 = {
							name = result.Name or "",
							creatorName = creator and creator.Name or "",
							creatorHasVerifiedBadge = 0
						}
						local v33 = if creator then creator.HasVerifiedBadge == true else false
						v32.creatorHasVerifiedBadge = v33
						updateMarketplaceAssetInfo(v31, v32)
					end)

					if signal2(false) > 0 then
						return
					end

					local v31 = thread2

					if v31 and coroutine.status(v31) ~= "dead" then
						task.cancel(v31)
					end

					thread2 = task.defer(function()
						local success, result = pcall(fetchUniverseId, v29)

						if
							not flag
							and v29 == signal(false)
							and success
							and type(result) == "number"
							and not (flag or result <= 0)
						then
							if signal2(false) > 0 then
								return
							end

							v12(result)
							local connection = gameIdChangedConnection

							if connection then
								connection:Disconnect()
							end

							gameIdChangedConnection = nil
						end
					end)
				end
			else
				local v24 = thread3

				if v24 and coroutine.status(v24) ~= "dead" then
					task.cancel(v24)
				end

				thread3 = task.defer(function()
					local success, result = pcall(fetchIsSubjectToChinaPolicies)

					if not flag and success and type(result) == "boolean" then
						v19(result)
					end
				end)

				local v25 = signal(false)

				if v25 <= 0 then
					return
				end

				local v26 = thread

				if v26 and coroutine.status(v26) ~= "dead" then
					task.cancel(v26)
				end

				thread = task.defer(function()
					local success, result = pcall(fetchProductInfo, v25)

					if not success then
						print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))
						return
					end

					if flag or v25 ~= signal(false) then
						return
					end

					local creator = result.Creator
					local updateMarketplaceAssetInfo = v9.updateMarketplaceAssetInfo
					local v27 = tostring(v25)
					local v28 = {
						name = result.Name or "",
						creatorName = creator and creator.Name or "",
						creatorHasVerifiedBadge = 0
					}
					local v29 = if creator then creator.HasVerifiedBadge == true else false
					v28.creatorHasVerifiedBadge = v29
					updateMarketplaceAssetInfo(v27, v28)
				end)

				if signal2(false) > 0 then
					return
				end

				local v27 = thread2

				if v27 and coroutine.status(v27) ~= "dead" then
					task.cancel(v27)
				end

				thread2 = task.defer(function()
					local success, result = pcall(fetchUniverseId, v25)

					if
						not flag
						and v25 == signal(false)
						and success
						and type(result) == "number"
						and not (flag or result <= 0)
					then
						if signal2(false) > 0 then
							return
						end

						v12(result)
						local connection = gameIdChangedConnection

						if connection then
							connection:Disconnect()
						end

						gameIdChangedConnection = nil
					end
				end)
			end
		end,
		destroy = function()
			if flag then
				return
			end

			flag = true
			local connection = placeIdChangedConnection

			if connection then
				connection:Disconnect()
			end

			placeIdChangedConnection = nil
			local connection2 = gameIdChangedConnection

			if connection2 then
				connection2:Disconnect()
			end

			gameIdChangedConnection = nil
			local connection3 = placeJoinStateChangedConnection

			if connection3 then
				connection3:Disconnect()
			end

			placeJoinStateChangedConnection = nil
			local connection4 = queuePositionChangedConnection

			if connection4 then
				connection4:Disconnect()
			end

			queuePositionChangedConnection = nil
			local connection5 = uiMessageChangedConnection

			if connection5 then
				connection5:Disconnect()
			end

			uiMessageChangedConnection = nil
			local v24 = thread

			if v24 and coroutine.status(v24) ~= "dead" then
				task.cancel(v24)
			end

			local v25 = thread2

			if v25 and coroutine.status(v25) ~= "dead" then
				task.cancel(v25)
			end

			local v26 = thread3

			if v26 and coroutine.status(v26) ~= "dead" then
				task.cancel(v26)
			end

			dataResolver.clear()
			dataCache.clear()
			dataResolver.dispose()

			if v23 and v8.CloseStatsBasedOnInputString then
				local inputBeganConnection = nil
				inputBeganConnection = UserInputService.InputBegan:Connect(function()
					if inputBeganConnection then
						inputBeganConnection:Disconnect()
						inputBeganConnection = nil
					end

					v8:CloseStatsBasedOnInputString("ConnectionHealth")
				end)
			end
		end
	}
end

return createTiltLoadingScreenModel

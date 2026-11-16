local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local parent = TiltLoadingScreen.Parent
local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local Http = require(parent2.Http)
local DataHydration = require(parent2.DataHydration)
local SocialExperiments = require(parent2.SocialExperiments)
local QueueExperimentation = SocialExperiments.QueueExperimentation
local CachedPolicyService = require(parent2.CachedPolicyService)

local MarketplaceGetMarketplaceAssetStore = require(parent2.DataHydration.MarketplaceGetMarketplaceAssetStore)
local LoadingScreenTelemetry = require(parent.LoadingScreenTelemetry)
local SharedFlags = require(parent2.SharedFlags)
local Constants = require(TiltLoadingScreen.Constants)

local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local FFlagEnableLuaAppsFollowUserId = SharedFlags.FFlagEnableLuaAppsFollowUserId

local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local engineFeature = game:GetEngineFeature("QueuePositionEnabled")
local v = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and FFlagEnableLuaAppsFollowUserId

local engineFeature2 = game:GetEngineFeature("PlaceJoinStateEnabled")

local internalWrapper = Http.NetworkLayers.requestInternalWrapper(HttpService)

local function defaultFetchUniverseId(p: number)
	local v2, v3 = internalWrapper(string.format("%suniverses/v1/places/%d/universe", Http.Url.APIS_URL, p), "GET"):await()

	if v2 and v3 and v3.responseBody then
		return v3.responseBody.universeId
	end

	return nil
end

local function defaultFetchProductInfo(p: number)
	return (MarketplaceService:GetProductInfoAsync(p))
end

local function defaultFetchPlayerLocalizationChoice(universeId: string)
	return internalWrapper(
		string.format(
			"%sv1/user-localization-settings/player-choice/%s",
			Http.Url.GAME_INTERNATIONALIZATION_URL,
			universeId
		),
		"GET"
	):andThen(function(p)
		if not (p and p.responseBody) then
			error({
				responseCode = p and p.responseCode,
				errorType = "PlayerLocalizationChoiceResponseError",
				errorMessage = p and "Missing response body" or "No response",
				customFields = { universeId = universeId }
			})
		end

		local responseBody = p.responseBody

		if responseBody.IsPlayerChoiceEnabled == nil then
			error({
				responseCode = p.responseCode,
				errorType = "PlayerLocalizationChoiceMissingKey",
				errorMessage = "Missing IsPlayerChoiceEnabled in response body",
				customFields = { universeId = universeId, responseBody = responseBody }
			})
		end

		return responseBody
	end)
end

local function getQueueTreatment()
	if not engineFeature2 then
		return nil
	end

	if QueueExperimentation.getIsAutoJoinNewServerEnabled() then
		return Constants.AUTO_JOIN_TREATMENT
	end

	if QueueExperimentation.getIsJoinNewServerButtonEnabled() then
		return Constants.JOIN_NEW_SERVER_TREATMENT
	end

	return nil
end

local function createTiltLoadingScreenModel(p: number, data, p2: number?)
	local v2

	if data and data.dataModel then
		v2 = data.dataModel
	else
		v2 = game
	end

	local v3

	if data and data.experienceService then
		v3 = data.experienceService
	else
		v3 = ExperienceService
	end

	local v4

	if data and data.guiService then
		v4 = data.guiService
	else
		v4 = GuiService
	end

	local fetchUniverseId = data and data.fetchUniverseId or defaultFetchUniverseId
	local fetchProductInfo = data and data.fetchProductInfo or defaultFetchProductInfo
	local fetchIsSubjectToChinaPolicies = data and data.fetchIsSubjectToChinaPolicies or function()
		return CachedPolicyService:IsSubjectToChinaPolicies()
	end

	local fetchPlayerLocalizationChoice = data and data.fetchPlayerLocalizationChoice
		or defaultFetchPlayerLocalizationChoice

	local function readServerStatusText() -- 1 equivalent call inferred from this helper
		if not v4.GetUiMessage then
			return ""
		end

		local success, uiMessage = pcall(v4.GetUiMessage, v4)

		if success and type(uiMessage) == "string" then
			return uiMessage
		end

		return ""
	end

	local marketplaceGetMarketplaceAssetStore = MarketplaceGetMarketplaceAssetStore(false)
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p3)
			if type(p3) == "table" then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					responseCode = p3.responseCode,
					errorType = p3.errorType
				})
			else
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					errorType = "PlayerLocalizationChoiceFetchError"
				})
			end
		end,
		fetchFn = function(p3: string)
			return fetchPlayerLocalizationChoice(p3)
		end
	})

	if p2 == nil and not (p > 0) then
		p = v2.PlaceId
	end

	local signal, v5 = Signals.createSignal(not (p > 0) and 0 or p)
	local v6 = if p2 == nil then v2.GameId else p2
	local signal2, v7 = Signals.createSignal(not (v6 > 0) and 0 or v6)
	local v8

	if p2 == nil and engineFeature2 then
		if QueueExperimentation.getIsAutoJoinNewServerEnabled() then
			v8 = Constants.AUTO_JOIN_TREATMENT
		elseif QueueExperimentation.getIsJoinNewServerButtonEnabled() then
			v8 = Constants.JOIN_NEW_SERVER_TREATMENT
		else
			v8 = nil
		end
	else
		v8 = nil
	end

	local signal3 = Signals.createSignal(v8)
	local signal4, v9 = Signals.createSignal("")
	local signal5, v10 = Signals.createSignal(nil)

	local createSignal = Signals.createSignal
	local v11

	if p2 == nil and v4.GetUiMessage then
		local success, uiMessage = pcall(v4.GetUiMessage, v4)
		v11 = (not success or type(uiMessage) ~= "string") and "" or uiMessage
	else
		v11 = ""
	end

	local signal6, v12 = createSignal(v11)
	local signal7, v13 = Signals.createSignal(0)
	local signal8, v14 = Signals.createSignal(false)
	local getAssetInfo = Signals.createComputed(function(p3)
		local v15 = signal(p3)

		if v15 <= 0 then
			return nil
		end

		local data2 = marketplaceGetMarketplaceAssetStore.getMarketplaceAssetInfo((tostring(v15))).data(p3)

		if data2 then
			return {
				name = data2.name,
				creatorName = data2.creatorName,
				creatorHasVerifiedBadge = data2.creatorHasVerifiedBadge
			}
		end

		return nil
	end)

	local v15 = false
	local getIsAutoTranslated = Signals.createComputed(function(p3)
		local v16 = signal2(p3)

		if v16 <= 0 then
			if not v15 then
				v15 = true
				LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()
			end

			return nil
		else
			local data2 = dataResolver.getAndFetchItem((tostring(v16))).data(p3)
			return if data2 then data2.IsPlayerChoiceEnabled else nil
		end
	end)

	local v16 = false
	local flag = false
	local placeIdChangedConnection = nil
	local gameIdChangedConnection = nil
	local placeJoinStateChangedConnection = nil
	local queuePositionChangedConnection = nil
	local uiMessageChangedConnection = nil
	local thread = nil
	local thread2 = nil
	local thread3 = nil
	local v17 = false
	local v18 = false

	local function cancel(thread4: thread?) -- 6 equivalent calls inferred from this helper
		if thread4 and coroutine.status(thread4) ~= "dead" then
			task.cancel(thread4)
		end
	end

	local function disconnect(connection): nil -- 13 equivalent calls inferred from this helper
		if connection then
			connection:Disconnect()
		end

		return nil
	end

	local function readFollowUserId() -- 1 equivalent call inferred from this helper
		if not (v and v3.GetFollowUserId) then
			return 0
		end

		local success, followUserId = pcall(v3.GetFollowUserId, v3)

		if success and type(followUserId) == "number" then
			return followUserId
		end

		return 0
	end

	local function readExposureFollowUserId() -- 2 equivalent calls inferred from this helper
		if not v3.GetFollowUserId then
			return 0
		end

		local success, followUserId = pcall(v3.GetFollowUserId, v3)

		if success and type(followUserId) == "number" then
			return followUserId
		end

		return 0
	end

	local function readQueuePosition()
		if not (engineFeature and v3.GetQueuePosition) then
			return nil
		end

		local success, queuePosition = pcall(v3.GetQueuePosition, v3)

		if success and type(queuePosition) == "number" then
			return queuePosition
		end

		return nil
	end

	local function updateQueuePosition() -- 1 equivalent call inferred from this helper
		local queuePosition

		if engineFeature and v3.GetQueuePosition then
			local success
			success, queuePosition = pcall(v3.GetQueuePosition, v3)

			if not success or type(queuePosition) ~= "number" then
				queuePosition = nil
			end
		end

		v10(queuePosition)
	end

	local function logQueueExposureIfNeeded(placeJoinState: string) -- 1 equivalent call inferred from this helper
		if
			not v17
			and placeJoinState == Constants.QUEUED_STATE
			and not (signal(false) <= 0)
			and not (readExposureFollowUserId() <= 0) -- inferred equivalent call
			and QueueExperimentation.isInExperiment()
		then
			v17 = true
			QueueExperimentation.logExposure()
		end
	end

	local function updateJoinState(value: string?)
		if type(value) ~= "string" then
			return
		end

		v9(value)

		if value ~= Constants.QUEUED_STATE then
			v10(nil)
		end

		if
			not v17
			and value == Constants.QUEUED_STATE
			and not (signal(false) <= 0)
			and not (readExposureFollowUserId() <= 0) -- inferred equivalent call
		then
			if not QueueExperimentation.isInExperiment() then
				return
			end

			v17 = true
			QueueExperimentation.logExposure()
		end
	end

	local function resolveUniverseId(p3: number)
		if flag or p3 <= 0 or signal2(false) > 0 then
			return
		end

		v7(p3)
		gameIdChangedConnection = disconnect(gameIdChangedConnection) -- inferred equivalent call
	end

	local function watchUniverseId()
		gameIdChangedConnection = disconnect(gameIdChangedConnection) -- inferred equivalent call

		if flag or signal2(false) > 0 then
			return
		end

		gameIdChangedConnection = v2:GetPropertyChangedSignal("GameId"):Connect(function()
			local gameId = v2.GameId

			if not (flag or gameId <= 0) then
				if signal2(false) > 0 then
					return
				end

				v7(gameId)
				gameIdChangedConnection = disconnect(gameIdChangedConnection) -- inferred equivalent call
			end
		end)
		local gameId = v2.GameId

		if not (flag or gameId <= 0) then
			if signal2(false) > 0 then
				return
			end

			v7(gameId)
			gameIdChangedConnection = disconnect(gameIdChangedConnection) -- inferred equivalent call
		end
	end

	local function fetchUniverseIdForPlace(p3: number) -- 1 equivalent call inferred from this helper
		if signal2(false) > 0 then
			return
		end

		cancel(thread2) -- inferred equivalent call
		thread2 = task.defer(function()
			local success, result = pcall(fetchUniverseId, p3)

			if
				not flag
				and p3 == signal(false)
				and success
				and type(result) == "number"
				and not (flag or result <= 0)
			then
				if signal2(false) > 0 then
					return
				end

				v7(result)
				gameIdChangedConnection = disconnect(gameIdChangedConnection) -- inferred equivalent call
			end
		end)
	end

	local function fetchGameDataForPlace(p3: number) -- 1 equivalent call inferred from this helper
		cancel(thread) -- inferred equivalent call
		thread = task.defer(function()
			local success, result = pcall(fetchProductInfo, p3)

			if not success then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))
				return
			end

			if flag or p3 ~= signal(false) then
				return
			end

			local creator = result.Creator
			local updateMarketplaceAssetInfo = marketplaceGetMarketplaceAssetStore.updateMarketplaceAssetInfo
			local v19 = tostring(p3)
			local v20 = {
				name = result.Name or "",
				creatorName = creator and creator.Name or "",
				creatorHasVerifiedBadge = 0
			}
			local creatorHasVerifiedBadge

			if creator then
				creatorHasVerifiedBadge = creator.HasVerifiedBadge == true
			else
				creatorHasVerifiedBadge = false
			end

			v20.creatorHasVerifiedBadge = creatorHasVerifiedBadge
			updateMarketplaceAssetInfo(v19, v20)
		end)
	end

	local function resolveChinaPolicy() -- 2 equivalent calls inferred from this helper
		cancel(thread3) -- inferred equivalent call
		thread3 = task.defer(function()
			local success, result = pcall(fetchIsSubjectToChinaPolicies)

			if not flag and success and type(result) == "boolean" then
				v14(result)
			end
		end)
	end

	local function beginRequests(p3: number) -- 5 equivalent calls inferred from this helper
		if p3 <= 0 then
			return
		end

		fetchGameDataForPlace(p3) -- inferred equivalent call
		fetchUniverseIdForPlace(p3) -- inferred equivalent call
	end

	local function resolvePlaceId(p3: number)
		if flag or p3 <= 0 or signal(false) == p3 then
			return
		end

		v5(p3)
		placeIdChangedConnection = disconnect(placeIdChangedConnection) -- inferred equivalent call
		beginRequests(p3) -- inferred equivalent call
	end

	return {
		getAssetInfo = getAssetInfo,
		getFollowUserId = signal7,
		getIsAutoTranslated = getIsAutoTranslated,
		getIsSubjectToChinaPolicies = signal8,
		getJoinState = signal4,
		getQueuePosition = signal5,
		getQueueTreatment = signal3,
		getServerStatusText = signal6,
		getUniverseId = signal2,
		launchExperience = function()
			local placeId = signal(false)

			if placeId > 0 and v3.LaunchExperience then
				v3:LaunchExperience({ placeId = placeId })
			end
		end,
		logQueuedStateButtonClick = function(buttonName: string, timeElapsedMs: number?)
			if not v8 then
				return
			end

			local logQueuedStateButtonClick = LoadingScreenTelemetry.logQueuedStateButtonClick
			local joinTargetUserId

			if v then
				joinTargetUserId = signal7(false)
			end

			local v19 = {
				buttonName = buttonName,
				joinTargetUserId = joinTargetUserId,
				placeId = signal(false),
				positionInQueue = 0,
				timeElapsedMs = 0,
				universeId = 0
			}
			local positionInQueue

			if engineFeature then
				positionInQueue = signal5(false)
			end

			v19.positionInQueue = positionInQueue
			v19.timeElapsedMs = timeElapsedMs
			v19.universeId = signal2(false)
			logQueuedStateButtonClick(v19)
		end,
		showConnectionHealth = function()
			if v4.ShowStatsBasedOnInputString then
				v18 = true
				v4:ShowStatsBasedOnInputString("ConnectionHealth")
			end
		end,
		start = function()
			if v16 or flag then
				return
			end

			v16 = true

			if p2 == nil then
				if signal(false) <= 0 then
					placeIdChangedConnection = v2:GetPropertyChangedSignal("PlaceId"):Connect(function()
						local placeId = v2.PlaceId

						if not (flag or placeId <= 0) then
							if signal(false) == placeId then
								return
							end

							v5(placeId)
							placeIdChangedConnection = disconnect(placeIdChangedConnection) -- inferred equivalent call
							beginRequests(placeId) -- inferred equivalent call
						end
					end)
				end

				watchUniverseId()
				resolveChinaPolicy() -- inferred equivalent call
				v13(readFollowUserId()) -- inferred equivalent call

				if v4.UiMessageChanged then
					uiMessageChangedConnection = v4.UiMessageChanged:Connect(function(p3, value)
						if p3 == Enum.UiMessageType.UiMessageInfo and type(value) == "string" then
							v12(value)
						end
					end)
				end

				v12(readServerStatusText()) -- inferred equivalent call

				if QueueExperimentation.isInExperiment() then
					if v3.GetPlaceJoinState then
						local success, placeJoinState = pcall(v3.GetPlaceJoinState, v3)

						if success and type(placeJoinState) == "string" then
							v9(placeJoinState)

							if placeJoinState ~= Constants.QUEUED_STATE then
								v10(nil)
							end

							logQueueExposureIfNeeded(placeJoinState) -- inferred equivalent call
						end
					end

					if v3.PlaceJoinStateChanged then
						placeJoinStateChangedConnection = v3.PlaceJoinStateChanged:Connect(updateJoinState)
					end

					if engineFeature and v3.QueuePositionChanged then
						queuePositionChangedConnection = v3.QueuePositionChanged:Connect(updateQueuePosition)
					end

					if engineFeature then
						updateQueuePosition() -- inferred equivalent call
					end
				end

				if signal(false) <= 0 then
					local placeId = v2.PlaceId

					if not (flag or placeId <= 0) then
						if signal(false) == placeId then
							return
						end

						v5(placeId)
						placeIdChangedConnection = disconnect(placeIdChangedConnection) -- inferred equivalent call
						beginRequests(placeId) -- inferred equivalent call
					end
				else
					beginRequests(signal(false)) -- inferred equivalent call
				end
			else
				resolveChinaPolicy() -- inferred equivalent call
				beginRequests(signal(false)) -- inferred equivalent call
			end
		end,
		destroy = function()
			if flag then
				return
			end

			flag = true
			placeIdChangedConnection = disconnect(placeIdChangedConnection) -- inferred equivalent call
			gameIdChangedConnection = disconnect(gameIdChangedConnection) -- inferred equivalent call
			placeJoinStateChangedConnection = disconnect(placeJoinStateChangedConnection) -- inferred equivalent call
			queuePositionChangedConnection = disconnect(queuePositionChangedConnection) -- inferred equivalent call
			uiMessageChangedConnection = disconnect(uiMessageChangedConnection) -- inferred equivalent call
			cancel(thread) -- inferred equivalent call
			cancel(thread2) -- inferred equivalent call
			cancel(thread3) -- inferred equivalent call
			dataResolver.clear()
			dataCache.clear()
			dataResolver.dispose()

			if v18 and v4.CloseStatsBasedOnInputString then
				local inputBeganConnection = nil
				inputBeganConnection = UserInputService.InputBegan:Connect(function()
					if inputBeganConnection then
						inputBeganConnection:Disconnect()
						inputBeganConnection = nil
					end

					v4:CloseStatsBasedOnInputString("ConnectionHealth")
				end)
			end
		end
	}
end

return createTiltLoadingScreenModel

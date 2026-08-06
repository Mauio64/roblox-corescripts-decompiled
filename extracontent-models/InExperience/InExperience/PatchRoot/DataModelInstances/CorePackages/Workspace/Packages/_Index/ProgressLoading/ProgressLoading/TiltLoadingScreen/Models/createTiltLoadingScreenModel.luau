local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local TiltLoadingScreenParent = TiltLoadingScreen.Parent
local TiltLoadingScreenParentParent = TiltLoadingScreenParent.Parent
local Signals = require(TiltLoadingScreenParentParent.Signals)
local Http = require(TiltLoadingScreenParentParent.Http)
local DataHydration = require(TiltLoadingScreenParentParent.DataHydration)
local QueueExperimentation = require(TiltLoadingScreenParentParent.SocialExperiments).QueueExperimentation
local CachedPolicyService = require(TiltLoadingScreenParentParent.CachedPolicyService)
local MarketplaceGetMarketplaceAssetStore = require(TiltLoadingScreenParentParent.DataHydration.MarketplaceGetMarketplaceAssetStore)
local LoadingScreenTelemetry = require(TiltLoadingScreenParent.LoadingScreenTelemetry)
local SharedFlags = require(TiltLoadingScreenParentParent.SharedFlags)
local Constants = require(TiltLoadingScreen.Constants)
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local FFlagAddAutoTranslateToLoadingScreen = SharedFlags.FFlagAddAutoTranslateToLoadingScreen
local FFlagAutoTranslateSkipZeroUniverseId = SharedFlags.FFlagAutoTranslateSkipZeroUniverseId
local FFlagEnableLuaAppsFollowUserId = SharedFlags.FFlagEnableLuaAppsFollowUserId
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local EngineFeature = game:GetEngineFeature("QueuePositionEnabled")
local v24 = game:GetEngineFeature("ExperienceServiceFollowUserIdEnabled") and FFlagEnableLuaAppsFollowUserId
local EngineFeature2 = game:GetEngineFeature("PlaceJoinStateEnabled")
local v26 = Http.NetworkLayers.requestInternalWrapper(HttpService)

local function defaultFetchUniverseId(n1: number) -- line: 82
	-- upvalues: Http (copy), v26 (copy)
	local v33 = string.format("%suniverses/v1/places/%d/universe", Http.Url.APIS_URL, n1)
	local v34, v35 = v26(v33, "GET"):await()

	if not v34 or (not v35 or not v35.responseBody) then
		return nil
	end

	return v35.responseBody.universeId
end
local function defaultFetchProductInfo(n2: number) -- line: 91
	-- upvalues: MarketplaceService (copy)
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		return (MarketplaceService:GetProductInfoAsync(n2))
	end

	return (MarketplaceService:GetProductInfo(n2))
end
local function defaultFetchPlayerLocalizationChoice(s1: string) -- line: 98
	-- upvalues: v26 (copy), Http (copy)
	return v26(string.format("%sv1/user-localization-settings/player-choice/%s", Http.Url.GAME_INTERNATIONALIZATION_URL, s1), "GET"):andThen(function(p1) -- line: 106
		-- upvalues: s1 (copy)
		if not p1 or not p1.responseBody then
			error({
				errorType = "PlayerLocalizationChoiceResponseError",
				responseCode = p1 and p1.responseCode,
				errorMessage = not p1 and "No response" or "Missing response body",
				customFields = {
					universeId = s1
				}
			})
		end

		local responseBody = p1.responseBody

		if responseBody.IsPlayerChoiceEnabled == nil then
			error({
				errorType = "PlayerLocalizationChoiceMissingKey",
				errorMessage = "Missing IsPlayerChoiceEnabled in response body",
				responseCode = p1.responseCode,
				customFields = {
					universeId = s1,
					responseBody = responseBody
				}
			})
		end

		return responseBody
	end)
end
local function getQueueTreatment() -- line: 129
	-- upvalues: EngineFeature2 (copy), QueueExperimentation (copy), Constants (copy)
	if not EngineFeature2 then
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
local function createTiltLoadingScreenModel(n3: number, t1: {[any]: any}?) -- line: 142
	-- upvalues: ExperienceService (copy), GuiService (copy), defaultFetchUniverseId (copy), defaultFetchProductInfo (copy), CachedPolicyService (copy), defaultFetchPlayerLocalizationChoice (copy), MarketplaceGetMarketplaceAssetStore (copy), createDataCache (copy), createDataResolver (copy), LoadingScreenTelemetry (copy), Signals (copy), EngineFeature2 (copy), QueueExperimentation (copy), Constants (copy), FFlagAddAutoTranslateToLoadingScreen (copy), FFlagAutoTranslateSkipZeroUniverseId (copy), v24 (copy), EngineFeature (copy), UserInputService (copy)
	local v40 = if not t1 or not t1.dataModel then game else t1.dataModel
	local v41 = if not t1 or not t1.experienceService then ExperienceService else t1.experienceService
	local v42 = if not t1 or not t1.guiService then GuiService else t1.guiService
	local v43 = t1 and t1.fetchUniverseId or defaultFetchUniverseId
	local v44 = t1 and t1.fetchProductInfo or defaultFetchProductInfo
	local v45 = t1 and t1.fetchIsSubjectToChinaPolicies or function() -- line: 151
		-- upvalues: CachedPolicyService (copy)
		return CachedPolicyService:IsSubjectToChinaPolicies()
	end
	local v46 = t1 and t1.fetchPlayerLocalizationChoice or defaultFetchPlayerLocalizationChoice

	local function readServerStatusText() -- line: 157
		-- upvalues: v42 (copy)
		if not v42.GetUiMessage then
			return ""
		end

		local ok, result = pcall(v42.GetUiMessage, v42)

		if ok and type(result) == "string" then
			return result
		end

		return ""
	end

	local v48 = MarketplaceGetMarketplaceAssetStore(false)
	local v49 = createDataCache()
	local v50 = createDataResolver({
		supportsMultiGet = false,
		cache = v49,
		logError = function(p2) -- line: 169
			-- upvalues: LoadingScreenTelemetry (copy)
			if type(p2) == "table" then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					responseCode = p2.responseCode,
					errorType = p2.errorType
				})

				return
			end

			LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
				errorType = "PlayerLocalizationChoiceFetchError"
			})
		end,
		fetchFn = function(s2: string) -- line: 181
			-- upvalues: v46 (copy)
			return v46(s2)
		end
	})
	local v51 = if not (n3 > 0) then v40.PlaceId else n3
	local v52, v53 = Signals.createSignal(not (v51 > 0) and 0 or v51)
	local v54, v55 = Signals.createSignal(not (v40.GameId > 0) and 0 or v40.GameId)
	local v56 = if EngineFeature2 then if not QueueExperimentation.getIsAutoJoinNewServerEnabled() then if not QueueExperimentation.getIsJoinNewServerButtonEnabled() then nil else Constants.JOIN_NEW_SERVER_TREATMENT else Constants.AUTO_JOIN_TREATMENT else nil
	local v57 = Signals.createSignal(v56)
	local v58, v59 = Signals.createSignal("")
	local v60, v61 = Signals.createSignal(nil)
	local createSignal = Signals.createSignal
	local s3

	if not v42.GetUiMessage then
		s3 = ""
	else
		local ok, result = pcall(v42.GetUiMessage, v42)

		s3 = (not ok or type(result) ~= "string") and "" or result
	end

	local v66, v67 = createSignal(s3)
	local v68, v69 = Signals.createSignal(0)
	local v70, v71 = Signals.createSignal(false)
	local v72 = Signals.createComputed(function(p3) -- line: 197
		-- upvalues: v52 (copy), v48 (copy)
		local v109 = v52(p3)

		if v109 <= 0 then
			return nil
		end

		local v110 = v48.getMarketplaceAssetInfo((tostring(v109))).data(p3)

		if v110 then
			return {
				name = v110.name,
				creatorName = v110.creatorName,
				creatorHasVerifiedBadge = v110.creatorHasVerifiedBadge
			}
		end

		return nil
	end)
	local u73 = false
	local v74 = Signals.createComputed(function(p4) -- line: 213
		-- upvalues: FFlagAddAutoTranslateToLoadingScreen (copy), v54 (copy), FFlagAutoTranslateSkipZeroUniverseId (copy), u73 (ref), LoadingScreenTelemetry (copy), v50 (copy)
		if not FFlagAddAutoTranslateToLoadingScreen then
			return nil
		end

		local v112 = v54(p4)

		if FFlagAutoTranslateSkipZeroUniverseId and v112 <= 0 then
			if not u73 then
				u73 = true
				LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()
			end

			return nil
		end

		local v113 = v50.getAndFetchItem((tostring(v112))).data(p4)

		if v113 then
			return v113.IsPlayerChoiceEnabled
		end

		return nil
	end)
	local u75 = false
	local u76 = false
	local u77 = nil
	local u78 = nil
	local connection = nil
	local connection2 = nil
	local connection3 = nil
	local thread = nil
	local thread2 = nil
	local thread3 = nil
	local u85 = false
	local u86 = false

	local function cancel(p5: thread?) -- line: 244
		if p5 and coroutine.status(p5) ~= "dead" then
			task.cancel(p5)
		end
	end
	local function disconnect(p6) -- line: 250
		if p6 then
			p6:Disconnect()
		end

		return nil
	end
	local function readFollowUserId() -- line: 257
		-- upvalues: v24 (copy), v41 (copy)
		if not v24 or not v41.GetFollowUserId then
			return 0
		end

		local ok, result = pcall(v41.GetFollowUserId, v41)

		if ok and type(result) == "number" then
			return result
		end

		return 0
	end
	local function readExposureFollowUserId() -- line: 265
		-- upvalues: v41 (copy)
		if not v41.GetFollowUserId then
			return 0
		end

		local ok, result = pcall(v41.GetFollowUserId, v41)

		if ok and type(result) == "number" then
			return result
		end

		return 0
	end
	local function readQueuePosition() -- line: 273
		-- upvalues: EngineFeature (copy), v41 (copy)
		if not EngineFeature or not v41.GetQueuePosition then
			return nil
		end

		local ok, result = pcall(v41.GetQueuePosition, v41)

		if ok and type(result) == "number" then
			return result
		end

		return nil
	end
	local function updateQueuePosition() -- line: 281
		-- upvalues: v61 (copy), EngineFeature (copy), v41 (copy)
		local v122 = v61
		local v123

		if not EngineFeature or not v41.GetQueuePosition then
			v123 = nil
		else
			local ok, result = pcall(v41.GetQueuePosition, v41)

			v123 = if not ok or type(result) ~= "number" then nil else result
		end

		v122(v123)
	end
	local function logQueueExposureIfNeeded(s4: string) -- line: 285
		-- upvalues: u85 (ref), Constants (copy), v52 (copy), v41 (copy), QueueExperimentation (copy)
		if not u85 and (s4 == Constants.QUEUED_STATE and not (v52(false) <= 0)) then
			local n4

			if not v41.GetFollowUserId then
				n4 = 0
			else
				local ok, result = pcall(v41.GetFollowUserId, v41)

				n4 = (not ok or type(result) ~= "number") and 0 or result
			end

			if not (n4 <= 0) and QueueExperimentation.isInExperiment() then
				u85 = true
				QueueExperimentation.logExposure()

				return
			end
		end
	end
	local function updateJoinState(s5: string?) -- line: 299
		-- upvalues: v59 (copy), Constants (copy), v61 (copy), u85 (ref), v52 (copy), v41 (copy), QueueExperimentation (copy)
		if type(s5) ~= "string" then
			return
		end

		v59(s5)

		if s5 ~= Constants.QUEUED_STATE then
			v61(nil)
		end

		if not u85 and s5 == Constants.QUEUED_STATE and not (v52(false) <= 0) then
			local n5

			if not v41.GetFollowUserId then
				n5 = 0
			else
				local ok, result = pcall(v41.GetFollowUserId, v41)

				n5 = (not ok or type(result) ~= "number") and 0 or result
			end

			if not (n5 <= 0) then
				if not QueueExperimentation.isInExperiment() then
					return
				end

				u85 = true
				QueueExperimentation.logExposure()
			end
		end
	end
	local function resolveUniverseId(n6: number) -- line: 310
		-- upvalues: u76 (ref), v54 (copy), v55 (copy), u78 (ref)
		if u76 or (n6 <= 0 or v54(false) > 0) then
			return
		end

		v55(n6)

		local v135 = u78

		if v135 then
			v135:Disconnect()
		end

		u78 = nil
	end
	local function watchUniverseId() -- line: 318
		-- upvalues: u78 (ref), u76 (ref), v54 (copy), v40 (copy), v55 (copy)
		local v136 = u78

		if v136 then
			v136:Disconnect()
		end

		u78 = nil

		if u76 or v54(false) > 0 then
			return
		end

		u78 = v40:GetPropertyChangedSignal("GameId"):Connect(function() -- line: 323
			-- upvalues: v40 (copy), u76 (ref), v54 (copy), v55 (copy), u78 (ref)
			local GameId = v40.GameId

			if not u76 and not (GameId <= 0) then
				if v54(false) > 0 then
					return
				end

				v55(GameId)

				local v189 = u78

				if v189 then
					v189:Disconnect()
				end

				u78 = nil
			end
		end)

		local GameId = v40.GameId

		if not u76 and not (GameId <= 0) then
			if v54(false) > 0 then
				return
			end

			v55(GameId)

			local v138 = u78

			if v138 then
				v138:Disconnect()
			end

			u78 = nil
		end
	end
	local function fetchUniverseIdForPlace(n7: number) -- line: 329
		-- upvalues: v54 (copy), thread2 (ref), v43 (copy), u76 (ref), v52 (copy), v55 (copy), u78 (ref)
		if v54(false) > 0 then
			return
		end

		local v140 = thread2

		if v140 and coroutine.status(v140) ~= "dead" then
			task.cancel(v140)
		end

		thread2 = task.defer(function() -- line: 334
			-- upvalues: v43 (copy), n7 (copy), u76 (ref), v52 (copy), v54 (copy), v55 (copy), u78 (ref)
			local ok, result = pcall(v43, n7)

			if not u76 and (n7 == v52(false) and ok and type(result) == "number" and not u76 and not (result <= 0)) then
				if v54(false) > 0 then
					return
				end

				v55(result)

				local v192 = u78

				if v192 then
					v192:Disconnect()
				end

				u78 = nil
			end
		end)
	end
	local function fetchGameDataForPlace(n8: number) -- line: 342
		-- upvalues: thread (ref), v44 (copy), u76 (ref), v52 (copy), v48 (copy)
		local v142 = thread

		if v142 and coroutine.status(v142) ~= "dead" then
			task.cancel(v142)
		end

		thread = task.defer(function() -- line: 344
			-- upvalues: v44 (copy), n8 (copy), u76 (ref), v52 (copy), v48 (copy)
			local ok, result = pcall(v44, n8)

			if not ok then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

				return
			end

			if u76 or n8 ~= v52(false) then
				return
			end

			local Creator = result.Creator

			v48.updateMarketplaceAssetInfo(tostring(n8), {
				name = result.Name or "",
				creatorName = not Creator and "" or (Creator.Name or ""),
				creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
			})
		end)
	end
	local function resolveChinaPolicy() -- line: 363
		-- upvalues: thread3 (ref), v45 (copy), u76 (ref), v71 (copy)
		local v143 = thread3

		if v143 and coroutine.status(v143) ~= "dead" then
			task.cancel(v143)
		end

		thread3 = task.defer(function() -- line: 365
			-- upvalues: v45 (copy), u76 (ref), v71 (copy)
			local ok, result = pcall(v45)

			if not u76 and (ok and type(result) == "boolean") then
				v71(result)
			end
		end)
	end
	local function beginRequests(n9: number) -- line: 373
		-- upvalues: thread (ref), v44 (copy), u76 (ref), v52 (copy), v48 (copy), v54 (copy), thread2 (ref), v43 (copy), v55 (copy), u78 (ref)
		if n9 <= 0 then
			return
		end

		local v145 = thread

		if v145 and coroutine.status(v145) ~= "dead" then
			task.cancel(v145)
		end

		thread = task.defer(function() -- line: 344
			-- upvalues: v44 (copy), n9 (copy), u76 (ref), v52 (copy), v48 (copy)
			local ok, result = pcall(v44, n9)

			if not ok then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

				return
			end

			if u76 or n9 ~= v52(false) then
				return
			end

			local Creator = result.Creator

			v48.updateMarketplaceAssetInfo(tostring(n9), {
				name = result.Name or "",
				creatorName = not Creator and "" or (Creator.Name or ""),
				creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
			})
		end)

		if v54(false) > 0 then
			return
		end

		local v146 = thread2

		if v146 and coroutine.status(v146) ~= "dead" then
			task.cancel(v146)
		end

		thread2 = task.defer(function() -- line: 334
			-- upvalues: v43 (copy), n9 (copy), u76 (ref), v52 (copy), v54 (copy), v55 (copy), u78 (ref)
			local ok, result = pcall(v43, n9)

			if not u76 and (n9 == v52(false) and ok and type(result) == "number" and not u76 and not (result <= 0)) then
				if v54(false) > 0 then
					return
				end

				v55(result)

				local v203 = u78

				if v203 then
					v203:Disconnect()
				end

				u78 = nil
			end
		end)
	end
	local function resolvePlaceId(n10: number) -- line: 381
		-- upvalues: u76 (ref), v52 (copy), v53 (copy), u77 (ref), thread (ref), v44 (copy), v48 (copy), v54 (copy), thread2 (ref), v43 (copy), v55 (copy), u78 (ref)
		if u76 or (n10 <= 0 or n10 == v52(false)) then
			return
		end

		v53(n10)

		local v148 = u77

		if v148 then
			v148:Disconnect()
		end

		u77 = nil

		if n10 <= 0 then
			return
		end

		local v149 = thread

		if v149 and coroutine.status(v149) ~= "dead" then
			task.cancel(v149)
		end

		thread = task.defer(function() -- line: 344
			-- upvalues: v44 (copy), n10 (copy), u76 (ref), v52 (copy), v48 (copy)
			local ok, result = pcall(v44, n10)

			if not ok then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

				return
			end

			if u76 or n10 ~= v52(false) then
				return
			end

			local Creator = result.Creator

			v48.updateMarketplaceAssetInfo(tostring(n10), {
				name = result.Name or "",
				creatorName = not Creator and "" or (Creator.Name or ""),
				creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
			})
		end)

		if v54(false) > 0 then
			return
		end

		local v150 = thread2

		if v150 and coroutine.status(v150) ~= "dead" then
			task.cancel(v150)
		end

		thread2 = task.defer(function() -- line: 334
			-- upvalues: v43 (copy), n10 (copy), u76 (ref), v52 (copy), v54 (copy), v55 (copy), u78 (ref)
			local ok, result = pcall(v43, n10)

			if not u76 and (n10 == v52(false) and ok and type(result) == "number" and not u76 and not (result <= 0)) then
				if v54(false) > 0 then
					return
				end

				v55(result)

				local v209 = u78

				if v209 then
					v209:Disconnect()
				end

				u78 = nil
			end
		end)
	end

	return {
		getAssetInfo = v72,
		getFollowUserId = v68,
		getIsAutoTranslated = v74,
		getIsSubjectToChinaPolicies = v70,
		getJoinState = v58,
		getQueuePosition = v60,
		getQueueTreatment = v57,
		getServerStatusText = v66,
		getUniverseId = v54,
		launchExperience = function() -- line: 465
			-- upvalues: v52 (copy), v41 (copy)
			local v185 = v52(false)

			if v185 > 0 and v41.LaunchExperience then
				v41:LaunchExperience({
					placeId = v185
				})
			end
		end,
		logQueuedStateButtonClick = function(s6: string, n11: number?) -- line: 479
			-- upvalues: v56 (copy), LoadingScreenTelemetry (copy), v24 (copy), v68 (copy), v52 (copy), EngineFeature (copy), v60 (copy), v54 (copy)
			if not v56 then
				return
			end

			LoadingScreenTelemetry.logQueuedStateButtonClick({
				buttonName = s6,
				joinTargetUserId = if not v24 then nil else v68(false),
				placeId = v52(false),
				positionInQueue = if not EngineFeature then nil else v60(false),
				timeElapsedMs = n11,
				universeId = v54(false)
			})
		end,
		showConnectionHealth = function() -- line: 472
			-- upvalues: v42 (copy), u86 (ref)
			if v42.ShowStatsBasedOnInputString then
				u86 = true
				v42:ShowStatsBasedOnInputString("ConnectionHealth")
			end
		end,
		start = function() -- line: 391
			-- upvalues: u75 (ref), u76 (ref), v52 (copy), u77 (ref), v40 (copy), v53 (copy), thread (ref), v44 (copy), v48 (copy), v54 (copy), thread2 (ref), v43 (copy), v55 (copy), u78 (ref), watchUniverseId (copy), thread3 (ref), v45 (copy), v71 (copy), v69 (copy), v24 (copy), v41 (copy), v42 (copy), connection3 (ref), v67 (copy), QueueExperimentation (copy), v59 (copy), Constants (copy), v61 (copy), u85 (ref), connection (ref), updateJoinState (copy), EngineFeature (copy), connection2 (ref), updateQueuePosition (copy)
			if u75 or u76 then
				return
			end

			u75 = true

			if v52(false) <= 0 then
				u77 = v40:GetPropertyChangedSignal("PlaceId"):Connect(function() -- line: 397
					-- upvalues: v40 (copy), u76 (ref), v52 (copy), v53 (copy), u77 (ref), thread (ref), v44 (copy), v48 (copy), v54 (copy), thread2 (ref), v43 (copy), v55 (copy), u78 (ref)
					local PlaceId = v40.PlaceId

					if not u76 and not (PlaceId <= 0) then
						if PlaceId == v52(false) then
							return
						end

						v53(PlaceId)

						local v211 = u77

						if v211 then
							v211:Disconnect()
						end

						u77 = nil

						if PlaceId <= 0 then
							return
						end

						local v212 = thread

						if v212 and coroutine.status(v212) ~= "dead" then
							task.cancel(v212)
						end

						thread = task.defer(function() -- line: 344
							-- upvalues: v44 (copy), PlaceId (copy), u76 (ref), v52 (copy), v48 (copy)
							local ok, result = pcall(v44, PlaceId)

							if not ok then
								print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

								return
							end

							if u76 or PlaceId ~= v52(false) then
								return
							end

							local Creator = result.Creator

							v48.updateMarketplaceAssetInfo(tostring(PlaceId), {
								name = result.Name or "",
								creatorName = not Creator and "" or (Creator.Name or ""),
								creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
							})
						end)

						if v54(false) > 0 then
							return
						end

						local v213 = thread2

						if v213 and coroutine.status(v213) ~= "dead" then
							task.cancel(v213)
						end

						thread2 = task.defer(function() -- line: 334
							-- upvalues: v43 (copy), PlaceId (copy), u76 (ref), v52 (copy), v54 (copy), v55 (copy), u78 (ref)
							local ok, result = pcall(v43, PlaceId)

							if not u76 and (PlaceId == v52(false) and ok and type(result) == "number" and not u76 and not (result <= 0)) then
								if v54(false) > 0 then
									return
								end

								v55(result)

								local v235 = u78

								if v235 then
									v235:Disconnect()
								end

								u78 = nil
							end
						end)
					end
				end)
			end

			watchUniverseId()

			local v151 = thread3

			if v151 and coroutine.status(v151) ~= "dead" then
				task.cancel(v151)
			end

			thread3 = task.defer(function() -- line: 365
				-- upvalues: v45 (copy), u76 (ref), v71 (copy)
				local ok, result = pcall(v45)

				if not u76 and (ok and type(result) == "boolean") then
					v71(result)
				end
			end)

			local v152 = v69
			local n12

			if not v24 or not v41.GetFollowUserId then
				n12 = 0
			else
				local ok, result = pcall(v41.GetFollowUserId, v41)

				n12 = (not ok or type(result) ~= "number") and 0 or result
			end

			v152(n12)

			if v42.UiMessageChanged then
				connection3 = v42.UiMessageChanged:Connect(function(p7, p8) -- line: 405
					-- upvalues: v67 (copy)
					if p7 == Enum.UiMessageType.UiMessageInfo and type(p8) == "string" then
						v67(p8)
					end
				end)
			end

			local v156 = v67
			local s7

			if not v42.GetUiMessage then
				s7 = ""
			else
				local ok, result = pcall(v42.GetUiMessage, v42)

				s7 = (not ok or type(result) ~= "string") and "" or result
			end

			v156(s7)

			if QueueExperimentation.isInExperiment() then
				if v41.GetPlaceJoinState then
					local ok, result = pcall(v41.GetPlaceJoinState, v41)

					if ok and type(result) == "string" then
						v59(result)

						if result ~= Constants.QUEUED_STATE then
							v61(nil)
						end

						if not u85 and result == Constants.QUEUED_STATE and not (v52(false) <= 0) then
							local n13

							if not v41.GetFollowUserId then
								n13 = 0
							else
								local ok2, result2 = pcall(v41.GetFollowUserId, v41)

								n13 = (not ok2 or type(result2) ~= "number") and 0 or result2
							end

							if not (n13 <= 0) and QueueExperimentation.isInExperiment() then
								u85 = true
								QueueExperimentation.logExposure()
							end
						end
					end
				end

				if v41.PlaceJoinStateChanged then
					connection = v41.PlaceJoinStateChanged:Connect(updateJoinState)
				end

				if EngineFeature and v41.QueuePositionChanged then
					connection2 = v41.QueuePositionChanged:Connect(updateQueuePosition)
				end

				if EngineFeature then
					local v165 = v61
					local v166

					if not EngineFeature or not v41.GetQueuePosition then
						v166 = nil
					else
						local ok, result = pcall(v41.GetQueuePosition, v41)

						v166 = if not ok or type(result) ~= "number" then nil else result
					end

					v165(v166)
				end
			end

			if v52(false) <= 0 then
				local PlaceId = v40.PlaceId

				if not u76 and not (PlaceId <= 0) then
					if PlaceId == v52(false) then
						return
					end

					v53(PlaceId)

					local v170 = u77

					if v170 then
						v170:Disconnect()
					end

					u77 = nil

					if PlaceId <= 0 then
						return
					end

					local v171 = thread

					if v171 and coroutine.status(v171) ~= "dead" then
						task.cancel(v171)
					end

					thread = task.defer(function() -- line: 344
						-- upvalues: v44 (copy), PlaceId (copy), u76 (ref), v52 (copy), v48 (copy)
						local ok, result = pcall(v44, PlaceId)

						if not ok then
							print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

							return
						end

						if u76 or PlaceId ~= v52(false) then
							return
						end

						local Creator = result.Creator

						v48.updateMarketplaceAssetInfo(tostring(PlaceId), {
							name = result.Name or "",
							creatorName = not Creator and "" or (Creator.Name or ""),
							creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
						})
					end)

					if v54(false) > 0 then
						return
					end

					local v172 = thread2

					if v172 and coroutine.status(v172) ~= "dead" then
						task.cancel(v172)
					end

					thread2 = task.defer(function() -- line: 334
						-- upvalues: v43 (copy), PlaceId (copy), u76 (ref), v52 (copy), v54 (copy), v55 (copy), u78 (ref)
						local ok, result = pcall(v43, PlaceId)

						if not u76 and (PlaceId == v52(false) and ok and type(result) == "number" and not u76 and not (result <= 0)) then
							if v54(false) > 0 then
								return
							end

							v55(result)

							local v223 = u78

							if v223 then
								v223:Disconnect()
							end

							u78 = nil
						end
					end)

					return
				end
			else
				local v173 = v52(false)

				if v173 <= 0 then
					return
				end

				local v174 = thread

				if v174 and coroutine.status(v174) ~= "dead" then
					task.cancel(v174)
				end

				thread = task.defer(function() -- line: 344
					-- upvalues: v44 (copy), v173 (copy), u76 (ref), v52 (copy), v48 (copy)
					local ok, result = pcall(v44, v173)

					if not ok then
						print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

						return
					end

					if u76 or v173 ~= v52(false) then
						return
					end

					local Creator = result.Creator

					v48.updateMarketplaceAssetInfo(tostring(v173), {
						name = result.Name or "",
						creatorName = not Creator and "" or (Creator.Name or ""),
						creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
					})
				end)

				if v54(false) > 0 then
					return
				end

				local v175 = thread2

				if v175 and coroutine.status(v175) ~= "dead" then
					task.cancel(v175)
				end

				thread2 = task.defer(function() -- line: 334
					-- upvalues: v43 (copy), v173 (copy), u76 (ref), v52 (copy), v54 (copy), v55 (copy), u78 (ref)
					local ok, result = pcall(v43, v173)

					if not u76 and (v173 == v52(false) and ok and type(result) == "number" and not u76 and not (result <= 0)) then
						if v54(false) > 0 then
							return
						end

						v55(result)

						local v229 = u78

						if v229 then
							v229:Disconnect()
						end

						u78 = nil
					end
				end)
			end
		end,
		destroy = function() -- line: 437
			-- upvalues: u76 (ref), u77 (ref), u78 (ref), connection (ref), connection2 (ref), connection3 (ref), thread (ref), thread2 (ref), thread3 (ref), v50 (copy), v49 (copy), u86 (ref), v42 (copy), UserInputService (copy)
			if u76 then
				return
			end

			u76 = true

			local v176 = u77

			if v176 then
				v176:Disconnect()
			end

			u77 = nil

			local v177 = u78

			if v177 then
				v177:Disconnect()
			end

			u78 = nil

			local v178 = connection

			if v178 then
				v178:Disconnect()
			end

			connection = nil

			local v179 = connection2

			if v179 then
				v179:Disconnect()
			end

			connection2 = nil

			local v180 = connection3

			if v180 then
				v180:Disconnect()
			end

			connection3 = nil

			local v181 = thread

			if v181 and coroutine.status(v181) ~= "dead" then
				task.cancel(v181)
			end

			local v182 = thread2

			if v182 and coroutine.status(v182) ~= "dead" then
				task.cancel(v182)
			end

			local v183 = thread3

			if v183 and coroutine.status(v183) ~= "dead" then
				task.cancel(v183)
			end

			v50.clear()
			v49.clear()
			v50.dispose()

			if u86 and v42.CloseStatsBasedOnInputString then
				local u184 = nil

				u184 = UserInputService.InputBegan:Connect(function() -- line: 455
					-- upvalues: u184 (ref), v42 (copy)
					if u184 then
						u184:Disconnect()
						u184 = nil
					end

					v42:CloseStatsBasedOnInputString("ConnectionHealth")
				end)
			end
		end
	}
end

return createTiltLoadingScreenModel

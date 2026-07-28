local Parent = script:FindFirstAncestor("TiltLoadingScreen").Parent
local ParentParent = Parent.Parent
local Signals = require(ParentParent.Signals)
local Http = require(ParentParent.Http)
local DataHydration = require(ParentParent.DataHydration)
local MarketplaceGetMarketplaceAssetStore = require(ParentParent.DataHydration.MarketplaceGetMarketplaceAssetStore)
local LoadingScreenTelemetry = require(Parent.LoadingScreenTelemetry)
local SharedFlags = require(ParentParent.SharedFlags)
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local FFlagAddAutoTranslateToLoadingScreen = SharedFlags.FFlagAddAutoTranslateToLoadingScreen
local FFlagAutoTranslateSkipZeroUniverseId = SharedFlags.FFlagAutoTranslateSkipZeroUniverseId
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local v15 = Http.NetworkLayers.requestInternalWrapper(HttpService)

local function defaultFetchUniverseId(n1: number) -- line: 59
	-- upvalues: Http (copy), v15 (copy)
	local v21 = string.format("%suniverses/v1/places/%d/universe", Http.Url.APIS_URL, n1)
	local v22, v23 = v15(v21, "GET"):await()

	if not v22 or (not v23 or not v23.responseBody) then
		return nil
	end

	return v23.responseBody.universeId
end
local function defaultFetchProductInfo(n2: number) -- line: 68
	-- upvalues: MarketplaceService (copy)
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		return (MarketplaceService:GetProductInfoAsync(n2))
	end

	return (MarketplaceService:GetProductInfo(n2))
end
local function defaultFetchPlayerLocalizationChoice(s1: string) -- line: 75
	-- upvalues: v15 (copy), Http (copy)
	return v15(string.format("%sv1/user-localization-settings/player-choice/%s", Http.Url.GAME_INTERNATIONALIZATION_URL, s1), "GET"):andThen(function(p1) -- line: 83
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
local function createTiltLoadingScreenModel(n3: number, t1: {[any]: any}?) -- line: 106
	-- upvalues: defaultFetchUniverseId (copy), defaultFetchProductInfo (copy), defaultFetchPlayerLocalizationChoice (copy), MarketplaceGetMarketplaceAssetStore (copy), createDataCache (copy), createDataResolver (copy), LoadingScreenTelemetry (copy), Signals (copy), FFlagAddAutoTranslateToLoadingScreen (copy), FFlagAutoTranslateSkipZeroUniverseId (copy)
	local v28 = if not t1 or not t1.dataModel then game else t1.dataModel
	local v29 = t1 and t1.fetchUniverseId or defaultFetchUniverseId
	local v30 = t1 and t1.fetchProductInfo or defaultFetchProductInfo
	local v31 = t1 and t1.fetchPlayerLocalizationChoice or defaultFetchPlayerLocalizationChoice
	local v32 = MarketplaceGetMarketplaceAssetStore(false)
	local v33 = createDataCache()
	local v34 = createDataResolver({
		supportsMultiGet = false,
		cache = v33,
		logError = function(p2) -- line: 118
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
		fetchFn = function(s2: string) -- line: 130
			-- upvalues: v31 (copy)
			return v31(s2)
		end
	})
	local v35 = if not (n3 > 0) then v28.PlaceId else n3
	local v36, v37 = Signals.createSignal(not (v35 > 0) and 0 or v35)
	local v38, v39 = Signals.createSignal(not (v28.GameId > 0) and 0 or v28.GameId)
	local v40 = Signals.createComputed(function(p3) -- line: 139
		-- upvalues: v36 (copy), v32 (copy)
		local v62 = v36(p3)

		if v62 <= 0 then
			return nil
		end

		local v63 = v32.getMarketplaceAssetInfo((tostring(v62))).data(p3)

		if v63 then
			return {
				name = v63.name,
				creatorName = v63.creatorName,
				creatorHasVerifiedBadge = v63.creatorHasVerifiedBadge
			}
		end

		return nil
	end)
	local u41 = false
	local v42 = Signals.createComputed(function(p4) -- line: 155
		-- upvalues: FFlagAddAutoTranslateToLoadingScreen (copy), v38 (copy), FFlagAutoTranslateSkipZeroUniverseId (copy), u41 (ref), LoadingScreenTelemetry (copy), v34 (copy)
		if not FFlagAddAutoTranslateToLoadingScreen then
			return nil
		end

		local v65 = v38(p4)

		if FFlagAutoTranslateSkipZeroUniverseId and v65 <= 0 then
			if not u41 then
				u41 = true
				LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()
			end

			return nil
		end

		local v66 = v34.getAndFetchItem((tostring(v65))).data(p4)

		if v66 then
			return v66.IsPlayerChoiceEnabled
		end

		return nil
	end)
	local u43 = false
	local u44 = false
	local u45 = nil
	local u46 = nil
	local thread = nil
	local thread2 = nil

	local function cancel(p5: thread?) -- line: 180
		if p5 and coroutine.status(p5) ~= "dead" then
			task.cancel(p5)
		end
	end
	local function disconnect(p6) -- line: 186
		if p6 then
			p6:Disconnect()
		end

		return nil
	end
	local function resolveUniverseId(n4: number) -- line: 193
		-- upvalues: u44 (ref), v38 (copy), v39 (copy), u46 (ref)
		if u44 or (n4 <= 0 or v38(false) > 0) then
			return
		end

		v39(n4)

		local v70 = u46

		if v70 then
			v70:Disconnect()
		end

		u46 = nil
	end
	local function watchUniverseId() -- line: 201
		-- upvalues: u46 (ref), u44 (ref), v38 (copy), v28 (copy), v39 (copy)
		local v71 = u46

		if v71 then
			v71:Disconnect()
		end

		u46 = nil

		if u44 or v38(false) > 0 then
			return
		end

		u46 = v28:GetPropertyChangedSignal("GameId"):Connect(function() -- line: 206
			-- upvalues: v28 (copy), u44 (ref), v38 (copy), v39 (copy), u46 (ref)
			local GameId = v28.GameId

			if not u44 and not (GameId <= 0) then
				if v38(false) > 0 then
					return
				end

				v39(GameId)

				local v97 = u46

				if v97 then
					v97:Disconnect()
				end

				u46 = nil
			end
		end)

		local GameId = v28.GameId

		if not u44 and not (GameId <= 0) then
			if v38(false) > 0 then
				return
			end

			v39(GameId)

			local v73 = u46

			if v73 then
				v73:Disconnect()
			end

			u46 = nil
		end
	end
	local function fetchUniverseIdForPlace(n5: number) -- line: 212
		-- upvalues: v38 (copy), thread2 (ref), v29 (copy), u44 (ref), v36 (copy), v39 (copy), u46 (ref)
		if v38(false) > 0 then
			return
		end

		local v75 = thread2

		if v75 and coroutine.status(v75) ~= "dead" then
			task.cancel(v75)
		end

		thread2 = task.defer(function() -- line: 217
			-- upvalues: v29 (copy), n5 (copy), u44 (ref), v36 (copy), v38 (copy), v39 (copy), u46 (ref)
			local ok, result = pcall(v29, n5)

			if not u44 and (n5 == v36(false) and ok and type(result) == "number" and not u44 and not (result <= 0)) then
				if v38(false) > 0 then
					return
				end

				v39(result)

				local v100 = u46

				if v100 then
					v100:Disconnect()
				end

				u46 = nil
			end
		end)
	end
	local function fetchGameDataForPlace(n6: number) -- line: 225
		-- upvalues: thread (ref), v30 (copy), u44 (ref), v36 (copy), v32 (copy)
		local v77 = thread

		if v77 and coroutine.status(v77) ~= "dead" then
			task.cancel(v77)
		end

		thread = task.defer(function() -- line: 227
			-- upvalues: v30 (copy), n6 (copy), u44 (ref), v36 (copy), v32 (copy)
			local ok, result = pcall(v30, n6)

			if not ok then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

				return
			end

			if u44 or n6 ~= v36(false) then
				return
			end

			local Creator = result.Creator

			v32.updateMarketplaceAssetInfo(tostring(n6), {
				name = result.Name or "",
				creatorName = not Creator and "" or (Creator.Name or ""),
				creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
			})
		end)
	end
	local function beginRequests(n7: number) -- line: 246
		-- upvalues: thread (ref), v30 (copy), u44 (ref), v36 (copy), v32 (copy), v38 (copy), thread2 (ref), v29 (copy), v39 (copy), u46 (ref)
		if n7 <= 0 then
			return
		end

		local v79 = thread

		if v79 and coroutine.status(v79) ~= "dead" then
			task.cancel(v79)
		end

		thread = task.defer(function() -- line: 227
			-- upvalues: v30 (copy), n7 (copy), u44 (ref), v36 (copy), v32 (copy)
			local ok, result = pcall(v30, n7)

			if not ok then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

				return
			end

			if u44 or n7 ~= v36(false) then
				return
			end

			local Creator = result.Creator

			v32.updateMarketplaceAssetInfo(tostring(n7), {
				name = result.Name or "",
				creatorName = not Creator and "" or (Creator.Name or ""),
				creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
			})
		end)

		if v38(false) > 0 then
			return
		end

		local v80 = thread2

		if v80 and coroutine.status(v80) ~= "dead" then
			task.cancel(v80)
		end

		thread2 = task.defer(function() -- line: 217
			-- upvalues: v29 (copy), n7 (copy), u44 (ref), v36 (copy), v38 (copy), v39 (copy), u46 (ref)
			local ok, result = pcall(v29, n7)

			if not u44 and (n7 == v36(false) and ok and type(result) == "number" and not u44 and not (result <= 0)) then
				if v38(false) > 0 then
					return
				end

				v39(result)

				local v109 = u46

				if v109 then
					v109:Disconnect()
				end

				u46 = nil
			end
		end)
	end
	local function resolvePlaceId(n8: number) -- line: 254
		-- upvalues: u44 (ref), v36 (copy), v37 (copy), u45 (ref), thread (ref), v30 (copy), v32 (copy), v38 (copy), thread2 (ref), v29 (copy), v39 (copy), u46 (ref)
		if u44 or (n8 <= 0 or n8 == v36(false)) then
			return
		end

		v37(n8)

		local v82 = u45

		if v82 then
			v82:Disconnect()
		end

		u45 = nil

		if n8 <= 0 then
			return
		end

		local v83 = thread

		if v83 and coroutine.status(v83) ~= "dead" then
			task.cancel(v83)
		end

		thread = task.defer(function() -- line: 227
			-- upvalues: v30 (copy), n8 (copy), u44 (ref), v36 (copy), v32 (copy)
			local ok, result = pcall(v30, n8)

			if not ok then
				print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

				return
			end

			if u44 or n8 ~= v36(false) then
				return
			end

			local Creator = result.Creator

			v32.updateMarketplaceAssetInfo(tostring(n8), {
				name = result.Name or "",
				creatorName = not Creator and "" or (Creator.Name or ""),
				creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
			})
		end)

		if v38(false) > 0 then
			return
		end

		local v84 = thread2

		if v84 and coroutine.status(v84) ~= "dead" then
			task.cancel(v84)
		end

		thread2 = task.defer(function() -- line: 217
			-- upvalues: v29 (copy), n8 (copy), u44 (ref), v36 (copy), v38 (copy), v39 (copy), u46 (ref)
			local ok, result = pcall(v29, n8)

			if not u44 and (n8 == v36(false) and ok and type(result) == "number" and not u44 and not (result <= 0)) then
				if v38(false) > 0 then
					return
				end

				v39(result)

				local v115 = u46

				if v115 then
					v115:Disconnect()
				end

				u46 = nil
			end
		end)
	end

	return {
		getAssetInfo = v40,
		getIsAutoTranslated = v42,
		getUniverseId = v38,
		start = function() -- line: 264
			-- upvalues: u43 (ref), u44 (ref), v36 (copy), u45 (ref), v28 (copy), v37 (copy), thread (ref), v30 (copy), v32 (copy), v38 (copy), thread2 (ref), v29 (copy), v39 (copy), u46 (ref), watchUniverseId (copy)
			if u43 or u44 then
				return
			end

			u43 = true

			if v36(false) <= 0 then
				u45 = v28:GetPropertyChangedSignal("PlaceId"):Connect(function() -- line: 270
					-- upvalues: v28 (copy), u44 (ref), v36 (copy), v37 (copy), u45 (ref), thread (ref), v30 (copy), v32 (copy), v38 (copy), thread2 (ref), v29 (copy), v39 (copy), u46 (ref)
					local PlaceId = v28.PlaceId

					if not u44 and not (PlaceId <= 0) then
						if PlaceId == v36(false) then
							return
						end

						v37(PlaceId)

						local v117 = u45

						if v117 then
							v117:Disconnect()
						end

						u45 = nil

						if PlaceId <= 0 then
							return
						end

						local v118 = thread

						if v118 and coroutine.status(v118) ~= "dead" then
							task.cancel(v118)
						end

						thread = task.defer(function() -- line: 227
							-- upvalues: v30 (copy), PlaceId (copy), u44 (ref), v36 (copy), v32 (copy)
							local ok, result = pcall(v30, PlaceId)

							if not ok then
								print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

								return
							end

							if u44 or PlaceId ~= v36(false) then
								return
							end

							local Creator = result.Creator

							v32.updateMarketplaceAssetInfo(tostring(PlaceId), {
								name = result.Name or "",
								creatorName = not Creator and "" or (Creator.Name or ""),
								creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
							})
						end)

						if v38(false) > 0 then
							return
						end

						local v119 = thread2

						if v119 and coroutine.status(v119) ~= "dead" then
							task.cancel(v119)
						end

						thread2 = task.defer(function() -- line: 217
							-- upvalues: v29 (copy), PlaceId (copy), u44 (ref), v36 (copy), v38 (copy), v39 (copy), u46 (ref)
							local ok, result = pcall(v29, PlaceId)

							if not u44 and (PlaceId == v36(false) and ok and type(result) == "number" and not u44 and not (result <= 0)) then
								if v38(false) > 0 then
									return
								end

								v39(result)

								local v137 = u46

								if v137 then
									v137:Disconnect()
								end

								u46 = nil
							end
						end)
					end
				end)
			end

			watchUniverseId()

			if v36(false) <= 0 then
				local PlaceId = v28.PlaceId

				if not u44 and not (PlaceId <= 0) then
					if PlaceId == v36(false) then
						return
					end

					v37(PlaceId)

					local v86 = u45

					if v86 then
						v86:Disconnect()
					end

					u45 = nil

					if PlaceId <= 0 then
						return
					end

					local v87 = thread

					if v87 and coroutine.status(v87) ~= "dead" then
						task.cancel(v87)
					end

					thread = task.defer(function() -- line: 227
						-- upvalues: v30 (copy), PlaceId (copy), u44 (ref), v36 (copy), v32 (copy)
						local ok, result = pcall(v30, PlaceId)

						if not ok then
							print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

							return
						end

						if u44 or PlaceId ~= v36(false) then
							return
						end

						local Creator = result.Creator

						v32.updateMarketplaceAssetInfo(tostring(PlaceId), {
							name = result.Name or "",
							creatorName = not Creator and "" or (Creator.Name or ""),
							creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
						})
					end)

					if v38(false) > 0 then
						return
					end

					local v88 = thread2

					if v88 and coroutine.status(v88) ~= "dead" then
						task.cancel(v88)
					end

					thread2 = task.defer(function() -- line: 217
						-- upvalues: v29 (copy), PlaceId (copy), u44 (ref), v36 (copy), v38 (copy), v39 (copy), u46 (ref)
						local ok, result = pcall(v29, PlaceId)

						if not u44 and (PlaceId == v36(false) and ok and type(result) == "number" and not u44 and not (result <= 0)) then
							if v38(false) > 0 then
								return
							end

							v39(result)

							local v125 = u46

							if v125 then
								v125:Disconnect()
							end

							u46 = nil
						end
					end)

					return
				end
			else
				local v89 = v36(false)

				if v89 <= 0 then
					return
				end

				local v90 = thread

				if v90 and coroutine.status(v90) ~= "dead" then
					task.cancel(v90)
				end

				thread = task.defer(function() -- line: 227
					-- upvalues: v30 (copy), v89 (copy), u44 (ref), v36 (copy), v32 (copy)
					local ok, result = pcall(v30, v89)

					if not ok then
						print(string.format("LoadingScreen:GetGameProductInfo: %s", (tostring(result))))

						return
					end

					if u44 or v89 ~= v36(false) then
						return
					end

					local Creator = result.Creator

					v32.updateMarketplaceAssetInfo(tostring(v89), {
						name = result.Name or "",
						creatorName = not Creator and "" or (Creator.Name or ""),
						creatorHasVerifiedBadge = not not Creator and Creator.HasVerifiedBadge == true
					})
				end)

				if v38(false) > 0 then
					return
				end

				local v91 = thread2

				if v91 and coroutine.status(v91) ~= "dead" then
					task.cancel(v91)
				end

				thread2 = task.defer(function() -- line: 217
					-- upvalues: v29 (copy), v89 (copy), u44 (ref), v36 (copy), v38 (copy), v39 (copy), u46 (ref)
					local ok, result = pcall(v29, v89)

					if not u44 and (v89 == v36(false) and ok and type(result) == "number" and not u44 and not (result <= 0)) then
						if v38(false) > 0 then
							return
						end

						v39(result)

						local v131 = u46

						if v131 then
							v131:Disconnect()
						end

						u46 = nil
					end
				end)
			end
		end,
		destroy = function() -- line: 283
			-- upvalues: u44 (ref), u45 (ref), u46 (ref), thread (ref), thread2 (ref), v34 (copy), v33 (copy)
			if u44 then
				return
			end

			u44 = true

			local v92 = u45

			if v92 then
				v92:Disconnect()
			end

			u45 = nil

			local v93 = u46

			if v93 then
				v93:Disconnect()
			end

			u46 = nil

			local v94 = thread

			if v94 and coroutine.status(v94) ~= "dead" then
				task.cancel(v94)
			end

			local v95 = thread2

			if v95 and coroutine.status(v95) ~= "dead" then
				task.cancel(v95)
			end

			v34.clear()
			v33.clear()
			v34.dispose()
		end
	}
end

return createTiltLoadingScreenModel

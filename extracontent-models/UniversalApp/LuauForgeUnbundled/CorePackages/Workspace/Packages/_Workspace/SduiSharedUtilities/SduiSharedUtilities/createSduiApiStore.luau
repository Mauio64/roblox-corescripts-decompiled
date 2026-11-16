local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Signals")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/HttpClient")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/DataHydration")
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local getLocalPlayerUserId = DataHydration.DataHydrationUtils.getLocalPlayerUserId

local SduiIntegrationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")
local sduiRequestConcurrencyPolicy = SduiIntegrationTypes.SduiRequestConcurrencyPolicy
local sduiRequestStatus = SduiIntegrationTypes.SduiRequestStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local SduiProtobufResponseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiProtobufResponseHelpers")
local makeProtoResponseDecoder = SduiProtobufResponseHelpers.makeProtoResponseDecoder
local makeProtobufJsonResponseDecoder = SduiProtobufResponseHelpers.makeProtobufJsonResponseDecoder
local sduiResponseType = SduiIntegrationTypes.SduiResponseType
local handleSduiApiResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/handleSduiApiResponse")
local SduiPageAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageAnalytics")
local SduiApiStorePostConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiApiStorePostConfig")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiApiRequestConfig")
local buildSduiRequestHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/buildSduiRequestHeaders")
local createSduiStreamingResponseHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/createSduiStreamingResponseHandler")
local SduiRetryPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiRetryPolicy")
local sendSduiHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/sendSduiHttpRequest")
local fFlagSduiAllowNoConfigsBuilt = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAllowNoConfigsBuilt
local fFlagSduiAlwaysCacheWithIdentifier = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAlwaysCacheWithIdentifier
local fFlagLuaAppSduiStreamingChunkedResponses = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiStreamingChunkedResponses
local fFlagSduiDismissPromptAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiDismissPromptAction
local fFlagPromptsEdpOpenReplaceOnFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagPromptsEdpOpenReplaceOnFetch
local fFlagSduiApiStoreUpdateInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiApiStoreUpdateInputData

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner
local FFlagSduiUseHttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/Flags/FFlagSduiUseHttpClient")
local FFlagSduiRequestCounters = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/Flags/FFlagSduiRequestCounters")
local fFlagSduiFreshInputDataSignalOnRebuild = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiFreshInputDataSignalOnRebuild
local FFlagSduiMrRouterHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/Flags/FFlagSduiMrRouterHeaders")
local fFlagHomeSduiOfflineCache = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagHomeSduiOfflineCache
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppEnableSduiHomePage

local fFlagSduiStreamingRefreshReplacesInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiStreamingRefreshReplacesInputData
local fFlagLuaAppSduiSearchAutocomplete = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiSearchAutocomplete
local fFlagLuaAppEnableSduiApiStoreInFlightFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppEnableSduiApiStoreInFlightFix
local fFlagDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagDataHydrationAccountReset

local fFlagHomePageRefetchOnDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagHomePageRefetchOnDataHydrationAccountReset
local fFlagSduiReleaseSearchResultsPageState = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiReleaseSearchResultsPageState

local defineFastInt = game:DefineFastInt("SduiPageRequestPriority", 1)

local resolveSduiCacheEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/resolveSduiCacheEntry")
local accumulateSduiCacheSubEntries = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/accumulateSduiCacheSubEntries")

local function shouldApplyResponse(p2, callback)
	return (callback == nil or callback()) and (p2.isResponseCurrent == nil or p2.isResponseCurrent())
end

local function checkAndReportStaleResponse(p2, data, p3): boolean
	if p2.isCurrentRequest(data.accountPlayerId, data.accountGeneration) then
		return false
	end

	local v5 = data.enableStreaming and "streaming" or "buffered"
	SduiPageAnalytics.sendStaleResponseDiscarded(data.surfaceKey, v5, p3)
	return true
end

local function getSduiRequestEndpointForCounters(url)
	if url == nil or url == "" then
		return "unknown"
	end

	local v5 = string.gsub(url, "^%a[%w+.%-]*://", "")
	local v6 = string.match(v5, "^[^?#]*")

	if v6 == nil or v6 == "" then
		return "unknown"
	end

	local v7, v8 = string.match(v6, "^([^/]*)(.*)$")
	local v9 = {}

	for k in string.gmatch(v8, "[^/]+") do
		table.insert(v9, string.match(k, "^%d+$") ~= nil and "{id}" or k)
	end

	return `{v7}/{table.concat(v9, "/")}`
end

local function createSduiApiStore(p2)
	local dataCache = createDataCache(
		nil,
		nil,
		fFlagDataHydrationAccountReset and { observeLocalUser = false } or nil
	)

	local v5 = {}
	local v6 = fFlagLuaAppEnableSduiHomePage and {} or nil
	local v7 = {}

	local v8 = {}

	local function completeActiveRequest(p3, p4, p5, p6, p7)
		local v9 = v8[p3]

		if v9 then
			v8[p3] = nil

			if p4 then
				v9.resolve(p5)
			else
				v9.reject(p5)
			end
		end

		if p4 and p7 ~= false then
			local v10 = v5[p3]

			if v10 and v10.onSuccess then
				v10.onSuccess(p5, p6)
			end
		end
	end

	local function isInFlight(p3): boolean
		if v8[p3] ~= nil then
			return true
		end

		if not fFlagSduiReleaseSearchResultsPageState then
			return v7[p3] == true
		end

		local v9 = v7[p3]
		return v9 ~= nil and not v9.released
	end

	local v9 = {}
	local v10 = nil

	local function getInputDataSignals(p3)
		local inputDataSignals = v9[p3]

		if inputDataSignals == nil then
			local signal, v11 = Signals.createSignal(nil)
			inputDataSignals = { get = signal, set = v11 }

			v9[p3] = inputDataSignals
		end

		return inputDataSignals
	end

	local v11 = fFlagSduiReleaseSearchResultsPageState and {} or nil

	local function registerInputDataSignalKey(p3, p4)
		local v12 = v11

		if v12 == nil then
			return
		end

		local v13 = v12[p3]

		if v13 == nil then
			v13 = {}
			v12[p3] = v13
		end

		v13[p4] = true
	end

	local function createGetInputDataSignalsForRequest(p3)
		return function(p4)
			if fFlagSduiReleaseSearchResultsPageState then
				local v12 = p3
				local v13 = v11

				if v13 ~= nil then
					local v14 = v13[v12]

					if v14 == nil then
						v14 = {}
						v13[v12] = v14
					end

					v14[p4] = true
				end
			end

			local v12 = v9[p4]

			if v12 == nil then
				local signal, v13 = Signals.createSignal(nil)
				v12 = { get = signal, set = v13 }

				v9[p4] = v12
			end

			return v12
		end
	end

	local v12 = {}

	local function getInputDataSignalsGeneration(p3)
		local inputDataSignalsGeneration = v12[p3]

		if inputDataSignalsGeneration == nil then
			local signal, v13 = Signals.createSignal(0)
			inputDataSignalsGeneration = { get = signal, set = v13 }

			v12[p3] = inputDataSignalsGeneration
		end

		return inputDataSignalsGeneration
	end

	local function bumpInputDataSignalsGeneration(p3)
		local v13 = v12[p3]

		if v13 == nil then
			local signal, v14 = Signals.createSignal(0)
			v13 = { get = signal, set = v14 }

			v12[p3] = v13
		end

		v13.set(function(p4)
			return p4 + 1
		end)
	end

	local function setInputDataSignals(p3, p4, p5)
		v9[p4] = p5

		if fFlagSduiReleaseSearchResultsPageState then
			local v13 = v11

			if v13 ~= nil then
				local v14 = v13[p3]

				if v14 == nil then
					v14 = {}
					v13[p3] = v14
				end

				v14[p4] = true
			end
		end

		local v13 = v12[p4]

		if v13 == nil then
			local signal, v14 = Signals.createSignal(0)
			v13 = { get = signal, set = v14 }

			v12[p4] = v13
		end

		local function fn(p6)
			return p6 + 1
		end

		v13.set(fn)

		if p4 ~= p3 then
			local v14 = v12[p3]

			if v14 == nil then
				local signal, v15 = Signals.createSignal(0)
				v14 = { get = signal, set = v15 }

				v12[p3] = v14
			end

			v14.set(fn)
		end
	end

	local fn

	local function fetchFunction(configKey, p3, data, fn2)
		local v13 = fFlagLuaAppEnableSduiHomePage and data ~= nil

		if not (fFlagLuaAppEnableSduiHomePage and v13) then
			data = v5[configKey]
		end

		if not data then
			return Promise.reject("No request config for key", configKey)
		end

		local v14

		if fFlagSduiReleaseSearchResultsPageState and not v13 then
			v14 = { released = false }
			v7[configKey] = v14
		else
			v14 = nil
		end

		local fn3 = fFlagLuaAppEnableSduiHomePage and v13 and function(p4, p5, p6, p7)
			if p5 and data.onSuccess then
				data.onSuccess(p6, p7)
			end
		end or completeActiveRequest

		local url = data.url
		local v16 = not FFlagSduiRequestCounters and "" or getSduiRequestEndpointForCounters(url)
		local loadTimer = data.loadTimer

		loadTimer.logUiRequestSent()

		local v17 = data.responseType == sduiResponseType.ProtobufJson

		local postConfig = data.postConfig
		local v18 = postConfig and "POST" or "GET"
		local enableStreaming = if fFlagLuaAppSduiStreamingChunkedResponses then data.enableStreaming else nil
		local v19

		if v17 then
			v19 = makeProtobufJsonResponseDecoder(data.apiProto)
		else
			v19 = makeProtoResponseDecoder(data.apiProto)
		end

		local enableInputDataMerge = if fFlagSduiStreamingRefreshReplacesInputData then data.enableInputDataMerge else nil

		local function processSduiResponse(p4)
			local v20 = data.isPaginated and p3.data(false) ~= nil
			local v21

			if fFlagLuaAppEnableSduiHomePage or fFlagSduiStreamingRefreshReplacesInputData then
				if enableInputDataMerge == nil then
					v21 = fFlagLuaAppSduiStreamingChunkedResponses and enableStreaming
						or data.enableInputDataMerge
						or nil
				else
					v21 = enableInputDataMerge
				end
			end

			local v23 = {
				response = p4,
				loadTimer = loadTimer,
				surfaceKey = data.surfaceKey,
				configCacheKey = data.configKey,
				decodeResponse = v19,
				parseHydrationDataFromResponse = SduiProtobufResponseHelpers.parseHydrationDataFromResponse,
				parseTemplateEntriesFromResponse = data.parseTemplateEntriesFromResponse or SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse,
				parsePageEntriesFromResponse = data.parsePageEntriesFromResponse or SduiProtobufResponseHelpers.parsePageEntriesFromResponse,
				parseLocalizedLiteralsFromResponse = data.parseLocalizedLiteralsFromResponse or SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse,
				getInputDataSignalsForRequest = 0,
				setInputDataSignalsForRequest = 0,
				enableStreamingMerge = 0,
				enableInputDataMerge = 0,
				paginateResponse = 0,
				buildNextPageUrl = 0,
				buildNextPagePostBody = 0,
				allowNoConfigsBuilt = 0,
				mergeStrategy = 0,
				cacheSingleEntryWithIdentifier = 0,
				enableTemplateCache = 0
			}
			local v24

			if fFlagSduiReleaseSearchResultsPageState then
				local v25 = configKey

				v24 = function(p5)
					if fFlagSduiReleaseSearchResultsPageState then
						local v26 = v25
						local v27 = v11

						if v27 ~= nil then
							local v28 = v27[v26]

							if v28 == nil then
								v28 = {}
								v27[v26] = v28
							end

							v28[p5] = true
						end
					end

					local v26 = v9[p5]

					if v26 == nil then
						local signal, v27 = Signals.createSignal(nil)
						v26 = { get = signal, set = v27 }

						v9[p5] = v26
					end

					return v26
				end
			else
				v24 = getInputDataSignals
			end

			v23.getInputDataSignalsForRequest = v24

			v23.setInputDataSignalsForRequest = if fFlagSduiFreshInputDataSignalOnRebuild then setInputDataSignals else nil

			v23.enableStreamingMerge = if fFlagLuaAppSduiStreamingChunkedResponses then enableStreaming else nil
			v23.enableInputDataMerge = v21
			v23.paginateResponse = v20
			v23.buildNextPageUrl = data.buildNextPageUrl
			v23.buildNextPagePostBody = data.buildNextPagePostBody
			local v27 = if fFlagSduiAllowNoConfigsBuilt then data.allowNoConfigsBuilt else nil
			v23.allowNoConfigsBuilt = v27
			v23.mergeStrategy = data.mergeStrategy

			local v28 = if fFlagLuaAppEnableSduiHomePage then data.cacheSingleEntryWithIdentifier else nil
			v23.cacheSingleEntryWithIdentifier = v28

			v23.enableTemplateCache = data.enableTemplateCache
			local v29, v30 = handleSduiApiResponse(v23)

			if fFlagSduiStreamingRefreshReplacesInputData then
				enableInputDataMerge = nil
			end

			return v29, v30
		end

		local fn4 = fFlagHomeSduiOfflineCache and function(p4)
			local recoverFromError = data.recoverFromError

			if recoverFromError == nil then
				return nil
			end

			local data2 = p3.data(false)

			if type(data2) == "table" and next(data2) ~= nil then
				return data2
			end

			local function reportUnusable(p5)
				sduiLogger.reportError(
					sduiErrors.SduiErrorType.FailedToApplyFallbackResponse,
					{ message = p5, name = data.surfaceKey },
					data.surfaceKey
				)
			end

			local success, result = pcall(recoverFromError.getDecodedResponse, p4)

			if success then
				if result == nil then
					return nil
				end

				local success2, result2 = pcall(fn, {
					surfaceKey = data.surfaceKey,
					configKey = configKey,
					decodedResponse = result,
					loadTimer = loadTimer,
					apiProto = data.apiProto,
					requestConfig = data
				})

				if success2 then
					local data3 = p3.data(false)

					if type(data3) ~= "table" or next(data3) == nil then
						sduiLogger.reportError(
							sduiErrors.SduiErrorType.FailedToApplyFallbackResponse,
							{
								message = "recovery built no configs",
								name = data.surfaceKey
							},
							data.surfaceKey
						)

						return nil
					end

					loadTimer.updateRequestStatus(sduiRequestStatus.LoadedFromCache)

					if recoverFromError.onApplied ~= nil then
						recoverFromError.onApplied()
					end

					return data3
				else
					local formatted = `recovery errored: {sduiParseHelpers.stringifyValue(result2)}`
					sduiLogger.reportError(
						sduiErrors.SduiErrorType.FailedToApplyFallbackResponse,
						{ message = formatted, name = data.surfaceKey },
						data.surfaceKey
					)

					return nil
				end
			else
				local formatted = `recovery errored: {sduiParseHelpers.stringifyValue(result)}`
				sduiLogger.reportError(
					sduiErrors.SduiErrorType.FailedToApplyFallbackResponse,
					{ message = formatted, name = data.surfaceKey },
					data.surfaceKey
				)

				return nil
			end
		end or nil

		local v20 = nil
		local v21

		if fFlagLuaAppSduiStreamingChunkedResponses and enableStreaming then
			v21 = createSduiStreamingResponseHandler({
				configKey = configKey,
				loadTimer = loadTimer,
				processFrame = function(str)
					if fFlagSduiReleaseSearchResultsPageState and v14 and v14.released then
						return true, nil
					end

					if fFlagHomePageRefetchOnDataHydrationAccountReset then
						local v22 = data
						local flag

						if v10.isCurrentRequest(v22.accountPlayerId, v22.accountGeneration) then
							flag = false
						else
							local v23 = v22.enableStreaming and "streaming" or "buffered"
							SduiPageAnalytics.sendStaleResponseDiscarded(v22.surfaceKey, v23, "streamFrame")
							flag = true
						end

						if flag then
							return true, p3.data(false)
						end
					end

					if fFlagLuaAppEnableSduiHomePage or fFlagLuaAppSduiSearchAutocomplete then
						local v22 = data

						if
							fn2 ~= nil and not fn2()
							or v22.isResponseCurrent ~= nil and not v22.isResponseCurrent()
						then
							return true, p3.data(false)
						end
					end

					local pcall2 = pcall
					local v23

					if FFlagSduiUseHttpClient then
						v23 = {
							statusCode = 200,
							responseBody = buffer.fromstring(str),
							stats = {}
						}
					else
						v23 = { Stats = {}, Body = buffer.fromstring(str) }
					end

					local success, result, v24 = pcall2(processSduiResponse, v23)

					if not success then
						return false, result
					end

					v20 = v24
					local v25 = accumulateSduiCacheSubEntries(result, p3.data(false))
					dataCache.updateItems({ [configKey] = v25 })
					return true, v25
				end
			})
		else
			v21 = nil
		end

		local function createRequestPromise(fn5)
			return Promise.new(function(callback, callback2, callback3)
				local v22 = callback
				local v23 = if fFlagHomeSduiOfflineCache then callback else nil
				local v24 = nil
				local v25 = nil

				if FFlagSduiRequestCounters then
					local v26 = callback2
					callback = function(p4)
						SduiPageAnalytics.sendRequestOutcomeCounter(data.surfaceKey, v16, "success", v24, v25)

						return v22(p4)
					end

					callback2 = function(p4)
						SduiPageAnalytics.sendRequestOutcomeCounter(data.surfaceKey, v16, "failure", v24, v25)

						return v26(p4)
					end
				end

				local fn6 = fFlagHomeSduiOfflineCache and function(p4, p5)
					local v26 = fn4(p4)

					if v26 == nil then
						local v27 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
						v27(configKey, false, p4)

						if p5 ~= nil then
							p4 = p5
						end

						return callback2(p4)
					else
						if FFlagSduiRequestCounters then
							SduiPageAnalytics.sendRequestOutcomeCounter(data.surfaceKey, v16, "failure", v24, v25)
						end

						v23(v26)
						local v27 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
						return v27(configKey, false, p4)
					end
				end or nil

				local v26 = fn5(function(p4, data2)
					if fFlagHomePageRefetchOnDataHydrationAccountReset then
						local v27 = data
						local flag

						if v10.isCurrentRequest(v27.accountPlayerId, v27.accountGeneration) then
							flag = false
						else
							local v28 = v27.enableStreaming and "streaming" or "buffered"
							SduiPageAnalytics.sendStaleResponseDiscarded(v27.surfaceKey, v28, "response")
							flag = true
						end

						if flag then
							return v22(nil)
						end
					end

					if fFlagSduiReleaseSearchResultsPageState and v14 and v14.released then
						return v22(nil)
					end

					loadTimer.logUiResponseReceived()

					if not (fFlagLuaAppEnableSduiHomePage and v13) then
						if fFlagSduiReleaseSearchResultsPageState then
							if v14 and v7[configKey] == v14 then
								v7[configKey] = nil
							end
						else
							v7[configKey] = false
						end
					end

					local sendPageStatusEvent = SduiPageAnalytics.sendPageStatusEvent
					local surfaceKey = data.surfaceKey
					local statusCode = if FFlagSduiUseHttpClient then data2.statusCode else data2.StatusCode
					local v27 = if FFlagSduiUseHttpClient then data2.httpError else data2.HttpError
					sendPageStatusEvent(surfaceKey, statusCode, v27)

					if FFlagSduiRequestCounters then
						v24 = if FFlagSduiUseHttpClient then data2.statusCode else data2.StatusCode
						v25 = if FFlagSduiUseHttpClient then data2.httpError else data2.HttpError
					end

					if p4 then
						local statusCode2 = if FFlagSduiUseHttpClient then data2.statusCode else data2.StatusCode

						local httpError = if FFlagSduiUseHttpClient then data2.httpError else data2.HttpError
						local v28 = if statusCode2 then tonumber(statusCode2) else nil

						local v29 = if FFlagSduiUseHttpClient then data2.wasTransportFailure == true else false

						if v28 and v28 >= 400 or httpError and httpError ~= Enum.HttpError.OK or v29 then
							loadTimer.updateRequestStatus(sduiRequestStatus.FailedToLoad)
						else
							loadTimer.updateRequestStatus(sduiRequestStatus.LoadedFromNetwork)

							if fFlagLuaAppEnableSduiHomePage or fFlagLuaAppSduiSearchAutocomplete then
								local v30 = data

								if
									fn2 ~= nil and not fn2()
									or v30.isResponseCurrent ~= nil and not v30.isResponseCurrent()
								then
									if
										(fFlagLuaAppEnableSduiApiStoreInFlightFix or fFlagLuaAppSduiSearchAutocomplete)
										and not v13
									then
										local v32 = configKey
										local v33 = v8[v32]

										if v33 then
											v8[v32] = nil

											v33.resolve(nil)
										end
									end

									return callback(nil)
								end
							end

							local v30 = if FFlagSduiUseHttpClient then data2.responseBody else data2.Body

							SduiPageAnalytics.sendPagePayloadSizeEvent(data.surfaceKey, v30)

							if v21 then
								local finalize = v21.finalize(v30)

								if finalize.ok then
									local v31 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
									v31(configKey, true, finalize.value, v20)

									return callback(finalize.value)
								else
									local stringifyValue = sduiParseHelpers.stringifyValue(finalize.value)
									sduiLogger.reportError(
										sduiErrors.SduiErrorType.FailedToFetchPage,
										{
											message = stringifyValue,
											name = data.surfaceKey
										},
										data.surfaceKey
									)
									loadTimer.updateRequestStatus(sduiRequestStatus.FailedToLoad)

									if fFlagHomeSduiOfflineCache then
										return fn6(finalize.value)
									end

									local v31 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
									v31(configKey, false, finalize.value)

									return callback2(finalize.value)
								end
							else
								local success, result, v31 = pcall(processSduiResponse, data2)

								if success then
									local v32 = {}

									if fFlagPromptsEdpOpenReplaceOnFetch and data.replaceOnFetch then
										local data3 = p3.data(false)

										for k, v33 in result do
											v32[k] = v33
										end

										if data3 then
											for k in data3 do
												if result[k] == nil then
													v32[k] = Cryo.None
												end
											end
										end
									elseif next(result) then
										local data3 = p3.data(false)

										for k, joined in result do
											local v33 = data3 and data3[k]

											if v33 then
												joined = Cryo.Dictionary.join(v33, joined)
											end

											v32[k] = joined
										end
									elseif data.clearOnEmptyResponse and data.configKey then
										v32[data.configKey] = {}
									end

									local v33 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
									v33(configKey, true, v32, v31)

									return callback(v32)
								else
									local stringifyValue = sduiParseHelpers.stringifyValue(result)

									sduiLogger.reportError(
										sduiErrors.SduiErrorType.FailedToFetchPage,
										{
											message = `handleSduiApiResponse not successful for {url} err {stringifyValue}`,
											name = data.surfaceKey
										},
										data.surfaceKey
									)

									if fFlagHomeSduiOfflineCache then
										return fn6(result, p3)
									end

									local v32 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
									v32(configKey, false, result)

									return callback2(p3)
								end
							end
						end
					end

					if fFlagLuaAppEnableSduiHomePage or fFlagLuaAppSduiSearchAutocomplete then
						local v28 = data

						if
							fn2 ~= nil and not fn2()
							or v28.isResponseCurrent ~= nil and not v28.isResponseCurrent()
						then
							if
								(fFlagLuaAppEnableSduiApiStoreInFlightFix or fFlagLuaAppSduiSearchAutocomplete)
								and not v13
							then
								local v30 = configKey
								local v31 = v8[v30]

								if v31 then
									v8[v30] = nil

									v31.resolve(nil)
								end
							end

							return callback(nil)
						end
					end

					if fFlagHomeSduiOfflineCache then
						return fn6(data2)
					end

					local v28 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
					v28(configKey, false, data2)

					return callback2(data2)
				end)

				if v26 ~= nil then
					callback3(v26)
				end
			end)
		end

		if not FFlagSduiUseHttpClient then
			return createRequestPromise(function(p4): nil
				local v23 = {
					Url = url,
					Method = v18,
					Headers = 0,
					Body = 0,
					OnMessage = 0,
					Priority = 0
				}
				local v24

				if FFlagSduiMrRouterHeaders then
					local v27 = if postConfig then SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig) else nil
					v24 = buildSduiRequestHeaders(v17 and "application/json" or "application/x-protobuf", v27)
				else
					v24 = {
						["Accept"] = nil,
						Accept = v17 and "application/json" or "application/x-protobuf"
					}

					local v25 = if postConfig then SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig) else nil
					v24["Content-Type"] = v25
				end

				v23.Headers = v24

				local v25 = if postConfig then SduiApiStorePostConfig.getBodyFromPostConfig(postConfig) else nil
				v23.Body = v25
				local v26 = if v21 then v21.handleChunk else nil
				v23.OnMessage = v26
				v23.Priority = defineFastInt
				HttpService:RequestInternal(v23):Start(p4)
				return nil
			end)
		end

		local v22 = if postConfig then SduiApiStorePostConfig.getBodyFromPostConfig(postConfig) else nil

		local v23 = if postConfig then SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig) else nil

		local resolved = SduiRetryPolicy.resolve(data.retry)

		if FFlagSduiRequestCounters and resolved ~= nil then
			local onRetry = resolved.onRetry
			resolved = Cryo.Dictionary.join(resolved, {
				onRetry = function(p4)
					if onRetry ~= nil then
						onRetry(p4)
					end

					SduiPageAnalytics.sendRequestRetryCounter(data.surfaceKey, v16, p4)
				end
			})
		end

		local v24 = if p2 and p2.requestDeadlineSec then p2.requestDeadlineSec else SduiRetryPolicy.getRequestDeadlineSec()
		local v25 = {
			url = url,
			method = v18,
			body = v22,
			contentType = v23,
			accept = v17 and "application/json" or "application/x-protobuf",
			analyticsKey = data.surfaceKey,
			priority = defineFastInt,
			retry = resolved,
			deadlineSec = v24,
			network = p2 and p2.network or nil,
			delivery = v21 and { mode = "streaming", onMessage = v21.handleChunk } or {
				mode = "buffered"
			}
		}

		return createRequestPromise(function(callback)
			local v26 = sendSduiHttpRequest(v25)
			v26:andThen(function(p4)
				callback(true, p4)
			end, function(p4)
				if typeof(p4) == "table" and (p4.statusCode ~= nil or p4.httpError ~= nil) then
					callback(true, p4)
				else
					callback(false, p4)
				end
			end)
			return function()
				v26:cancel()
			end
		end)
	end

	local v14 = {
		cache = dataCache,
		fetchFn = fetchFunction,
		queueProcessDelaySec = 0,
		supportsMultiGet = false,
		requestTimeoutSec = 0,
		onBeforeClear = 0
	}

	local v15 = if FFlagSduiUseHttpClient then SduiRetryPolicy.getFetchTimeoutSec() else nil
	v14.requestTimeoutSec = v15
	v14.onBeforeClear = fFlagHomePageRefetchOnDataHydrationAccountReset and function()
		local v16 = v8
		v8 = {}
		v7 = {}
		v5 = {}

		if v6 ~= nil then
			v6 = {}
		end

		v9 = {}

		if fFlagSduiReleaseSearchResultsPageState then
			v11 = {}
		end

		for k, v17 in v16 do
			v17.resolve(nil)
		end
	end or nil
	v10 = createDataResolver(v14)

	local function fetchIfNeeded(joined, p3)
		if joined.responseType == nil then
			joined.responseType = sduiResponseType.Protobuf
		end

		local configKey = joined.configKey or joined.url

		local v16 = fFlagLuaAppEnableSduiHomePage
			and joined.concurrencyPolicy == sduiRequestConcurrencyPolicy.LatestWins
		joined.configKey = configKey
		joined.loadTimer.logUiRequestQueued()

		if fFlagHomePageRefetchOnDataHydrationAccountReset then
			joined.accountGeneration = v10.getAccountGeneration(false)
			joined.accountPlayerId = getLocalPlayerUserId()
		end

		if fFlagLuaAppEnableSduiHomePage and v16 then
			local concurrencyKey = joined.concurrencyKey or configKey
			local v17 = v6
			local v18 = (v17[concurrencyKey] or 0) + 1
			v17[concurrencyKey] = v18

			return fetchFunction(configKey, v10.getCachedItem(configKey), joined, function(): boolean
				return v17[concurrencyKey] == v18
			end):andThen(function(p4)
				if fFlagHomePageRefetchOnDataHydrationAccountReset and p4 ~= nil then
					local v19 = joined
					local flag

					if v10.isCurrentRequest(v19.accountPlayerId, v19.accountGeneration) then
						flag = false
					else
						local v20 = v19.enableStreaming and "streaming" or "buffered"
						SduiPageAnalytics.sendStaleResponseDiscarded(v19.surfaceKey, v20, "cacheCommit")
						flag = true
					end

					if flag then
						return nil
					end
				end

				if p4 ~= nil and not joined.enableInputDataMerge then
					dataCache.updateItems({ [configKey] = p4 })
				end

				return p4
			end)
		else
			v5[configKey] = joined

			local fetchItem, v17 = v10.getAndFetchItem(configKey, p3 and function(): boolean
				return true
			end or nil, joined.staleTimeSec)

			if not v17 then
				return Promise.resolve()
			end

			if v8[configKey] then
				return v8[configKey].promise
			end

			local v18 = nil
			local v19 = nil
			local v20 = Promise.new(function(p4, p5)
				v18 = p4
				v19 = p5
			end)
			v20:catch(function(p4) end)
			v8[configKey] = { promise = v20, resolve = v18, reject = v19 }

			return v8[configKey].promise
		end
	end

	local function getInputData(p3, p4, p5)
		local v16 = if p4 and p4 ~= "" then `{p3}_{p4}` else nil

		if fFlagSduiFreshInputDataSignalOnRebuild and p5 then
			local v17 = v16 or p3
			local v18 = v12[v17]

			if v18 == nil then
				local signal, v19 = Signals.createSignal(0)
				v18 = { get = signal, set = v19 }

				v12[v17] = v18
			end

			v18.get(p5)
		end

		local v17 = resolveSduiCacheEntry(v9, p3, v16)

		if v17 == nil then
			return nil
		end

		local get = v17.get

		if p5 == nil then
			p5 = false
		end

		return get(p5)
	end

	local function forEachInputData(p3, callback)
		local data = v10.getCachedItem(p3).data(false)

		if data == nil then
			return
		end

		for k in data do
			local v16 = v9[k]
			local v17 = if v16 then v16.get(false) else nil

			if v17 ~= nil and callback(k, v17) then
				break
			end
		end
	end

	local function setInputDataField(p3, p4, p5, p6): boolean
		local data = v10.getCachedItem(p3).data(false)
		local v16 = v9[p4]

		if data == nil or data[p4] == nil or v16 == nil then
			return false
		end

		local v17 = v16.get(false)
		local v18 = if v17 then v17[p5] else nil

		if v18 == nil or p6 == nil or typeof(p6) ~= typeof(v18) then
			return false
		end

		local clone = table.clone(v17)
		clone[p5] = p6
		v16.set(clone)
		return true
	end

	local function getRootConfig(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p4)
		local v16

		if fFlagSduiAlwaysCacheWithIdentifier then
			v16 = resolveSduiCacheEntry(data, p3, p5)
		else
			v16 = data and data[p5 or p3]
		end

		if v16 then
			return v16.config
		end

		return nil
	end

	local function getTitle(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p4)
		local v16

		if fFlagSduiAlwaysCacheWithIdentifier then
			v16 = resolveSduiCacheEntry(data, p3, p5)
		else
			v16 = data and data[p5 or p3]
		end

		if v16 and v16.title ~= "" then
			return v16.title
		end

		return nil
	end

	local function getDataUpdatedTimestamp(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p4)
		local v16

		if fFlagSduiAlwaysCacheWithIdentifier then
			v16 = resolveSduiCacheEntry(data, p3, p5)
		else
			v16 = data and data[p5 or p3]
		end

		if v16 then
			return v16.dataUpdatedTimestamp
		end

		return nil
	end

	local function getEntrySurfacing(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p5)
		local v16

		if fFlagSduiAlwaysCacheWithIdentifier then
			v16 = resolveSduiCacheEntry(data, p3, p4)
		else
			v16 = data and data[p4 or p3]
		end

		if v16 then
			return v16.surfacing
		end

		return nil
	end

	local function loadMoreFromApi(data)
		local v16 = v5[data.configKey]

		if not v16 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToPaginateRequest,
				{
					message = `No requestData for {data.configKey}`
				},
				"unknown"
			)

			return Promise.resolve()
		end

		local data2 = v10.getCachedItem(data.configKey).data(false)
		local v17

		if fFlagSduiAlwaysCacheWithIdentifier then
			v17 = resolveSduiCacheEntry(data2, data.configKey, data.identifier)
		else
			v17 = data2 and data2[data.identifier or data.configKey]
		end

		if not v17 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToPaginateRequest,
				{
					message = `No entry data for {data.configKey}`,
					name = v16.surfaceKey
				},
				v16.surfaceKey
			)
			return Promise.resolve()
		end

		local nextPageUrl = v17.nextPageUrl

		if not nextPageUrl or nextPageUrl == "" then
			return Promise.resolve()
		end

		local v18 = {
			url = nextPageUrl,
			loadTimer = data.loadTimer,
			isPaginated = true
		}

		if v16.postConfig and v17.nextPagePostBody then
			v18.postConfig = Cryo.Dictionary.join(v16.postConfig, {
				body = v17.nextPagePostBody
			})
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v16, v18), true)
	end

	local function refreshFromApi(p3)
		local v16 = v5[p3.configKey]

		if not v16 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToFetchPage,
				{
					message = `No requestData for refresh: {p3.configKey}`
				},
				"unknown"
			)

			return Promise.resolve()
		end

		if v16.refresh then
			return v16.refresh(p3.loadTimer)
		end

		local v18 = {
			url = (if v16.buildRefreshUrl then v16.buildRefreshUrl() else nil) or v16.url,
			loadTimer = p3.loadTimer,
			isPaginated = Cryo.None
		}

		if fFlagSduiStreamingRefreshReplacesInputData and not v16.enableInputDataMerge then
			v18.enableInputDataMerge = false
		end

		if v16.postConfig then
			local v19 = if v16.buildRefreshPostBody then v16.buildRefreshPostBody() else nil

			if v19 then
				v18.postConfig = Cryo.Dictionary.join(v16.postConfig, { body = v19 })
			end
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v16, v18), true)
	end

	fn = function(data)
		local configKey = data.configKey
		local loadTimer = data.loadTimer

		if fFlagHomeSduiOfflineCache and data.requestConfig ~= nil then
			v5[configKey] = data.requestConfig
		else
			loadTimer.logUiRequestQueued()
			v5[configKey] = {
				url = `inline://{configKey}`,
				surfaceKey = data.surfaceKey,
				configKey = configKey,
				loadTimer = loadTimer,
				apiProto = data.apiProto,
				responseType = sduiResponseType.Protobuf
			}
		end

		local requestConfig = if fFlagHomeSduiOfflineCache then data.requestConfig else nil
		local data2 = v10.getCachedItem(configKey).data(false)

		local success, result = pcall(function()
			local v18 = if FFlagSduiUseHttpClient then {
				statusCode = 200,
				responseBody = data.decodedResponse,
				stats = {}
			} else { Body = data.decodedResponse, Stats = {}, StatusCode = 200 }
			local v17 = {
				response = v18,
				loadTimer = loadTimer,
				surfaceKey = data.surfaceKey,
				configCacheKey = configKey,
				decodeResponse = function(p3)
					return p3
				end,
				parseHydrationDataFromResponse = SduiProtobufResponseHelpers.parseHydrationDataFromResponse,
				parseTemplateEntriesFromResponse = 0,
				parsePageEntriesFromResponse = 0,
				parseLocalizedLiteralsFromResponse = 0,
				getInputDataSignalsForRequest = 0,
				setInputDataSignalsForRequest = 0,
				paginateResponse = false,
				allowNoConfigsBuilt = 0,
				mergeStrategy = 0,
				enableTemplateCache = 0,
				cacheSingleEntryWithIdentifier = true
			}

			local v19 = if fFlagHomeSduiOfflineCache and requestConfig ~= nil then requestConfig.parseTemplateEntriesFromResponse or SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse else SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse
			v17.parseTemplateEntriesFromResponse = v19

			local v20 = if fFlagHomeSduiOfflineCache and requestConfig ~= nil then requestConfig.parsePageEntriesFromResponse or SduiProtobufResponseHelpers.parsePageEntriesFromResponse else SduiProtobufResponseHelpers.parsePageEntriesFromResponse
			v17.parsePageEntriesFromResponse = v20

			local v21 = if fFlagHomeSduiOfflineCache and requestConfig ~= nil then requestConfig.parseLocalizedLiteralsFromResponse or SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse else SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
			v17.parseLocalizedLiteralsFromResponse = v21
			local v22

			if fFlagSduiReleaseSearchResultsPageState then
				local v23 = configKey

				v22 = function(p3)
					if fFlagSduiReleaseSearchResultsPageState then
						local v24 = v23
						local v25 = v11

						if v25 ~= nil then
							local v26 = v25[v24]

							if v26 == nil then
								v26 = {}
								v25[v24] = v26
							end

							v26[p3] = true
						end
					end

					local v24 = v9[p3]

					if v24 == nil then
						local signal, v25 = Signals.createSignal(nil)
						v24 = { get = signal, set = v25 }

						v9[p3] = v24
					end

					return v24
				end
			else
				v22 = getInputDataSignals
			end

			v17.getInputDataSignalsForRequest = v22

			v17.setInputDataSignalsForRequest = if fFlagSduiFreshInputDataSignalOnRebuild then setInputDataSignals else nil

			local v24 = if fFlagHomeSduiOfflineCache and requestConfig ~= nil and fFlagSduiAllowNoConfigsBuilt then requestConfig.allowNoConfigsBuilt else nil
			v17.allowNoConfigsBuilt = v24

			local v25 = if fFlagHomeSduiOfflineCache and requestConfig ~= nil then requestConfig.mergeStrategy else nil
			v17.mergeStrategy = v25

			local v26 = if fFlagHomeSduiOfflineCache and requestConfig ~= nil then requestConfig.enableTemplateCache else nil
			v17.enableTemplateCache = v26
			return handleSduiApiResponse(v17)
		end)

		if not success then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToFetchPage,
				{
					message = `seedFromDecodedResponse failed for {configKey}: {sduiParseHelpers.stringifyValue(result)}`,
					name = data.surfaceKey
				},
				data.surfaceKey
			)
			error(result)
		end

		if fFlagAppChatConversationTrustedFriendUpsellBanner and data.replace then
			dataCache.replaceItems({ [configKey] = result })
			return
		end

		local v16 = accumulateSduiCacheSubEntries(result, data2)
		dataCache.updateItems({ [configKey] = v16 })
	end

	local function dismissEntry(value)
		local result = {}

		if typeof(value) ~= "string" or value == "" then
			return result
		end

		for k in v5 do
			local data = v10.getCachedItem(k).data(false)

			if not data then
				continue
			end

			local v16 = {}
			local flag = false

			for k2, v17 in data do
				if v17 and v17.category ~= nil and v17.title == value then
					flag = true
				else
					v16[k2] = v17
				end
			end

			if not flag then
				continue
			end

			dataCache.replaceItems({ [k] = v16 })
			table.insert(result, k)
		end

		return result
	end

	local function clearConfigEntries(value)
		if typeof(value) ~= "string" or value == "" then
			return
		end

		dataCache.replaceItems({ [value] = {} })
	end

	local function releaseConfigKey(p3)
		if p3 == "" then
			return
		end

		local v16 = v11
		local v17 = if v16 then v16[p3] else nil

		if v17 ~= nil then
			for k in v17 do
				v9[k] = nil
				v12[k] = nil
			end
		end

		if v16 ~= nil then
			v16[p3] = nil
		end

		v5[p3] = nil
		local v18 = v7[p3]

		if v18 then
			v18.released = true
			v7[p3] = nil
		end

		local v19 = v8[p3]
		v8[p3] = nil

		if v19 then
			v19.resolve(nil)
		end

		v10.releaseItem(p3)
	end

	local sduiApiStore = {
		fetchIfNeeded = fetchIfNeeded,
		releaseConfigKey = nil,
		isInFlight = nil,
		clearConfigEntries = nil,
		dismissEntry = nil,
		seedFromDecodedResponse = nil,
		getData = 0,
		getInputData = 0,
		forEachInputData = 0,
		setInputDataField = 0,
		getRootConfig = 0,
		getTitle = 0,
		getDataUpdatedTimestamp = 0,
		getAccountGeneration = 0,
		getEntrySurfacing = 0,
		loadMoreFromApi = 0,
		refreshFromApi = 0
	}

	if not fFlagSduiReleaseSearchResultsPageState then
		releaseConfigKey = nil
	end

	sduiApiStore.releaseConfigKey = releaseConfigKey
	sduiApiStore.isInFlight = isInFlight

	if not fFlagAppChatConversationTrustedFriendUpsellBanner then
		clearConfigEntries = nil
	end

	sduiApiStore.clearConfigEntries = clearConfigEntries

	if not fFlagSduiDismissPromptAction then
		dismissEntry = nil
	end

	sduiApiStore.dismissEntry = dismissEntry
	sduiApiStore.seedFromDecodedResponse = fn
	sduiApiStore.getData = v10.getCachedItem
	sduiApiStore.getInputData = getInputData

	if not fFlagSduiApiStoreUpdateInputData then
		forEachInputData = nil
	end

	sduiApiStore.forEachInputData = forEachInputData

	if not fFlagSduiApiStoreUpdateInputData then
		setInputDataField = nil
	end

	sduiApiStore.setInputDataField = setInputDataField
	sduiApiStore.getRootConfig = getRootConfig
	sduiApiStore.getTitle = getTitle
	sduiApiStore.getDataUpdatedTimestamp = getDataUpdatedTimestamp

	local v16 = if fFlagHomePageRefetchOnDataHydrationAccountReset then v10.getAccountGeneration else nil
	sduiApiStore.getAccountGeneration = v16

	sduiApiStore.getEntrySurfacing = getEntrySurfacing
	sduiApiStore.loadMoreFromApi = loadMoreFromApi
	sduiApiStore.refreshFromApi = refreshFromApi
	return sduiApiStore
end

return createSduiApiStore

local HttpService = game:GetService("HttpService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

local parent = SduiSharedUtilities.Parent
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local Promise = require(parent.Promise)
require(parent.HttpClient)
local DataHydration = require(parent.DataHydration)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local getLocalPlayerUserId = DataHydration.DataHydrationUtils.getLocalPlayerUserId

local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local SduiRequestConcurrencyPolicy = SduiIntegrationTypes.SduiRequestConcurrencyPolicy
local SduiRequestStatus = SduiIntegrationTypes.SduiRequestStatus
require(SduiSharedUtilities.SduiLoadTimer)
local SduiProtobufResponseHelpers = require(SduiSharedUtilities.SduiProtobufResponseHelpers)
local makeProtoResponseDecoder = SduiProtobufResponseHelpers.makeProtoResponseDecoder
local makeProtobufJsonResponseDecoder = SduiProtobufResponseHelpers.makeProtobufJsonResponseDecoder
local SduiResponseType = SduiIntegrationTypes.SduiResponseType
local handleSduiApiResponse = require(SduiSharedUtilities.handleSduiApiResponse)
local SduiPageAnalytics = require(SduiSharedUtilities.SduiPageAnalytics)
local SduiApiStorePostConfig = require(SduiSharedUtilities.SduiApiStorePostConfig)
require(SduiSharedUtilities.SduiApiRequestConfig)
local buildSduiRequestHeaders = require(SduiSharedUtilities.buildSduiRequestHeaders)
local createSduiStreamingResponseHandler = require(SduiSharedUtilities.createSduiStreamingResponseHandler)
local SduiRetryPolicy = require(SduiSharedUtilities.SduiRetryPolicy)
local sendSduiHttpRequest = require(SduiSharedUtilities.sendSduiHttpRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiAlwaysCacheWithIdentifier = SharedFlags2.FFlagSduiAlwaysCacheWithIdentifier
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSduiStreamingChunkedResponses = SharedFlags3.FFlagLuaAppSduiStreamingChunkedResponses
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiDismissPromptAction = SharedFlags4.FFlagSduiDismissPromptAction
local SharedFlags5 = require(parent.SharedFlags)
local FFlagPromptsEdpOpenReplaceOnFetch = SharedFlags5.FFlagPromptsEdpOpenReplaceOnFetch
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiApiStoreUpdateInputData = SharedFlags6.FFlagSduiApiStoreUpdateInputData

local SharedFlags7 = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags7.FFlagAppChatConversationTrustedFriendUpsellBanner
local FFlagSduiUseHttpClient = require(SduiSharedUtilities.Flags.FFlagSduiUseHttpClient)
local FFlagSduiRequestCounters = require(SduiSharedUtilities.Flags.FFlagSduiRequestCounters)
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiFreshInputDataSignalOnRebuild = SharedFlags8.FFlagSduiFreshInputDataSignalOnRebuild
local FFlagSduiMrRouterHeaders = require(SduiSharedUtilities.Flags.FFlagSduiMrRouterHeaders)
local SharedFlags9 = require(parent.SharedFlags)
local FFlagHomeSduiOfflineCache = SharedFlags9.FFlagHomeSduiOfflineCache
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags10.FFlagLuaAppEnableSduiHomePage

local SharedFlags11 = require(parent.SharedFlags)
local FFlagSduiStreamingRefreshReplacesInputData = SharedFlags11.FFlagSduiStreamingRefreshReplacesInputData
local SharedFlags12 = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocomplete = SharedFlags12.FFlagLuaAppSduiSearchAutocomplete
local SharedFlags13 = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiApiStoreInFlightFix = SharedFlags13.FFlagLuaAppEnableSduiApiStoreInFlightFix
local SharedFlags14 = require(parent.SharedFlags)
local FFlagDataHydrationAccountReset = SharedFlags14.FFlagDataHydrationAccountReset

local SharedFlags15 = require(parent.SharedFlags)
local FFlagHomePageRefetchOnDataHydrationAccountReset = SharedFlags15.FFlagHomePageRefetchOnDataHydrationAccountReset
local SharedFlags16 = require(parent.SharedFlags)
local FFlagSduiReleaseSearchResultsPageState = SharedFlags16.FFlagSduiReleaseSearchResultsPageState

local defineFastInt = game:DefineFastInt("SduiPageRequestPriority", 1)

local resolveSduiCacheEntry = require(SduiSharedUtilities.resolveSduiCacheEntry)
local accumulateSduiCacheSubEntries = require(SduiSharedUtilities.accumulateSduiCacheSubEntries)

local function shouldApplyResponse(p, callback)
	return (callback == nil or callback()) and (p.isResponseCurrent == nil or p.isResponseCurrent())
end

local function checkAndReportStaleResponse(p, data, p2): boolean -- 3 equivalent calls inferred from this helper
	if p.isCurrentRequest(data.accountPlayerId, data.accountGeneration) then
		return false
	end

	local v = data.enableStreaming and "streaming" or "buffered"
	SduiPageAnalytics.sendStaleResponseDiscarded(data.surfaceKey, v, p2)
	return true
end

local function getSduiRequestEndpointForCounters(url: string?)
	if url == nil or url == "" then
		return "unknown"
	end

	local v = string.gsub(url, "^%a[%w+.%-]*://", "")
	local v2 = string.match(v, "^[^?#]*")

	if v2 == nil or v2 == "" then
		return "unknown"
	end

	local v3, v4 = string.match(v2, "^([^/]*)(.*)$")
	local v5 = {}

	for k in string.gmatch(v4, "[^/]+") do
		table.insert(v5, string.match(k, "^%d+$") ~= nil and "{id}" or k)
	end

	return `{v3}/{table.concat(v5, "/")}`
end

local function createSduiApiStore(p)
	local dataCache = createDataCache(nil, nil, FFlagDataHydrationAccountReset and {
		observeLocalUser = false
	} or nil)

	local v = {}
	local v2 = FFlagLuaAppEnableSduiHomePage and {} or nil
	local v3 = {}

	local v4 = {}

	local function completeActiveRequest(p2: string, flag: boolean, p3, p4, flag2: boolean?)
		local v5 = v4[p2]

		if v5 then
			v4[p2] = nil

			if flag then
				v5.resolve(p3)
			else
				v5.reject(p3)
			end
		end

		if flag and flag2 ~= false then
			local v6 = v[p2]

			if v6 and v6.onSuccess then
				v6.onSuccess(p3, p4)
			end
		end
	end

	local function isInFlight(p2: string): boolean
		if v4[p2] ~= nil then
			return true
		end

		if not FFlagSduiReleaseSearchResultsPageState then
			return v3[p2] == true
		end

		local v5 = v3[p2]
		return v5 ~= nil and not v5.released
	end

	local v5 = {}
	local v6 = nil

	local function getInputDataSignals(p2: string) -- 1 equivalent call inferred from this helper
		local inputDataSignals = v5[p2]

		if inputDataSignals == nil then
			local signal, set = Signals.createSignal(nil)
			inputDataSignals = { get = signal, set = set }

			v5[p2] = inputDataSignals
		end

		return inputDataSignals
	end

	local v7 = FFlagSduiReleaseSearchResultsPageState and {} or nil

	local function registerInputDataSignalKey(p2: string, p3: string) -- 2 equivalent calls inferred from this helper
		local v8 = v7

		if v8 == nil then
			return
		end

		local v9 = v8[p2]

		if v9 == nil then
			v9 = {}
			v8[p2] = v9
		end

		v9[p3] = true
	end

	local function createGetInputDataSignalsForRequest(p2: string) -- 2 equivalent calls inferred from this helper
		return function(p3: string)
			if FFlagSduiReleaseSearchResultsPageState then
				registerInputDataSignalKey(p2, p3) -- inferred equivalent call
			end

			return getInputDataSignals(p3) -- inferred equivalent call
		end
	end

	local v8 = {}

	local function getInputDataSignalsGeneration(p2: string) -- 4 equivalent calls inferred from this helper
		local inputDataSignalsGeneration = v8[p2]

		if inputDataSignalsGeneration == nil then
			local signal, set = Signals.createSignal(0)
			inputDataSignalsGeneration = { get = signal, set = set }

			v8[p2] = inputDataSignalsGeneration
		end

		return inputDataSignalsGeneration
	end

	local function bumpInputDataSignalsGeneration(p2: string)
		getInputDataSignalsGeneration(p2).set(function(p3: number) -- inferred equivalent call
			return p3 + 1
		end)
	end

	local function setInputDataSignals(p2: string, p3: string, p4)
		v5[p3] = p4

		if FFlagSduiReleaseSearchResultsPageState then
			registerInputDataSignalKey(p2, p3) -- inferred equivalent call
		end

		local function fn(p5: number)
			return p5 + 1
		end

		getInputDataSignalsGeneration(p3).set(fn) -- inferred equivalent call

		if p3 ~= p2 then
			getInputDataSignalsGeneration(p2).set(fn) -- inferred equivalent call
		end
	end

	local fn

	local function fetchFunction(configKey: string, p2, requestConfig, fn2)
		local v9 = FFlagLuaAppEnableSduiHomePage and requestConfig ~= nil

		if not (FFlagLuaAppEnableSduiHomePage and v9) then
			requestConfig = v[configKey]
		end

		if not requestConfig then
			return Promise.reject("No request config for key", configKey)
		end

		local v10

		if FFlagSduiReleaseSearchResultsPageState and not v9 then
			v10 = { released = false }
			v3[configKey] = v10
		else
			v10 = nil
		end

		local fn3 = FFlagLuaAppEnableSduiHomePage and v9 and function(_, p3, p4, p5)
			if p3 and requestConfig.onSuccess then
				requestConfig.onSuccess(p4, p5)
			end
		end or completeActiveRequest

		local url = requestConfig.url
		local v11 = not FFlagSduiRequestCounters and "" or getSduiRequestEndpointForCounters(url)
		local loadTimer = requestConfig.loadTimer

		loadTimer.logUiRequestSent()

		local v12 = requestConfig.responseType == SduiResponseType.ProtobufJson

		local postConfig = requestConfig.postConfig
		local method = postConfig and "POST" or "GET"
		local enableStreaming

		if FFlagLuaAppSduiStreamingChunkedResponses then
			enableStreaming = requestConfig.enableStreaming
		else
			enableStreaming = nil
		end

		local decodeResponse

		if v12 then
			decodeResponse = makeProtobufJsonResponseDecoder(requestConfig.apiProto)
		else
			decodeResponse = makeProtoResponseDecoder(requestConfig.apiProto)
		end

		local enableInputDataMerge

		if FFlagSduiStreamingRefreshReplacesInputData then
			enableInputDataMerge = requestConfig.enableInputDataMerge
		else
			enableInputDataMerge = nil
		end

		local function processSduiResponse(response)
			local paginateResponse = requestConfig.isPaginated and p2.data(false) ~= nil
			local enableInputDataMerge2

			if FFlagLuaAppEnableSduiHomePage or FFlagSduiStreamingRefreshReplacesInputData then
				if enableInputDataMerge == nil then
					enableInputDataMerge2 = FFlagLuaAppSduiStreamingChunkedResponses and enableStreaming
						or requestConfig.enableInputDataMerge
						or nil
				else
					enableInputDataMerge2 = enableInputDataMerge
				end
			end

			local v13 = {
				response = response,
				loadTimer = loadTimer,
				surfaceKey = requestConfig.surfaceKey,
				configCacheKey = requestConfig.configKey,
				decodeResponse = decodeResponse,
				parseHydrationDataFromResponse = SduiProtobufResponseHelpers.parseHydrationDataFromResponse,
				parseTemplateEntriesFromResponse = requestConfig.parseTemplateEntriesFromResponse or SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse,
				parsePageEntriesFromResponse = requestConfig.parsePageEntriesFromResponse or SduiProtobufResponseHelpers.parsePageEntriesFromResponse,
				parseLocalizedLiteralsFromResponse = requestConfig.parseLocalizedLiteralsFromResponse or SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse,
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
			local getInputDataSignalsForRequest

			if FFlagSduiReleaseSearchResultsPageState then
				getInputDataSignalsForRequest = createGetInputDataSignalsForRequest(configKey) -- inferred equivalent call
			else
				getInputDataSignalsForRequest = getInputDataSignals
			end

			v13.getInputDataSignalsForRequest = getInputDataSignalsForRequest
			local setInputDataSignalsForRequest

			if FFlagSduiFreshInputDataSignalOnRebuild then
				setInputDataSignalsForRequest = setInputDataSignals
			end

			v13.setInputDataSignalsForRequest = setInputDataSignalsForRequest
			local enableStreamingMerge

			if FFlagLuaAppSduiStreamingChunkedResponses then
				enableStreamingMerge = enableStreaming
			end

			v13.enableStreamingMerge = enableStreamingMerge
			v13.enableInputDataMerge = enableInputDataMerge2
			v13.paginateResponse = paginateResponse
			v13.buildNextPageUrl = requestConfig.buildNextPageUrl
			v13.buildNextPagePostBody = requestConfig.buildNextPagePostBody
			local allowNoConfigsBuilt

			if FFlagSduiAllowNoConfigsBuilt then
				allowNoConfigsBuilt = requestConfig.allowNoConfigsBuilt
			end

			v13.allowNoConfigsBuilt = allowNoConfigsBuilt
			v13.mergeStrategy = requestConfig.mergeStrategy
			local cacheSingleEntryWithIdentifier

			if FFlagLuaAppEnableSduiHomePage then
				cacheSingleEntryWithIdentifier = requestConfig.cacheSingleEntryWithIdentifier
			end

			v13.cacheSingleEntryWithIdentifier = cacheSingleEntryWithIdentifier

			v13.enableTemplateCache = requestConfig.enableTemplateCache
			local v14, v15 = handleSduiApiResponse(v13)

			if FFlagSduiStreamingRefreshReplacesInputData then
				enableInputDataMerge = nil
			end

			return v14, v15
		end

		local fn4 = FFlagHomeSduiOfflineCache and function(p3)
			local recoverFromError = requestConfig.recoverFromError

			if recoverFromError == nil then
				return nil
			end

			local data = p2.data(false)

			if type(data) == "table" and next(data) ~= nil then
				return data
			end

			local function reportUnusable(message: string) -- 3 equivalent calls inferred from this helper
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.FailedToApplyFallbackResponse,
					{ message = message, name = requestConfig.surfaceKey },
					requestConfig.surfaceKey
				)
			end

			local success, result = pcall(recoverFromError.getDecodedResponse, p3)

			if success then
				if result == nil then
					return nil
				end

				local success2, result2 = pcall(fn, {
					surfaceKey = requestConfig.surfaceKey,
					configKey = configKey,
					decodedResponse = result,
					loadTimer = loadTimer,
					apiProto = requestConfig.apiProto,
					requestConfig = requestConfig
				})

				if success2 then
					local data2 = p2.data(false)

					if type(data2) ~= "table" or next(data2) == nil then
						reportUnusable("recovery built no configs") -- inferred equivalent call
						return nil
					end

					loadTimer.updateRequestStatus(SduiRequestStatus.LoadedFromCache)

					if recoverFromError.onApplied ~= nil then
						recoverFromError.onApplied()
					end

					return data2
				end

				reportUnusable(`recovery errored: {SduiParseHelpers.stringifyValue(result2)}`) -- inferred equivalent call
				return nil
			end

			reportUnusable(`recovery errored: {SduiParseHelpers.stringifyValue(result)}`) -- inferred equivalent call
			return nil
		end or nil

		local v13 = nil
		local v14

		if FFlagLuaAppSduiStreamingChunkedResponses and enableStreaming then
			v14 = createSduiStreamingResponseHandler({
				configKey = configKey,
				loadTimer = loadTimer,
				processFrame = function(str: string)
					if FFlagSduiReleaseSearchResultsPageState and v10 and v10.released then
						return true, nil
					end

					if
						FFlagHomePageRefetchOnDataHydrationAccountReset
						and checkAndReportStaleResponse(v6, requestConfig, "streamFrame") -- inferred equivalent call
					then
						return true, p2.data(false)
					end

					if FFlagLuaAppEnableSduiHomePage or FFlagLuaAppSduiSearchAutocomplete then
						local v15 = requestConfig

						if fn2 ~= nil and not fn2() or v15.isResponseCurrent ~= nil and not v15.isResponseCurrent() then
							return true, p2.data(false)
						end
					end

					local v15

					if FFlagSduiUseHttpClient then
						v15 = {
							statusCode = 200,
							responseBody = buffer.fromstring(str),
							stats = {}
						}
					else
						v15 = { Stats = {}, Body = buffer.fromstring(str) }
					end

					local success, result, v16 = pcall(processSduiResponse, v15)

					if not success then
						return false, result
					end

					v13 = v16
					local v17 = accumulateSduiCacheSubEntries(result, p2.data(false))
					dataCache.updateItems({ [configKey] = v17 })
					return true, v17
				end
			})
		else
			v14 = nil
		end

		local function createRequestPromise(fn5)
			return Promise.new(function(callback, callback2, callback3)
				local v15 = callback
				local v16

				if FFlagHomeSduiOfflineCache then
					v16 = callback
				else
					v16 = nil
				end

				local v17 = nil
				local v18 = nil

				if FFlagSduiRequestCounters then
					local v19 = callback2
					callback = function(p3)
						SduiPageAnalytics.sendRequestOutcomeCounter(requestConfig.surfaceKey, v11, "success", v17, v18)

						return v15(p3)
					end

					callback2 = function(p3)
						SduiPageAnalytics.sendRequestOutcomeCounter(requestConfig.surfaceKey, v11, "failure", v17, v18)

						return v19(p3)
					end
				end

				local fn6 = FFlagHomeSduiOfflineCache and function(p3, p4)
					local v19 = fn4(p3)

					if v19 == nil then
						local v20

						if FFlagLuaAppEnableSduiHomePage then
							v20 = fn3
						else
							v20 = completeActiveRequest
						end

						v20(configKey, false, p3)

						if p4 ~= nil then
							p3 = p4
						end

						return callback2(p3)
					else
						if FFlagSduiRequestCounters then
							SduiPageAnalytics.sendRequestOutcomeCounter(
								requestConfig.surfaceKey,
								v11,
								"failure",
								v17,
								v18
							)
						end

						v16(v19)
						local v20

						if FFlagLuaAppEnableSduiHomePage then
							v20 = fn3
						else
							v20 = completeActiveRequest
						end

						return v20(configKey, false, p3)
					end
				end or nil

				local v19 = fn5(function(p3, data)
					if
						FFlagHomePageRefetchOnDataHydrationAccountReset
						and checkAndReportStaleResponse(v6, requestConfig, "response") -- inferred equivalent call
						or FFlagSduiReleaseSearchResultsPageState and v10 and v10.released
					then
						return v15(nil)
					end

					loadTimer.logUiResponseReceived()

					if not (FFlagLuaAppEnableSduiHomePage and v9) then
						if FFlagSduiReleaseSearchResultsPageState then
							if v10 and v3[configKey] == v10 then
								v3[configKey] = nil
							end
						else
							v3[configKey] = false
						end
					end

					local sendPageStatusEvent = SduiPageAnalytics.sendPageStatusEvent
					local surfaceKey = requestConfig.surfaceKey
					local statusCode

					if FFlagSduiUseHttpClient then
						statusCode = data.statusCode
					else
						statusCode = data.StatusCode
					end

					local v19

					if FFlagSduiUseHttpClient then
						v19 = data.httpError
					else
						v19 = data.HttpError
					end

					sendPageStatusEvent(surfaceKey, statusCode, v19)

					if FFlagSduiRequestCounters then
						local v20

						if FFlagSduiUseHttpClient then
							v20 = data.statusCode
						else
							v20 = data.StatusCode
						end

						v17 = v20
						local v21

						if FFlagSduiUseHttpClient then
							v21 = data.httpError
						else
							v21 = data.HttpError
						end

						v18 = v21
					end

					if p3 then
						local statusCode2

						if FFlagSduiUseHttpClient then
							statusCode2 = data.statusCode
						else
							statusCode2 = data.StatusCode
						end

						local httpError

						if FFlagSduiUseHttpClient then
							httpError = data.httpError
						else
							httpError = data.HttpError
						end

						local v20

						if statusCode2 then
							v20 = tonumber(statusCode2)
						end

						local v21

						if FFlagSduiUseHttpClient then
							v21 = data.wasTransportFailure == true
						else
							v21 = false
						end

						if v20 and v20 >= 400 or httpError and httpError ~= Enum.HttpError.OK or v21 then
							loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)
						else
							loadTimer.updateRequestStatus(SduiRequestStatus.LoadedFromNetwork)

							if FFlagLuaAppEnableSduiHomePage or FFlagLuaAppSduiSearchAutocomplete then
								local v22 = requestConfig

								if
									fn2 ~= nil and not fn2()
									or v22.isResponseCurrent ~= nil and not v22.isResponseCurrent()
								then
									if
										(FFlagLuaAppEnableSduiApiStoreInFlightFix or FFlagLuaAppSduiSearchAutocomplete)
										and not v9
									then
										local v23 = configKey
										local v24 = v4[v23]

										if v24 then
											v4[v23] = nil

											v24.resolve(nil)
										end
									end

									return callback(nil)
								end
							end

							local v22

							if FFlagSduiUseHttpClient then
								v22 = data.responseBody
							else
								v22 = data.Body
							end

							SduiPageAnalytics.sendPagePayloadSizeEvent(requestConfig.surfaceKey, v22)

							if v14 then
								local finalize = v14.finalize(v22)

								if finalize.ok then
									local v23

									if FFlagLuaAppEnableSduiHomePage then
										v23 = fn3
									else
										v23 = completeActiveRequest
									end

									v23(configKey, true, finalize.value, v13)

									return callback(finalize.value)
								else
									local stringifyValue = SduiParseHelpers.stringifyValue(finalize.value)
									SduiLogger.reportError(
										SduiErrors.SduiErrorType.FailedToFetchPage,
										{
											message = stringifyValue,
											name = requestConfig.surfaceKey
										},
										requestConfig.surfaceKey
									)
									loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)

									if FFlagHomeSduiOfflineCache then
										return fn6(finalize.value)
									end

									local v23

									if FFlagLuaAppEnableSduiHomePage then
										v23 = fn3
									else
										v23 = completeActiveRequest
									end

									v23(configKey, false, finalize.value)

									return callback2(finalize.value)
								end
							else
								local success, result, v23 = pcall(processSduiResponse, data)

								if success then
									local v24 = {}

									if FFlagPromptsEdpOpenReplaceOnFetch and requestConfig.replaceOnFetch then
										local data2 = p2.data(false)

										for k, v25 in result do
											v24[k] = v25
										end

										if data2 then
											for k in data2 do
												if result[k] == nil then
													v24[k] = Cryo.None
												end
											end
										end
									elseif next(result) then
										local data2 = p2.data(false)

										for k, joined in result do
											local v25 = data2 and data2[k]

											if v25 then
												joined = Cryo.Dictionary.join(v25, joined)
											end

											v24[k] = joined
										end
									elseif requestConfig.clearOnEmptyResponse and requestConfig.configKey then
										v24[requestConfig.configKey] = {}
									end

									local v25

									if FFlagLuaAppEnableSduiHomePage then
										v25 = fn3
									else
										v25 = completeActiveRequest
									end

									v25(configKey, true, v24, v23)

									return callback(v24)
								else
									local stringifyValue = SduiParseHelpers.stringifyValue(result)

									SduiLogger.reportError(
										SduiErrors.SduiErrorType.FailedToFetchPage,
										{
											message = `handleSduiApiResponse not successful for {url} err {stringifyValue}`,
											name = requestConfig.surfaceKey
										},
										requestConfig.surfaceKey
									)

									if FFlagHomeSduiOfflineCache then
										return fn6(result, p2)
									end

									local v24

									if FFlagLuaAppEnableSduiHomePage then
										v24 = fn3
									else
										v24 = completeActiveRequest
									end

									v24(configKey, false, result)

									return callback2(p2)
								end
							end
						end
					end

					if FFlagLuaAppEnableSduiHomePage or FFlagLuaAppSduiSearchAutocomplete then
						local v20 = requestConfig

						if fn2 ~= nil and not fn2() or v20.isResponseCurrent ~= nil and not v20.isResponseCurrent() then
							if
								(FFlagLuaAppEnableSduiApiStoreInFlightFix or FFlagLuaAppSduiSearchAutocomplete)
								and not v9
							then
								local v21 = configKey
								local v22 = v4[v21]

								if v22 then
									v4[v21] = nil

									v22.resolve(nil)
								end
							end

							return callback(nil)
						end
					end

					if FFlagHomeSduiOfflineCache then
						return fn6(data)
					end

					local v20

					if FFlagLuaAppEnableSduiHomePage then
						v20 = fn3
					else
						v20 = completeActiveRequest
					end

					v20(configKey, false, data)

					return callback2(data)
				end)

				if v19 ~= nil then
					callback3(v19)
				end
			end)
		end

		if not FFlagSduiUseHttpClient then
			return createRequestPromise(function(p3): nil
				local v15 = {
					Url = url,
					Method = method,
					Headers = 0,
					Body = 0,
					OnMessage = 0,
					Priority = 0
				}
				local headers

				if FFlagSduiMrRouterHeaders then
					local v16

					if postConfig then
						v16 = SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig)
					end

					headers = buildSduiRequestHeaders(v12 and "application/json" or "application/x-protobuf", v16)
				else
					headers = {
						["Accept"] = nil,
						Accept = v12 and "application/json" or "application/x-protobuf"
					}
					local contentType

					if postConfig then
						contentType = SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig)
					end

					headers["Content-Type"] = contentType
				end

				v15.Headers = headers
				local body

				if postConfig then
					body = SduiApiStorePostConfig.getBodyFromPostConfig(postConfig)
				end

				v15.Body = body
				local onMessage

				if v14 then
					onMessage = v14.handleChunk
				end

				v15.OnMessage = onMessage
				v15.Priority = defineFastInt
				HttpService:RequestInternal(v15):Start(p3)
				return nil
			end)
		end

		local body

		if postConfig then
			body = SduiApiStorePostConfig.getBodyFromPostConfig(postConfig)
		end

		local contentType

		if postConfig then
			contentType = SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig)
		end

		local resolved = SduiRetryPolicy.resolve(requestConfig.retry)

		if FFlagSduiRequestCounters and resolved ~= nil then
			local onRetry = resolved.onRetry
			resolved = Cryo.Dictionary.join(resolved, {
				onRetry = function(p3: number)
					if onRetry ~= nil then
						onRetry(p3)
					end

					SduiPageAnalytics.sendRequestRetryCounter(requestConfig.surfaceKey, v11, p3)
				end
			})
		end

		local deadlineSec

		if p and p.requestDeadlineSec then
			deadlineSec = p.requestDeadlineSec
		else
			deadlineSec = SduiRetryPolicy.getRequestDeadlineSec()
		end

		local v15 = {
			url = url,
			method = method,
			body = body,
			contentType = contentType,
			accept = v12 and "application/json" or "application/x-protobuf",
			analyticsKey = requestConfig.surfaceKey,
			priority = defineFastInt,
			retry = resolved,
			deadlineSec = deadlineSec,
			network = p and p.network or nil,
			delivery = v14 and { mode = "streaming", onMessage = v14.handleChunk } or {
				mode = "buffered"
			}
		}

		return createRequestPromise(function(callback)
			local v16 = sendSduiHttpRequest(v15)
			v16:andThen(function(p3)
				callback(true, p3)
			end, function(p3)
				if typeof(p3) == "table" and (p3.statusCode ~= nil or p3.httpError ~= nil) then
					callback(true, p3)
				else
					callback(false, p3)
				end
			end)
			return function()
				v16:cancel()
			end
		end)
	end

	local v9 = {
		cache = dataCache,
		fetchFn = fetchFunction,
		queueProcessDelaySec = 0,
		supportsMultiGet = false,
		requestTimeoutSec = 0,
		onBeforeClear = 0
	}
	local requestTimeoutSec

	if FFlagSduiUseHttpClient then
		requestTimeoutSec = SduiRetryPolicy.getFetchTimeoutSec()
	end

	v9.requestTimeoutSec = requestTimeoutSec
	v9.onBeforeClear = FFlagHomePageRefetchOnDataHydrationAccountReset and function()
		local v10 = v4
		v4 = {}
		v3 = {}
		v = {}

		if v2 ~= nil then
			v2 = {}
		end

		v5 = {}

		if FFlagSduiReleaseSearchResultsPageState then
			v7 = {}
		end

		for _, v11 in v10 do
			v11.resolve(nil)
		end
	end or nil
	v6 = createDataResolver(v9)

	local function fetchIfNeeded(joined, flag: boolean?)
		if joined.responseType == nil then
			joined.responseType = SduiResponseType.Protobuf
		end

		local configKey = joined.configKey or joined.url

		local v10 = FFlagLuaAppEnableSduiHomePage
			and joined.concurrencyPolicy == SduiRequestConcurrencyPolicy.LatestWins
		joined.configKey = configKey
		joined.loadTimer.logUiRequestQueued()

		if FFlagHomePageRefetchOnDataHydrationAccountReset then
			joined.accountGeneration = v6.getAccountGeneration(false)
			joined.accountPlayerId = getLocalPlayerUserId()
		end

		if FFlagLuaAppEnableSduiHomePage and v10 then
			local concurrencyKey = joined.concurrencyKey or configKey
			local v11 = v2
			local v12 = (v11[concurrencyKey] or 0) + 1
			v11[concurrencyKey] = v12

			return fetchFunction(configKey, v6.getCachedItem(configKey), joined, function(): boolean
				return v11[concurrencyKey] == v12
			end):andThen(function(p2)
				if
					FFlagHomePageRefetchOnDataHydrationAccountReset
					and p2 ~= nil
					and checkAndReportStaleResponse(v6, joined, "cacheCommit") -- inferred equivalent call
				then
					return nil
				end

				if p2 ~= nil and not joined.enableInputDataMerge then
					dataCache.updateItems({ [configKey] = p2 })
				end

				return p2
			end)
		else
			v[configKey] = joined

			local _, v11 = v6.getAndFetchItem(configKey, flag and function(): boolean
				return true
			end or nil, joined.staleTimeSec)

			if not v11 then
				return Promise.resolve()
			end

			if v4[configKey] then
				return v4[configKey].promise
			end

			local resolve = nil
			local reject = nil
			local promise = Promise.new(function(p2, p3)
				resolve = p2
				reject = p3
			end)
			promise:catch(function(_) end)
			v4[configKey] = { promise = promise, resolve = resolve, reject = reject }

			return v4[configKey].promise
		end
	end

	local function getInputData(p2: string, p3: string?, p4)
		local v10

		if p3 and p3 ~= "" then
			v10 = `{p2}_{p3}`
		end

		if FFlagSduiFreshInputDataSignalOnRebuild and p4 then
			getInputDataSignalsGeneration(v10 or p2).get(p4) -- inferred equivalent call
		end

		local sduiCacheEntry = resolveSduiCacheEntry(v5, p2, v10)

		if sduiCacheEntry == nil then
			return nil
		end

		local get = sduiCacheEntry.get

		if p4 == nil then
			p4 = false
		end

		return get(p4)
	end

	local function forEachInputData(p2: string, callback)
		local data = v6.getCachedItem(p2).data(false)

		if data == nil then
			return
		end

		for k in data do
			local v10 = v5[k]
			local v11

			if v10 then
				v11 = v10.get(false)
			end

			if v11 ~= nil and callback(k, v11) then
				break
			end
		end
	end

	local function setInputDataField(p2: string, p3: string, p4: string, p5): boolean
		local data = v6.getCachedItem(p2).data(false)
		local v10 = v5[p3]

		if data == nil or data[p3] == nil or v10 == nil then
			return false
		end

		local v11 = v10.get(false)
		local v12

		if v11 then
			v12 = v11[p4]
		end

		if v12 == nil or p5 == nil or typeof(p5) ~= typeof(v12) then
			return false
		end

		local clone = table.clone(v11)
		clone[p4] = p5
		v10.set(clone)
		return true
	end

	local function getRootConfig(p2: string, p3, p4: string?)
		local data = v6.getCachedItem(p2).data(p3)
		local v10

		if FFlagSduiAlwaysCacheWithIdentifier then
			v10 = resolveSduiCacheEntry(data, p2, p4)
		else
			v10 = data and data[p4 or p2]
		end

		return if v10 then v10.config else nil
	end

	local function getTitle(p2: string, p3, p4: string?)
		local data = v6.getCachedItem(p2).data(p3)
		local v10

		if FFlagSduiAlwaysCacheWithIdentifier then
			v10 = resolveSduiCacheEntry(data, p2, p4)
		else
			v10 = data and data[p4 or p2]
		end

		return if v10 and v10.title ~= "" then v10.title else nil
	end

	local function getDataUpdatedTimestamp(p2: string, p3, p4: string?)
		local data = v6.getCachedItem(p2).data(p3)
		local v10

		if FFlagSduiAlwaysCacheWithIdentifier then
			v10 = resolveSduiCacheEntry(data, p2, p4)
		else
			v10 = data and data[p4 or p2]
		end

		return if v10 then v10.dataUpdatedTimestamp else nil
	end

	local function getEntrySurfacing(p2: string, p3: string?, p4)
		local data = v6.getCachedItem(p2).data(p4)
		local v10

		if FFlagSduiAlwaysCacheWithIdentifier then
			v10 = resolveSduiCacheEntry(data, p2, p3)
		else
			v10 = data and data[p3 or p2]
		end

		return if v10 then v10.surfacing else nil
	end

	local function loadMoreFromApi(data)
		local v10 = v[data.configKey]

		if not v10 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToPaginateRequest,
				{
					message = `No requestData for {data.configKey}`
				},
				"unknown"
			)

			return Promise.resolve()
		end

		local data2 = v6.getCachedItem(data.configKey).data(false)
		local v11

		if FFlagSduiAlwaysCacheWithIdentifier then
			v11 = resolveSduiCacheEntry(data2, data.configKey, data.identifier)
		else
			v11 = data2 and data2[data.identifier or data.configKey]
		end

		if not v11 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToPaginateRequest,
				{
					message = `No entry data for {data.configKey}`,
					name = v10.surfaceKey
				},
				v10.surfaceKey
			)
			return Promise.resolve()
		end

		local nextPageUrl = v11.nextPageUrl

		if not nextPageUrl or nextPageUrl == "" then
			return Promise.resolve()
		end

		local v12 = { url = nextPageUrl, loadTimer = data.loadTimer, isPaginated = true }

		if v10.postConfig and v11.nextPagePostBody then
			v12.postConfig = Cryo.Dictionary.join(v10.postConfig, { body = v11.nextPagePostBody })
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v10, v12), true)
	end

	local function refreshFromApi(p2)
		local v10 = v[p2.configKey]

		if not v10 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToFetchPage,
				{
					message = `No requestData for refresh: {p2.configKey}`
				},
				"unknown"
			)

			return Promise.resolve()
		end

		if v10.refresh then
			return v10.refresh(p2.loadTimer)
		end

		local v11

		if v10.buildRefreshUrl then
			v11 = v10.buildRefreshUrl()
		end

		local v12 = {
			url = v11 or v10.url,
			loadTimer = p2.loadTimer,
			isPaginated = Cryo.None
		}

		if FFlagSduiStreamingRefreshReplacesInputData and not v10.enableInputDataMerge then
			v12.enableInputDataMerge = false
		end

		if v10.postConfig then
			local body

			if v10.buildRefreshPostBody then
				body = v10.buildRefreshPostBody()
			end

			if body then
				v12.postConfig = Cryo.Dictionary.join(v10.postConfig, { body = body })
			end
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v10, v12), true)
	end

	fn = function(data)
		local configKey = data.configKey
		local loadTimer = data.loadTimer

		if FFlagHomeSduiOfflineCache and data.requestConfig ~= nil then
			v[configKey] = data.requestConfig
		else
			loadTimer.logUiRequestQueued()
			v[configKey] = {
				url = `inline://{configKey}`,
				surfaceKey = data.surfaceKey,
				configKey = configKey,
				loadTimer = loadTimer,
				apiProto = data.apiProto,
				responseType = SduiResponseType.Protobuf
			}
		end

		local requestConfig

		if FFlagHomeSduiOfflineCache then
			requestConfig = data.requestConfig
		else
			requestConfig = nil
		end

		local data2 = v6.getCachedItem(configKey).data(false)

		local success, result = pcall(function()
			local response

			if FFlagSduiUseHttpClient then
				response = { statusCode = 200, responseBody = data.decodedResponse, stats = {} }
			else
				response = { Body = data.decodedResponse, Stats = {}, StatusCode = 200 }
			end

			local v10 = {
				response = response,
				loadTimer = loadTimer,
				surfaceKey = data.surfaceKey,
				configCacheKey = configKey,
				decodeResponse = function(p2)
					return p2
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
			local parseTemplateEntriesFromResponse

			if FFlagHomeSduiOfflineCache and requestConfig ~= nil then
				parseTemplateEntriesFromResponse = requestConfig.parseTemplateEntriesFromResponse
					or SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse
			else
				parseTemplateEntriesFromResponse = SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse
			end

			v10.parseTemplateEntriesFromResponse = parseTemplateEntriesFromResponse
			local parsePageEntriesFromResponse

			if FFlagHomeSduiOfflineCache and requestConfig ~= nil then
				parsePageEntriesFromResponse = requestConfig.parsePageEntriesFromResponse
					or SduiProtobufResponseHelpers.parsePageEntriesFromResponse
			else
				parsePageEntriesFromResponse = SduiProtobufResponseHelpers.parsePageEntriesFromResponse
			end

			v10.parsePageEntriesFromResponse = parsePageEntriesFromResponse
			local parseLocalizedLiteralsFromResponse

			if FFlagHomeSduiOfflineCache and requestConfig ~= nil then
				parseLocalizedLiteralsFromResponse = requestConfig.parseLocalizedLiteralsFromResponse
					or SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
			else
				parseLocalizedLiteralsFromResponse = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
			end

			v10.parseLocalizedLiteralsFromResponse = parseLocalizedLiteralsFromResponse
			local getInputDataSignalsForRequest

			if FFlagSduiReleaseSearchResultsPageState then
				getInputDataSignalsForRequest = createGetInputDataSignalsForRequest(configKey) -- inferred equivalent call
			else
				getInputDataSignalsForRequest = getInputDataSignals
			end

			v10.getInputDataSignalsForRequest = getInputDataSignalsForRequest
			local setInputDataSignalsForRequest

			if FFlagSduiFreshInputDataSignalOnRebuild then
				setInputDataSignalsForRequest = setInputDataSignals
			end

			v10.setInputDataSignalsForRequest = setInputDataSignalsForRequest
			local allowNoConfigsBuilt

			if FFlagHomeSduiOfflineCache and requestConfig ~= nil and FFlagSduiAllowNoConfigsBuilt then
				allowNoConfigsBuilt = requestConfig.allowNoConfigsBuilt
			end

			v10.allowNoConfigsBuilt = allowNoConfigsBuilt
			local mergeStrategy

			if FFlagHomeSduiOfflineCache and requestConfig ~= nil then
				mergeStrategy = requestConfig.mergeStrategy
			end

			v10.mergeStrategy = mergeStrategy
			local enableTemplateCache

			if FFlagHomeSduiOfflineCache and requestConfig ~= nil then
				enableTemplateCache = requestConfig.enableTemplateCache
			end

			v10.enableTemplateCache = enableTemplateCache
			return handleSduiApiResponse(v10)
		end)

		if not success then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToFetchPage,
				{
					message = `seedFromDecodedResponse failed for {configKey}: {SduiParseHelpers.stringifyValue(result)}`,
					name = data.surfaceKey
				},
				data.surfaceKey
			)
			error(result)
		end

		if FFlagAppChatConversationTrustedFriendUpsellBanner and data.replace then
			dataCache.replaceItems({ [configKey] = result })
			return
		end

		local v10 = accumulateSduiCacheSubEntries(result, data2)
		dataCache.updateItems({ [configKey] = v10 })
	end

	local function dismissEntry(value: string)
		local result = {}

		if typeof(value) ~= "string" or value == "" then
			return result
		end

		for k in v do
			local data = v6.getCachedItem(k).data(false)

			if not data then
				continue
			end

			local v10 = {}
			local flag = false

			for k2, v11 in data do
				if v11 and v11.category ~= nil and v11.title == value then
					flag = true
				else
					v10[k2] = v11
				end
			end

			if not flag then
				continue
			end

			dataCache.replaceItems({ [k] = v10 })
			table.insert(result, k)
		end

		return result
	end

	local function clearConfigEntries(value: string)
		if typeof(value) ~= "string" or value == "" then
			return
		end

		dataCache.replaceItems({ [value] = {} })
	end

	local function releaseConfigKey(p2: string)
		if p2 == "" then
			return
		end

		local v10 = v7
		local v11

		if v10 then
			v11 = v10[p2]
		end

		if v11 ~= nil then
			for k in v11 do
				v5[k] = nil
				v8[k] = nil
			end
		end

		if v10 ~= nil then
			v10[p2] = nil
		end

		v[p2] = nil
		local v12 = v3[p2]

		if v12 then
			v12.released = true
			v3[p2] = nil
		end

		local v13 = v4[p2]
		v4[p2] = nil

		if v13 then
			v13.resolve(nil)
		end

		v6.releaseItem(p2)
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

	if not FFlagSduiReleaseSearchResultsPageState then
		releaseConfigKey = nil
	end

	sduiApiStore.releaseConfigKey = releaseConfigKey
	sduiApiStore.isInFlight = isInFlight

	if not FFlagAppChatConversationTrustedFriendUpsellBanner then
		clearConfigEntries = nil
	end

	sduiApiStore.clearConfigEntries = clearConfigEntries

	if not FFlagSduiDismissPromptAction then
		dismissEntry = nil
	end

	sduiApiStore.dismissEntry = dismissEntry
	sduiApiStore.seedFromDecodedResponse = fn
	sduiApiStore.getData = v6.getCachedItem
	sduiApiStore.getInputData = getInputData

	if not FFlagSduiApiStoreUpdateInputData then
		forEachInputData = nil
	end

	sduiApiStore.forEachInputData = forEachInputData

	if not FFlagSduiApiStoreUpdateInputData then
		setInputDataField = nil
	end

	sduiApiStore.setInputDataField = setInputDataField
	sduiApiStore.getRootConfig = getRootConfig
	sduiApiStore.getTitle = getTitle
	sduiApiStore.getDataUpdatedTimestamp = getDataUpdatedTimestamp
	local getAccountGeneration

	if FFlagHomePageRefetchOnDataHydrationAccountReset then
		getAccountGeneration = v6.getAccountGeneration
	end

	sduiApiStore.getAccountGeneration = getAccountGeneration

	sduiApiStore.getEntrySurfacing = getEntrySurfacing
	sduiApiStore.loadMoreFromApi = loadMoreFromApi
	sduiApiStore.refreshFromApi = refreshFromApi
	return sduiApiStore
end

return createSduiApiStore

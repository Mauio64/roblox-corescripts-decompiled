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
local createSduiStreamingResponseHandler = require(SduiSharedUtilities.createSduiStreamingResponseHandler)
local SduiRetryPolicy = require(SduiSharedUtilities.SduiRetryPolicy)
local sendSduiHttpRequest = require(SduiSharedUtilities.sendSduiHttpRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiAlwaysCacheWithIdentifier = SharedFlags2.FFlagSduiAlwaysCacheWithIdentifier
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiDismissPromptAction = SharedFlags3.FFlagSduiDismissPromptAction
local SharedFlags4 = require(parent.SharedFlags)
local FFlagPromptsEdpOpenReplaceOnFetch = SharedFlags4.FFlagPromptsEdpOpenReplaceOnFetch
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiApiStoreUpdateInputData = SharedFlags5.FFlagSduiApiStoreUpdateInputData

local SharedFlags6 = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags6.FFlagAppChatConversationTrustedFriendUpsellBanner
local FFlagSduiRequestCounters = require(SduiSharedUtilities.Flags.FFlagSduiRequestCounters)
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiFreshInputDataSignalOnRebuild = SharedFlags7.FFlagSduiFreshInputDataSignalOnRebuild
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags8.FFlagLuaAppEnableSduiHomePage

local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiStreamingRefreshReplacesInputData = SharedFlags9.FFlagSduiStreamingRefreshReplacesInputData
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocomplete = SharedFlags10.FFlagLuaAppSduiSearchAutocomplete
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiApiStoreInFlightFix = SharedFlags11.FFlagLuaAppEnableSduiApiStoreInFlightFix
local SharedFlags12 = require(parent.SharedFlags)
local FFlagDataHydrationAccountReset = SharedFlags12.FFlagDataHydrationAccountReset

local SharedFlags13 = require(parent.SharedFlags)
local FFlagHomePageRefetchOnDataHydrationAccountReset = SharedFlags13.FFlagHomePageRefetchOnDataHydrationAccountReset
local SharedFlags14 = require(parent.SharedFlags)
local FFlagSduiReleaseSearchResultsPageState = SharedFlags14.FFlagSduiReleaseSearchResultsPageState

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

		local enableStreaming = requestConfig.enableStreaming
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
					enableInputDataMerge2 = enableStreaming or requestConfig.enableInputDataMerge or nil
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

			v13.enableStreamingMerge = enableStreaming
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

		local function fn4(p3)
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
		end

		local v13 = nil
		local v14

		if enableStreaming then
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

					local success, result, v15 = pcall(processSduiResponse, {
						statusCode = 200,
						responseBody = buffer.fromstring(str),
						stats = {}
					})

					if not success then
						return false, result
					end

					v13 = v15
					local v16 = accumulateSduiCacheSubEntries(result, p2.data(false))
					dataCache.updateItems({ [configKey] = v16 })
					return true, v16
				end
			})
		else
			v14 = nil
		end

		local function createRequestPromise(fn5)
			return Promise.new(function(callback, p3, callback2)
				local v15 = callback

				local statusCode = nil
				local httpError = nil

				if FFlagSduiRequestCounters then
					local v16 = p3
					callback = function(p4)
						SduiPageAnalytics.sendRequestOutcomeCounter(
							requestConfig.surfaceKey,
							v11,
							"success",
							statusCode,
							httpError
						)

						return v15(p4)
					end

					p3 = function(p4)
						SduiPageAnalytics.sendRequestOutcomeCounter(
							requestConfig.surfaceKey,
							v11,
							"failure",
							statusCode,
							httpError
						)

						return v16(p4)
					end
				end

				local function fn6(p4, p5)
					local v16 = fn4(p4)

					if v16 == nil then
						local v17

						if FFlagLuaAppEnableSduiHomePage then
							v17 = fn3
						else
							v17 = completeActiveRequest
						end

						v17(configKey, false, p4)

						if p5 ~= nil then
							p4 = p5
						end

						return p3(p4)
					else
						if FFlagSduiRequestCounters then
							SduiPageAnalytics.sendRequestOutcomeCounter(
								requestConfig.surfaceKey,
								v11,
								"failure",
								statusCode,
								httpError
							)
						end

						v15(v16)
						local v17

						if FFlagLuaAppEnableSduiHomePage then
							v17 = fn3
						else
							v17 = completeActiveRequest
						end

						return v17(configKey, false, p4)
					end
				end

				local v16 = fn5(function(p4, data)
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

					SduiPageAnalytics.sendPageStatusEvent(requestConfig.surfaceKey, data.statusCode, data.httpError)

					if FFlagSduiRequestCounters then
						statusCode = data.statusCode
						httpError = data.httpError
					end

					if p4 then
						local statusCode2 = data.statusCode
						local httpError2 = data.httpError
						local v16

						if statusCode2 then
							v16 = tonumber(statusCode2)
						end

						local wasTransportFailure = data.wasTransportFailure == true

						if
							v16 and v16 >= 400
							or httpError2 and httpError2 ~= Enum.HttpError.OK
							or wasTransportFailure
						then
							loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)
						else
							loadTimer.updateRequestStatus(SduiRequestStatus.LoadedFromNetwork)

							if FFlagLuaAppEnableSduiHomePage or FFlagLuaAppSduiSearchAutocomplete then
								local v17 = requestConfig

								if
									fn2 ~= nil and not fn2()
									or v17.isResponseCurrent ~= nil and not v17.isResponseCurrent()
								then
									if
										(FFlagLuaAppEnableSduiApiStoreInFlightFix or FFlagLuaAppSduiSearchAutocomplete)
										and not v9
									then
										local v18 = configKey
										local v19 = v4[v18]

										if v19 then
											v4[v18] = nil

											v19.resolve(nil)
										end
									end

									return callback(nil)
								end
							end

							local responseBody = data.responseBody

							SduiPageAnalytics.sendPagePayloadSizeEvent(requestConfig.surfaceKey, responseBody)

							if v14 then
								local finalize = v14.finalize(responseBody)

								if finalize.ok then
									local v17

									if FFlagLuaAppEnableSduiHomePage then
										v17 = fn3
									else
										v17 = completeActiveRequest
									end

									v17(configKey, true, finalize.value, v13)

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
									return fn6(finalize.value)
								end
							else
								local success, result, v17 = pcall(processSduiResponse, data)

								if success then
									local v18 = {}

									if FFlagPromptsEdpOpenReplaceOnFetch and requestConfig.replaceOnFetch then
										local data2 = p2.data(false)

										for k, v19 in result do
											v18[k] = v19
										end

										if data2 then
											for k in data2 do
												if result[k] == nil then
													v18[k] = Cryo.None
												end
											end
										end
									elseif next(result) then
										local data2 = p2.data(false)

										for k, joined in result do
											local v19 = data2 and data2[k]

											if v19 then
												joined = Cryo.Dictionary.join(v19, joined)
											end

											v18[k] = joined
										end
									elseif requestConfig.clearOnEmptyResponse and requestConfig.configKey then
										v18[requestConfig.configKey] = {}
									end

									local v19

									if FFlagLuaAppEnableSduiHomePage then
										v19 = fn3
									else
										v19 = completeActiveRequest
									end

									v19(configKey, true, v18, v17)

									return callback(v18)
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
									return fn6(result, p2)
								end
							end
						end
					end

					if FFlagLuaAppEnableSduiHomePage or FFlagLuaAppSduiSearchAutocomplete then
						local v16 = requestConfig

						if fn2 ~= nil and not fn2() or v16.isResponseCurrent ~= nil and not v16.isResponseCurrent() then
							if
								(FFlagLuaAppEnableSduiApiStoreInFlightFix or FFlagLuaAppSduiSearchAutocomplete)
								and not v9
							then
								local v17 = configKey
								local v18 = v4[v17]

								if v18 then
									v4[v17] = nil

									v18.resolve(nil)
								end
							end

							return callback(nil)
						end
					end

					return fn6(data)
				end)

				if v16 ~= nil then
					callback2(v16)
				end
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
			method = postConfig and "POST" or "GET",
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

	v6 = createDataResolver({
		cache = dataCache,
		fetchFn = fetchFunction,
		queueProcessDelaySec = 0,
		supportsMultiGet = false,
		requestTimeoutSec = SduiRetryPolicy.getFetchTimeoutSec(),
		onBeforeClear = FFlagHomePageRefetchOnDataHydrationAccountReset and function()
			local v9 = v4
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

			for _, v10 in v9 do
				v10.resolve(nil)
			end
		end or nil
	})

	local function fetchIfNeeded(joined, flag: boolean?)
		if joined.responseType == nil then
			joined.responseType = SduiResponseType.Protobuf
		end

		local configKey = joined.configKey or joined.url

		local v9 = FFlagLuaAppEnableSduiHomePage and joined.concurrencyPolicy == SduiRequestConcurrencyPolicy.LatestWins
		joined.configKey = configKey
		joined.loadTimer.logUiRequestQueued()

		if FFlagHomePageRefetchOnDataHydrationAccountReset then
			joined.accountGeneration = v6.getAccountGeneration(false)
			joined.accountPlayerId = getLocalPlayerUserId()
		end

		if FFlagLuaAppEnableSduiHomePage and v9 then
			local concurrencyKey = joined.concurrencyKey or configKey
			local v10 = v2
			local v11 = (v10[concurrencyKey] or 0) + 1
			v10[concurrencyKey] = v11

			return fetchFunction(configKey, v6.getCachedItem(configKey), joined, function(): boolean
				return v10[concurrencyKey] == v11
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

			local _, v10 = v6.getAndFetchItem(configKey, flag and function(): boolean
				return true
			end or nil, joined.staleTimeSec)

			if not v10 then
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
		local v9

		if p3 and p3 ~= "" then
			v9 = `{p2}_{p3}`
		end

		if FFlagSduiFreshInputDataSignalOnRebuild and p4 then
			getInputDataSignalsGeneration(v9 or p2).get(p4) -- inferred equivalent call
		end

		local sduiCacheEntry = resolveSduiCacheEntry(v5, p2, v9)

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
			local v9 = v5[k]
			local v10

			if v9 then
				v10 = v9.get(false)
			end

			if v10 ~= nil and callback(k, v10) then
				break
			end
		end
	end

	local function setInputDataField(p2: string, p3: string, p4: string, p5): boolean
		local data = v6.getCachedItem(p2).data(false)
		local v9 = v5[p3]

		if data == nil or data[p3] == nil or v9 == nil then
			return false
		end

		local v10 = v9.get(false)
		local v11

		if v10 then
			v11 = v10[p4]
		end

		if v11 == nil or p5 == nil or typeof(p5) ~= typeof(v11) then
			return false
		end

		local clone = table.clone(v10)
		clone[p4] = p5
		v9.set(clone)
		return true
	end

	local function getRootConfig(p2: string, p3, p4: string?)
		local data = v6.getCachedItem(p2).data(p3)
		local v9

		if FFlagSduiAlwaysCacheWithIdentifier then
			v9 = resolveSduiCacheEntry(data, p2, p4)
		else
			v9 = data and data[p4 or p2]
		end

		return if v9 then v9.config else nil
	end

	local function getTitle(p2: string, p3, p4: string?)
		local data = v6.getCachedItem(p2).data(p3)
		local v9

		if FFlagSduiAlwaysCacheWithIdentifier then
			v9 = resolveSduiCacheEntry(data, p2, p4)
		else
			v9 = data and data[p4 or p2]
		end

		return if v9 and v9.title ~= "" then v9.title else nil
	end

	local function getDataUpdatedTimestamp(p2: string, p3, p4: string?)
		local data = v6.getCachedItem(p2).data(p3)
		local v9

		if FFlagSduiAlwaysCacheWithIdentifier then
			v9 = resolveSduiCacheEntry(data, p2, p4)
		else
			v9 = data and data[p4 or p2]
		end

		return if v9 then v9.dataUpdatedTimestamp else nil
	end

	local function getEntrySurfacing(p2: string, p3: string?, p4)
		local data = v6.getCachedItem(p2).data(p4)
		local v9

		if FFlagSduiAlwaysCacheWithIdentifier then
			v9 = resolveSduiCacheEntry(data, p2, p3)
		else
			v9 = data and data[p3 or p2]
		end

		return if v9 then v9.surfacing else nil
	end

	local function loadMoreFromApi(data)
		local v9 = v[data.configKey]

		if not v9 then
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
		local v10

		if FFlagSduiAlwaysCacheWithIdentifier then
			v10 = resolveSduiCacheEntry(data2, data.configKey, data.identifier)
		else
			v10 = data2 and data2[data.identifier or data.configKey]
		end

		if not v10 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToPaginateRequest,
				{
					message = `No entry data for {data.configKey}`,
					name = v9.surfaceKey
				},
				v9.surfaceKey
			)
			return Promise.resolve()
		end

		local nextPageUrl = v10.nextPageUrl

		if not nextPageUrl or nextPageUrl == "" then
			return Promise.resolve()
		end

		local v11 = { url = nextPageUrl, loadTimer = data.loadTimer, isPaginated = true }

		if v9.postConfig and v10.nextPagePostBody then
			v11.postConfig = Cryo.Dictionary.join(v9.postConfig, { body = v10.nextPagePostBody })
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v9, v11), true)
	end

	local function refreshFromApi(p2)
		local v9 = v[p2.configKey]

		if not v9 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToFetchPage,
				{
					message = `No requestData for refresh: {p2.configKey}`
				},
				"unknown"
			)

			return Promise.resolve()
		end

		if v9.refresh then
			return v9.refresh(p2.loadTimer)
		end

		local v10

		if v9.buildRefreshUrl then
			v10 = v9.buildRefreshUrl()
		end

		local v11 = {
			url = v10 or v9.url,
			loadTimer = p2.loadTimer,
			isPaginated = Cryo.None
		}

		if FFlagSduiStreamingRefreshReplacesInputData and not v9.enableInputDataMerge then
			v11.enableInputDataMerge = false
		end

		if v9.postConfig then
			local body

			if v9.buildRefreshPostBody then
				body = v9.buildRefreshPostBody()
			end

			if body then
				v11.postConfig = Cryo.Dictionary.join(v9.postConfig, { body = body })
			end
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v9, v11), true)
	end

	fn = function(data)
		local configKey = data.configKey
		local loadTimer = data.loadTimer

		if data.requestConfig == nil then
			loadTimer.logUiRequestQueued()
			v[configKey] = {
				url = `inline://{configKey}`,
				surfaceKey = data.surfaceKey,
				configKey = configKey,
				loadTimer = loadTimer,
				apiProto = data.apiProto,
				responseType = SduiResponseType.Protobuf
			}
		else
			v[configKey] = data.requestConfig
		end

		local requestConfig = data.requestConfig
		local data2 = v6.getCachedItem(configKey).data(false)

		local success, result = pcall(function()
			local v9 = {
				response = { statusCode = 200, responseBody = data.decodedResponse, stats = {} },
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

			if requestConfig == nil then
				parseTemplateEntriesFromResponse = SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse
			else
				parseTemplateEntriesFromResponse = requestConfig.parseTemplateEntriesFromResponse
					or SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse
			end

			v9.parseTemplateEntriesFromResponse = parseTemplateEntriesFromResponse
			local parsePageEntriesFromResponse

			if requestConfig == nil then
				parsePageEntriesFromResponse = SduiProtobufResponseHelpers.parsePageEntriesFromResponse
			else
				parsePageEntriesFromResponse = requestConfig.parsePageEntriesFromResponse
					or SduiProtobufResponseHelpers.parsePageEntriesFromResponse
			end

			v9.parsePageEntriesFromResponse = parsePageEntriesFromResponse
			local parseLocalizedLiteralsFromResponse

			if requestConfig == nil then
				parseLocalizedLiteralsFromResponse = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
			else
				parseLocalizedLiteralsFromResponse = requestConfig.parseLocalizedLiteralsFromResponse
					or SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
			end

			v9.parseLocalizedLiteralsFromResponse = parseLocalizedLiteralsFromResponse
			local getInputDataSignalsForRequest

			if FFlagSduiReleaseSearchResultsPageState then
				getInputDataSignalsForRequest = createGetInputDataSignalsForRequest(configKey) -- inferred equivalent call
			else
				getInputDataSignalsForRequest = getInputDataSignals
			end

			v9.getInputDataSignalsForRequest = getInputDataSignalsForRequest
			local setInputDataSignalsForRequest

			if FFlagSduiFreshInputDataSignalOnRebuild then
				setInputDataSignalsForRequest = setInputDataSignals
			end

			v9.setInputDataSignalsForRequest = setInputDataSignalsForRequest
			local allowNoConfigsBuilt

			if not (requestConfig == nil or not FFlagSduiAllowNoConfigsBuilt) then
				allowNoConfigsBuilt = requestConfig.allowNoConfigsBuilt
			end

			v9.allowNoConfigsBuilt = allowNoConfigsBuilt
			local mergeStrategy

			if requestConfig ~= nil then
				mergeStrategy = requestConfig.mergeStrategy
			end

			v9.mergeStrategy = mergeStrategy
			local enableTemplateCache

			if requestConfig ~= nil then
				enableTemplateCache = requestConfig.enableTemplateCache
			end

			v9.enableTemplateCache = enableTemplateCache
			return handleSduiApiResponse(v9)
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

		local v9 = accumulateSduiCacheSubEntries(result, data2)
		dataCache.updateItems({ [configKey] = v9 })
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

			local v9 = {}
			local flag = false

			for k2, v10 in data do
				if v10 and v10.category ~= nil and v10.title == value then
					flag = true
				else
					v9[k2] = v10
				end
			end

			if not flag then
				continue
			end

			dataCache.replaceItems({ [k] = v9 })
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

		local v9 = v7
		local v10

		if v9 then
			v10 = v9[p2]
		end

		if v10 ~= nil then
			for k in v10 do
				v5[k] = nil
				v8[k] = nil
			end
		end

		if v9 ~= nil then
			v9[p2] = nil
		end

		v[p2] = nil
		local v11 = v3[p2]

		if v11 then
			v11.released = true
			v3[p2] = nil
		end

		local v12 = v4[p2]
		v4[p2] = nil

		if v12 then
			v12.resolve(nil)
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

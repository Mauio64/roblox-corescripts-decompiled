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
local createSduiStreamingResponseHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/createSduiStreamingResponseHandler")
local SduiRetryPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiRetryPolicy")
local sendSduiHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/sendSduiHttpRequest")
local fFlagSduiAllowNoConfigsBuilt = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAllowNoConfigsBuilt
local fFlagSduiAlwaysCacheWithIdentifier = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAlwaysCacheWithIdentifier
local fFlagSduiDismissPromptAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiDismissPromptAction
local fFlagPromptsEdpOpenReplaceOnFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagPromptsEdpOpenReplaceOnFetch
local fFlagSduiApiStoreUpdateInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiApiStoreUpdateInputData

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner
local FFlagSduiRequestCounters = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/Flags/FFlagSduiRequestCounters")
local fFlagSduiFreshInputDataSignalOnRebuild = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiFreshInputDataSignalOnRebuild
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

		local enableStreaming = data.enableStreaming
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
					v21 = enableStreaming or data.enableInputDataMerge or nil
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

			v23.enableStreamingMerge = enableStreaming
			v23.enableInputDataMerge = v21
			v23.paginateResponse = v20
			v23.buildNextPageUrl = data.buildNextPageUrl
			v23.buildNextPagePostBody = data.buildNextPagePostBody
			local v26 = if fFlagSduiAllowNoConfigsBuilt then data.allowNoConfigsBuilt else nil
			v23.allowNoConfigsBuilt = v26
			v23.mergeStrategy = data.mergeStrategy

			local v27 = if fFlagLuaAppEnableSduiHomePage then data.cacheSingleEntryWithIdentifier else nil
			v23.cacheSingleEntryWithIdentifier = v27

			v23.enableTemplateCache = data.enableTemplateCache
			local v28, v29 = handleSduiApiResponse(v23)

			if fFlagSduiStreamingRefreshReplacesInputData then
				enableInputDataMerge = nil
			end

			return v28, v29
		end

		local function fn4(p4)
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
		end

		local v20 = nil
		local v21

		if enableStreaming then
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

					local success, result, v22 = pcall(processSduiResponse, {
						statusCode = 200,
						responseBody = buffer.fromstring(str),
						stats = {}
					})

					if not success then
						return false, result
					end

					v20 = v22
					local v23 = accumulateSduiCacheSubEntries(result, p3.data(false))
					dataCache.updateItems({ [configKey] = v23 })
					return true, v23
				end
			})
		else
			v21 = nil
		end

		local function createRequestPromise(fn5)
			return Promise.new(function(callback, p4, callback2)
				local v22 = callback

				local statusCode = nil
				local httpError = nil

				if FFlagSduiRequestCounters then
					local v23 = p4
					callback = function(p5)
						SduiPageAnalytics.sendRequestOutcomeCounter(
							data.surfaceKey,
							v16,
							"success",
							statusCode,
							httpError
						)

						return v22(p5)
					end

					p4 = function(p5)
						SduiPageAnalytics.sendRequestOutcomeCounter(
							data.surfaceKey,
							v16,
							"failure",
							statusCode,
							httpError
						)

						return v23(p5)
					end
				end

				local function fn6(p5, p6)
					local v23 = fn4(p5)

					if v23 == nil then
						local v24 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
						v24(configKey, false, p5)

						if p6 ~= nil then
							p5 = p6
						end

						return p4(p5)
					else
						if FFlagSduiRequestCounters then
							SduiPageAnalytics.sendRequestOutcomeCounter(
								data.surfaceKey,
								v16,
								"failure",
								statusCode,
								httpError
							)
						end

						v22(v23)
						local v24 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
						return v24(configKey, false, p5)
					end
				end

				local v23 = fn5(function(p5, data2)
					if fFlagHomePageRefetchOnDataHydrationAccountReset then
						local v24 = data
						local flag

						if v10.isCurrentRequest(v24.accountPlayerId, v24.accountGeneration) then
							flag = false
						else
							local v25 = v24.enableStreaming and "streaming" or "buffered"
							SduiPageAnalytics.sendStaleResponseDiscarded(v24.surfaceKey, v25, "response")
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

					SduiPageAnalytics.sendPageStatusEvent(data.surfaceKey, data2.statusCode, data2.httpError)

					if FFlagSduiRequestCounters then
						statusCode = data2.statusCode
						httpError = data2.httpError
					end

					if p5 then
						local statusCode2 = data2.statusCode
						local httpError2 = data2.httpError
						local v24 = if statusCode2 then tonumber(statusCode2) else nil
						local wasTransportFailure = data2.wasTransportFailure == true

						if
							v24 and v24 >= 400
							or httpError2 and httpError2 ~= Enum.HttpError.OK
							or wasTransportFailure
						then
							loadTimer.updateRequestStatus(sduiRequestStatus.FailedToLoad)
						else
							loadTimer.updateRequestStatus(sduiRequestStatus.LoadedFromNetwork)

							if fFlagLuaAppEnableSduiHomePage or fFlagLuaAppSduiSearchAutocomplete then
								local v25 = data

								if
									fn2 ~= nil and not fn2()
									or v25.isResponseCurrent ~= nil and not v25.isResponseCurrent()
								then
									if
										(fFlagLuaAppEnableSduiApiStoreInFlightFix or fFlagLuaAppSduiSearchAutocomplete)
										and not v13
									then
										local v27 = configKey
										local v28 = v8[v27]

										if v28 then
											v8[v27] = nil

											v28.resolve(nil)
										end
									end

									return callback(nil)
								end
							end

							local responseBody = data2.responseBody

							SduiPageAnalytics.sendPagePayloadSizeEvent(data.surfaceKey, responseBody)

							if v21 then
								local finalize = v21.finalize(responseBody)

								if finalize.ok then
									local v25 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
									v25(configKey, true, finalize.value, v20)

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
									return fn6(finalize.value)
								end
							else
								local success, result, v25 = pcall(processSduiResponse, data2)

								if success then
									local v26 = {}

									if fFlagPromptsEdpOpenReplaceOnFetch and data.replaceOnFetch then
										local data3 = p3.data(false)

										for k, v27 in result do
											v26[k] = v27
										end

										if data3 then
											for k in data3 do
												if result[k] == nil then
													v26[k] = Cryo.None
												end
											end
										end
									elseif next(result) then
										local data3 = p3.data(false)

										for k, joined in result do
											local v27 = data3 and data3[k]

											if v27 then
												joined = Cryo.Dictionary.join(v27, joined)
											end

											v26[k] = joined
										end
									elseif data.clearOnEmptyResponse and data.configKey then
										v26[data.configKey] = {}
									end

									local v27 = if fFlagLuaAppEnableSduiHomePage then fn3 else completeActiveRequest
									v27(configKey, true, v26, v25)

									return callback(v26)
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
									return fn6(result, p3)
								end
							end
						end
					end

					if fFlagLuaAppEnableSduiHomePage or fFlagLuaAppSduiSearchAutocomplete then
						local v24 = data

						if
							fn2 ~= nil and not fn2()
							or v24.isResponseCurrent ~= nil and not v24.isResponseCurrent()
						then
							if
								(fFlagLuaAppEnableSduiApiStoreInFlightFix or fFlagLuaAppSduiSearchAutocomplete)
								and not v13
							then
								local v26 = configKey
								local v27 = v8[v26]

								if v27 then
									v8[v26] = nil

									v27.resolve(nil)
								end
							end

							return callback(nil)
						end
					end

					return fn6(data2)
				end)

				if v23 ~= nil then
					callback2(v23)
				end
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
			method = postConfig and "POST" or "GET",
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

	v10 = createDataResolver({
		cache = dataCache,
		fetchFn = fetchFunction,
		queueProcessDelaySec = 0,
		supportsMultiGet = false,
		requestTimeoutSec = SduiRetryPolicy.getFetchTimeoutSec(),
		onBeforeClear = fFlagHomePageRefetchOnDataHydrationAccountReset and function()
			local v13 = v8
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

			for k, v14 in v13 do
				v14.resolve(nil)
			end
		end or nil
	})

	local function fetchIfNeeded(joined, p3)
		if joined.responseType == nil then
			joined.responseType = sduiResponseType.Protobuf
		end

		local configKey = joined.configKey or joined.url

		local v13 = fFlagLuaAppEnableSduiHomePage
			and joined.concurrencyPolicy == sduiRequestConcurrencyPolicy.LatestWins
		joined.configKey = configKey
		joined.loadTimer.logUiRequestQueued()

		if fFlagHomePageRefetchOnDataHydrationAccountReset then
			joined.accountGeneration = v10.getAccountGeneration(false)
			joined.accountPlayerId = getLocalPlayerUserId()
		end

		if fFlagLuaAppEnableSduiHomePage and v13 then
			local concurrencyKey = joined.concurrencyKey or configKey
			local v14 = v6
			local v15 = (v14[concurrencyKey] or 0) + 1
			v14[concurrencyKey] = v15

			return fetchFunction(configKey, v10.getCachedItem(configKey), joined, function(): boolean
				return v14[concurrencyKey] == v15
			end):andThen(function(p4)
				if fFlagHomePageRefetchOnDataHydrationAccountReset and p4 ~= nil then
					local v16 = joined
					local flag

					if v10.isCurrentRequest(v16.accountPlayerId, v16.accountGeneration) then
						flag = false
					else
						local v17 = v16.enableStreaming and "streaming" or "buffered"
						SduiPageAnalytics.sendStaleResponseDiscarded(v16.surfaceKey, v17, "cacheCommit")
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

			local fetchItem, v14 = v10.getAndFetchItem(configKey, p3 and function(): boolean
				return true
			end or nil, joined.staleTimeSec)

			if not v14 then
				return Promise.resolve()
			end

			if v8[configKey] then
				return v8[configKey].promise
			end

			local v15 = nil
			local v16 = nil
			local v17 = Promise.new(function(p4, p5)
				v15 = p4
				v16 = p5
			end)
			v17:catch(function(p4) end)
			v8[configKey] = { promise = v17, resolve = v15, reject = v16 }

			return v8[configKey].promise
		end
	end

	local function getInputData(p3, p4, p5)
		local v13 = if p4 and p4 ~= "" then `{p3}_{p4}` else nil

		if fFlagSduiFreshInputDataSignalOnRebuild and p5 then
			local v14 = v13 or p3
			local v15 = v12[v14]

			if v15 == nil then
				local signal, v16 = Signals.createSignal(0)
				v15 = { get = signal, set = v16 }

				v12[v14] = v15
			end

			v15.get(p5)
		end

		local v14 = resolveSduiCacheEntry(v9, p3, v13)

		if v14 == nil then
			return nil
		end

		local get = v14.get

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
			local v13 = v9[k]
			local v14 = if v13 then v13.get(false) else nil

			if v14 ~= nil and callback(k, v14) then
				break
			end
		end
	end

	local function setInputDataField(p3, p4, p5, p6): boolean
		local data = v10.getCachedItem(p3).data(false)
		local v13 = v9[p4]

		if data == nil or data[p4] == nil or v13 == nil then
			return false
		end

		local v14 = v13.get(false)
		local v15 = if v14 then v14[p5] else nil

		if v15 == nil or p6 == nil or typeof(p6) ~= typeof(v15) then
			return false
		end

		local clone = table.clone(v14)
		clone[p5] = p6
		v13.set(clone)
		return true
	end

	local function getRootConfig(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p4)
		local v13

		if fFlagSduiAlwaysCacheWithIdentifier then
			v13 = resolveSduiCacheEntry(data, p3, p5)
		else
			v13 = data and data[p5 or p3]
		end

		if v13 then
			return v13.config
		end

		return nil
	end

	local function getTitle(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p4)
		local v13

		if fFlagSduiAlwaysCacheWithIdentifier then
			v13 = resolveSduiCacheEntry(data, p3, p5)
		else
			v13 = data and data[p5 or p3]
		end

		if v13 and v13.title ~= "" then
			return v13.title
		end

		return nil
	end

	local function getDataUpdatedTimestamp(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p4)
		local v13

		if fFlagSduiAlwaysCacheWithIdentifier then
			v13 = resolveSduiCacheEntry(data, p3, p5)
		else
			v13 = data and data[p5 or p3]
		end

		if v13 then
			return v13.dataUpdatedTimestamp
		end

		return nil
	end

	local function getEntrySurfacing(p3, p4, p5)
		local data = v10.getCachedItem(p3).data(p5)
		local v13

		if fFlagSduiAlwaysCacheWithIdentifier then
			v13 = resolveSduiCacheEntry(data, p3, p4)
		else
			v13 = data and data[p4 or p3]
		end

		if v13 then
			return v13.surfacing
		end

		return nil
	end

	local function loadMoreFromApi(data)
		local v13 = v5[data.configKey]

		if not v13 then
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
		local v14

		if fFlagSduiAlwaysCacheWithIdentifier then
			v14 = resolveSduiCacheEntry(data2, data.configKey, data.identifier)
		else
			v14 = data2 and data2[data.identifier or data.configKey]
		end

		if not v14 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToPaginateRequest,
				{
					message = `No entry data for {data.configKey}`,
					name = v13.surfaceKey
				},
				v13.surfaceKey
			)
			return Promise.resolve()
		end

		local nextPageUrl = v14.nextPageUrl

		if not nextPageUrl or nextPageUrl == "" then
			return Promise.resolve()
		end

		local v15 = {
			url = nextPageUrl,
			loadTimer = data.loadTimer,
			isPaginated = true
		}

		if v13.postConfig and v14.nextPagePostBody then
			v15.postConfig = Cryo.Dictionary.join(v13.postConfig, {
				body = v14.nextPagePostBody
			})
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v13, v15), true)
	end

	local function refreshFromApi(p3)
		local v13 = v5[p3.configKey]

		if not v13 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToFetchPage,
				{
					message = `No requestData for refresh: {p3.configKey}`
				},
				"unknown"
			)

			return Promise.resolve()
		end

		if v13.refresh then
			return v13.refresh(p3.loadTimer)
		end

		local v15 = {
			url = (if v13.buildRefreshUrl then v13.buildRefreshUrl() else nil) or v13.url,
			loadTimer = p3.loadTimer,
			isPaginated = Cryo.None
		}

		if fFlagSduiStreamingRefreshReplacesInputData and not v13.enableInputDataMerge then
			v15.enableInputDataMerge = false
		end

		if v13.postConfig then
			local v16 = if v13.buildRefreshPostBody then v13.buildRefreshPostBody() else nil

			if v16 then
				v15.postConfig = Cryo.Dictionary.join(v13.postConfig, { body = v16 })
			end
		end

		return fetchIfNeeded(Cryo.Dictionary.join(v13, v15), true)
	end

	fn = function(data)
		local configKey = data.configKey
		local loadTimer = data.loadTimer

		if data.requestConfig == nil then
			loadTimer.logUiRequestQueued()
			v5[configKey] = {
				url = `inline://{configKey}`,
				surfaceKey = data.surfaceKey,
				configKey = configKey,
				loadTimer = loadTimer,
				apiProto = data.apiProto,
				responseType = sduiResponseType.Protobuf
			}
		else
			v5[configKey] = data.requestConfig
		end

		local requestConfig = data.requestConfig
		local data2 = v10.getCachedItem(configKey).data(false)

		local success, result = pcall(function()
			local v14 = {
				response = {
					statusCode = 200,
					responseBody = data.decodedResponse,
					stats = {}
				},
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
			local v15 = if requestConfig == nil then SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse else requestConfig.parseTemplateEntriesFromResponse or SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse
			v14.parseTemplateEntriesFromResponse = v15

			local v16 = if requestConfig == nil then SduiProtobufResponseHelpers.parsePageEntriesFromResponse else requestConfig.parsePageEntriesFromResponse or SduiProtobufResponseHelpers.parsePageEntriesFromResponse
			v14.parsePageEntriesFromResponse = v16

			local v17 = if requestConfig == nil then SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse else requestConfig.parseLocalizedLiteralsFromResponse or SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
			v14.parseLocalizedLiteralsFromResponse = v17
			local v18

			if fFlagSduiReleaseSearchResultsPageState then
				local v19 = configKey

				v18 = function(p3)
					if fFlagSduiReleaseSearchResultsPageState then
						local v20 = v19
						local v21 = v11

						if v21 ~= nil then
							local v22 = v21[v20]

							if v22 == nil then
								v22 = {}
								v21[v20] = v22
							end

							v22[p3] = true
						end
					end

					local v20 = v9[p3]

					if v20 == nil then
						local signal, v21 = Signals.createSignal(nil)
						v20 = { get = signal, set = v21 }

						v9[p3] = v20
					end

					return v20
				end
			else
				v18 = getInputDataSignals
			end

			v14.getInputDataSignalsForRequest = v18

			v14.setInputDataSignalsForRequest = if fFlagSduiFreshInputDataSignalOnRebuild then setInputDataSignals else nil

			local v20 = if requestConfig ~= nil and not not fFlagSduiAllowNoConfigsBuilt then requestConfig.allowNoConfigsBuilt else nil
			v14.allowNoConfigsBuilt = v20

			local v21 = if requestConfig ~= nil then requestConfig.mergeStrategy else nil
			v14.mergeStrategy = v21
			local v22 = if requestConfig ~= nil then requestConfig.enableTemplateCache else nil
			v14.enableTemplateCache = v22
			return handleSduiApiResponse(v14)
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

		local v13 = accumulateSduiCacheSubEntries(result, data2)
		dataCache.updateItems({ [configKey] = v13 })
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

			local v13 = {}
			local flag = false

			for k2, v14 in data do
				if v14 and v14.category ~= nil and v14.title == value then
					flag = true
				else
					v13[k2] = v14
				end
			end

			if not flag then
				continue
			end

			dataCache.replaceItems({ [k] = v13 })
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

		local v13 = v11
		local v14 = if v13 then v13[p3] else nil

		if v14 ~= nil then
			for k in v14 do
				v9[k] = nil
				v12[k] = nil
			end
		end

		if v13 ~= nil then
			v13[p3] = nil
		end

		v5[p3] = nil
		local v15 = v7[p3]

		if v15 then
			v15.released = true
			v7[p3] = nil
		end

		local v16 = v8[p3]
		v8[p3] = nil

		if v16 then
			v16.resolve(nil)
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

	local v13 = if fFlagHomePageRefetchOnDataHydrationAccountReset then v10.getAccountGeneration else nil
	sduiApiStore.getAccountGeneration = v13

	sduiApiStore.getEntrySurfacing = getEntrySurfacing
	sduiApiStore.loadMoreFromApi = loadMoreFromApi
	sduiApiStore.refreshFromApi = refreshFromApi
	return sduiApiStore
end

return createSduiApiStore

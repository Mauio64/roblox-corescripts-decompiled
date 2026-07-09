local HttpService = game:GetService("HttpService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local Cryo = require(SduiSharedUtilitiesParent.Cryo)
local Signals = require(SduiSharedUtilitiesParent.Signals)
local SduiCoreSystem = require(SduiSharedUtilitiesParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local Promise = require(SduiSharedUtilitiesParent.Promise)
local DataHydration = require(SduiSharedUtilitiesParent.DataHydration)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local SduiRequestStatus = SduiIntegrationTypes.SduiRequestStatus

require(SduiSharedUtilities.SduiLoadTimer)

local SduiProtobufResponseHelpers = require(SduiSharedUtilities.SduiProtobufResponseHelpers)
local makeProtoResponseDecoder = SduiProtobufResponseHelpers.makeProtoResponseDecoder
local makeProtobufJsonResponseDecoder = SduiProtobufResponseHelpers.makeProtobufJsonResponseDecoder
local SduiResponseType = SduiIntegrationTypes.SduiResponseType
local handleSduiApiResponse = require(SduiSharedUtilities.handleSduiApiResponse)
local SduiPageAnalytics = require(SduiSharedUtilities.SduiPageAnalytics)
local SduiApiStorePostConfig = require(SduiSharedUtilities.SduiApiStorePostConfig)
local createSduiStreamingResponseHandler = require(SduiSharedUtilities.createSduiStreamingResponseHandler)
local FFlagSduiProtobufJsonDecode = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiProtobufJsonDecode
local v25 = game:DefineFastFlag("SduiEnableClearOnEmptyResponse", false)
local FFlagSduiAllowNoConfigsBuilt = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiAllowNoConfigsBuilt
local FFlagSduiChartsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiConfigFetchTakesPostBody = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiConfigFetchTakesPostBody
local FFlagSduiClientTemplateCache = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiClientTemplateCache
local FFlagSduiAlwaysCacheWithIdentifier = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiAlwaysCacheWithIdentifier
local FFlagEnableSduiV2HomeInterleave = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableSduiV2HomeInterleave
local FFlagLuaAppSduiStreamingChunkedResponses = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiStreamingChunkedResponses
local FFlagSduiErrorCleanup = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiErrorCleanup
local FFlagSduiInputDataMergeStrategy = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiInputDataMergeStrategy
local FFlagSduiDismissPromptAction = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiDismissPromptAction
local FFlagSduiApiStoreExposeGetInputData = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiApiStoreExposeGetInputData
local FFlagSduiRenderPerf = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiRenderPerf
local v38 = game:DefineFastInt("SduiPageRequestPriority", 1)
local resolveSduiCacheEntry = require(SduiSharedUtilities.resolveSduiCacheEntry)
local accumulateSduiCacheSubEntries = require(SduiSharedUtilities.accumulateSduiCacheSubEntries)

local function createSduiApiStore() -- line: 113
	-- upvalues: createDataCache (copy), Signals (copy), Promise (copy), FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), FFlagSduiConfigFetchTakesPostBody (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), makeProtobufJsonResponseDecoder (copy), makeProtoResponseDecoder (copy), handleSduiApiResponse (copy), SduiProtobufResponseHelpers (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), FFlagSduiClientTemplateCache (copy), createSduiStreamingResponseHandler (copy), accumulateSduiCacheSubEntries (copy), HttpService (copy), SduiApiStorePostConfig (copy), FFlagSduiRenderPerf (copy), v38 (copy), SduiPageAnalytics (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiChartsSupport (copy), SduiParseHelpers (copy), v25 (copy), Cryo (copy), createDataResolver (copy), resolveSduiCacheEntry (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), FFlagEnableSduiV2HomeInterleave (copy), FFlagSduiDismissPromptAction (copy), FFlagSduiApiStoreExposeGetInputData (copy)
	local v42 = createDataCache()
	local t1 = {}
	local t2 = {}
	local t3 = {}

	local function completeActiveRequest(s1: string, b1: boolean, p1) -- line: 127
		-- upvalues: t3 (copy)
		local v58 = t3[s1]

		if v58 then
			t3[s1] = nil

			if b1 then
				v58.resolve(p1)

				return
			end

			v58.reject(p1)
		end
	end

	local t4 = {}

	local function getInputDataSignals(s2: string) -- line: 158
		-- upvalues: t4 (copy), Signals (copy)
		local v61 = t4[s2]

		if v61 == nil then
			local v62, v63 = Signals.createSignal(nil)

			v61 = {
				get = v62,
				set = v63
			}
			t4[s2] = v61
		end

		return v61
	end
	local function fetchFunction(s3: string, p2) -- line: 174
		-- upvalues: t1 (copy), Promise (copy), FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), FFlagSduiConfigFetchTakesPostBody (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), makeProtobufJsonResponseDecoder (copy), makeProtoResponseDecoder (copy), handleSduiApiResponse (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), FFlagSduiClientTemplateCache (copy), createSduiStreamingResponseHandler (copy), accumulateSduiCacheSubEntries (copy), v42 (copy), HttpService (copy), SduiApiStorePostConfig (copy), FFlagSduiRenderPerf (copy), v38 (copy), t2 (copy), SduiPageAnalytics (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiChartsSupport (copy), t3 (copy), SduiParseHelpers (copy), v25 (copy), Cryo (copy)
		local v66 = t1[s3]

		if not v66 then
			return Promise.reject("No request config for key", s3)
		end

		local url = v66.url
		local loadTimer = v66.loadTimer

		loadTimer.logUiRequestSent()

		local v69 = FFlagSduiProtobufJsonDecode and v66.responseType == SduiResponseType.ProtobufJson
		local postConfig = v66.postConfig
		local v71 = (not FFlagSduiConfigFetchTakesPostBody or not postConfig) and "GET" or "POST"
		local v72 = if not FFlagLuaAppSduiStreamingChunkedResponses then nil else v66.enableStreaming
		local v73 = if not v69 then makeProtoResponseDecoder(v66.apiProto) else makeProtobufJsonResponseDecoder(v66.apiProto)

		local function processSduiResponse(p3) -- line: 197
			-- upvalues: v66 (copy), p2 (copy), handleSduiApiResponse (copy), loadTimer (copy), v73 (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), v72 (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), FFlagSduiClientTemplateCache (copy)
			local v134 = v66.isPaginated and p2.data(false) ~= nil

			return handleSduiApiResponse({
				response = p3,
				loadTimer = loadTimer,
				surfaceKey = v66.surfaceKey,
				configCacheKey = v66.configKey,
				decodeResponse = v73,
				parseHydrationDataFromResponse = SduiProtobufResponseHelpers.parseHydrationDataFromResponse,
				parseTemplateEntriesFromResponse = SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse,
				parsePageEntriesFromResponse = SduiProtobufResponseHelpers.parsePageEntriesFromResponse,
				getInputDataSignalsForRequest = getInputDataSignals,
				enableStreamingMerge = if not FFlagLuaAppSduiStreamingChunkedResponses then nil else v72,
				paginateResponse = v134,
				buildNextPageUrl = v66.buildNextPageUrl,
				allowNoConfigsBuilt = if not FFlagSduiAllowNoConfigsBuilt then nil else v66.allowNoConfigsBuilt,
				mergeStrategy = if not FFlagSduiInputDataMergeStrategy then nil else v66.mergeStrategy,
				enableTemplateCache = if not FFlagSduiClientTemplateCache then nil else v66.enableTemplateCache
			})
		end

		local v75 = if not FFlagLuaAppSduiStreamingChunkedResponses or not v72 then nil else createSduiStreamingResponseHandler({
			configKey = s3,
			loadTimer = loadTimer,
			processFrame = function(s4: string) -- line: 222
				-- upvalues: processSduiResponse (copy), accumulateSduiCacheSubEntries (copy), p2 (copy), v42 (copy), s3 (copy)
				local ok, result = pcall(processSduiResponse, {
					Stats = {},
					Body = buffer.fromstring(s4)
				})

				if ok then
					local v138 = accumulateSduiCacheSubEntries(result, p2.data(false))

					v42.updateItems({
						[s3] = v138
					})

					return true, v138
				end

				return false, result
			end
		})
		local v76 = HttpService:RequestInternal({
			Url = url,
			Method = v71,
			Headers = {
				Accept = not v69 and "application/x-protobuf" or "application/json",
				["Content-Type"] = if not FFlagSduiConfigFetchTakesPostBody or not postConfig then nil else SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig)
			},
			Body = if not FFlagSduiConfigFetchTakesPostBody or not postConfig then nil else SduiApiStorePostConfig.getBodyFromPostConfig(postConfig),
			OnMessage = if not v75 then nil else v75.handleChunk,
			Priority = if not FFlagSduiRenderPerf then nil else v38
		})

		return Promise.new(function(resolve, reject) -- line: 254
			-- upvalues: v76 (copy), loadTimer (copy), t2 (copy), s3 (copy), SduiPageAnalytics (copy), v66 (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), url (copy), FFlagSduiChartsSupport (copy), t3 (copy), v75 (copy), SduiParseHelpers (copy), processSduiResponse (copy), p2 (copy), v25 (copy), Cryo (copy)
			v76:Start(function(p4, p5) -- line: 255
				-- upvalues: loadTimer (copy), t2 (copy), s3 (copy), SduiPageAnalytics (copy), v66 (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), url (copy), FFlagSduiChartsSupport (copy), t3 (copy), reject (copy), v75 (copy), resolve (copy), SduiParseHelpers (copy), processSduiResponse (copy), p2 (copy), v25 (copy), Cryo (copy)
				loadTimer.logUiResponseReceived()
				t2[s3] = false
				SduiPageAnalytics.sendPageStatusEvent(v66.surfaceKey, p5.StatusCode, p5.HttpError)

				if p4 then
					local v146 = if not p5.StatusCode then nil else tonumber(p5.StatusCode)

					if v146 and v146 >= 400 or p5.HttpError and p5.HttpError ~= Enum.HttpError.OK then
						loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)

						if not FFlagSduiErrorCleanup then
							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
								message = `Http request not successful for { url } StatusCode { p5.StatusCode } HttpError { p5.HttpError }`,
								name = v66.surfaceKey
							}, v66.surfaceKey)
						end

						if FFlagSduiChartsSupport then
							local v147 = s3
							local v148 = t3[v147]

							if v148 then
								t3[v147] = nil
								v148.reject(p5)
							end
						end

						return reject(p5)
					end

					loadTimer.updateRequestStatus(SduiRequestStatus.LoadedFromNetwork)
					SduiPageAnalytics.sendPagePayloadSizeEvent(v66.surfaceKey, p5.Body)

					if v75 then
						local v149 = v75.finalize(p5.Body)

						if v149.ok then
							if FFlagSduiChartsSupport then
								local v150 = s3
								local value = v149.value
								local v152 = t3[v150]

								if v152 then
									t3[v150] = nil
									v152.resolve(value)
								end
							end

							return resolve(v149.value)
						end

						local v153 = SduiParseHelpers.stringifyValue(v149.value)

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
							message = v153,
							name = v66.surfaceKey
						}, v66.surfaceKey)
						loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)

						if FFlagSduiChartsSupport then
							local v154 = s3
							local value = v149.value
							local v156 = t3[v154]

							if v156 then
								t3[v154] = nil
								v156.reject(value)
							end
						end

						return reject(v149.value)
					end

					local ok, result = pcall(processSduiResponse, p5)

					if not ok then
						local v159 = SduiParseHelpers.stringifyValue(result)

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
							message = `handleSduiApiResponse not successful for { url } err { v159 }`,
							name = v66.surfaceKey
						}, v66.surfaceKey)

						if FFlagSduiChartsSupport then
							local v160 = s3
							local v161 = t3[v160]

							if v161 then
								t3[v160] = nil
								v161.reject(result)
							end
						end

						return reject(p2)
					end

					local t5 = {}

					if v25 then
						if next(result) then
							local v163 = p2.data(false)

							for v164, v165 in result do
								local v166 = v163 and v163[v164]

								t5[v164] = if not v166 then v165 else Cryo.Dictionary.join(v166, v165)
							end
						elseif v66.clearOnEmptyResponse and v66.configKey then
							t5[v66.configKey] = {}
						end
					else
						local v167 = p2.data(false)

						for v168, v169 in result do
							local v170 = v167 and v167[v168]

							t5[v168] = if not v170 then v169 else Cryo.Dictionary.join(v170, v169)
						end
					end

					if FFlagSduiChartsSupport then
						local v171 = s3
						local v172 = t3[v171]

						if v172 then
							t3[v171] = nil
							v172.resolve(t5)
						end
					end

					return resolve(t5)
				end

				if not FFlagSduiErrorCleanup then
					local v173 = SduiParseHelpers.stringifyValue(p5)

					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
						message = `Http request not successful for { url } err { v173 }`,
						name = v66.surfaceKey
					}, v66.surfaceKey)
				end

				if FFlagSduiChartsSupport then
					local v174 = s3
					local v175 = t3[v174]

					if v175 then
						t3[v174] = nil
						v175.reject(p5)
					end
				end

				return reject(p5)
			end)
		end)
	end

	local v50 = createDataResolver({
		queueProcessDelaySec = 0,
		supportsMultiGet = false,
		cache = v42,
		fetchFn = fetchFunction
	})

	local function fetchIfNeeded(t6: {[any]: any}, b2: boolean?) -- line: 385
		-- upvalues: FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), FFlagSduiChartsSupport (copy), t1 (copy), v50 (copy), t3 (copy), Promise (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), t2 (copy)
		if FFlagSduiProtobufJsonDecode and t6.responseType == nil then
			t6.responseType = SduiResponseType.Protobuf
		end

		local v79 = t6.configKey or t6.url

		t6.configKey = v79

		if FFlagSduiChartsSupport then
			t6.loadTimer.logUiRequestQueued()
			t1[v79] = t6

			local _, v81 = v50.getAndFetchItem(v79, if not b2 then nil else function() -- line: 401
				return true
			end)

			if v81 then
				if not t3[v79] then
					local u82 = nil
					local u83 = nil
					local v84 = Promise.new(function(resolve, reject) -- line: 410
						-- upvalues: u82 (ref), u83 (ref)
						u82 = resolve
						u83 = reject
					end)

					v84:catch(function(p6) -- line: 414
						-- upvalues: FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), v79 (copy), SduiParseHelpers (copy), t6 (copy)
						if not FFlagSduiErrorCleanup then
							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
								message = `fetchIfNeeded promise rejected for { v79 }: { SduiParseHelpers.stringifyValue(p6) }`
							}, t6.surfaceKey)
						end
					end)
					t3[v79] = {
						promise = v84,
						resolve = u82,
						reject = u83
					}
				end

				return t3[v79].promise
			end

			return Promise.resolve()
		end

		if t2[v79] then
			return nil
		end

		t2[v79] = true
		t6.loadTimer.logUiRequestQueued()
		t1[v79] = t6

		return v50.getAndFetchItem(v79, if not b2 then nil else function() -- line: 451
			return true
		end)
	end
	local function getInputData(s5: string, s6: string?, p7) -- line: 470
		-- upvalues: resolveSduiCacheEntry (copy), t4 (copy)
		local v88 = if not s6 or s6 == "" then nil else `{ s5 }_{ s6 }`
		local v89 = resolveSduiCacheEntry(t4, s5, v88)

		if v89 == nil then
			return nil
		end

		return v89.get(p7 ~= nil and p7)
	end

	local v53 = nil

	if FFlagEnableSduiV2HomeInterleave then
		function v53(t7: {[any]: any}) -- line: 638
			-- upvalues: t1 (copy), SduiResponseType (copy), v50 (copy), handleSduiApiResponse (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), accumulateSduiCacheSubEntries (copy), v42 (copy)
			local configKey = t7.configKey
			local loadTimer = t7.loadTimer

			loadTimer.logUiRequestQueued()
			t1[configKey] = {
				url = `inline://{ configKey }`,
				surfaceKey = t7.surfaceKey,
				configKey = configKey,
				loadTimer = loadTimer,
				apiProto = t7.apiProto,
				responseType = SduiResponseType.Protobuf
			}

			local v121 = v50.getCachedItem(configKey).data(false)
			local ok, result = pcall(function() -- line: 661
				-- upvalues: handleSduiApiResponse (copy), t7 (copy), loadTimer (copy), configKey (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy)
				return handleSduiApiResponse({
					paginateResponse = false,
					cacheSingleEntryWithIdentifier = true,
					response = {
						StatusCode = 200,
						Body = t7.decodedResponse,
						Stats = {}
					},
					loadTimer = loadTimer,
					surfaceKey = t7.surfaceKey,
					configCacheKey = configKey,
					decodeResponse = function(p8) -- line: 671
						return p8
					end,
					parseHydrationDataFromResponse = SduiProtobufResponseHelpers.parseHydrationDataFromResponse,
					parseTemplateEntriesFromResponse = SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse,
					parsePageEntriesFromResponse = SduiProtobufResponseHelpers.parsePageEntriesFromResponse,
					getInputDataSignalsForRequest = getInputDataSignals
				})
			end)

			if not ok then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
					message = `seedFromDecodedResponse failed for { configKey }: { SduiParseHelpers.stringifyValue(result) }`,
					name = t7.surfaceKey
				}, t7.surfaceKey)
				error(result)
			end

			local v124 = accumulateSduiCacheSubEntries(result, v121)

			v42.updateItems({
				[configKey] = v124
			})
		end
	end

	local function dismissEntry(s7: string) -- line: 704
		-- upvalues: t1 (copy), v50 (copy), v42 (copy)
		local t8 = {}

		if typeof(s7) ~= "string" or s7 == "" then
			return t8
		end

		for v127 in t1 do
			local v128 = v50.getCachedItem(v127).data(false)

			if v128 then
				local v129 = false
				local t9 = {}

				for v131, v132 in v128 do
					if v132 and v132.category ~= nil and s7 == v132.title then
						v129 = true
					else
						t9[v131] = v132
					end
				end

				if v129 then
					v42.replaceItems({
						[v127] = t9
					})
					table.insert(t8, v127)
				end
			end
		end

		return t8
	end

	return {
		fetchIfNeeded = fetchIfNeeded,
		isInFlight = function(s8: string) -- line: 143
			-- upvalues: t3 (copy), t2 (copy)
			if t3[s8] ~= nil then
				return true
			end

			return t2[s8] == true
		end,
		dismissEntry = if not FFlagSduiDismissPromptAction then nil else dismissEntry,
		seedFromDecodedResponse = if not FFlagEnableSduiV2HomeInterleave then nil else v53,
		getData = v50.getCachedItem,
		getInputData = if not FFlagSduiApiStoreExposeGetInputData then nil else getInputData,
		getRootConfig = function(s9: string, p9, s10: string?) -- line: 483
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v93 = v50.getCachedItem(s9).data(p9)
			local v94 = if not FFlagSduiAlwaysCacheWithIdentifier then v93 and v93[s10 or s9] else resolveSduiCacheEntry(v93, s9, s10)

			if v94 then
				return v94.config
			end

			return nil
		end,
		getTitle = function(s11: string, p10, s12: string?) -- line: 499
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v98 = v50.getCachedItem(s11).data(p10)
			local v99 = if not FFlagSduiAlwaysCacheWithIdentifier then v98 and v98[s12 or s11] else resolveSduiCacheEntry(v98, s11, s12)

			if v99 and v99.title ~= "" then
				return v99.title
			end

			return nil
		end,
		getDataUpdatedTimestamp = function(s13: string, p11, s14: string?) -- line: 511
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v103 = v50.getCachedItem(s13).data(p11)
			local v104 = if not FFlagSduiAlwaysCacheWithIdentifier then v103 and v103[s14 or s13] else resolveSduiCacheEntry(v103, s13, s14)

			if v104 then
				return v104.dataUpdatedTimestamp
			end

			return nil
		end,
		getEntrySurfacing = function(s15: string, s16: string?, p12) -- line: 525
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v108 = v50.getCachedItem(s15).data(p12)
			local v109 = if not FFlagSduiAlwaysCacheWithIdentifier then v108 and v108[s16 or s15] else resolveSduiCacheEntry(v108, s15, s16)

			if v109 then
				return v109.surfacing
			end

			return nil
		end,
		loadMoreFromApi = function(t10: {[any]: any}) -- line: 537
			-- upvalues: FFlagSduiChartsSupport (copy), t2 (copy), t1 (copy), SduiLogger (copy), SduiErrors (copy), Promise (copy), v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy), fetchIfNeeded (copy), Cryo (copy)
			if not FFlagSduiChartsSupport and t2[t10.configKey] then
				return nil
			end

			local v111 = t1[t10.configKey]

			if not v111 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToPaginateRequest, {
					message = `No requestData for { t10.configKey }`
				}, "unknown")

				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			local v112 = v50.getCachedItem(t10.configKey).data(false)
			local v113 = if not FFlagSduiAlwaysCacheWithIdentifier then v112 and v112[t10.identifier or t10.configKey] else resolveSduiCacheEntry(v112, t10.configKey, t10.identifier)

			if not v113 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToPaginateRequest, {
					message = `No entry data for { t10.configKey }`,
					name = v111.surfaceKey
				}, v111.surfaceKey)

				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			local nextPageUrl = v113.nextPageUrl

			if not nextPageUrl or nextPageUrl == "" then
				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			if FFlagSduiChartsSupport then
				return fetchIfNeeded(Cryo.Dictionary.join(v111, {
					isPaginated = true,
					url = nextPageUrl,
					loadTimer = t10.loadTimer
				}), true)
			end

			fetchIfNeeded(Cryo.Dictionary.join(v111, {
				isPaginated = true,
				url = nextPageUrl,
				loadTimer = t10.loadTimer
			}), true)

			return nil
		end,
		refreshFromApi = function(t11: {[any]: any}) -- line: 601
			-- upvalues: t1 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiChartsSupport (copy), Promise (copy), fetchIfNeeded (copy), Cryo (copy)
			local v116 = t1[t11.configKey]

			if not v116 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
					message = `No requestData for refresh: { t11.configKey }`
				}, "unknown")

				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			if FFlagSduiChartsSupport then
				local v117 = if not v116.buildRefreshUrl then nil else v116.buildRefreshUrl()

				return fetchIfNeeded(Cryo.Dictionary.join(v116, {
					url = v117 or v116.url,
					loadTimer = t11.loadTimer,
					isPaginated = Cryo.None
				}), true)
			end

			return fetchIfNeeded(Cryo.Dictionary.join(v116, {
				loadTimer = t11.loadTimer
			}), true)
		end
	}
end

return createSduiApiStore

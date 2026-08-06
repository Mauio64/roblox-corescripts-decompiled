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
local FFlagLuaAppSduiStreamingChunkedResponses = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiStreamingChunkedResponses
local FFlagSduiErrorCleanup = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiErrorCleanup
local FFlagSduiInputDataMergeStrategy = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiInputDataMergeStrategy
local FFlagSduiDismissPromptAction = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiDismissPromptAction
local FFlagSduiApiStoreExposeGetInputData = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiApiStoreExposeGetInputData
local FFlagSduiRenderPerf = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiRenderPerf
local FFlagSduiPaginatePostBody = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPaginatePostBody
local v38 = game:DefineFastInt("SduiPageRequestPriority", 1)
local resolveSduiCacheEntry = require(SduiSharedUtilities.resolveSduiCacheEntry)
local accumulateSduiCacheSubEntries = require(SduiSharedUtilities.accumulateSduiCacheSubEntries)

local function createSduiApiStore() -- line: 122
	-- upvalues: createDataCache (copy), Signals (copy), Promise (copy), FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), FFlagSduiConfigFetchTakesPostBody (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), makeProtobufJsonResponseDecoder (copy), makeProtoResponseDecoder (copy), handleSduiApiResponse (copy), SduiProtobufResponseHelpers (copy), FFlagSduiPaginatePostBody (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), FFlagSduiClientTemplateCache (copy), createSduiStreamingResponseHandler (copy), accumulateSduiCacheSubEntries (copy), HttpService (copy), SduiApiStorePostConfig (copy), FFlagSduiRenderPerf (copy), v38 (copy), SduiPageAnalytics (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiChartsSupport (copy), SduiParseHelpers (copy), v25 (copy), Cryo (copy), createDataResolver (copy), resolveSduiCacheEntry (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), FFlagSduiDismissPromptAction (copy), FFlagSduiApiStoreExposeGetInputData (copy)
	local v42 = createDataCache()
	local t1 = {}
	local t2 = {}
	local t3 = {}

	local function completeActiveRequest(s1: string, b1: boolean, p1) -- line: 136
		-- upvalues: t3 (copy)
		local v57 = t3[s1]

		if v57 then
			t3[s1] = nil

			if b1 then
				v57.resolve(p1)

				return
			end

			v57.reject(p1)
		end
	end

	local t4 = {}

	local function getInputDataSignals(s2: string) -- line: 167
		-- upvalues: t4 (copy), Signals (copy)
		local v60 = t4[s2]

		if v60 == nil then
			local v61, v62 = Signals.createSignal(nil)

			v60 = {
				get = v61,
				set = v62
			}
			t4[s2] = v60
		end

		return v60
	end
	local function fetchFunction(s3: string, p2) -- line: 183
		-- upvalues: t1 (copy), Promise (copy), FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), FFlagSduiConfigFetchTakesPostBody (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), makeProtobufJsonResponseDecoder (copy), makeProtoResponseDecoder (copy), handleSduiApiResponse (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy), FFlagSduiPaginatePostBody (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), FFlagSduiClientTemplateCache (copy), createSduiStreamingResponseHandler (copy), accumulateSduiCacheSubEntries (copy), v42 (copy), HttpService (copy), SduiApiStorePostConfig (copy), FFlagSduiRenderPerf (copy), v38 (copy), t2 (copy), SduiPageAnalytics (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiChartsSupport (copy), t3 (copy), SduiParseHelpers (copy), v25 (copy), Cryo (copy)
		local v65 = t1[s3]

		if not v65 then
			return Promise.reject("No request config for key", s3)
		end

		local url = v65.url
		local loadTimer = v65.loadTimer

		loadTimer.logUiRequestSent()

		local v68 = FFlagSduiProtobufJsonDecode and v65.responseType == SduiResponseType.ProtobufJson
		local postConfig = v65.postConfig
		local v70 = (not FFlagSduiConfigFetchTakesPostBody or not postConfig) and "GET" or "POST"
		local v71 = if not FFlagLuaAppSduiStreamingChunkedResponses then nil else v65.enableStreaming
		local v72 = if not v68 then makeProtoResponseDecoder(v65.apiProto) else makeProtobufJsonResponseDecoder(v65.apiProto)

		local function processSduiResponse(p3) -- line: 206
			-- upvalues: v65 (copy), p2 (copy), handleSduiApiResponse (copy), loadTimer (copy), v72 (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), v71 (copy), FFlagSduiPaginatePostBody (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), FFlagSduiClientTemplateCache (copy)
			local v135 = v65.isPaginated and p2.data(false) ~= nil

			return handleSduiApiResponse({
				response = p3,
				loadTimer = loadTimer,
				surfaceKey = v65.surfaceKey,
				configCacheKey = v65.configKey,
				decodeResponse = v72,
				parseHydrationDataFromResponse = SduiProtobufResponseHelpers.parseHydrationDataFromResponse,
				parseTemplateEntriesFromResponse = SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse,
				parsePageEntriesFromResponse = SduiProtobufResponseHelpers.parsePageEntriesFromResponse,
				getInputDataSignalsForRequest = getInputDataSignals,
				enableStreamingMerge = if not FFlagLuaAppSduiStreamingChunkedResponses then nil else v71,
				paginateResponse = v135,
				buildNextPageUrl = v65.buildNextPageUrl,
				buildNextPagePostBody = if not FFlagSduiPaginatePostBody then nil else v65.buildNextPagePostBody,
				allowNoConfigsBuilt = if not FFlagSduiAllowNoConfigsBuilt then nil else v65.allowNoConfigsBuilt,
				mergeStrategy = if not FFlagSduiInputDataMergeStrategy then nil else v65.mergeStrategy,
				enableTemplateCache = if not FFlagSduiClientTemplateCache then nil else v65.enableTemplateCache
			})
		end

		local v74 = if not FFlagLuaAppSduiStreamingChunkedResponses or not v71 then nil else createSduiStreamingResponseHandler({
			configKey = s3,
			loadTimer = loadTimer,
			processFrame = function(s4: string) -- line: 232
				-- upvalues: processSduiResponse (copy), accumulateSduiCacheSubEntries (copy), p2 (copy), v42 (copy), s3 (copy)
				local ok, result = pcall(processSduiResponse, {
					Stats = {},
					Body = buffer.fromstring(s4)
				})

				if ok then
					local v139 = accumulateSduiCacheSubEntries(result, p2.data(false))

					v42.updateItems({
						[s3] = v139
					})

					return true, v139
				end

				return false, result
			end
		})
		local v75 = HttpService:RequestInternal({
			Url = url,
			Method = v70,
			Headers = {
				Accept = not v68 and "application/x-protobuf" or "application/json",
				["Content-Type"] = if not FFlagSduiConfigFetchTakesPostBody or not postConfig then nil else SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(postConfig)
			},
			Body = if not FFlagSduiConfigFetchTakesPostBody or not postConfig then nil else SduiApiStorePostConfig.getBodyFromPostConfig(postConfig),
			OnMessage = if not v74 then nil else v74.handleChunk,
			Priority = if not FFlagSduiRenderPerf then nil else v38
		})

		return Promise.new(function(resolve, reject) -- line: 264
			-- upvalues: v75 (copy), loadTimer (copy), t2 (copy), s3 (copy), SduiPageAnalytics (copy), v65 (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), url (copy), FFlagSduiChartsSupport (copy), t3 (copy), v74 (copy), SduiParseHelpers (copy), processSduiResponse (copy), p2 (copy), v25 (copy), Cryo (copy)
			v75:Start(function(p4, p5) -- line: 265
				-- upvalues: loadTimer (copy), t2 (copy), s3 (copy), SduiPageAnalytics (copy), v65 (copy), SduiRequestStatus (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), url (copy), FFlagSduiChartsSupport (copy), t3 (copy), reject (copy), v74 (copy), resolve (copy), SduiParseHelpers (copy), processSduiResponse (copy), p2 (copy), v25 (copy), Cryo (copy)
				loadTimer.logUiResponseReceived()
				t2[s3] = false
				SduiPageAnalytics.sendPageStatusEvent(v65.surfaceKey, p5.StatusCode, p5.HttpError)

				if p4 then
					local v147 = if not p5.StatusCode then nil else tonumber(p5.StatusCode)

					if v147 and v147 >= 400 or p5.HttpError and p5.HttpError ~= Enum.HttpError.OK then
						loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)

						if not FFlagSduiErrorCleanup then
							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
								message = `Http request not successful for { url } StatusCode { p5.StatusCode } HttpError { p5.HttpError }`,
								name = v65.surfaceKey
							}, v65.surfaceKey)
						end

						if FFlagSduiChartsSupport then
							local v148 = s3
							local v149 = t3[v148]

							if v149 then
								t3[v148] = nil
								v149.reject(p5)
							end
						end

						return reject(p5)
					end

					loadTimer.updateRequestStatus(SduiRequestStatus.LoadedFromNetwork)
					SduiPageAnalytics.sendPagePayloadSizeEvent(v65.surfaceKey, p5.Body)

					if v74 then
						local v150 = v74.finalize(p5.Body)

						if v150.ok then
							if FFlagSduiChartsSupport then
								local v151 = s3
								local value = v150.value
								local v153 = t3[v151]

								if v153 then
									t3[v151] = nil
									v153.resolve(value)
								end
							end

							return resolve(v150.value)
						end

						local v154 = SduiParseHelpers.stringifyValue(v150.value)

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
							message = v154,
							name = v65.surfaceKey
						}, v65.surfaceKey)
						loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)

						if FFlagSduiChartsSupport then
							local v155 = s3
							local value = v150.value
							local v157 = t3[v155]

							if v157 then
								t3[v155] = nil
								v157.reject(value)
							end
						end

						return reject(v150.value)
					end

					local ok, result = pcall(processSduiResponse, p5)

					if not ok then
						local v160 = SduiParseHelpers.stringifyValue(result)

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
							message = `handleSduiApiResponse not successful for { url } err { v160 }`,
							name = v65.surfaceKey
						}, v65.surfaceKey)

						if FFlagSduiChartsSupport then
							local v161 = s3
							local v162 = t3[v161]

							if v162 then
								t3[v161] = nil
								v162.reject(result)
							end
						end

						return reject(p2)
					end

					local t5 = {}

					if v25 then
						if next(result) then
							local v164 = p2.data(false)

							for v165, v166 in result do
								local v167 = v164 and v164[v165]

								t5[v165] = if not v167 then v166 else Cryo.Dictionary.join(v167, v166)
							end
						elseif v65.clearOnEmptyResponse and v65.configKey then
							t5[v65.configKey] = {}
						end
					else
						local v168 = p2.data(false)

						for v169, v170 in result do
							local v171 = v168 and v168[v169]

							t5[v169] = if not v171 then v170 else Cryo.Dictionary.join(v171, v170)
						end
					end

					if FFlagSduiChartsSupport then
						local v172 = s3
						local v173 = t3[v172]

						if v173 then
							t3[v172] = nil
							v173.resolve(t5)
						end
					end

					return resolve(t5)
				end

				if not FFlagSduiErrorCleanup then
					local v174 = SduiParseHelpers.stringifyValue(p5)

					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
						message = `Http request not successful for { url } err { v174 }`,
						name = v65.surfaceKey
					}, v65.surfaceKey)
				end

				if FFlagSduiChartsSupport then
					local v175 = s3
					local v176 = t3[v175]

					if v176 then
						t3[v175] = nil
						v176.reject(p5)
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

	local function fetchIfNeeded(t6: {[any]: any}, b2: boolean?) -- line: 395
		-- upvalues: FFlagSduiProtobufJsonDecode (copy), SduiResponseType (copy), FFlagSduiChartsSupport (copy), t1 (copy), v50 (copy), t3 (copy), Promise (copy), FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), t2 (copy)
		if FFlagSduiProtobufJsonDecode and t6.responseType == nil then
			t6.responseType = SduiResponseType.Protobuf
		end

		local v78 = t6.configKey or t6.url

		t6.configKey = v78

		if FFlagSduiChartsSupport then
			t6.loadTimer.logUiRequestQueued()
			t1[v78] = t6

			local _, v80 = v50.getAndFetchItem(v78, if not b2 then nil else function() -- line: 411
				return true
			end)

			if v80 then
				if not t3[v78] then
					local u81 = nil
					local u82 = nil
					local v83 = Promise.new(function(resolve, reject) -- line: 420
						-- upvalues: u81 (ref), u82 (ref)
						u81 = resolve
						u82 = reject
					end)

					v83:catch(function(p6) -- line: 424
						-- upvalues: FFlagSduiErrorCleanup (copy), SduiLogger (copy), SduiErrors (copy), v78 (copy), SduiParseHelpers (copy), t6 (copy)
						if not FFlagSduiErrorCleanup then
							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
								message = `fetchIfNeeded promise rejected for { v78 }: { SduiParseHelpers.stringifyValue(p6) }`
							}, t6.surfaceKey)
						end
					end)
					t3[v78] = {
						promise = v83,
						resolve = u81,
						reject = u82
					}
				end

				return t3[v78].promise
			end

			return Promise.resolve()
		end

		if t2[v78] then
			return nil
		end

		t2[v78] = true
		t6.loadTimer.logUiRequestQueued()
		t1[v78] = t6

		return v50.getAndFetchItem(v78, if not b2 then nil else function() -- line: 461
			return true
		end)
	end
	local function getInputData(s5: string, s6: string?, p7) -- line: 480
		-- upvalues: resolveSduiCacheEntry (copy), t4 (copy)
		local v87 = if not s6 or s6 == "" then nil else `{ s5 }_{ s6 }`
		local v88 = resolveSduiCacheEntry(t4, s5, v87)

		if v88 == nil then
			return nil
		end

		return v88.get(p7 ~= nil and p7)
	end
	local function dismissEntry(s7: string) -- line: 711
		-- upvalues: t1 (copy), v50 (copy), v42 (copy)
		local t7 = {}

		if typeof(s7) ~= "string" or s7 == "" then
			return t7
		end

		for v128 in t1 do
			local v129 = v50.getCachedItem(v128).data(false)

			if v129 then
				local v130 = false
				local t8 = {}

				for v132, v133 in v129 do
					if v133 and v133.category ~= nil and s7 == v133.title then
						v130 = true
					else
						t8[v132] = v133
					end
				end

				if v130 then
					v42.replaceItems({
						[v128] = t8
					})
					table.insert(t7, v128)
				end
			end
		end

		return t7
	end

	return {
		fetchIfNeeded = fetchIfNeeded,
		isInFlight = function(s8: string) -- line: 152
			-- upvalues: t3 (copy), t2 (copy)
			if t3[s8] ~= nil then
				return true
			end

			return t2[s8] == true
		end,
		dismissEntry = if not FFlagSduiDismissPromptAction then nil else dismissEntry,
		seedFromDecodedResponse = function(t9: {[any]: any}) -- line: 648
			-- upvalues: t1 (copy), SduiResponseType (copy), v50 (copy), handleSduiApiResponse (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), accumulateSduiCacheSubEntries (copy), v42 (copy)
			local configKey = t9.configKey
			local loadTimer = t9.loadTimer

			loadTimer.logUiRequestQueued()
			t1[configKey] = {
				url = `inline://{ configKey }`,
				surfaceKey = t9.surfaceKey,
				configKey = configKey,
				loadTimer = loadTimer,
				apiProto = t9.apiProto,
				responseType = SduiResponseType.Protobuf
			}

			local v122 = v50.getCachedItem(configKey).data(false)
			local ok, result = pcall(function() -- line: 671
				-- upvalues: handleSduiApiResponse (copy), t9 (copy), loadTimer (copy), configKey (copy), SduiProtobufResponseHelpers (copy), getInputDataSignals (copy)
				return handleSduiApiResponse({
					paginateResponse = false,
					cacheSingleEntryWithIdentifier = true,
					response = {
						StatusCode = 200,
						Body = t9.decodedResponse,
						Stats = {}
					},
					loadTimer = loadTimer,
					surfaceKey = t9.surfaceKey,
					configCacheKey = configKey,
					decodeResponse = function(p8) -- line: 681
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
					name = t9.surfaceKey
				}, t9.surfaceKey)
				error(result)
			end

			local v125 = accumulateSduiCacheSubEntries(result, v122)

			v42.updateItems({
				[configKey] = v125
			})
		end,
		getData = v50.getCachedItem,
		getInputData = if not FFlagSduiApiStoreExposeGetInputData then nil else getInputData,
		getRootConfig = function(s9: string, p9, s10: string?) -- line: 493
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v92 = v50.getCachedItem(s9).data(p9)
			local v93 = if not FFlagSduiAlwaysCacheWithIdentifier then v92 and v92[s10 or s9] else resolveSduiCacheEntry(v92, s9, s10)

			if v93 then
				return v93.config
			end

			return nil
		end,
		getTitle = function(s11: string, p10, s12: string?) -- line: 509
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v97 = v50.getCachedItem(s11).data(p10)
			local v98 = if not FFlagSduiAlwaysCacheWithIdentifier then v97 and v97[s12 or s11] else resolveSduiCacheEntry(v97, s11, s12)

			if v98 and v98.title ~= "" then
				return v98.title
			end

			return nil
		end,
		getDataUpdatedTimestamp = function(s13: string, p11, s14: string?) -- line: 521
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v102 = v50.getCachedItem(s13).data(p11)
			local v103 = if not FFlagSduiAlwaysCacheWithIdentifier then v102 and v102[s14 or s13] else resolveSduiCacheEntry(v102, s13, s14)

			if v103 then
				return v103.dataUpdatedTimestamp
			end

			return nil
		end,
		getEntrySurfacing = function(s15: string, s16: string?, p12) -- line: 535
			-- upvalues: v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy)
			local v107 = v50.getCachedItem(s15).data(p12)
			local v108 = if not FFlagSduiAlwaysCacheWithIdentifier then v107 and v107[s16 or s15] else resolveSduiCacheEntry(v107, s15, s16)

			if v108 then
				return v108.surfacing
			end

			return nil
		end,
		loadMoreFromApi = function(t10: {[any]: any}) -- line: 547
			-- upvalues: FFlagSduiChartsSupport (copy), t2 (copy), t1 (copy), SduiLogger (copy), SduiErrors (copy), Promise (copy), v50 (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), resolveSduiCacheEntry (copy), FFlagSduiPaginatePostBody (copy), Cryo (copy), fetchIfNeeded (copy)
			if not FFlagSduiChartsSupport and t2[t10.configKey] then
				return nil
			end

			local v110 = t1[t10.configKey]

			if not v110 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToPaginateRequest, {
					message = `No requestData for { t10.configKey }`
				}, "unknown")

				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			local v111 = v50.getCachedItem(t10.configKey).data(false)
			local v112 = if not FFlagSduiAlwaysCacheWithIdentifier then v111 and v111[t10.identifier or t10.configKey] else resolveSduiCacheEntry(v111, t10.configKey, t10.identifier)

			if not v112 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToPaginateRequest, {
					message = `No entry data for { t10.configKey }`,
					name = v110.surfaceKey
				}, v110.surfaceKey)

				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			local nextPageUrl = v112.nextPageUrl

			if not nextPageUrl or nextPageUrl == "" then
				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			local t11 = {
				isPaginated = true,
				url = nextPageUrl,
				loadTimer = t10.loadTimer
			}

			if FFlagSduiPaginatePostBody and v110.postConfig and v112.nextPagePostBody then
				t11.postConfig = Cryo.Dictionary.join(v110.postConfig, {
					body = v112.nextPagePostBody
				})
			end

			if FFlagSduiChartsSupport then
				return fetchIfNeeded(Cryo.Dictionary.join(v110, t11), true)
			end

			fetchIfNeeded(Cryo.Dictionary.join(v110, t11), true)

			return nil
		end,
		refreshFromApi = function(t12: {[any]: any}) -- line: 605
			-- upvalues: t1 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiChartsSupport (copy), Promise (copy), Cryo (copy), FFlagSduiPaginatePostBody (copy), fetchIfNeeded (copy)
			local v116 = t1[t12.configKey]

			if not v116 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToFetchPage, {
					message = `No requestData for refresh: { t12.configKey }`
				}, "unknown")

				if FFlagSduiChartsSupport then
					return Promise.resolve()
				end

				return nil
			end

			if FFlagSduiChartsSupport then
				local t13 = {
					url = ((if not v116.buildRefreshUrl then nil else v116.buildRefreshUrl())) or v116.url,
					loadTimer = t12.loadTimer,
					isPaginated = Cryo.None
				}

				if FFlagSduiPaginatePostBody and v116.postConfig then
					local v118 = if not v116.buildRefreshPostBody then nil else v116.buildRefreshPostBody()

					if v118 then
						t13.postConfig = Cryo.Dictionary.join(v116.postConfig, {
							body = v118
						})
					end
				end

				return fetchIfNeeded(Cryo.Dictionary.join(v116, t13), true)
			end

			return fetchIfNeeded(Cryo.Dictionary.join(v116, {
				loadTimer = t12.loadTimer
			}), true)
		end
	}
end

return createSduiApiStore

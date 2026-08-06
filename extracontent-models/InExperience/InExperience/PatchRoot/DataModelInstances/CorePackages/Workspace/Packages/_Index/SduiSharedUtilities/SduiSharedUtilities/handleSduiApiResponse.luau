local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent

require(SduiSharedUtilitiesParent.Signals)

local SduiCoreSystem = require(SduiSharedUtilitiesParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiUsageRecorder = SduiCoreSystem.SduiUsageRecorder
local recordTemplateUsage = SduiCoreSystem.recordTemplateUsage
local getSduiTemplateStore = require(SduiSharedUtilities.getSduiTemplateStore)
local SduiProtobufResponseHelpers = require(SduiSharedUtilities.SduiProtobufResponseHelpers)

require(SduiSharedUtilities.SduiLoadTimer)

local SduiRequestStatus = require(SduiSharedUtilities.SduiIntegrationTypes).SduiRequestStatus
local SduiInputDataMerge = require(SduiSharedUtilities.SduiInputDataMerge)
local processClientHints = require(SduiSharedUtilities.processClientHints)
local getSduiClientBindingBuilder = SduiCoreSystem.getSduiClientBindingBuilder
local createBuilderConfig = SduiCoreSystem.createBuilderConfig
local getSduiDataBinder = SduiCoreSystem.getSduiDataBinder
local FFlagSduiAllowNoConfigsBuilt = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiAllowNoConfigsBuilt
local FFlagSduiInputDataMergeStrategy = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiInputDataMergeStrategy
local FFlagSduiAlwaysCacheWithIdentifier = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiAlwaysCacheWithIdentifier
local FFlagSduiNilHydrationGuard = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiNilHydrationGuard
local FFlagEnableSduiV2HomepagePrompts = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableSduiV2HomepagePrompts
local FFlagEnableHomepagePromptsForModalsAndBanners = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = require(SduiSharedUtilitiesParent.SharedFlags).FFlagPromptsHandlerEnabled
local FFlagSduiImprovedErrorDimensions = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiUsageTelemetry = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiUsageTelemetry
local FFlagSduiExperienceDetailsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiPageEntrySurfacing = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntrySurfacing
local FFlagLuaAppSduiStreamingChunkedResponses = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiStreamingChunkedResponses
local FFlagSduiClientTemplateCache = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiClientTemplateCache
local FFlagSduiPaginatePostBody = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPaginatePostBody
local FFlagSduiGameIconSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiGameIconSupport
local Cryo = require(SduiSharedUtilitiesParent.Cryo)

local function mergeTables(t1: {[any]: any}, t2: {[any]: any}) -- line: 57
	-- upvalues: mergeTables (copy)
	for v38, v39 in t2 do
		if typeof(v39) == "table" then
			if t1[v38] == nil then
				t1[v38] = {}
			end

			if #v39 > 0 then
				for _, v41 in v39 do
					table.insert(t1[v38], v41)
				end
			else
				mergeTables(t1[v38], v39)
			end
		else
			t1[v38] = v39
		end
	end
end
local function getUpdatedInputData(t3: {[any]: any}, t4: {[any]: any}) -- line: 79
	-- upvalues: mergeTables (copy)
	local v44 = table.clone(t3)

	mergeTables(v44, t4)

	return v44
end
local function handleSduiApiResponse(t5: {[any]: any}) -- line: 96
	-- upvalues: FFlagSduiPaginatePostBody (copy), FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), SduiRequestStatus (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), FFlagSduiNilHydrationGuard (copy), getSduiDataBinder (copy), FFlagSduiClientTemplateCache (copy), getSduiTemplateStore (copy), FFlagSduiUsageTelemetry (copy), recordTemplateUsage (copy), SduiUsageRecorder (copy), SduiProtobufResponseHelpers (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), SduiInputDataMerge (copy), mergeTables (copy), createBuilderConfig (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiClientBindingBuilder (copy), FFlagEnableSduiV2HomepagePrompts (copy), FFlagPromptsHandlerEnabled (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), FFlagSduiPageEntrySurfacing (copy), Cryo (copy), FFlagSduiGameIconSupport (copy), processClientHints (copy)
	local response = t5.response
	local decodeResponse = t5.decodeResponse
	local parsePageEntriesFromResponse = t5.parsePageEntriesFromResponse
	local parseHydrationDataFromResponse = t5.parseHydrationDataFromResponse
	local parseTemplateEntriesFromResponse = t5.parseTemplateEntriesFromResponse
	local getInputDataSignalsForRequest = t5.getInputDataSignalsForRequest
	local loadTimer = t5.loadTimer
	local surfaceKey = t5.surfaceKey
	local v54 = t5.configCacheKey or t5.surfaceKey
	local enableTemplateCache = t5.enableTemplateCache
	local paginateResponse = t5.paginateResponse
	local buildNextPageUrl = t5.buildNextPageUrl
	local v58 = if not FFlagSduiPaginatePostBody then nil else t5.buildNextPagePostBody
	local v59 = if not FFlagSduiAllowNoConfigsBuilt then nil else t5.allowNoConfigsBuilt
	local mergeStrategy = nil
	local g83 = nil
	local g85 = nil

	if FFlagSduiInputDataMergeStrategy then
		mergeStrategy = t5.mergeStrategy
	end

	assert(v54, "configCacheKey must exist")
	loadTimer.logNetRequestStats(response.Stats)
	loadTimer.logResponseDecodeBegin()

	local ok, result = pcall(function() -- line: 154
		-- upvalues: decodeResponse (copy), response (copy)
		return (decodeResponse(response.Body))
	end)

	loadTimer.logResponseDecodeEnd()

	if not ok then
		loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToDecodeResponse, {
			debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v54,
			message = result
		}, surfaceKey)
		error("Failed to decode")
	end

	loadTimer.logResponseDataUpdateBegin()

	if parseHydrationDataFromResponse then
		local ok2, result2 = pcall(function() -- line: 179
			-- upvalues: parseHydrationDataFromResponse (copy), result (copy), FFlagSduiNilHydrationGuard (copy), getSduiDataBinder (copy)
			local v94 = parseHydrationDataFromResponse(result)

			if FFlagSduiNilHydrationGuard then
				if v94 ~= nil then
					getSduiDataBinder().updateDataStores(v94)

					return
				end
			else
				getSduiDataBinder().updateDataStores(v94)
			end
		end)

		if not ok2 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToUpdateDataStores, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
				name = if not FFlagSduiImprovedErrorDimensions then nil else v54,
				message = result2
			}, surfaceKey)
		end
	end

	local t6 = {}

	if parseTemplateEntriesFromResponse then
		local ok3, result3 = pcall(function() -- line: 204
			-- upvalues: t6 (ref), parseTemplateEntriesFromResponse (copy), result (copy), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), getSduiTemplateStore (copy), surfaceKey (copy), FFlagSduiUsageTelemetry (copy), recordTemplateUsage (copy), SduiUsageRecorder (copy)
			local v95, v96, v97 = parseTemplateEntriesFromResponse(result, if not FFlagSduiClientTemplateCache then nil else enableTemplateCache)

			t6 = v96
			getSduiTemplateStore().addTemplates(v95)

			if FFlagSduiClientTemplateCache and enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v97)
			end

			if FFlagSduiUsageTelemetry and v95 then
				for _, v99 in v95 do
					pcall(recordTemplateUsage, surfaceKey, v99)
				end

				SduiUsageRecorder.scheduleFlush()
			end
		end)

		if not ok3 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
				name = if not FFlagSduiImprovedErrorDimensions then nil else v54,
				message = result3
			}, surfaceKey)
		end
	end

	loadTimer.logResponseDataUpdateEnd()
	loadTimer.logSduiTreeBuildBegin()

	local v68 = if not parsePageEntriesFromResponse then {} else parsePageEntriesFromResponse(result)
	local v69 = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)

	local function resolveTemplateForRobloxComponent(s1: string) -- line: 262
		-- upvalues: t6 (ref), getSduiTemplateStore (copy), surfaceKey (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), v54 (copy)
		local v101 = t6[s1]

		if v101 == nil then
			v101 = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, s1)
		end

		if v101 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.MissingCachedTemplate, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
				name = s1,
				message = `Backend omitted template for { s1 } but it could not be resolved from the surface cache + template store`
			}, surfaceKey)
		end

		return v101
	end

	local t7 = {}
	local v72 = #v68 > 1

	for _, v74 in v68 do
		local identifier = v74.identifier
		local v76 = if not v72 and (not FFlagSduiAlwaysCacheWithIdentifier and not t5.cacheSingleEntryWithIdentifier) or (not identifier or identifier == "") then v54 else `{ v54 }_{ identifier }`
		local componentInputData = v74.componentInputData
		local v78 = getInputDataSignalsForRequest(v76)
		local v79 = v78.get(false)
		local v80 = FFlagLuaAppSduiStreamingChunkedResponses and t5.enableStreamingMerge

		if (paginateResponse or v80) and v79 then
			if componentInputData then
				local v81

				if FFlagSduiInputDataMergeStrategy then
					v81 = SduiInputDataMerge.merge(v78.get(false), componentInputData, mergeStrategy)
				else
					local v82 = v78.get(false)

					v81 = table.clone(v82)
					mergeTables(v81, componentInputData)
				end

				v78.set(v81)
			end
		else
			v78.set(componentInputData)
		end

		repeat
			if g83 or (paginateResponse or v80) and v79 then
				g83 = false
				t7[v76] = t7[v76] or {}

				if buildNextPageUrl then
					t7[v76].nextPageUrl = buildNextPageUrl(result) or ""
				else
					t7[v76].nextPageUrl = ""
				end

				if FFlagSduiPaginatePostBody and v58 then
					local v84 = v58(result)

					t7[v76].nextPagePostBody = v84 or Cryo.None
				end

				g85 = true

				break
			end

			local robloxComponentType = v74.robloxComponentType

			if robloxComponentType then
				local v87 = if not FFlagSduiClientTemplateCache or not enableTemplateCache then t6[robloxComponentType] else resolveTemplateForRobloxComponent(robloxComponentType)

				if not v87 then
					if not FFlagSduiClientTemplateCache or not enableTemplateCache then
						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate, {
							debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
							name = robloxComponentType,
							message = `Missing template for robloxComponentType { robloxComponentType }`
						}, surfaceKey)
					end

					g85 = true

					break
				end

				local ok4, result4 = pcall(function() -- line: 340
					-- upvalues: createBuilderConfig (copy), surfaceKey (copy), v54 (copy), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref), v69 (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiClientBindingBuilder (copy), v87 (copy), v78 (copy)
					local v102 = createBuilderConfig({
						appPage = surfaceKey,
						debugName = v54,
						getTemplateForRobloxComponent = function(p1) -- line: 344
							-- upvalues: FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref)
							if FFlagSduiClientTemplateCache and enableTemplateCache then
								return (resolveTemplateForRobloxComponent(p1))
							end

							return t6[p1]
						end,
						localizedLiterals = v69,
						configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else v54
					})

					return (getSduiClientBindingBuilder().buildConfigForComponent(v87, v78.get, v102))
				end)

				if ok4 then
					if t7[v76] then
						SduiLogger.reportError(SduiErrors.SduiErrorType.DuplicateOrMissingIdentifier, {
							debugName = if not FFlagSduiImprovedErrorDimensions then v76 else nil,
							name = robloxComponentType,
							message = `Existing config found for cacheKey { v76 }. Need to specify identifer in page entry for multiple configs`
						}, surfaceKey)
					end

					t7[v76] = {
						config = result4,
						dataUpdatedTimestamp = os.clock(),
						identifier = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else identifier,
						robloxComponentType = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else robloxComponentType,
						category = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else v74.category,
						surfacing = if not FFlagSduiPageEntrySurfacing then nil else v74.surfacing
					}
				else
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToBuildClientBindingConfig, {
						debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
						name = robloxComponentType,
						message = `{ result4 }`
					}, surfaceKey)
				end

				if v74.title and t7[v76] then
					t7[v76].title = v74.title
				end

				g83 = true
			end
		until not g83

		if g85 then
			g85 = false

			continue
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, {
			message = "Page entry missing robloxComponentType",
			debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v54
		}, surfaceKey)
	end

	if not next(t7) and not paginateResponse and (not FFlagSduiAllowNoConfigsBuilt or not v59) then
		SduiLogger.reportError(SduiErrors.SduiErrorType.NoComponentConfigsBuilt, {
			debugName = if not FFlagSduiImprovedErrorDimensions then v54 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v54,
			message = `No configs built when handling proto response for { v54 }`
		}, surfaceKey)
	end

	loadTimer.logSduiTreeBuildEnd()

	if FFlagSduiGameIconSupport then
		local function getTemplateForRobloxComponent(s2: string) -- line: 435
			-- upvalues: FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref)
			if FFlagSduiClientTemplateCache and enableTemplateCache then
				return (resolveTemplateForRobloxComponent(s2))
			end

			return t6[s2]
		end
		local function getKnownTemplates() -- line: 445
			-- upvalues: t6 (ref), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), getSduiTemplateStore (copy), surfaceKey (copy)
			local t8 = {}

			for _, v106 in t6 do
				table.insert(t8, v106)
			end

			if FFlagSduiClientTemplateCache and enableTemplateCache then
				local v107 = getSduiTemplateStore()

				for _, v109 in v107.getCachedRobloxComponentToTemplateId(surfaceKey) do
					local v110 = v107.getTemplate(v109)

					if v110 ~= nil then
						table.insert(t8, v110)
					end
				end
			end

			return t8
		end

		loadTimer.logSduiClientHintsBegin()

		local ok5, result5 = pcall(function() -- line: 463
			-- upvalues: processClientHints (copy), v68 (copy), getTemplateForRobloxComponent (copy), getKnownTemplates (copy)
			processClientHints({
				pageEntries = v68,
				getTemplateForRobloxComponent = getTemplateForRobloxComponent,
				getKnownTemplates = getKnownTemplates
			})
		end)

		loadTimer.logSduiClientHintsEnd()

		if not ok5 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToProcessClientHints, {
				name = v54,
				message = result5
			}, surfaceKey)
		end
	end

	return t7
end

return handleSduiApiResponse

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
local getSduiClientBindingBuilder = SduiCoreSystem.getSduiClientBindingBuilder
local createBuilderConfig = SduiCoreSystem.createBuilderConfig
local getSduiDataBinder = SduiCoreSystem.getSduiDataBinder
local FFlagSduiAllowNoConfigsBuilt = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiAllowNoConfigsBuilt
local FFlagSduiInputDataMergeStrategy = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiInputDataMergeStrategy
local FFlagSduiLocalizedLiterals = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagSduiAlwaysCacheWithIdentifier = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiAlwaysCacheWithIdentifier
local FFlagSduiNilHydrationGuard = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiNilHydrationGuard
local FFlagSduiChartsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiChartsSupport
local FFlagEnableSduiV2HomepagePrompts = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableSduiV2HomepagePrompts
local FFlagEnableHomepagePromptsForModalsAndBanners = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = require(SduiSharedUtilitiesParent.SharedFlags).FFlagPromptsHandlerEnabled
local FFlagSduiImprovedErrorDimensions = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiUsageTelemetry = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiUsageTelemetry
local FFlagSduiExperienceDetailsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiPageEntrySurfacing = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntrySurfacing
local FFlagEnableSduiV2HomeInterleave = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableSduiV2HomeInterleave
local FFlagLuaAppSduiStreamingChunkedResponses = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiStreamingChunkedResponses
local FFlagSduiClientTemplateCache = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiClientTemplateCache

local function mergeTables(t1: {[any]: any}, t2: {[any]: any}) -- line: 54
	-- upvalues: mergeTables (copy)
	for v37, v38 in t2 do
		if typeof(v38) == "table" then
			if t1[v37] == nil then
				t1[v37] = {}
			end

			if #v38 > 0 then
				for _, v40 in v38 do
					table.insert(t1[v37], v40)
				end
			else
				mergeTables(t1[v37], v38)
			end
		else
			t1[v37] = v38
		end
	end
end
local function getUpdatedInputData(t3: {[any]: any}, t4: {[any]: any}) -- line: 76
	-- upvalues: mergeTables (copy)
	local v43 = table.clone(t3)

	mergeTables(v43, t4)

	return v43
end
local function handleSduiApiResponse(t5: {[any]: any}) -- line: 93
	-- upvalues: FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), SduiRequestStatus (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), FFlagSduiNilHydrationGuard (copy), getSduiDataBinder (copy), FFlagSduiClientTemplateCache (copy), getSduiTemplateStore (copy), FFlagSduiUsageTelemetry (copy), recordTemplateUsage (copy), SduiUsageRecorder (copy), FFlagSduiLocalizedLiterals (copy), SduiProtobufResponseHelpers (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), FFlagEnableSduiV2HomeInterleave (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), SduiInputDataMerge (copy), mergeTables (copy), createBuilderConfig (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiClientBindingBuilder (copy), FFlagSduiChartsSupport (copy), FFlagEnableSduiV2HomepagePrompts (copy), FFlagPromptsHandlerEnabled (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), FFlagSduiPageEntrySurfacing (copy)
	local response = t5.response
	local decodeResponse = t5.decodeResponse
	local parsePageEntriesFromResponse = t5.parsePageEntriesFromResponse
	local parseHydrationDataFromResponse = t5.parseHydrationDataFromResponse
	local parseTemplateEntriesFromResponse = t5.parseTemplateEntriesFromResponse
	local getInputDataSignalsForRequest = t5.getInputDataSignalsForRequest
	local loadTimer = t5.loadTimer
	local surfaceKey = t5.surfaceKey
	local v53 = t5.configCacheKey or t5.surfaceKey
	local enableTemplateCache = t5.enableTemplateCache
	local paginateResponse = t5.paginateResponse
	local buildNextPageUrl = t5.buildNextPageUrl
	local v57 = if not FFlagSduiAllowNoConfigsBuilt then nil else t5.allowNoConfigsBuilt
	local mergeStrategy = nil
	local g81 = nil
	local g82 = nil

	if FFlagSduiInputDataMergeStrategy then
		mergeStrategy = t5.mergeStrategy
	end

	assert(v53, "configCacheKey must exist")
	loadTimer.logNetRequestStats(response.Stats)
	loadTimer.logResponseDecodeBegin()

	local ok, result = pcall(function() -- line: 147
		-- upvalues: decodeResponse (copy), response (copy)
		return (decodeResponse(response.Body))
	end)

	loadTimer.logResponseDecodeEnd()

	if not ok then
		loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToDecodeResponse, {
			debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v53,
			message = result
		}, surfaceKey)
		error("Failed to decode")
	end

	loadTimer.logResponseDataUpdateBegin()

	if parseHydrationDataFromResponse then
		local ok2, result2 = pcall(function() -- line: 171
			-- upvalues: parseHydrationDataFromResponse (copy), result (copy), FFlagSduiNilHydrationGuard (copy), getSduiDataBinder (copy)
			local v87 = parseHydrationDataFromResponse(result)

			if FFlagSduiNilHydrationGuard then
				if v87 ~= nil then
					getSduiDataBinder().updateDataStores(v87)

					return
				end
			else
				getSduiDataBinder().updateDataStores(v87)
			end
		end)

		if not ok2 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToUpdateDataStores, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
				name = if not FFlagSduiImprovedErrorDimensions then nil else v53,
				message = result2
			}, surfaceKey)
		end
	end

	local t6 = {}

	if parseTemplateEntriesFromResponse then
		local ok3, result3 = pcall(function() -- line: 196
			-- upvalues: t6 (ref), parseTemplateEntriesFromResponse (copy), result (copy), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), getSduiTemplateStore (copy), surfaceKey (copy), FFlagSduiUsageTelemetry (copy), recordTemplateUsage (copy), SduiUsageRecorder (copy)
			local v88, v89, v90 = parseTemplateEntriesFromResponse(result, if not FFlagSduiClientTemplateCache then nil else enableTemplateCache)

			t6 = v89
			getSduiTemplateStore().addTemplates(v88)

			if FFlagSduiClientTemplateCache and enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v90)
			end

			if FFlagSduiUsageTelemetry and v88 then
				for _, v92 in v88 do
					pcall(recordTemplateUsage, surfaceKey, v92)
				end

				SduiUsageRecorder.scheduleFlush()
			end
		end)

		if not ok3 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
				name = if not FFlagSduiImprovedErrorDimensions then nil else v53,
				message = result3
			}, surfaceKey)
		end
	end

	loadTimer.logResponseDataUpdateEnd()
	loadTimer.logSduiTreeBuildBegin()

	local v66 = if not parsePageEntriesFromResponse then {} else parsePageEntriesFromResponse(result)
	local v67 = if not FFlagSduiLocalizedLiterals then nil else SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)

	local function resolveTemplateForRobloxComponent(s1: string) -- line: 256
		-- upvalues: t6 (ref), getSduiTemplateStore (copy), surfaceKey (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), v53 (copy)
		local v94 = t6[s1]

		if v94 == nil then
			v94 = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, s1)
		end

		if v94 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.MissingCachedTemplate, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
				name = s1,
				message = `Backend omitted template for { s1 } but it could not be resolved from the surface cache + template store`
			}, surfaceKey)
		end

		return v94
	end

	local t7 = {}
	local v70 = #v66 > 1

	for _, v72 in v66 do
		local identifier = v72.identifier
		local v74 = if not v70 and (not FFlagSduiAlwaysCacheWithIdentifier and (not FFlagEnableSduiV2HomeInterleave or not t5.cacheSingleEntryWithIdentifier)) or (not identifier or identifier == "") then v53 else `{ v53 }_{ identifier }`
		local componentInputData = v72.componentInputData
		local v76 = getInputDataSignalsForRequest(v74)
		local v77 = v76.get(false)
		local v78 = FFlagLuaAppSduiStreamingChunkedResponses and t5.enableStreamingMerge

		if (paginateResponse or v78) and v77 then
			if componentInputData then
				local v79

				if FFlagSduiInputDataMergeStrategy then
					v79 = SduiInputDataMerge.merge(v76.get(false), componentInputData, mergeStrategy)
				else
					local v80 = v76.get(false)

					v79 = table.clone(v80)
					mergeTables(v79, componentInputData)
				end

				v76.set(v79)
			end
		else
			v76.set(componentInputData)
		end

		repeat
			if g81 or (paginateResponse or v78) and v77 then
				g81 = false
				t7[v74] = t7[v74] or {}

				if buildNextPageUrl then
					t7[v74].nextPageUrl = buildNextPageUrl(result) or ""
				else
					t7[v74].nextPageUrl = ""
				end

				g82 = true

				break
			end

			local robloxComponentType = v72.robloxComponentType

			if robloxComponentType then
				local v84 = if not FFlagSduiClientTemplateCache or not enableTemplateCache then t6[robloxComponentType] else resolveTemplateForRobloxComponent(robloxComponentType)

				if not v84 then
					if not FFlagSduiClientTemplateCache or not enableTemplateCache then
						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate, {
							debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
							name = robloxComponentType,
							message = `Missing template for robloxComponentType { robloxComponentType }`
						}, surfaceKey)
					end

					g82 = true

					break
				end

				local ok4, result4 = pcall(function() -- line: 334
					-- upvalues: createBuilderConfig (copy), surfaceKey (copy), v53 (copy), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref), v67 (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiClientBindingBuilder (copy), v84 (copy), v76 (copy)
					local v95 = createBuilderConfig({
						appPage = surfaceKey,
						debugName = v53,
						getTemplateForRobloxComponent = function(p1) -- line: 338
							-- upvalues: FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref)
							if FFlagSduiClientTemplateCache and enableTemplateCache then
								return (resolveTemplateForRobloxComponent(p1))
							end

							return t6[p1]
						end,
						localizedLiterals = v67,
						configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else v53
					})

					return (getSduiClientBindingBuilder().buildConfigForComponent(v84, v76.get, v95))
				end)

				if ok4 then
					if t7[v74] then
						SduiLogger.reportError(SduiErrors.SduiErrorType.DuplicateOrMissingIdentifier, {
							debugName = if not FFlagSduiImprovedErrorDimensions then v74 else nil,
							name = robloxComponentType,
							message = `Existing config found for cacheKey { v74 }. Need to specify identifer in page entry for multiple configs`
						}, surfaceKey)
					end

					t7[v74] = {
						config = result4,
						dataUpdatedTimestamp = if not FFlagSduiChartsSupport and not FFlagEnableSduiV2HomeInterleave then nil else os.clock(),
						identifier = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else identifier,
						robloxComponentType = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else robloxComponentType,
						category = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else v72.category,
						surfacing = if not FFlagSduiPageEntrySurfacing then nil else v72.surfacing
					}
				else
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToBuildClientBindingConfig, {
						debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
						name = robloxComponentType,
						message = `{ result4 }`
					}, surfaceKey)
				end

				if v72.title and t7[v74] then
					t7[v74].title = v72.title
				end

				g81 = true
			end
		until not g81

		if g82 then
			g82 = false

			continue
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, {
			message = "Page entry missing robloxComponentType",
			debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v53
		}, surfaceKey)
	end

	if not next(t7) and not paginateResponse and (not FFlagSduiAllowNoConfigsBuilt or not v57) then
		SduiLogger.reportError(SduiErrors.SduiErrorType.NoComponentConfigsBuilt, {
			debugName = if not FFlagSduiImprovedErrorDimensions then v53 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v53,
			message = `No configs built when handling proto response for { v53 }`
		}, surfaceKey)
	end

	loadTimer.logSduiTreeBuildEnd()

	return t7
end

return handleSduiApiResponse

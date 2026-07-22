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

local function mergeTables(t1: {[any]: any}, t2: {[any]: any}) -- line: 53
	-- upvalues: mergeTables (copy)
	for v36, v37 in t2 do
		if typeof(v37) == "table" then
			if t1[v36] == nil then
				t1[v36] = {}
			end

			if #v37 > 0 then
				for _, v39 in v37 do
					table.insert(t1[v36], v39)
				end
			else
				mergeTables(t1[v36], v37)
			end
		else
			t1[v36] = v37
		end
	end
end
local function getUpdatedInputData(t3: {[any]: any}, t4: {[any]: any}) -- line: 75
	-- upvalues: mergeTables (copy)
	local v42 = table.clone(t3)

	mergeTables(v42, t4)

	return v42
end
local function handleSduiApiResponse(t5: {[any]: any}) -- line: 92
	-- upvalues: FFlagSduiAllowNoConfigsBuilt (copy), FFlagSduiInputDataMergeStrategy (copy), SduiRequestStatus (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), FFlagSduiNilHydrationGuard (copy), getSduiDataBinder (copy), FFlagSduiClientTemplateCache (copy), getSduiTemplateStore (copy), FFlagSduiUsageTelemetry (copy), recordTemplateUsage (copy), SduiUsageRecorder (copy), SduiProtobufResponseHelpers (copy), FFlagSduiAlwaysCacheWithIdentifier (copy), FFlagEnableSduiV2HomeInterleave (copy), FFlagLuaAppSduiStreamingChunkedResponses (copy), SduiInputDataMerge (copy), mergeTables (copy), createBuilderConfig (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiClientBindingBuilder (copy), FFlagSduiChartsSupport (copy), FFlagEnableSduiV2HomepagePrompts (copy), FFlagPromptsHandlerEnabled (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), FFlagSduiPageEntrySurfacing (copy)
	local response = t5.response
	local decodeResponse = t5.decodeResponse
	local parsePageEntriesFromResponse = t5.parsePageEntriesFromResponse
	local parseHydrationDataFromResponse = t5.parseHydrationDataFromResponse
	local parseTemplateEntriesFromResponse = t5.parseTemplateEntriesFromResponse
	local getInputDataSignalsForRequest = t5.getInputDataSignalsForRequest
	local loadTimer = t5.loadTimer
	local surfaceKey = t5.surfaceKey
	local v52 = t5.configCacheKey or t5.surfaceKey
	local enableTemplateCache = t5.enableTemplateCache
	local paginateResponse = t5.paginateResponse
	local buildNextPageUrl = t5.buildNextPageUrl
	local v56 = if not FFlagSduiAllowNoConfigsBuilt then nil else t5.allowNoConfigsBuilt
	local mergeStrategy = nil
	local g80 = nil
	local g81 = nil

	if FFlagSduiInputDataMergeStrategy then
		mergeStrategy = t5.mergeStrategy
	end

	assert(v52, "configCacheKey must exist")
	loadTimer.logNetRequestStats(response.Stats)
	loadTimer.logResponseDecodeBegin()

	local ok, result = pcall(function() -- line: 146
		-- upvalues: decodeResponse (copy), response (copy)
		return (decodeResponse(response.Body))
	end)

	loadTimer.logResponseDecodeEnd()

	if not ok then
		loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToDecodeResponse, {
			debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v52,
			message = result
		}, surfaceKey)
		error("Failed to decode")
	end

	loadTimer.logResponseDataUpdateBegin()

	if parseHydrationDataFromResponse then
		local ok2, result2 = pcall(function() -- line: 170
			-- upvalues: parseHydrationDataFromResponse (copy), result (copy), FFlagSduiNilHydrationGuard (copy), getSduiDataBinder (copy)
			local v86 = parseHydrationDataFromResponse(result)

			if FFlagSduiNilHydrationGuard then
				if v86 ~= nil then
					getSduiDataBinder().updateDataStores(v86)

					return
				end
			else
				getSduiDataBinder().updateDataStores(v86)
			end
		end)

		if not ok2 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToUpdateDataStores, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
				name = if not FFlagSduiImprovedErrorDimensions then nil else v52,
				message = result2
			}, surfaceKey)
		end
	end

	local t6 = {}

	if parseTemplateEntriesFromResponse then
		local ok3, result3 = pcall(function() -- line: 195
			-- upvalues: t6 (ref), parseTemplateEntriesFromResponse (copy), result (copy), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), getSduiTemplateStore (copy), surfaceKey (copy), FFlagSduiUsageTelemetry (copy), recordTemplateUsage (copy), SduiUsageRecorder (copy)
			local v87, v88, v89 = parseTemplateEntriesFromResponse(result, if not FFlagSduiClientTemplateCache then nil else enableTemplateCache)

			t6 = v88
			getSduiTemplateStore().addTemplates(v87)

			if FFlagSduiClientTemplateCache and enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v89)
			end

			if FFlagSduiUsageTelemetry and v87 then
				for _, v91 in v87 do
					pcall(recordTemplateUsage, surfaceKey, v91)
				end

				SduiUsageRecorder.scheduleFlush()
			end
		end)

		if not ok3 then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
				name = if not FFlagSduiImprovedErrorDimensions then nil else v52,
				message = result3
			}, surfaceKey)
		end
	end

	loadTimer.logResponseDataUpdateEnd()
	loadTimer.logSduiTreeBuildBegin()

	local v65 = if not parsePageEntriesFromResponse then {} else parsePageEntriesFromResponse(result)
	local v66 = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)

	local function resolveTemplateForRobloxComponent(s1: string) -- line: 253
		-- upvalues: t6 (ref), getSduiTemplateStore (copy), surfaceKey (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), v52 (copy)
		local v93 = t6[s1]

		if v93 == nil then
			v93 = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, s1)
		end

		if v93 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.MissingCachedTemplate, {
				debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
				name = s1,
				message = `Backend omitted template for { s1 } but it could not be resolved from the surface cache + template store`
			}, surfaceKey)
		end

		return v93
	end

	local t7 = {}
	local v69 = #v65 > 1

	for _, v71 in v65 do
		local identifier = v71.identifier
		local v73 = if not v69 and (not FFlagSduiAlwaysCacheWithIdentifier and (not FFlagEnableSduiV2HomeInterleave or not t5.cacheSingleEntryWithIdentifier)) or (not identifier or identifier == "") then v52 else `{ v52 }_{ identifier }`
		local componentInputData = v71.componentInputData
		local v75 = getInputDataSignalsForRequest(v73)
		local v76 = v75.get(false)
		local v77 = FFlagLuaAppSduiStreamingChunkedResponses and t5.enableStreamingMerge

		if (paginateResponse or v77) and v76 then
			if componentInputData then
				local v78

				if FFlagSduiInputDataMergeStrategy then
					v78 = SduiInputDataMerge.merge(v75.get(false), componentInputData, mergeStrategy)
				else
					local v79 = v75.get(false)

					v78 = table.clone(v79)
					mergeTables(v78, componentInputData)
				end

				v75.set(v78)
			end
		else
			v75.set(componentInputData)
		end

		repeat
			if g80 or (paginateResponse or v77) and v76 then
				g80 = false
				t7[v73] = t7[v73] or {}

				if buildNextPageUrl then
					t7[v73].nextPageUrl = buildNextPageUrl(result) or ""
				else
					t7[v73].nextPageUrl = ""
				end

				g81 = true

				break
			end

			local robloxComponentType = v71.robloxComponentType

			if robloxComponentType then
				local v83 = if not FFlagSduiClientTemplateCache or not enableTemplateCache then t6[robloxComponentType] else resolveTemplateForRobloxComponent(robloxComponentType)

				if not v83 then
					if not FFlagSduiClientTemplateCache or not enableTemplateCache then
						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate, {
							debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
							name = robloxComponentType,
							message = `Missing template for robloxComponentType { robloxComponentType }`
						}, surfaceKey)
					end

					g81 = true

					break
				end

				local ok4, result4 = pcall(function() -- line: 331
					-- upvalues: createBuilderConfig (copy), surfaceKey (copy), v52 (copy), FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref), v66 (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), getSduiClientBindingBuilder (copy), v83 (copy), v75 (copy)
					local v94 = createBuilderConfig({
						appPage = surfaceKey,
						debugName = v52,
						getTemplateForRobloxComponent = function(p1) -- line: 335
							-- upvalues: FFlagSduiClientTemplateCache (copy), enableTemplateCache (copy), resolveTemplateForRobloxComponent (copy), t6 (ref)
							if FFlagSduiClientTemplateCache and enableTemplateCache then
								return (resolveTemplateForRobloxComponent(p1))
							end

							return t6[p1]
						end,
						localizedLiterals = v66,
						configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else v52
					})

					return (getSduiClientBindingBuilder().buildConfigForComponent(v83, v75.get, v94))
				end)

				if ok4 then
					if t7[v73] then
						SduiLogger.reportError(SduiErrors.SduiErrorType.DuplicateOrMissingIdentifier, {
							debugName = if not FFlagSduiImprovedErrorDimensions then v73 else nil,
							name = robloxComponentType,
							message = `Existing config found for cacheKey { v73 }. Need to specify identifer in page entry for multiple configs`
						}, surfaceKey)
					end

					t7[v73] = {
						config = result4,
						dataUpdatedTimestamp = if not FFlagSduiChartsSupport and not FFlagEnableSduiV2HomeInterleave then nil else os.clock(),
						identifier = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else identifier,
						robloxComponentType = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else robloxComponentType,
						category = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else v71.category,
						surfacing = if not FFlagSduiPageEntrySurfacing then nil else v71.surfacing
					}
				else
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToBuildClientBindingConfig, {
						debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
						name = robloxComponentType,
						message = `{ result4 }`
					}, surfaceKey)
				end

				if v71.title and t7[v73] then
					t7[v73].title = v71.title
				end

				g80 = true
			end
		until not g80

		if g81 then
			g81 = false

			continue
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, {
			message = "Page entry missing robloxComponentType",
			debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v52
		}, surfaceKey)
	end

	if not next(t7) and not paginateResponse and (not FFlagSduiAllowNoConfigsBuilt or not v56) then
		SduiLogger.reportError(SduiErrors.SduiErrorType.NoComponentConfigsBuilt, {
			debugName = if not FFlagSduiImprovedErrorDimensions then v52 else nil,
			name = if not FFlagSduiImprovedErrorDimensions then nil else v52,
			message = `No configs built when handling proto response for { v52 }`
		}, surfaceKey)
	end

	loadTimer.logSduiTreeBuildEnd()

	return t7
end

return handleSduiApiResponse

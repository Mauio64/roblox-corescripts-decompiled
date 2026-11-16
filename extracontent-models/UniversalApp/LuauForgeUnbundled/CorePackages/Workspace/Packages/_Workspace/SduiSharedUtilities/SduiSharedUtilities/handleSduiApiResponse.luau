local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Signals")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields
local sduiLogger = SduiCoreSystem.SduiLogger
local sduiUsageRecorder = SduiCoreSystem.SduiUsageRecorder
local recordTemplateUsage = SduiCoreSystem.recordTemplateUsage
local getSduiTemplateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiTemplateStore")
local SduiProtobufResponseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiProtobufResponseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local sduiRequestStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").SduiRequestStatus
local SduiInputDataMerge = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiInputDataMerge")
local processClientHints = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/processClientHints")
local getSduiClientBindingBuilder = SduiCoreSystem.getSduiClientBindingBuilder
local createBuilderConfig = SduiCoreSystem.createBuilderConfig
local getSduiDataBinder = SduiCoreSystem.getSduiDataBinder

local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiErrorPaths
local fFlagSduiAllowNoConfigsBuilt = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAllowNoConfigsBuilt
local fFlagSduiAlwaysCacheWithIdentifier = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAlwaysCacheWithIdentifier
local fFlagEnableSduiV2HomepagePrompts = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagEnableSduiV2HomepagePrompts

local fFlagEnableHomepagePromptsForModalsAndBanners = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagPromptsHandlerEnabled
local fFlagLuaAppSduiStreamingChunkedResponses = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiStreamingChunkedResponses
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppEnableSduiHomePage

local fFlagSduiStreamingRefreshReplacesInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiStreamingRefreshReplacesInputData
local FFlagSduiUseHttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/Flags/FFlagSduiUseHttpClient")
local fFlagSduiFreshInputDataSignalOnRebuild = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiFreshInputDataSignalOnRebuild
local fFlagSduiSharedLocalizedLiterals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiSharedLocalizedLiterals
local fFlagLuaAppSduiHomePageSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiHomePageSupport

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Cryo")
local function mergeTables(p2, item)
	for k, item2 in item do
		if typeof(item2) == "table" then
			if p2[k] == nil then
				p2[k] = {}
			end

			if #item2 > 0 then
				for k2, v5 in item2 do
					table.insert(p2[k], v5)
				end
			else
				mergeTables(p2[k], item2)
			end
		else
			p2[k] = item2
		end
	end
end

local function getLocalizedLiteral(p2)
	return getSduiTemplateStore().getLocalizedLiterals()[p2]
end

local function handleSduiApiResponse(data)
	local response = data.response
	local decodeResponse = data.decodeResponse
	local parsePageEntriesFromResponse = data.parsePageEntriesFromResponse
	local parseHydrationDataFromResponse = data.parseHydrationDataFromResponse
	local parseTemplateEntriesFromResponse = data.parseTemplateEntriesFromResponse
	local parseLocalizedLiteralsFromResponse = data.parseLocalizedLiteralsFromResponse
	local getInputDataSignalsForRequest = data.getInputDataSignalsForRequest
	local setInputDataSignalsForRequest = data.setInputDataSignalsForRequest
	local loadTimer = data.loadTimer
	local surfaceKey = data.surfaceKey
	local configCacheKey = data.configCacheKey or data.surfaceKey
	local enableTemplateCache = data.enableTemplateCache
	local paginateResponse = data.paginateResponse
	local buildNextPageUrl = data.buildNextPageUrl
	local buildNextPagePostBody = data.buildNextPagePostBody
	local allowNoConfigsBuilt = if fFlagSduiAllowNoConfigsBuilt then data.allowNoConfigsBuilt else nil
	local mergeStrategy = data.mergeStrategy

	local enableInputDataMerge = (fFlagLuaAppEnableSduiHomePage or fFlagSduiStreamingRefreshReplacesInputData)
		and data.enableInputDataMerge
	assert(configCacheKey, "configCacheKey must exist")

	local logNetRequestStats = loadTimer.logNetRequestStats
	local v5 = if FFlagSduiUseHttpClient then response.stats or {} else response.Stats
	logNetRequestStats(v5)

	loadTimer.logResponseDecodeBegin()
	local success, result = pcall(function()
		local v7 = if FFlagSduiUseHttpClient then response.responseBody else response.Body
		return (decodeResponse(v7))
	end)

	loadTimer.logResponseDecodeEnd()

	if not success then
		loadTimer.updateRequestStatus(sduiRequestStatus.FailedToLoad)

		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToDecodeResponse,
			{ name = configCacheKey, message = result },
			surfaceKey
		)

		error("Failed to decode")
	end

	loadTimer.logResponseDataUpdateBegin()

	if parseHydrationDataFromResponse then
		local success2, result2 = pcall(function()
			local v6 = parseHydrationDataFromResponse(result)

			if v6 ~= nil then
				getSduiDataBinder().updateDataStores(v6)
			end
		end)

		if not success2 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToUpdateDataStores,
				{ name = configCacheKey, message = result2 },
				surfaceKey
			)
		end
	end

	local v6 = {}
	local v7 = nil

	if parseTemplateEntriesFromResponse then
		local success2, result2 = pcall(function()
			local v8, v9, v10 = parseTemplateEntriesFromResponse(
				result,
				fFlagSduiErrorPaths and true or enableTemplateCache
			)
			v6 = v9

			if fFlagSduiErrorPaths and not enableTemplateCache then
				v7 = v10
			end

			getSduiTemplateStore().addTemplates(v8)

			if enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v10)
			end

			if v8 then
				for k, v11 in v8 do
					pcall(recordTemplateUsage, surfaceKey, v11)
				end

				sduiUsageRecorder.scheduleFlush()
			end
		end)

		if not success2 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.FailedToAddTemplates,
				{ name = configCacheKey, message = result2 },
				surfaceKey
			)
		end
	end

	local function getTemplateIdForRCT(p2)
		if enableTemplateCache then
			return getSduiTemplateStore().getCachedRobloxComponentToTemplateId(surfaceKey)[p2]
		end

		return v7 and v7[p2]
	end

	local function createErrorContextForRCT(p2, p3)
		local v8

		if p3 then
			v8 = if p2 then `{surfaceKey}.{p2}` else surfaceKey
			local identifier = p3.identifier

			if identifier and identifier ~= "" then
				v8 = `{v8}[{identifier}]`
			end
		end

		local v9

		if p2 then
			if enableTemplateCache then
				v9 = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(surfaceKey)[p2]
			else
				v9 = v7 and v7[p2]
			end
		end

		return { fullName = v8, rctPath = p2, templateId = v9 }
	end

	loadTimer.logResponseDataUpdateEnd()

	loadTimer.logSduiTreeBuildBegin()

	local v8 = not parsePageEntriesFromResponse and {} or parsePageEntriesFromResponse(result)
	local v9

	if parseLocalizedLiteralsFromResponse then
		v9 = parseLocalizedLiteralsFromResponse(result)
	else
		v9 = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)
	end

	if fFlagSduiSharedLocalizedLiterals and v9 then
		getSduiTemplateStore().addLocalizedLiterals(v9)
	end

	local function resolveTemplateForRobloxComponent(p2, p3)
		local templateForRobloxComponent = v6[p2]

		if templateForRobloxComponent == nil then
			templateForRobloxComponent = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, p2)
		end

		if templateForRobloxComponent ~= nil then
			return templateForRobloxComponent
		end

		local v10 = {
			name = p2,
			message = `Backend omitted template for {p2} but it could not be resolved from the surface cache + template store`
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v10, createErrorContextForRCT(p2, p3))
		end

		sduiLogger.reportError(sduiErrors.SduiErrorType.MissingCachedTemplate, v10, surfaceKey)

		return templateForRobloxComponent
	end

	local v10 = #v8 > 1
	local result2 = {}
	local v11 = nil

	for k, v12 in v8 do
		local identifier = v12.identifier
		local v13

		if
			(v10 or fFlagSduiAlwaysCacheWithIdentifier or data.cacheSingleEntryWithIdentifier)
			and identifier
			and identifier ~= ""
		then
			v13 = `{configCacheKey}_{identifier}`
		else
			v13 = configCacheKey
		end

		local componentInputData = v12.componentInputData
		local v14 = getInputDataSignalsForRequest(v13)
		local v15 = v14.get(false)
		local v16 = fFlagLuaAppSduiStreamingChunkedResponses and data.enableStreamingMerge
		local merged, v17, v18

		if paginateResponse then
			if v15 then
				if componentInputData then
					merged = SduiInputDataMerge.merge(v14.get(false), componentInputData, mergeStrategy)
					v14.set(merged)
				end
			else
				if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					v17, v18 = Signals.createSignal(nil)
					v14 = { get = v17, set = v18 }
				end

				v14.set(componentInputData)
			end
		else
			local v19

			if fFlagLuaAppEnableSduiHomePage or fFlagSduiStreamingRefreshReplacesInputData then
				v19 = enableInputDataMerge
			else
				v19 = v16
			end

			if v19 then
				if v15 then
					if componentInputData then
						merged = SduiInputDataMerge.merge(v14.get(false), componentInputData, mergeStrategy)
						v14.set(merged)
					end
				else
					if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
						v17, v18 = Signals.createSignal(nil)
						v14 = { get = v17, set = v18 }
					end

					v14.set(componentInputData)
				end
			else
				if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					v17, v18 = Signals.createSignal(nil)
					v14 = { get = v17, set = v18 }
				end

				v14.set(componentInputData)
			end
		end

		if not paginateResponse then
			if fFlagLuaAppEnableSduiHomePage or fFlagSduiStreamingRefreshReplacesInputData then
				v16 = enableInputDataMerge
			end

			v15 = v16 and v15
		end

		if not v15 then
			local robloxComponentType = v12.robloxComponentType

			if robloxComponentType then
				local v19

				if enableTemplateCache then
					local v20 = if fFlagSduiErrorPaths then v12 else nil
					v19 = resolveTemplateForRobloxComponent(robloxComponentType, v20)
				else
					v19 = v6[robloxComponentType]
				end

				if v19 then
					local v20 = v19
					local v21 = robloxComponentType
					local v22 = identifier
					local success2, result3 = pcall(function()
						local v28 = createBuilderConfig({
							appPage = surfaceKey,
							debugName = configCacheKey,
							getTemplateForRobloxComponent = function(p2)
								if enableTemplateCache then
									return resolveTemplateForRobloxComponent(p2)
								end

								return v6[p2]
							end,
							getTemplateIdForRCT = if fFlagSduiErrorPaths then getTemplateIdForRCT else nil,
							localizedLiterals = if not fFlagSduiSharedLocalizedLiterals then v9 else nil,
							getLocalizedLiteral = if fFlagSduiSharedLocalizedLiterals then getLocalizedLiteral else nil,
							configKey = configCacheKey
						})

						local buildConfigForComponent = getSduiClientBindingBuilder().buildConfigForComponent
						local v30

						if fFlagLuaAppSduiHomePageSupport and v12.componentInputDataGetter then
							v30 = v12.componentInputDataGetter
						else
							v30 = v14.get
						end

						local v35 = if fFlagSduiErrorPaths then v21 else nil
						local v36 = if fFlagSduiErrorPaths then v22 else nil
						return (buildConfigForComponent(v20, v30, v28, nil, nil, nil, nil, v35, v36))
					end)

					if success2 then
						if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
							v11 = v11 == nil and {} or v11

							v11[v13] = v14
						end

						if result2[v13] then
							local v23 = {
								name = robloxComponentType,
								message = `Existing config found for cacheKey {v13}. Need to specify identifer in page entry for multiple configs`
							}

							if fFlagSduiErrorPaths then
								addSduiErrorContextFields(v23, result3 and result3.errorContext)
							end

							sduiLogger.reportError(
								sduiErrors.SduiErrorType.DuplicateOrMissingIdentifier,
								v23,
								surfaceKey
							)
						end

						local v23 = {
							config = result3,
							dataUpdatedTimestamp = os.clock(),
							identifier = 0,
							robloxComponentType = 0,
							category = 0,
							surfacing = 0
						}

						if not (fFlagEnableSduiV2HomepagePrompts or fFlagPromptsHandlerEnabled) then
							identifier = nil
						end

						v23.identifier = identifier

						if not (fFlagEnableSduiV2HomepagePrompts or fFlagPromptsHandlerEnabled) then
							robloxComponentType = nil
						end

						v23.robloxComponentType = robloxComponentType

						local v24 = if fFlagEnableHomepagePromptsForModalsAndBanners or fFlagPromptsHandlerEnabled then v12.category else nil
						v23.category = v24

						v23.surfacing = v12.surfacing
						result2[v13] = v23
					else
						local v23 = {
							name = robloxComponentType,
							message = `{result3}`
						}

						if fFlagSduiErrorPaths then
							addSduiErrorContextFields(
								v23,
								createErrorContextForRCT(robloxComponentType, v12)
							)
						end

						sduiLogger.reportError(
							sduiErrors.SduiErrorType.FailedToBuildClientBindingConfig,
							v23,
							surfaceKey
						)
					end

					if v12.title and result2[v13] then
						result2[v13].title = v12.title
					end
				else
					if enableTemplateCache then
						continue
					end

					local v20 = {
						name = robloxComponentType,
						message = `Missing template for robloxComponentType {robloxComponentType}`
					}

					if fFlagSduiErrorPaths then
						addSduiErrorContextFields(v20, createErrorContextForRCT(robloxComponentType, v12))
					end

					sduiLogger.reportError(
						sduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate,
						v20,
						surfaceKey
					)
					continue
				end
			else
				local v19 = {
					name = configCacheKey,
					message = "Page entry missing robloxComponentType"
				}

				if fFlagSduiErrorPaths then
					local v21

					if v12 then
						local identifier2 = v12.identifier

						v21 = if identifier2 and identifier2 ~= "" then `{surfaceKey}[{identifier2}]` else surfaceKey
					end

					addSduiErrorContextFields(v19, {
						fullName = v21,
						rctPath = nil,
						templateId = nil
					})
				end

				sduiLogger.reportError(sduiErrors.SduiErrorType.FailedToAddTemplates, v19, surfaceKey)
				continue
			end
		end

		result2[v13] = result2[v13] or {}

		if buildNextPageUrl then
			result2[v13].nextPageUrl = buildNextPageUrl(result) or ""
		else
			result2[v13].nextPageUrl = ""
		end

		if not buildNextPagePostBody then
			continue
		end

		local nextPagePostBody = buildNextPagePostBody(result)
		result2[v13].nextPagePostBody = nextPagePostBody or Cryo.None
	end

	if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest and v11 then
		for k, v12 in v11 do
			setInputDataSignalsForRequest(configCacheKey, k, v12)
		end
	end

	if not (next(result2) or paginateResponse or fFlagSduiAllowNoConfigsBuilt and allowNoConfigsBuilt) then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.NoComponentConfigsBuilt,
			{
				name = configCacheKey,
				message = `No configs built when handling proto response for {configCacheKey}`
			},
			surfaceKey
		)
	end

	loadTimer.logSduiTreeBuildEnd()

	local function getTemplateForRobloxComponent(p2)
		if enableTemplateCache then
			return resolveTemplateForRobloxComponent(p2)
		end

		return v6[p2]
	end

	local function getKnownTemplates()
		local knownTemplates = {}

		for k, v12 in v6 do
			table.insert(knownTemplates, v12)
		end

		if not enableTemplateCache then
			return knownTemplates
		end

		local v12 = getSduiTemplateStore()

		for k, v13 in v12.getCachedRobloxComponentToTemplateId(surfaceKey) do
			local template = v12.getTemplate(v13)

			if template ~= nil then
				table.insert(knownTemplates, template)
			end
		end

		return knownTemplates
	end

	loadTimer.logSduiClientHintsBegin()
	local success2, result3 = pcall(function()
		processClientHints({
			pageEntries = v8,
			getTemplateForRobloxComponent = getTemplateForRobloxComponent,
			getKnownTemplates = getKnownTemplates
		})
	end)
	loadTimer.logSduiClientHintsEnd()

	if not success2 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToProcessClientHints,
			{ name = configCacheKey, message = result3 },
			surfaceKey
		)
	end

	return result2, result
end

return handleSduiApiResponse

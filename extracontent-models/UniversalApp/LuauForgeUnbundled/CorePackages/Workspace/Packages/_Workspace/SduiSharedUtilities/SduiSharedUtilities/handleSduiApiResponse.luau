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
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppEnableSduiHomePage

local fFlagSduiStreamingRefreshReplacesInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiStreamingRefreshReplacesInputData
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

	loadTimer.logNetRequestStats(response.stats or {})

	loadTimer.logResponseDecodeBegin()
	local success, result = pcall(function()
		return (decodeResponse(response.responseBody))
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
			local v5 = parseHydrationDataFromResponse(result)

			if v5 ~= nil then
				getSduiDataBinder().updateDataStores(v5)
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

	local v5 = {}
	local v6 = nil

	if parseTemplateEntriesFromResponse then
		local success2, result2 = pcall(function()
			local v7, v8, v9 = parseTemplateEntriesFromResponse(
				result,
				fFlagSduiErrorPaths and true or enableTemplateCache
			)
			v5 = v8

			if fFlagSduiErrorPaths and not enableTemplateCache then
				v6 = v9
			end

			getSduiTemplateStore().addTemplates(v7)

			if enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v9)
			end

			if v7 then
				for k, v10 in v7 do
					pcall(recordTemplateUsage, surfaceKey, v10)
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

		return v6 and v6[p2]
	end

	local function createErrorContextForRCT(p2, p3)
		local v7

		if p3 then
			v7 = if p2 then `{surfaceKey}.{p2}` else surfaceKey
			local identifier = p3.identifier

			if identifier and identifier ~= "" then
				v7 = `{v7}[{identifier}]`
			end
		end

		local v8

		if p2 then
			if enableTemplateCache then
				v8 = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(surfaceKey)[p2]
			else
				v8 = v6 and v6[p2]
			end
		end

		return { fullName = v7, rctPath = p2, templateId = v8 }
	end

	loadTimer.logResponseDataUpdateEnd()

	loadTimer.logSduiTreeBuildBegin()

	local v7 = not parsePageEntriesFromResponse and {} or parsePageEntriesFromResponse(result)
	local v8

	if parseLocalizedLiteralsFromResponse then
		v8 = parseLocalizedLiteralsFromResponse(result)
	else
		v8 = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)
	end

	if fFlagSduiSharedLocalizedLiterals and v8 then
		getSduiTemplateStore().addLocalizedLiterals(v8)
	end

	local function resolveTemplateForRobloxComponent(p2, p3)
		local templateForRobloxComponent = v5[p2]

		if templateForRobloxComponent == nil then
			templateForRobloxComponent = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, p2)
		end

		if templateForRobloxComponent ~= nil then
			return templateForRobloxComponent
		end

		local v9 = {
			name = p2,
			message = `Backend omitted template for {p2} but it could not be resolved from the surface cache + template store`
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v9, createErrorContextForRCT(p2, p3))
		end

		sduiLogger.reportError(sduiErrors.SduiErrorType.MissingCachedTemplate, v9, surfaceKey)

		return templateForRobloxComponent
	end

	local v9 = #v7 > 1
	local result2 = {}
	local v10 = nil

	for k, v11 in v7 do
		local identifier = v11.identifier
		local v12

		if
			(v9 or fFlagSduiAlwaysCacheWithIdentifier or data.cacheSingleEntryWithIdentifier)
			and identifier
			and identifier ~= ""
		then
			v12 = `{configCacheKey}_{identifier}`
		else
			v12 = configCacheKey
		end

		local componentInputData = v11.componentInputData
		local v13 = getInputDataSignalsForRequest(v12)
		local v14 = v13.get(false)
		local v15 = data.enableStreamingMerge
		local merged, v16, v17

		if paginateResponse then
			if v14 then
				if componentInputData then
					merged = SduiInputDataMerge.merge(v13.get(false), componentInputData, mergeStrategy)
					v13.set(merged)
				end
			else
				if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					v16, v17 = Signals.createSignal(nil)
					v13 = { get = v16, set = v17 }
				end

				v13.set(componentInputData)
			end
		else
			local v18

			if fFlagLuaAppEnableSduiHomePage or fFlagSduiStreamingRefreshReplacesInputData then
				v18 = enableInputDataMerge
			else
				v18 = v15
			end

			if v18 then
				if v14 then
					if componentInputData then
						merged = SduiInputDataMerge.merge(v13.get(false), componentInputData, mergeStrategy)
						v13.set(merged)
					end
				else
					if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
						v16, v17 = Signals.createSignal(nil)
						v13 = { get = v16, set = v17 }
					end

					v13.set(componentInputData)
				end
			else
				if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					v16, v17 = Signals.createSignal(nil)
					v13 = { get = v16, set = v17 }
				end

				v13.set(componentInputData)
			end
		end

		if not paginateResponse then
			if fFlagLuaAppEnableSduiHomePage or fFlagSduiStreamingRefreshReplacesInputData then
				v15 = enableInputDataMerge
			end

			v14 = v15 and v14
		end

		if not v14 then
			local robloxComponentType = v11.robloxComponentType

			if robloxComponentType then
				local v18

				if enableTemplateCache then
					local v19 = if fFlagSduiErrorPaths then v11 else nil
					v18 = resolveTemplateForRobloxComponent(robloxComponentType, v19)
				else
					v18 = v5[robloxComponentType]
				end

				if v18 then
					local v19 = v18
					local v20 = robloxComponentType
					local v21 = identifier
					local success2, result3 = pcall(function()
						local v27 = createBuilderConfig({
							appPage = surfaceKey,
							debugName = configCacheKey,
							getTemplateForRobloxComponent = function(p2)
								if enableTemplateCache then
									return resolveTemplateForRobloxComponent(p2)
								end

								return v5[p2]
							end,
							getTemplateIdForRCT = if fFlagSduiErrorPaths then getTemplateIdForRCT else nil,
							localizedLiterals = if not fFlagSduiSharedLocalizedLiterals then v8 else nil,
							getLocalizedLiteral = if fFlagSduiSharedLocalizedLiterals then getLocalizedLiteral else nil,
							configKey = configCacheKey
						})

						local buildConfigForComponent = getSduiClientBindingBuilder().buildConfigForComponent
						local v29

						if fFlagLuaAppSduiHomePageSupport and v11.componentInputDataGetter then
							v29 = v11.componentInputDataGetter
						else
							v29 = v13.get
						end

						local v34 = if fFlagSduiErrorPaths then v20 else nil
						local v35 = if fFlagSduiErrorPaths then v21 else nil
						return (buildConfigForComponent(v19, v29, v27, nil, nil, nil, nil, v34, v35))
					end)

					if success2 then
						if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
							v10 = v10 == nil and {} or v10

							v10[v12] = v13
						end

						if result2[v12] then
							local v22 = {
								name = robloxComponentType,
								message = `Existing config found for cacheKey {v12}. Need to specify identifer in page entry for multiple configs`
							}

							if fFlagSduiErrorPaths then
								addSduiErrorContextFields(v22, result3 and result3.errorContext)
							end

							sduiLogger.reportError(
								sduiErrors.SduiErrorType.DuplicateOrMissingIdentifier,
								v22,
								surfaceKey
							)
						end

						local v22 = {
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

						v22.identifier = identifier

						if not (fFlagEnableSduiV2HomepagePrompts or fFlagPromptsHandlerEnabled) then
							robloxComponentType = nil
						end

						v22.robloxComponentType = robloxComponentType

						local v23 = if fFlagEnableHomepagePromptsForModalsAndBanners or fFlagPromptsHandlerEnabled then v11.category else nil
						v22.category = v23

						v22.surfacing = v11.surfacing
						result2[v12] = v22
					else
						local v22 = {
							name = robloxComponentType,
							message = `{result3}`
						}

						if fFlagSduiErrorPaths then
							addSduiErrorContextFields(
								v22,
								createErrorContextForRCT(robloxComponentType, v11)
							)
						end

						sduiLogger.reportError(
							sduiErrors.SduiErrorType.FailedToBuildClientBindingConfig,
							v22,
							surfaceKey
						)
					end

					if v11.title and result2[v12] then
						result2[v12].title = v11.title
					end
				else
					if enableTemplateCache then
						continue
					end

					local v19 = {
						name = robloxComponentType,
						message = `Missing template for robloxComponentType {robloxComponentType}`
					}

					if fFlagSduiErrorPaths then
						addSduiErrorContextFields(v19, createErrorContextForRCT(robloxComponentType, v11))
					end

					sduiLogger.reportError(
						sduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate,
						v19,
						surfaceKey
					)
					continue
				end
			else
				local v18 = {
					name = configCacheKey,
					message = "Page entry missing robloxComponentType"
				}

				if fFlagSduiErrorPaths then
					local v20

					if v11 then
						local identifier2 = v11.identifier

						v20 = if identifier2 and identifier2 ~= "" then `{surfaceKey}[{identifier2}]` else surfaceKey
					end

					addSduiErrorContextFields(v18, {
						fullName = v20,
						rctPath = nil,
						templateId = nil
					})
				end

				sduiLogger.reportError(sduiErrors.SduiErrorType.FailedToAddTemplates, v18, surfaceKey)
				continue
			end
		end

		result2[v12] = result2[v12] or {}

		if buildNextPageUrl then
			result2[v12].nextPageUrl = buildNextPageUrl(result) or ""
		else
			result2[v12].nextPageUrl = ""
		end

		if not buildNextPagePostBody then
			continue
		end

		local nextPagePostBody = buildNextPagePostBody(result)
		result2[v12].nextPagePostBody = nextPagePostBody or Cryo.None
	end

	if fFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest and v10 then
		for k, v11 in v10 do
			setInputDataSignalsForRequest(configCacheKey, k, v11)
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

		return v5[p2]
	end

	local function getKnownTemplates()
		local knownTemplates = {}

		for k, v11 in v5 do
			table.insert(knownTemplates, v11)
		end

		if not enableTemplateCache then
			return knownTemplates
		end

		local v11 = getSduiTemplateStore()

		for k, v12 in v11.getCachedRobloxComponentToTemplateId(surfaceKey) do
			local template = v11.getTemplate(v12)

			if template ~= nil then
				table.insert(knownTemplates, template)
			end
		end

		return knownTemplates
	end

	loadTimer.logSduiClientHintsBegin()
	local success2, result3 = pcall(function()
		processClientHints({
			pageEntries = v7,
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

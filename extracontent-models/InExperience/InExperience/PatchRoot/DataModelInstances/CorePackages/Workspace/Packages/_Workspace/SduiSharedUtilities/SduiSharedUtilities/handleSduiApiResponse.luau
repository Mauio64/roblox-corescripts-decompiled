local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local Signals = require(parent.Signals)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiUsageRecorder = SduiCoreSystem.SduiUsageRecorder
local recordTemplateUsage = SduiCoreSystem.recordTemplateUsage
local getSduiTemplateStore = require(SduiSharedUtilities.getSduiTemplateStore)
local SduiProtobufResponseHelpers = require(SduiSharedUtilities.SduiProtobufResponseHelpers)
require(SduiSharedUtilities.SduiLoadTimer)
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local SduiRequestStatus = SduiIntegrationTypes.SduiRequestStatus
local SduiInputDataMerge = require(SduiSharedUtilities.SduiInputDataMerge)
local processClientHints = require(SduiSharedUtilities.processClientHints)
local getSduiClientBindingBuilder = SduiCoreSystem.getSduiClientBindingBuilder
local createBuilderConfig = SduiCoreSystem.createBuilderConfig
local getSduiDataBinder = SduiCoreSystem.getSduiDataBinder

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags2.FFlagSduiAllowNoConfigsBuilt
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiAlwaysCacheWithIdentifier = SharedFlags3.FFlagSduiAlwaysCacheWithIdentifier
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableSduiV2HomepagePrompts = SharedFlags4.FFlagEnableSduiV2HomepagePrompts

local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags5.FFlagEnableHomepagePromptsForModalsAndBanners
local SharedFlags6 = require(parent.SharedFlags)
local FFlagPromptsHandlerEnabled = SharedFlags6.FFlagPromptsHandlerEnabled
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppSduiStreamingChunkedResponses = SharedFlags7.FFlagLuaAppSduiStreamingChunkedResponses
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags8.FFlagLuaAppEnableSduiHomePage

local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiStreamingRefreshReplacesInputData = SharedFlags9.FFlagSduiStreamingRefreshReplacesInputData
local FFlagSduiUseHttpClient = require(SduiSharedUtilities.Flags.FFlagSduiUseHttpClient)
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiFreshInputDataSignalOnRebuild = SharedFlags10.FFlagSduiFreshInputDataSignalOnRebuild
local SharedFlags11 = require(parent.SharedFlags)
local FFlagSduiSharedLocalizedLiterals = SharedFlags11.FFlagSduiSharedLocalizedLiterals
local SharedFlags12 = require(parent.SharedFlags)
local FFlagLuaAppSduiHomePageSupport = SharedFlags12.FFlagLuaAppSduiHomePageSupport

local Cryo = require(parent.Cryo)
local function mergeTables(p, item)
	for k, item2 in item do
		if typeof(item2) == "table" then
			if p[k] == nil then
				p[k] = {}
			end

			if #item2 > 0 then
				for _, v in item2 do
					table.insert(p[k], v)
				end
			else
				mergeTables(p[k], item2)
			end
		else
			p[k] = item2
		end
	end
end

local function getLocalizedLiteral(p: string)
	return getSduiTemplateStore().getLocalizedLiterals()[p]
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
	local allowNoConfigsBuilt

	if FFlagSduiAllowNoConfigsBuilt then
		allowNoConfigsBuilt = data.allowNoConfigsBuilt
	end

	local mergeStrategy = data.mergeStrategy

	local enableInputDataMerge = (FFlagLuaAppEnableSduiHomePage or FFlagSduiStreamingRefreshReplacesInputData)
		and data.enableInputDataMerge
	assert(configCacheKey, "configCacheKey must exist")

	local logNetRequestStats = loadTimer.logNetRequestStats
	local v

	if FFlagSduiUseHttpClient then
		v = response.stats or {}
	else
		v = response.Stats
	end

	logNetRequestStats(v)

	loadTimer.logResponseDecodeBegin()
	local success, result = pcall(function()
		local v2

		if FFlagSduiUseHttpClient then
			v2 = response.responseBody
		else
			v2 = response.Body
		end

		return (decodeResponse(v2))
	end)

	loadTimer.logResponseDecodeEnd()

	if not success then
		loadTimer.updateRequestStatus(SduiRequestStatus.FailedToLoad)

		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToDecodeResponse,
			{ name = configCacheKey, message = result },
			surfaceKey
		)

		error("Failed to decode")
	end

	loadTimer.logResponseDataUpdateBegin()

	if parseHydrationDataFromResponse then
		local success2, result2 = pcall(function()
			local v2 = parseHydrationDataFromResponse(result)

			if v2 ~= nil then
				getSduiDataBinder().updateDataStores(v2)
			end
		end)

		if not success2 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToUpdateDataStores,
				{ name = configCacheKey, message = result2 },
				surfaceKey
			)
		end
	end

	local v2 = {}
	local v3 = nil

	if parseTemplateEntriesFromResponse then
		local success2, result2 = pcall(function()
			local v4, v5, v6 = parseTemplateEntriesFromResponse(
				result,
				FFlagSduiErrorPaths and true or enableTemplateCache
			)
			v2 = v5

			if FFlagSduiErrorPaths and not enableTemplateCache then
				v3 = v6
			end

			getSduiTemplateStore().addTemplates(v4)

			if enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v6)
			end

			if v4 then
				for _, v7 in v4 do
					pcall(recordTemplateUsage, surfaceKey, v7)
				end

				SduiUsageRecorder.scheduleFlush()
			end
		end)

		if not success2 then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.FailedToAddTemplates,
				{ name = configCacheKey, message = result2 },
				surfaceKey
			)
		end
	end

	local function getTemplateIdForRCT(p: string) -- 1 equivalent call inferred from this helper
		if enableTemplateCache then
			return getSduiTemplateStore().getCachedRobloxComponentToTemplateId(surfaceKey)[p]
		end

		return v3 and v3[p]
	end

	local function createErrorContextForRCT(rctPath: string?, p)
		local fullName

		if p then
			if rctPath then
				fullName = `{surfaceKey}.{rctPath}`
			else
				fullName = surfaceKey
			end

			local identifier = p.identifier

			if identifier and identifier ~= "" then
				fullName = `{fullName}[{identifier}]`
			end
		end

		local templateId

		if rctPath then
			templateId = getTemplateIdForRCT(rctPath) -- inferred equivalent call
		end

		return { fullName = fullName, rctPath = rctPath, templateId = templateId }
	end

	loadTimer.logResponseDataUpdateEnd()

	loadTimer.logSduiTreeBuildBegin()

	local pageEntries = not parsePageEntriesFromResponse and {} or parsePageEntriesFromResponse(result)
	local v4

	if parseLocalizedLiteralsFromResponse then
		v4 = parseLocalizedLiteralsFromResponse(result)
	else
		v4 = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)
	end

	if FFlagSduiSharedLocalizedLiterals and v4 then
		getSduiTemplateStore().addLocalizedLiterals(v4)
	end

	local function resolveTemplateForRobloxComponent(name: string, p)
		local templateForRobloxComponent = v2[name]

		if templateForRobloxComponent == nil then
			templateForRobloxComponent = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, name)
		end

		if templateForRobloxComponent ~= nil then
			return templateForRobloxComponent
		end

		local v5 = {
			name = name,
			message = `Backend omitted template for {name} but it could not be resolved from the surface cache + template store`
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v5, createErrorContextForRCT(name, p))
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.MissingCachedTemplate, v5, surfaceKey)

		return templateForRobloxComponent
	end

	local v5 = #pageEntries > 1
	local result2 = {}
	local v6 = nil

	for _, v7 in pageEntries do
		local identifier = v7.identifier
		local v8

		if
			(v5 or FFlagSduiAlwaysCacheWithIdentifier or data.cacheSingleEntryWithIdentifier)
			and identifier
			and identifier ~= ""
		then
			v8 = `{configCacheKey}_{identifier}`
		else
			v8 = configCacheKey
		end

		local componentInputData = v7.componentInputData
		local v9 = getInputDataSignalsForRequest(v8)
		local v10 = v9.get(false)
		local v11 = FFlagLuaAppSduiStreamingChunkedResponses and data.enableStreamingMerge
		local merged, get, set

		if paginateResponse then
			if v10 then
				if componentInputData then
					merged = SduiInputDataMerge.merge(v9.get(false), componentInputData, mergeStrategy)
					v9.set(merged)
				end
			else
				if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					get, set = Signals.createSignal(nil)
					v9 = { get = get, set = set }
				end

				v9.set(componentInputData)
			end
		else
			local v12

			if FFlagLuaAppEnableSduiHomePage or FFlagSduiStreamingRefreshReplacesInputData then
				v12 = enableInputDataMerge
			else
				v12 = v11
			end

			if v12 then
				if v10 then
					if componentInputData then
						merged = SduiInputDataMerge.merge(v9.get(false), componentInputData, mergeStrategy)
						v9.set(merged)
					end
				else
					if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
						get, set = Signals.createSignal(nil)
						v9 = { get = get, set = set }
					end

					v9.set(componentInputData)
				end
			else
				if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					get, set = Signals.createSignal(nil)
					v9 = { get = get, set = set }
				end

				v9.set(componentInputData)
			end
		end

		if not paginateResponse then
			if FFlagLuaAppEnableSduiHomePage or FFlagSduiStreamingRefreshReplacesInputData then
				v11 = enableInputDataMerge
			end

			v10 = v11 and v10
		end

		if not v10 then
			local robloxComponentType = v7.robloxComponentType

			if robloxComponentType then
				local v12

				if enableTemplateCache then
					local v13

					if FFlagSduiErrorPaths then
						v13 = v7
					end

					v12 = resolveTemplateForRobloxComponent(robloxComponentType, v13)
				else
					v12 = v2[robloxComponentType]
				end

				if v12 then
					local v13 = v12
					local v14 = robloxComponentType
					local v15 = identifier
					local success2, result3 = pcall(function()
						local v16 = {
							appPage = surfaceKey,
							debugName = configCacheKey,
							getTemplateForRobloxComponent = function(p)
								if enableTemplateCache then
									return resolveTemplateForRobloxComponent(p)
								end

								return v2[p]
							end,
							getTemplateIdForRCT = 0,
							localizedLiterals = 0,
							getLocalizedLiteral = 0,
							configKey = 0
						}
						local getTemplateIdForRCT2

						if FFlagSduiErrorPaths then
							getTemplateIdForRCT2 = getTemplateIdForRCT
						end

						v16.getTemplateIdForRCT = getTemplateIdForRCT2
						local localizedLiterals

						if not FFlagSduiSharedLocalizedLiterals then
							localizedLiterals = v4
						end

						v16.localizedLiterals = localizedLiterals
						local getLocalizedLiteral2

						if FFlagSduiSharedLocalizedLiterals then
							getLocalizedLiteral2 = getLocalizedLiteral
						end

						v16.getLocalizedLiteral = getLocalizedLiteral2

						v16.configKey = configCacheKey
						local builderConfig = createBuilderConfig(v16)

						local buildConfigForComponent = getSduiClientBindingBuilder().buildConfigForComponent
						local v17

						if FFlagLuaAppSduiHomePageSupport and v7.componentInputDataGetter then
							v17 = v7.componentInputDataGetter
						else
							v17 = v9.get
						end

						local v18

						if FFlagSduiErrorPaths then
							v18 = v14
						end

						local v19

						if FFlagSduiErrorPaths then
							v19 = v15
						end

						return (buildConfigForComponent(v13, v17, builderConfig, nil, nil, nil, nil, v18, v19))
					end)

					if success2 then
						if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
							v6 = v6 == nil and {} or v6

							v6[v8] = v9
						end

						if result2[v8] then
							local v16 = {
								name = robloxComponentType,
								message = `Existing config found for cacheKey {v8}. Need to specify identifer in page entry for multiple configs`
							}

							if FFlagSduiErrorPaths then
								addSduiErrorContextFields(v16, result3 and result3.errorContext)
							end

							SduiLogger.reportError(
								SduiErrors.SduiErrorType.DuplicateOrMissingIdentifier,
								v16,
								surfaceKey
							)
						end

						local v16 = {
							config = result3,
							dataUpdatedTimestamp = os.clock(),
							identifier = 0,
							robloxComponentType = 0,
							category = 0,
							surfacing = 0
						}

						if not (FFlagEnableSduiV2HomepagePrompts or FFlagPromptsHandlerEnabled) then
							identifier = nil
						end

						v16.identifier = identifier

						if not (FFlagEnableSduiV2HomepagePrompts or FFlagPromptsHandlerEnabled) then
							robloxComponentType = nil
						end

						v16.robloxComponentType = robloxComponentType
						local category

						if FFlagEnableHomepagePromptsForModalsAndBanners or FFlagPromptsHandlerEnabled then
							category = v7.category
						end

						v16.category = category

						v16.surfacing = v7.surfacing
						result2[v8] = v16
					else
						local v16 = { name = robloxComponentType, message = `{result3}` }

						if FFlagSduiErrorPaths then
							addSduiErrorContextFields(v16, createErrorContextForRCT(robloxComponentType, v7))
						end

						SduiLogger.reportError(
							SduiErrors.SduiErrorType.FailedToBuildClientBindingConfig,
							v16,
							surfaceKey
						)
					end

					if v7.title and result2[v8] then
						result2[v8].title = v7.title
					end
				else
					if enableTemplateCache then
						continue
					end

					local v13 = {
						name = robloxComponentType,
						message = `Missing template for robloxComponentType {robloxComponentType}`
					}

					if FFlagSduiErrorPaths then
						addSduiErrorContextFields(v13, createErrorContextForRCT(robloxComponentType, v7))
					end

					SduiLogger.reportError(
						SduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate,
						v13,
						surfaceKey
					)
					continue
				end
			else
				local v12 = {
					name = configCacheKey,
					message = "Page entry missing robloxComponentType"
				}

				if FFlagSduiErrorPaths then
					local fullName

					if v7 then
						local identifier2 = v7.identifier

						if identifier2 and identifier2 ~= "" then
							fullName = `{surfaceKey}[{identifier2}]`
						else
							fullName = surfaceKey
						end
					end

					addSduiErrorContextFields(v12, {
						fullName = fullName,
						rctPath = nil,
						templateId = nil
					})
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, v12, surfaceKey)
				continue
			end
		end

		result2[v8] = result2[v8] or {}

		if buildNextPageUrl then
			result2[v8].nextPageUrl = buildNextPageUrl(result) or ""
		else
			result2[v8].nextPageUrl = ""
		end

		if not buildNextPagePostBody then
			continue
		end

		local nextPagePostBody = buildNextPagePostBody(result)
		result2[v8].nextPagePostBody = nextPagePostBody or Cryo.None
	end

	if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest and v6 then
		for k, v7 in v6 do
			setInputDataSignalsForRequest(configCacheKey, k, v7)
		end
	end

	if not (next(result2) or paginateResponse or FFlagSduiAllowNoConfigsBuilt and allowNoConfigsBuilt) then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.NoComponentConfigsBuilt,
			{
				name = configCacheKey,
				message = `No configs built when handling proto response for {configCacheKey}`
			},
			surfaceKey
		)
	end

	loadTimer.logSduiTreeBuildEnd()

	local function getTemplateForRobloxComponent(p: string)
		if enableTemplateCache then
			return resolveTemplateForRobloxComponent(p)
		end

		return v2[p]
	end

	local function getKnownTemplates()
		local knownTemplates = {}

		for _, v7 in v2 do
			table.insert(knownTemplates, v7)
		end

		if not enableTemplateCache then
			return knownTemplates
		end

		local sduiTemplateStore = getSduiTemplateStore()

		for _, v7 in sduiTemplateStore.getCachedRobloxComponentToTemplateId(surfaceKey) do
			local template = sduiTemplateStore.getTemplate(v7)

			if template ~= nil then
				table.insert(knownTemplates, template)
			end
		end

		return knownTemplates
	end

	loadTimer.logSduiClientHintsBegin()
	local success2, result3 = pcall(function()
		processClientHints({
			pageEntries = pageEntries,
			getTemplateForRobloxComponent = getTemplateForRobloxComponent,
			getKnownTemplates = getKnownTemplates
		})
	end)
	loadTimer.logSduiClientHintsEnd()

	if not success2 then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToProcessClientHints,
			{ name = configCacheKey, message = result3 },
			surfaceKey
		)
	end

	return result2, result
end

return handleSduiApiResponse

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
local FFlagLuaAppEnableSduiHomePage = SharedFlags7.FFlagLuaAppEnableSduiHomePage

local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiStreamingRefreshReplacesInputData = SharedFlags8.FFlagSduiStreamingRefreshReplacesInputData
local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiFreshInputDataSignalOnRebuild = SharedFlags9.FFlagSduiFreshInputDataSignalOnRebuild
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiSharedLocalizedLiterals = SharedFlags10.FFlagSduiSharedLocalizedLiterals
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppSduiHomePageSupport = SharedFlags11.FFlagLuaAppSduiHomePageSupport

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

	loadTimer.logNetRequestStats(response.stats or {})

	loadTimer.logResponseDecodeBegin()
	local success, result = pcall(function()
		return (decodeResponse(response.responseBody))
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
			local v = parseHydrationDataFromResponse(result)

			if v ~= nil then
				getSduiDataBinder().updateDataStores(v)
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

	local v = {}
	local v2 = nil

	if parseTemplateEntriesFromResponse then
		local success2, result2 = pcall(function()
			local v3, v4, v5 = parseTemplateEntriesFromResponse(
				result,
				FFlagSduiErrorPaths and true or enableTemplateCache
			)
			v = v4

			if FFlagSduiErrorPaths and not enableTemplateCache then
				v2 = v5
			end

			getSduiTemplateStore().addTemplates(v3)

			if enableTemplateCache then
				getSduiTemplateStore().recordSurfaceTemplates(surfaceKey, v5)
			end

			if v3 then
				for _, v6 in v3 do
					pcall(recordTemplateUsage, surfaceKey, v6)
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

		return v2 and v2[p]
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
	local v3

	if parseLocalizedLiteralsFromResponse then
		v3 = parseLocalizedLiteralsFromResponse(result)
	else
		v3 = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(result)
	end

	if FFlagSduiSharedLocalizedLiterals and v3 then
		getSduiTemplateStore().addLocalizedLiterals(v3)
	end

	local function resolveTemplateForRobloxComponent(name: string, p)
		local templateForRobloxComponent = v[name]

		if templateForRobloxComponent == nil then
			templateForRobloxComponent = getSduiTemplateStore().getTemplateForRobloxComponent(surfaceKey, name)
		end

		if templateForRobloxComponent ~= nil then
			return templateForRobloxComponent
		end

		local v4 = {
			name = name,
			message = `Backend omitted template for {name} but it could not be resolved from the surface cache + template store`
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v4, createErrorContextForRCT(name, p))
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.MissingCachedTemplate, v4, surfaceKey)

		return templateForRobloxComponent
	end

	local v4 = #pageEntries > 1
	local result2 = {}
	local v5 = nil

	for _, v6 in pageEntries do
		local identifier = v6.identifier
		local v7

		if
			(v4 or FFlagSduiAlwaysCacheWithIdentifier or data.cacheSingleEntryWithIdentifier)
			and identifier
			and identifier ~= ""
		then
			v7 = `{configCacheKey}_{identifier}`
		else
			v7 = configCacheKey
		end

		local componentInputData = v6.componentInputData
		local v8 = getInputDataSignalsForRequest(v7)
		local v9 = v8.get(false)
		local v10 = data.enableStreamingMerge
		local merged, get, set

		if paginateResponse then
			if v9 then
				if componentInputData then
					merged = SduiInputDataMerge.merge(v8.get(false), componentInputData, mergeStrategy)
					v8.set(merged)
				end
			else
				if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					get, set = Signals.createSignal(nil)
					v8 = { get = get, set = set }
				end

				v8.set(componentInputData)
			end
		else
			local v11

			if FFlagLuaAppEnableSduiHomePage or FFlagSduiStreamingRefreshReplacesInputData then
				v11 = enableInputDataMerge
			else
				v11 = v10
			end

			if v11 then
				if v9 then
					if componentInputData then
						merged = SduiInputDataMerge.merge(v8.get(false), componentInputData, mergeStrategy)
						v8.set(merged)
					end
				else
					if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
						get, set = Signals.createSignal(nil)
						v8 = { get = get, set = set }
					end

					v8.set(componentInputData)
				end
			else
				if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
					get, set = Signals.createSignal(nil)
					v8 = { get = get, set = set }
				end

				v8.set(componentInputData)
			end
		end

		if not paginateResponse then
			if FFlagLuaAppEnableSduiHomePage or FFlagSduiStreamingRefreshReplacesInputData then
				v10 = enableInputDataMerge
			end

			v9 = v10 and v9
		end

		if not v9 then
			local robloxComponentType = v6.robloxComponentType

			if robloxComponentType then
				local v11

				if enableTemplateCache then
					local v12

					if FFlagSduiErrorPaths then
						v12 = v6
					end

					v11 = resolveTemplateForRobloxComponent(robloxComponentType, v12)
				else
					v11 = v[robloxComponentType]
				end

				if v11 then
					local v12 = v11
					local v13 = robloxComponentType
					local v14 = identifier
					local success2, result3 = pcall(function()
						local v15 = {
							appPage = surfaceKey,
							debugName = configCacheKey,
							getTemplateForRobloxComponent = function(p)
								if enableTemplateCache then
									return resolveTemplateForRobloxComponent(p)
								end

								return v[p]
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

						v15.getTemplateIdForRCT = getTemplateIdForRCT2
						local localizedLiterals

						if not FFlagSduiSharedLocalizedLiterals then
							localizedLiterals = v3
						end

						v15.localizedLiterals = localizedLiterals
						local getLocalizedLiteral2

						if FFlagSduiSharedLocalizedLiterals then
							getLocalizedLiteral2 = getLocalizedLiteral
						end

						v15.getLocalizedLiteral = getLocalizedLiteral2

						v15.configKey = configCacheKey
						local builderConfig = createBuilderConfig(v15)

						local buildConfigForComponent = getSduiClientBindingBuilder().buildConfigForComponent
						local v16

						if FFlagLuaAppSduiHomePageSupport and v6.componentInputDataGetter then
							v16 = v6.componentInputDataGetter
						else
							v16 = v8.get
						end

						local v17

						if FFlagSduiErrorPaths then
							v17 = v13
						end

						local v18

						if FFlagSduiErrorPaths then
							v18 = v14
						end

						return (buildConfigForComponent(v12, v16, builderConfig, nil, nil, nil, nil, v17, v18))
					end)

					if success2 then
						if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest then
							v5 = v5 == nil and {} or v5

							v5[v7] = v8
						end

						if result2[v7] then
							local v15 = {
								name = robloxComponentType,
								message = `Existing config found for cacheKey {v7}. Need to specify identifer in page entry for multiple configs`
							}

							if FFlagSduiErrorPaths then
								addSduiErrorContextFields(v15, result3 and result3.errorContext)
							end

							SduiLogger.reportError(
								SduiErrors.SduiErrorType.DuplicateOrMissingIdentifier,
								v15,
								surfaceKey
							)
						end

						local v15 = {
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

						v15.identifier = identifier

						if not (FFlagEnableSduiV2HomepagePrompts or FFlagPromptsHandlerEnabled) then
							robloxComponentType = nil
						end

						v15.robloxComponentType = robloxComponentType
						local category

						if FFlagEnableHomepagePromptsForModalsAndBanners or FFlagPromptsHandlerEnabled then
							category = v6.category
						end

						v15.category = category

						v15.surfacing = v6.surfacing
						result2[v7] = v15
					else
						local v15 = { name = robloxComponentType, message = `{result3}` }

						if FFlagSduiErrorPaths then
							addSduiErrorContextFields(v15, createErrorContextForRCT(robloxComponentType, v6))
						end

						SduiLogger.reportError(
							SduiErrors.SduiErrorType.FailedToBuildClientBindingConfig,
							v15,
							surfaceKey
						)
					end

					if v6.title and result2[v7] then
						result2[v7].title = v6.title
					end
				else
					if enableTemplateCache then
						continue
					end

					local v12 = {
						name = robloxComponentType,
						message = `Missing template for robloxComponentType {robloxComponentType}`
					}

					if FFlagSduiErrorPaths then
						addSduiErrorContextFields(v12, createErrorContextForRCT(robloxComponentType, v6))
					end

					SduiLogger.reportError(
						SduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate,
						v12,
						surfaceKey
					)
					continue
				end
			else
				local v11 = {
					name = configCacheKey,
					message = "Page entry missing robloxComponentType"
				}

				if FFlagSduiErrorPaths then
					local fullName

					if v6 then
						local identifier2 = v6.identifier

						if identifier2 and identifier2 ~= "" then
							fullName = `{surfaceKey}[{identifier2}]`
						else
							fullName = surfaceKey
						end
					end

					addSduiErrorContextFields(v11, {
						fullName = fullName,
						rctPath = nil,
						templateId = nil
					})
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToAddTemplates, v11, surfaceKey)
				continue
			end
		end

		result2[v7] = result2[v7] or {}

		if buildNextPageUrl then
			result2[v7].nextPageUrl = buildNextPageUrl(result) or ""
		else
			result2[v7].nextPageUrl = ""
		end

		if not buildNextPagePostBody then
			continue
		end

		local nextPagePostBody = buildNextPagePostBody(result)
		result2[v7].nextPagePostBody = nextPagePostBody or Cryo.None
	end

	if FFlagSduiFreshInputDataSignalOnRebuild and setInputDataSignalsForRequest and v5 then
		for k, v6 in v5 do
			setInputDataSignalsForRequest(configCacheKey, k, v6)
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

		return v[p]
	end

	local function getKnownTemplates()
		local knownTemplates = {}

		for _, v6 in v do
			table.insert(knownTemplates, v6)
		end

		if not enableTemplateCache then
			return knownTemplates
		end

		local sduiTemplateStore = getSduiTemplateStore()

		for _, v6 in sduiTemplateStore.getCachedRobloxComponentToTemplateId(surfaceKey) do
			local template = sduiTemplateStore.getTemplate(v6)

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

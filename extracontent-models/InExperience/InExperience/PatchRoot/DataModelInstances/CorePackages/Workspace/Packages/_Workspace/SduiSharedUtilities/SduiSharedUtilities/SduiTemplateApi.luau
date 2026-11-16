local LocalizationService = game:GetService("LocalizationService")

local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local SduiApiStorePostConfig = require(SduiSharedUtilities.SduiApiStorePostConfig)
require(SduiSharedUtilities.SduiIntegrationTypes)
local SduiSurfaceToDisplayLocation = require(SduiSharedUtilities.SduiSurfaceToDisplayLocation)
local getSduiTemplateStore = require(SduiSharedUtilities.getSduiTemplateStore)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local ServiceContractsProto = require(parent.ServiceContractsProto)
local UrlBuilder = require(parent.UrlBuilder)

local SduiCapabilities = SduiCoreSystem.SduiCapabilities
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local displayLocation = ServiceContractsProto.apppageplatform.shared.display_location.DisplayLocation
local template_api_messages = ServiceContractsProto.apppageplatform.templates.template_api_messages

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiTemplateApiPostRequest = SharedFlags.FFlagSduiTemplateApiPostRequest
local FFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local function getTemplatesUrl() -- 3 equivalent calls inferred from this helper
	return `{UrlBuilder.UrlBase.APIS}/landing-page-api/v1/templates`
end

local function resolveSurfaceKey(item: string, data)
	local v = SduiSurfaceToDisplayLocation[item]

	if v == nil then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.CodeError,
			{
				name = item,
				message = `Unmapped SDUI surfaceKey {item}`
			},
			item
		)

		return
	end

	local success, result = pcall(displayLocation.toNumber, v)

	if not success or type(result) ~= "number" then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.CodeError,
			{
				name = item,
				message = `Invalid DisplayLocation {v} for surfaceKey {item}`
			},
			item
		)

		return
	end

	if not data.uniqueDisplayLocationNumbers[result] then
		data.uniqueDisplayLocationNumbers[result] = true
		table.insert(data.displayLocationNumbers, result)
	end

	local v2 = data.surfaceKeysByDisplayLocation[v]

	if v2 == nil then
		v2 = {}
		data.surfaceKeysByDisplayLocation[v] = v2
	end

	if not table.find(v2, item) then
		table.insert(v2, item)
	end
end

local function resolveSurfaceKeys(surfaceKeys)
	local v = {
		displayLocationNumbers = {},
		uniqueDisplayLocationNumbers = {},
		surfaceKeysByDisplayLocation = {}
	}

	for _, item in surfaceKeys do
		resolveSurfaceKey(item, v)
	end

	if #v.displayLocationNumbers ~= 0 then
		table.sort(v.displayLocationNumbers)
		return v
	end

	if #surfaceKeys == 0 then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.CodeError,
			{ name = "SduiTemplateApi", message = "At least one surfaceKey is required" },
			"Unknown"
		)
	end

	return nil
end

local function getDisplayLocationValues(list) -- 3 equivalent calls inferred from this helper
	local displayLocationValues = table.create(#list)

	for _, item in list do
		table.insert(displayLocationValues, (tostring(item)))
	end

	return displayLocationValues
end

local function buildGetUrl(displayLocationNumbers, locale: string, capabilities)
	local v = {
		displayLocations = table.concat(getDisplayLocationValues(displayLocationNumbers), ","), -- inferred equivalent call
		platform = "App",
		locale = locale
	}

	SduiCapabilities.addToQueryParams(v, capabilities)
	return UrlBuilder.UrlBuilder.addQueryString(getTemplatesUrl(), v) -- inferred equivalent call
end

local function buildCachedComponentMappings(displayLocationNumbers, surfaceKeysByDisplayLocation)
	local sduiTemplateStore = getSduiTemplateStore()
	local displayLocationTemplateMappings = {}

	for _, item in displayLocationNumbers do
		local roblox_component_to_template_id = {}

		for _, v in surfaceKeysByDisplayLocation[displayLocation.fromNumber(item)] or {} do
			for k, v2 in sduiTemplateStore.getCachedRobloxComponentToTemplateId(v) do
				roblox_component_to_template_id[k] = v2
			end
		end

		if next(roblox_component_to_template_id) then
			table.insert(
				displayLocationTemplateMappings,
				template_api_messages.DisplayLocationTemplateMapping.new({
					display_location = item,
					roblox_component_to_template_id = roblox_component_to_template_id
				})
			)
		end
	end

	return displayLocationTemplateMappings
end

local function buildPostConfig(surfaceKeys, locale: string, capabilities)
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local platform = ServiceContractsProto.apppageplatform.shared.client_capabilities.Platform
	local getTemplatesRequest = template_api_messages.GetTemplatesRequest.new({
		display_locations = surfaceKeys.displayLocationNumbers,
		client_capabilities = clientCapabilities.new({
			enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers(capabilities),
			platform = platform.toNumber("PLATFORM_APP")
		}),
		cached_component_mappings = buildCachedComponentMappings(
			surfaceKeys.displayLocationNumbers,
			surfaceKeys.surfaceKeysByDisplayLocation
		),
		locale = locale
	})

	return {
		contentType = SduiApiStorePostConfig.SduiApiStorePostConfigContentType.Proto,
		protoMessage = template_api_messages.GetTemplatesRequest,
		body = getTemplatesRequest
	}
end

local function buildPostConfigWithRuntimeSupport(surfaceKeys, locale: string, clientCapabilities)
	local getTemplatesRequest = template_api_messages.GetTemplatesRequest.new({
		display_locations = surfaceKeys.displayLocationNumbers,
		client_capabilities = clientCapabilities,
		cached_component_mappings = buildCachedComponentMappings(
			surfaceKeys.displayLocationNumbers,
			surfaceKeys.surfaceKeysByDisplayLocation
		),
		locale = locale
	})

	return {
		contentType = SduiApiStorePostConfig.SduiApiStorePostConfigContentType.Proto,
		protoMessage = template_api_messages.GetTemplatesRequest,
		body = getTemplatesRequest
	}
end

local function getDisplayLocationName(value)
	if type(value) ~= "number" then
		return value
	end

	local success, result = pcall(displayLocation.fromNumber, value)
	return if success then result else nil
end

local function extractTemplates(p)
	local templates = {}

	if p.templates then
		for k, template in p.templates do
			if template.template then
				templates[k] = template.template
			end
		end
	end

	return templates
end

local SduiTemplateApi = {}

function SduiTemplateApi.createRequest(data)
	local surfaceKeys = resolveSurfaceKeys(data.surfaceKeys)

	if surfaceKeys == nil then
		return nil
	end

	local locale = data.locale or LocalizationService.RobloxLocaleId
	local capabilities = data.capabilities or SduiCapabilities.getEnabledCapabilities()

	if FFlagSduiAdvertiseRuntimeSupportSets then
		local clone = table.clone(SduiCapabilities.getEnabledCapabilities())
		table.sort(clone)
		local clientCapabilities = SduiCapabilities.buildClientCapabilities()
		local url

		if FFlagSduiTemplateApiPostRequest then
			url = getTemplatesUrl() -- inferred equivalent call
		else
			url = buildGetUrl(surfaceKeys.displayLocationNumbers, locale, capabilities)
		end

		local v = {
			url = url,
			cacheKey = `sdui-template-api:{table.concat(getDisplayLocationValues(surfaceKeys.displayLocationNumbers), ",")}:{locale}:{table.concat(clone, ",")}`,
			postConfig = 0,
			responseProto = 0,
			surfaceKeysByDisplayLocation = 0
		} -- inferred equivalent call
		local postConfig

		if FFlagSduiTemplateApiPostRequest then
			postConfig = buildPostConfigWithRuntimeSupport(surfaceKeys, locale, clientCapabilities)
		end

		v.postConfig = postConfig

		v.responseProto = template_api_messages.GetTemplatesResponse
		v.surfaceKeysByDisplayLocation = surfaceKeys.surfaceKeysByDisplayLocation
		return v
	else
		local clone = table.clone(capabilities)
		table.sort(clone)
		local url

		if FFlagSduiTemplateApiPostRequest then
			url = getTemplatesUrl() -- inferred equivalent call
		else
			url = buildGetUrl(surfaceKeys.displayLocationNumbers, locale, capabilities)
		end

		local v = {
			url = url,
			cacheKey = `sdui-template-api:{table.concat(getDisplayLocationValues(surfaceKeys.displayLocationNumbers), ",")}:{locale}:{table.concat(clone, ",")}`,
			postConfig = 0,
			responseProto = 0,
			surfaceKeysByDisplayLocation = 0
		} -- inferred equivalent call
		local postConfig

		if FFlagSduiTemplateApiPostRequest then
			postConfig = buildPostConfig(surfaceKeys, locale, capabilities)
		end

		v.postConfig = postConfig

		v.responseProto = template_api_messages.GetTemplatesResponse
		v.surfaceKeysByDisplayLocation = surfaceKeys.surfaceKeysByDisplayLocation
		return v
	end
end

function SduiTemplateApi.parseResponseForSurface(p, p2: string)
	local v = SduiSurfaceToDisplayLocation[p2]
	local v2 = extractTemplates(p)
	local v3 = {}

	if p.component_mappings then
		for _, component_mapping in p.component_mappings do
			local result = component_mapping.display_location

			if type(result) == "number" then
				local success
				success, result = pcall(displayLocation.fromNumber, result)

				if not success then
					result = nil
				end
			end

			if result == v then
				v3 = component_mapping.roblox_component_to_template_id
				break
			end
		end
	end

	local sduiTemplateStore = getSduiTemplateStore()
	local result = {}

	for k, v4 in v3 do
		local v5 = v2[v4] or sduiTemplateStore.getTemplate(v4)

		if v5 then
			result[k] = v5
		end
	end

	return v2, result, v3
end

function SduiTemplateApi.storeResponse(p, p2)
	local sduiTemplateStore = getSduiTemplateStore()
	sduiTemplateStore.addTemplates(extractTemplates(p))

	if p.component_mappings then
		for _, component_mapping in p.component_mappings do
			local result = component_mapping.display_location

			if type(result) == "number" then
				local success
				success, result = pcall(displayLocation.fromNumber, result)

				if not success then
					result = nil
				end
			end

			if result == nil then
				local _, v = next(p2.surfaceKeysByDisplayLocation)
				local v2 = not v and "Unknown" or v[1]
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate,
					{
						name = tostring(component_mapping.display_location),
						message = `Unknown DisplayLocation {component_mapping.display_location}`
					},
					v2
				)
			else
				local surfaceKey = p2.surfaceKeysByDisplayLocation[result]

				if surfaceKey then
					for _, v in surfaceKey do
						sduiTemplateStore.recordSurfaceTemplates(v, component_mapping.roblox_component_to_template_id)
					end
				end
			end
		end
	end

	sduiTemplateStore.addLocalizedLiterals(p.localized_literals or {})
	return p
end

return SduiTemplateApi

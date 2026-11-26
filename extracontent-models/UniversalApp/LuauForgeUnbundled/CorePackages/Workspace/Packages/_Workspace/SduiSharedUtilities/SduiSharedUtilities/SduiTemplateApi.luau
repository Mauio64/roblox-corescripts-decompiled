local LocalizationService = game:GetService("LocalizationService")

local SduiApiStorePostConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiApiStorePostConfig")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")
local SduiSurfaceToDisplayLocation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiSurfaceToDisplayLocation")
local getSduiTemplateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiTemplateStore")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")
local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ServiceContractsProto")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/UrlBuilder")

local sduiCapabilities = SduiCoreSystem.SduiCapabilities
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local displayLocation = ServiceContractsProto.apppageplatform.shared.display_location.DisplayLocation
local template_api_messages = ServiceContractsProto.apppageplatform.templates.template_api_messages

local fFlagSduiAdvertiseRuntimeSupportSets = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAdvertiseRuntimeSupportSets

local function getTemplatesUrl()
	return `{module6.UrlBase.APIS}/landing-page-api/v1/templates`
end

local function resolveSurfaceKey(item, data)
	local v5 = SduiSurfaceToDisplayLocation[item]

	if v5 == nil then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.CodeError,
			{
				name = item,
				message = `Unmapped SDUI surfaceKey {item}`
			},
			item
		)

		return
	end

	local success, result = pcall(displayLocation.toNumber, v5)

	if not success or type(result) ~= "number" then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.CodeError,
			{
				name = item,
				message = `Invalid DisplayLocation {v5} for surfaceKey {item}`
			},
			item
		)

		return
	end

	if not data.uniqueDisplayLocationNumbers[result] then
		data.uniqueDisplayLocationNumbers[result] = true
		table.insert(data.displayLocationNumbers, result)
	end

	local v6 = data.surfaceKeysByDisplayLocation[v5]

	if v6 == nil then
		v6 = {}
		data.surfaceKeysByDisplayLocation[v5] = v6
	end

	if not table.find(v6, item) then
		table.insert(v6, item)
	end
end

local function resolveSurfaceKeys(surfaceKeys)
	local v5 = {
		displayLocationNumbers = {},
		uniqueDisplayLocationNumbers = {},
		surfaceKeysByDisplayLocation = {}
	}

	for k, item in surfaceKeys do
		resolveSurfaceKey(item, v5)
	end

	if #v5.displayLocationNumbers ~= 0 then
		table.sort(v5.displayLocationNumbers)
		return v5
	end

	if #surfaceKeys == 0 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.CodeError,
			{
				name = "SduiTemplateApi",
				message = "At least one surfaceKey is required"
			},
			"Unknown"
		)
	end

	return nil
end

local function getDisplayLocationValues(list)
	local displayLocationValues = table.create(#list)

	for k, item in list do
		table.insert(displayLocationValues, (tostring(item)))
	end

	return displayLocationValues
end

local function buildCachedComponentMappings(displayLocationNumbers, surfaceKeysByDisplayLocation)
	local v5 = getSduiTemplateStore()
	local displayLocationTemplateMappings = {}

	for k, item in displayLocationNumbers do
		local v6 = {}

		for k2, v7 in surfaceKeysByDisplayLocation[displayLocation.fromNumber(item)] or {} do
			for k3, v8 in v5.getCachedRobloxComponentToTemplateId(v7) do
				v6[k3] = v8
			end
		end

		if next(v6) then
			table.insert(
				displayLocationTemplateMappings,
				template_api_messages.DisplayLocationTemplateMapping.new({
					display_location = item,
					roblox_component_to_template_id = v6
				})
			)
		end
	end

	return displayLocationTemplateMappings
end

local function buildPostConfig(surfaceKeys, locale, capabilities)
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local platform = ServiceContractsProto.apppageplatform.shared.client_capabilities.Platform
	local getTemplatesRequest = template_api_messages.GetTemplatesRequest.new({
		display_locations = surfaceKeys.displayLocationNumbers,
		client_capabilities = clientCapabilities.new({
			enabled_capabilities = sduiCapabilities.getEnabledCapabilityNumbers(capabilities),
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

local function buildPostConfigWithRuntimeSupport(surfaceKeys, locale, clientCapabilities)
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

	if success then
		return result
	end

	return nil
end

local function extractTemplates(p2)
	local templates = {}

	if p2.templates then
		for k, template in p2.templates do
			if template.template then
				templates[k] = template.template
			end
		end
	end

	return templates
end

return {
	createRequest = function(data)
		local surfaceKeys = resolveSurfaceKeys(data.surfaceKeys)

		if surfaceKeys == nil then
			return nil
		end

		local locale = data.locale or LocalizationService.RobloxLocaleId
		local capabilities = data.capabilities or sduiCapabilities.getEnabledCapabilities()

		if fFlagSduiAdvertiseRuntimeSupportSets then
			local clone = table.clone(sduiCapabilities.getEnabledCapabilities())
			table.sort(clone)
			local clientCapabilities = sduiCapabilities.buildClientCapabilities()
			local v5 = {
				url = `{module6.UrlBase.APIS}/landing-page-api/v1/templates`,
				cacheKey = 0,
				postConfig = 0,
				responseProto = 0,
				surfaceKeysByDisplayLocation = 0
			}

			local concat = table.concat
			local displayLocationNumbers = surfaceKeys.displayLocationNumbers
			local v6 = table.create(#displayLocationNumbers)

			for k, displayLocationNumber in displayLocationNumbers do
				table.insert(v6, (tostring(displayLocationNumber)))
			end

			v5.cacheKey = `sdui-template-api:{concat(v6, ",")}:{locale}:{table.concat(clone, ",")}`
			v5.postConfig = buildPostConfigWithRuntimeSupport(surfaceKeys, locale, clientCapabilities)
			v5.responseProto = template_api_messages.GetTemplatesResponse
			v5.surfaceKeysByDisplayLocation = surfaceKeys.surfaceKeysByDisplayLocation
			return v5
		else
			local clone = table.clone(capabilities)
			table.sort(clone)
			local v5 = {
				url = `{module6.UrlBase.APIS}/landing-page-api/v1/templates`,
				cacheKey = 0,
				postConfig = 0,
				responseProto = 0,
				surfaceKeysByDisplayLocation = 0
			}

			local concat = table.concat
			local displayLocationNumbers = surfaceKeys.displayLocationNumbers
			local v6 = table.create(#displayLocationNumbers)

			for k, displayLocationNumber in displayLocationNumbers do
				table.insert(v6, (tostring(displayLocationNumber)))
			end

			v5.cacheKey = `sdui-template-api:{concat(v6, ",")}:{locale}:{table.concat(clone, ",")}`
			v5.postConfig = buildPostConfig(surfaceKeys, locale, capabilities)
			v5.responseProto = template_api_messages.GetTemplatesResponse
			v5.surfaceKeysByDisplayLocation = surfaceKeys.surfaceKeysByDisplayLocation
			return v5
		end
	end,
	parseResponseForSurface = function(p2, p3)
		local v5 = SduiSurfaceToDisplayLocation[p3]
		local v6 = extractTemplates(p2)
		local v7 = {}

		if p2.component_mappings then
			for k, component_mapping in p2.component_mappings do
				local result = component_mapping.display_location

				if type(result) == "number" then
					local success
					success, result = pcall(displayLocation.fromNumber, result)

					if not success then
						result = nil
					end
				end

				if result == v5 then
					v7 = component_mapping.roblox_component_to_template_id
					break
				end
			end
		end

		local v8 = getSduiTemplateStore()
		local result = {}

		for k, v9 in v7 do
			local v10 = v6[v9] or v8.getTemplate(v9)

			if v10 then
				result[k] = v10
			end
		end

		return v6, result, v7
	end,
	storeResponse = function(p2, p3)
		local v5 = getSduiTemplateStore()
		v5.addTemplates(extractTemplates(p2))

		if p2.component_mappings then
			for k, component_mapping in p2.component_mappings do
				local result = component_mapping.display_location

				if type(result) == "number" then
					local success
					success, result = pcall(displayLocation.fromNumber, result)

					if not success then
						result = nil
					end
				end

				if result == nil then
					local v6, v7 = next(p3.surfaceKeysByDisplayLocation)
					local v8 = not v7 and "Unknown" or v7[1]
					sduiLogger.reportError(
						sduiErrors.SduiErrorType.FailedToMapRobloxComponentToTemplate,
						{
							name = tostring(component_mapping.display_location),
							message = `Unknown DisplayLocation {component_mapping.display_location}`
						},
						v8
					)
				else
					local surfaceKey = p3.surfaceKeysByDisplayLocation[result]

					if surfaceKey then
						for k2, v6 in surfaceKey do
							v5.recordSurfaceTemplates(v6, component_mapping.roblox_component_to_template_id)
						end
					end
				end
			end
		end

		v5.addLocalizedLiterals(p2.localized_literals or {})
		return p2
	end
}

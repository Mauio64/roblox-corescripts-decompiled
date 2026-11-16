local SettingsSdui = script:FindFirstAncestor("SettingsSdui")
local parent = SettingsSdui.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local SettingsSduiConstants = require(SettingsSdui.SettingsSduiConstants)
local SettingsPageSession = require(SettingsSdui.SettingsPageSession)
local getSettingsPageUrl = require(SettingsSdui.getSettingsPageUrl)
local buildSettingsPageRequest = require(SettingsSdui.buildSettingsPageRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets
local function fetchSettingsPage(loadTimer, flag: boolean?)
	local configKey = SettingsSduiConstants.ConfigKey
	local sduiApiStore = getSduiApiStore()

	local _, v = sduiApiStore.getData(configKey)

	if (flag or v) and not sduiApiStore.isInFlight(configKey) then
		SettingsPageSession:Refresh()
	end

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local settings_page = ServiceContractsProto.apppageplatform.settings.settings_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local enabled_capabilities

	if FFlagSduiAdvertiseRuntimeSupportSets then
		enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbersWithoutExtendedMarker()
	else
		enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers(SduiCapabilities.getEnabledCapabilities())
	end

	local clientCapabilities2 = clientCapabilities.new({
		enabled_capabilities = enabled_capabilities
	})

	local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.Settings)
	local settingsPageUrl = getSettingsPageUrl()
	local settingsPageRequest = buildSettingsPageRequest(settings_page, {
		sessionId = SettingsPageSession:Get(),
		cachedRobloxComponentToTemplateId = cachedRobloxComponentToTemplateId,
		clientCapabilities = clientCapabilities2
	})

	return sduiApiStore.fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = settingsPageUrl,
		surfaceKey = AppPage.Settings,
		configKey = configKey,
		loadTimer = loadTimer,
		apiProto = settings_page.SettingsPageResponse,
		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Json,
			body = settingsPageRequest
		},
		enableTemplateCache = true,
		refresh = function(p)
			return fetchSettingsPage(p, true)
		end
	}, flag)
end

return fetchSettingsPage

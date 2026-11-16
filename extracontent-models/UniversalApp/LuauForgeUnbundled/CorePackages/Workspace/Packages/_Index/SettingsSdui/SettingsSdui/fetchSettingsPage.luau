local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities

local SettingsSduiConstants = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SettingsSduiConstants")
local SettingsPageSession = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SettingsPageSession")
local getSettingsPageUrl = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/getSettingsPageUrl")
local buildSettingsPageRequest = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/buildSettingsPageRequest")
local fFlagSduiAdvertiseRuntimeSupportSets = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SharedFlags").FFlagSduiAdvertiseRuntimeSupportSets
local function fetchSettingsPage(p2, p3)
	local configKey = SettingsSduiConstants.ConfigKey
	local sduiApiStore = getSduiApiStore()

	local data, v5 = sduiApiStore.getData(configKey)

	if (p3 or v5) and not sduiApiStore.isInFlight(configKey) then
		SettingsPageSession:Refresh()
	end

	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/ServiceContractsProto")
	local settings_page = ServiceContractsProto.apppageplatform.settings.settings_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local v6

	if fFlagSduiAdvertiseRuntimeSupportSets then
		v6 = sduiCapabilities.getEnabledCapabilityNumbersWithoutExtendedMarker()
	else
		v6 = sduiCapabilities.getEnabledCapabilityNumbers(sduiCapabilities.getEnabledCapabilities())
	end

	local v7 = clientCapabilities.new({ enabled_capabilities = v6 })

	local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.Settings)
	local v8 = getSettingsPageUrl()
	local v9 = buildSettingsPageRequest(settings_page, {
		sessionId = SettingsPageSession:Get(),
		cachedRobloxComponentToTemplateId = cachedRobloxComponentToTemplateId,
		clientCapabilities = v7
	})

	return sduiApiStore.fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = v8,
		surfaceKey = appPage.Settings,
		configKey = configKey,
		loadTimer = p2,
		apiProto = settings_page.SettingsPageResponse,
		postConfig = { contentType = sduiApiStorePostConfigContentType.Json, body = v9 },
		enableTemplateCache = true,
		refresh = function(p4)
			return fetchSettingsPage(p4, true)
		end
	}, p3)
end

return fetchSettingsPage

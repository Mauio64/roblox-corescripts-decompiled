local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities

local GroupPeekSduiConstants = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/GroupPeekSduiConstants")
local getGroupPeekPageUrl = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/getGroupPeekPageUrl")

local function fetchGroupPeekPage(p2, p3)
	local v5 = getGroupPeekPageUrl(p2)
	local configKey = GroupPeekSduiConstants.getConfigKey(p2)
	local appPage = GroupPeekSduiConstants.AppPage
	local loadTimer = sduiLoadTimer.createLoadTimer(appPage)

	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/ServiceContractsProto")
	local group_peek_page = ServiceContractsProto.apppageplatform.groups.group_peek_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities.new({
		enabled_capabilities = sduiCapabilities.getEnabledCapabilityNumbers({
			"CAPABILITY_SUPPORTS_GROUP_ANNOUNCEMENTS",
			"CAPABILITY_SUPPORTS_GROUP_CONTENT_REACTIONS"
		})
	})

	local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage)

	return getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.ProtobufJson,
		url = v5,
		surfaceKey = appPage,
		configKey = configKey,
		loadTimer = loadTimer,
		apiProto = group_peek_page.GroupPeekPageResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = group_peek_page.GroupPeekPageRequest,
			body = {
				group_id = p2,
				client_capabilities = clientCapabilities,
				cached_roblox_component_to_template_id = cachedRobloxComponentToTemplateId
			}
		},
		enableTemplateCache = true,
		staleTimeSec = 30
	}, p3)
end

return fetchGroupPeekPage

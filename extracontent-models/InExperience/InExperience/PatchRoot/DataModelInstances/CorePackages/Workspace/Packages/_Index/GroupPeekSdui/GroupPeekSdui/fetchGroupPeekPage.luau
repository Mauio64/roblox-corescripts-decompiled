local GroupPeekSdui = script:FindFirstAncestor("GroupPeekSdui")
local parent = GroupPeekSdui.Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local GroupPeekSduiConstants = require(GroupPeekSdui.GroupPeekSduiConstants)
local getGroupPeekPageUrl = require(GroupPeekSdui.getGroupPeekPageUrl)

local function fetchGroupPeekPage(group_id: string, flag: boolean?)
	local groupPeekPageUrl = getGroupPeekPageUrl(group_id)
	local configKey = GroupPeekSduiConstants.getConfigKey(group_id)
	local appPage = GroupPeekSduiConstants.AppPage
	local loadTimer = SduiLoadTimer.createLoadTimer(appPage)

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local group_peek_page = ServiceContractsProto.apppageplatform.groups.group_peek_page

	local clientCapabilities = SduiCapabilities.buildClientCapabilities()

	local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage)

	return getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.ProtobufJson,
		url = groupPeekPageUrl,
		surfaceKey = appPage,
		configKey = configKey,
		loadTimer = loadTimer,
		apiProto = group_peek_page.GroupPeekPageResponse,
		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = group_peek_page.GroupPeekPageRequest,
			body = {
				group_id = group_id,
				client_capabilities = clientCapabilities,
				cached_roblox_component_to_template_id = cachedRobloxComponentToTemplateId
			}
		},
		enableTemplateCache = true,
		staleTimeSec = 30
	}, flag)
end

return fetchGroupPeekPage

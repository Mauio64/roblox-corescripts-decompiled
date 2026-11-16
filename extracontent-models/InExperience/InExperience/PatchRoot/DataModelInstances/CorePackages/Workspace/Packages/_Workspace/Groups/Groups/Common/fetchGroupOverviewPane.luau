local parent = script:FindFirstAncestor("Groups").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
require(script.Parent.getGroupOverviewPaneConfig)

local function fetchGroupOverviewPane(data, loadTimer, flag: boolean?)
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local group_overview_page = ServiceContractsProto.apppageplatform.groups.group_overview_page

	return SduiSharedUtilities.getSduiApiStore().fetchIfNeeded({
		responseType = SduiSharedUtilities.SduiResponseType.Protobuf,
		url = data.url,
		surfaceKey = data.surfaceKey,
		configKey = data.configKey,
		loadTimer = loadTimer,
		apiProto = group_overview_page.GroupOverviewPageResponse,
		postConfig = {
			contentType = SduiSharedUtilities.SduiApiStorePostConfigContentType.Proto,
			protoMessage = group_overview_page.GroupOverviewPageRequest,
			body = {
				group_id = data.groupId,
				client_capabilities = SduiSharedUtilities.SduiCapabilities.buildClientCapabilities(),
				cached_roblox_component_to_template_id = SduiSharedUtilities.getSduiTemplateStore().getCachedRobloxComponentToTemplateId(data.surfaceKey)
			}
		},
		enableTemplateCache = true,
		allowNoConfigsBuilt = true
	}, flag)
end

return fetchGroupOverviewPane

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SduiSharedUtilities")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/getGroupOverviewPaneConfig")

local function fetchGroupOverviewPane(data, p2, p3)
	local group_overview_page = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/ServiceContractsProto").apppageplatform.groups.group_overview_page

	return SduiSharedUtilities.getSduiApiStore().fetchIfNeeded({
		responseType = SduiSharedUtilities.SduiResponseType.Protobuf,
		url = data.url,
		surfaceKey = data.surfaceKey,
		configKey = data.configKey,
		loadTimer = p2,
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
	}, p3)
end

return fetchGroupOverviewPane

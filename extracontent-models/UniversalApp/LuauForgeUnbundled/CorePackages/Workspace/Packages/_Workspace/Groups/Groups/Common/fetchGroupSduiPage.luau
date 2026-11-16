local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SduiSharedUtilities")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/getGroupSduiPageConfig")

local frozen = table.freeze({
	GroupSidebarSection = { "group_sidebar_section_page", "GroupSidebarSectionPage" }
})

local function fetchGroupSduiPage(data, p2, p3, p4)
	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/ServiceContractsProto")
	local v5, v6 = table.unpack(frozen[data.surfaceKey])
	local group = ServiceContractsProto.apppageplatform.groups[v5]
	local v7 = group[`{v6}Request`]
	local v8 = v7.new({
		group_id = data.groupId,
		client_capabilities = SduiSharedUtilities.SduiCapabilities.buildClientCapabilities(),
		cached_roblox_component_to_template_id = SduiSharedUtilities.getSduiTemplateStore().getCachedRobloxComponentToTemplateId(data.surfaceKey)
	})

	return SduiSharedUtilities.getSduiApiStore().fetchIfNeeded({
		responseType = SduiSharedUtilities.SduiResponseType.Protobuf,
		url = data.url,
		surfaceKey = data.surfaceKey,
		configKey = data.configKey,
		loadTimer = p2,
		apiProto = group[`{v6}Response`],
		postConfig = {
			contentType = SduiSharedUtilities.SduiApiStorePostConfigContentType.Json,
			body = v7.jsonEncode(v8)
		},
		enableTemplateCache = true,
		staleTimeSec = p4
	}, p3)
end

return fetchGroupSduiPage

local parent = script:FindFirstAncestor("Groups").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
require(script.Parent.getGroupSduiPageConfig)

local frozen = table.freeze({
	GroupSidebarSection = { "group_sidebar_section_page", "GroupSidebarSectionPage" }
})

local function fetchGroupSduiPage(data, loadTimer, flag: boolean?, staleTimeSec: number?)
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local v, v2 = table.unpack(frozen[data.surfaceKey])
	local group = ServiceContractsProto.apppageplatform.groups[v]
	local v3 = group[`{v2}Request`]
	local v4 = v3.new({
		group_id = data.groupId,
		client_capabilities = SduiSharedUtilities.SduiCapabilities.buildClientCapabilities(),
		cached_roblox_component_to_template_id = SduiSharedUtilities.getSduiTemplateStore().getCachedRobloxComponentToTemplateId(data.surfaceKey)
	})

	return SduiSharedUtilities.getSduiApiStore().fetchIfNeeded({
		responseType = SduiSharedUtilities.SduiResponseType.Protobuf,
		url = data.url,
		surfaceKey = data.surfaceKey,
		configKey = data.configKey,
		loadTimer = loadTimer,
		apiProto = group[`{v2}Response`],
		postConfig = {
			contentType = SduiSharedUtilities.SduiApiStorePostConfigContentType.Json,
			body = v3.jsonEncode(v4)
		},
		enableTemplateCache = true,
		staleTimeSec = staleTimeSec
	}, flag)
end

return fetchGroupSduiPage

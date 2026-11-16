local function buildSettingsPageRequest(p, data)
	local v = {}

	if data then
		v.session_id = data.sessionId
		v.client_capabilities = data.clientCapabilities

		if data.cachedRobloxComponentToTemplateId then
			v.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
		end
	end

	return p.SettingsPageRequest.new(v):jsonEncode()
end

return buildSettingsPageRequest

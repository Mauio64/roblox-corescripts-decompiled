local function buildSettingsPageRequest(p2, data)
	local v5 = {}

	if data then
		v5.session_id = data.sessionId
		v5.client_capabilities = data.clientCapabilities

		if data.cachedRobloxComponentToTemplateId then
			v5.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
		end
	end

	return p2.SettingsPageRequest.new(v5):jsonEncode()
end

return buildSettingsPageRequest

local addSystemInfoToArgs = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/DiscoveryUtils").AddSystemInfoToArgs
local FFlagSduiChartsAudienceFilter = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/Flags/FFlagSduiChartsAudienceFilter")

local function buildChartsSortDetailRequest(p2, data)
	local v5 = { sort_id = data.sortId }

	local v6 = {}
	addSystemInfoToArgs(v6, { "maxMemory" })

	if v6.maxMemory and v6.maxMemory ~= "" then
		v5.max_memory = v6.maxMemory
	end

	if data.contentPageToken and data.contentPageToken ~= "" then
		v5.content_page_token = data.contentPageToken
	end

	if data.sessionId and data.sessionId ~= "" then
		v5.session_id = data.sessionId
	end

	local filterSelections = data.filterSelections

	if filterSelections then
		if filterSelections.device and filterSelections.device ~= "" then
			v5.device = filterSelections.device
		end

		if filterSelections.country and filterSelections.country ~= "" then
			v5.country = filterSelections.country
		end

		if filterSelections.ageGroup and filterSelections.ageGroup ~= "" then
			v5.age_group = filterSelections.ageGroup
		end

		if filterSelections.selectedGenre and filterSelections.selectedGenre ~= "" then
			v5.selected_genre = filterSelections.selectedGenre
		end

		if FFlagSduiChartsAudienceFilter and filterSelections.audience and filterSelections.audience ~= "" then
			v5.audience = filterSelections.audience
		end
	end

	if data.cachedRobloxComponentToTemplateId then
		v5.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
	end

	if data.clientCapabilities then
		v5.client_capabilities = data.clientCapabilities
	end

	return p2.GetChartsSortDetailRequest.new(v5)
end

return buildChartsSortDetailRequest

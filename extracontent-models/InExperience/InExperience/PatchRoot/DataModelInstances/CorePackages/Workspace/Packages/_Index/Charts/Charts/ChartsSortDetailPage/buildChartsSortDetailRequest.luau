local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local AddSystemInfoToArgs = DiscoveryUtils.AddSystemInfoToArgs
local FFlagSduiChartsAudienceFilter = require(Charts.Flags.FFlagSduiChartsAudienceFilter)

local function buildChartsSortDetailRequest(p, data)
	local v = { sort_id = data.sortId }

	local v2 = {}
	AddSystemInfoToArgs(v2, { "maxMemory" })

	if v2.maxMemory and v2.maxMemory ~= "" then
		v.max_memory = v2.maxMemory
	end

	if data.contentPageToken and data.contentPageToken ~= "" then
		v.content_page_token = data.contentPageToken
	end

	if data.sessionId and data.sessionId ~= "" then
		v.session_id = data.sessionId
	end

	local filterSelections = data.filterSelections

	if filterSelections then
		if filterSelections.device and filterSelections.device ~= "" then
			v.device = filterSelections.device
		end

		if filterSelections.country and filterSelections.country ~= "" then
			v.country = filterSelections.country
		end

		if filterSelections.ageGroup and filterSelections.ageGroup ~= "" then
			v.age_group = filterSelections.ageGroup
		end

		if filterSelections.selectedGenre and filterSelections.selectedGenre ~= "" then
			v.selected_genre = filterSelections.selectedGenre
		end

		if FFlagSduiChartsAudienceFilter and filterSelections.audience and filterSelections.audience ~= "" then
			v.audience = filterSelections.audience
		end
	end

	if data.cachedRobloxComponentToTemplateId then
		v.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
	end

	if data.clientCapabilities then
		v.client_capabilities = data.clientCapabilities
	end

	return p.GetChartsSortDetailRequest.new(v)
end

return buildChartsSortDetailRequest

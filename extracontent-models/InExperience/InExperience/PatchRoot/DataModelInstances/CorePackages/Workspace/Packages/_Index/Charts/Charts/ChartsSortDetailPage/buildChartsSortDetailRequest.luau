local Parent = script:FindFirstAncestor("Charts").Parent
local AddSystemInfoToArgs = require(Parent.DiscoveryUtils).AddSystemInfoToArgs

local function buildChartsSortDetailRequest(p1, t1: {[any]: any}) -- line: 21
	-- upvalues: AddSystemInfoToArgs (copy)
	local t2 = {
		sort_id = t1.sortId
	}
	local t3 = {}

	AddSystemInfoToArgs(t3, { "maxMemory" })

	if t3.maxMemory and t3.maxMemory ~= "" then
		t2.max_memory = t3.maxMemory
	end

	if t1.contentPageToken and t1.contentPageToken ~= "" then
		t2.content_page_token = t1.contentPageToken
	end

	if t1.sessionId and t1.sessionId ~= "" then
		t2.session_id = t1.sessionId
	end

	local filterSelections = t1.filterSelections

	if filterSelections then
		if filterSelections.device and filterSelections.device ~= "" then
			t2.device = filterSelections.device
		end

		if filterSelections.country and filterSelections.country ~= "" then
			t2.country = filterSelections.country
		end

		if filterSelections.ageGroup and filterSelections.ageGroup ~= "" then
			t2.age_group = filterSelections.ageGroup
		end

		if filterSelections.selectedGenre and filterSelections.selectedGenre ~= "" then
			t2.selected_genre = filterSelections.selectedGenre
		end
	end

	if t1.cachedRobloxComponentToTemplateId then
		t2.cached_roblox_component_to_template_id = t1.cachedRobloxComponentToTemplateId
	end

	if t1.clientCapabilities then
		t2.client_capabilities = t1.clientCapabilities
	end

	return p1.GetChartsSortDetailRequest.new(t2)
end

return buildChartsSortDetailRequest

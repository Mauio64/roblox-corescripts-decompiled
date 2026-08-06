local Parent = script:FindFirstAncestor("Charts").Parent
local AddSystemInfoToArgs = require(Parent.DiscoveryUtils).AddSystemInfoToArgs
local buildSduiCollectionInfo = require(Parent.SduiSharedUtilities).buildSduiCollectionInfo
local FFlagSduiChartsRequestPlaceholders = require(Parent.SharedFlags).FFlagSduiChartsRequestPlaceholders
local uDim = UDim.new(1, 72)

local function buildChartsPageRequest(p1, t1: {[any]: any}?) -- line: 34
	-- upvalues: AddSystemInfoToArgs (copy), FFlagSduiChartsRequestPlaceholders (copy), buildSduiCollectionInfo (copy), uDim (copy)
	local t2 = {}
	local t3 = {}

	AddSystemInfoToArgs(t3, { "maxMemory" })

	if t3.maxMemory and t3.maxMemory ~= "" then
		t2.max_memory = t3.maxMemory
	end

	if t1 then
		if t1.feedPageToken and t1.feedPageToken ~= "" then
			t2.feed_page_token = t1.feedPageToken
		end

		if t1.sessionId and t1.sessionId ~= "" then
			t2.session_id = t1.sessionId
		end

		if t1.entryPaginationKey and t1.entryPaginationKey ~= "" then
			t2.entry_pagination_key = t1.entryPaginationKey
		end

		if t1.entryPageToken and t1.entryPageToken ~= "" then
			t2.entry_page_token = t1.entryPageToken
		end

		if t1.pageType and t1.pageType ~= "" then
			t2.page_type = t1.pageType
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
		end

		if FFlagSduiChartsRequestPlaceholders and t1.includePlaceholders then
			t2.include_placeholders = true
		end

		if t1.hydrationStreamEnabled ~= nil then
			t2.hydration_stream_enabled = t1.hydrationStreamEnabled
		end

		if t1.cachedRobloxComponentToTemplateId then
			t2.cached_roblox_component_to_template_id = t1.cachedRobloxComponentToTemplateId
		end

		if t1.clientCapabilities then
			t2.client_capabilities = t1.clientCapabilities
		end

		if t1.hydrationStreamEnabled then
			local v12 = buildSduiCollectionInfo("Small", uDim)

			t2.collection_layout = p1.CollectionLayoutInfo.new({
				items_per_row = v12.items_per_row,
				rows_above_fold = v12.rows_above_fold
			})
		end
	end

	return p1.GetChartsPageRequest.new(t2)
end

return buildChartsPageRequest

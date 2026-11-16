local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local AddSystemInfoToArgs = DiscoveryUtils.AddSystemInfoToArgs
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local buildSduiCollectionInfo = SduiSharedUtilities.buildSduiCollectionInfo
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets
local FFlagSduiChartsAudienceFilter = require(Charts.Flags.FFlagSduiChartsAudienceFilter)

local udim = UDim.new(1, 72)

local function buildChartsPageRequest(p, data)
	local v = {}

	local v2 = {}
	AddSystemInfoToArgs(v2, { "maxMemory" })

	if v2.maxMemory and v2.maxMemory ~= "" then
		v.max_memory = v2.maxMemory
	end

	if data then
		if data.feedPageToken and data.feedPageToken ~= "" then
			v.feed_page_token = data.feedPageToken
		end

		if data.sessionId and data.sessionId ~= "" then
			v.session_id = data.sessionId
		end

		if data.entryPaginationKey and data.entryPaginationKey ~= "" then
			v.entry_pagination_key = data.entryPaginationKey
		end

		if data.entryPageToken and data.entryPageToken ~= "" then
			v.entry_page_token = data.entryPageToken
		end

		if data.pageType and data.pageType ~= "" then
			v.page_type = data.pageType
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

			if FFlagSduiChartsAudienceFilter and filterSelections.audience and filterSelections.audience ~= "" then
				v.audience = filterSelections.audience
			end
		end

		if FFlagSduiChartsRequestPlaceholders and data.includePlaceholders then
			v.include_placeholders = true
		end

		if data.hydrationStreamEnabled ~= nil then
			v.hydration_stream_enabled = data.hydrationStreamEnabled
		end

		if data.cachedRobloxComponentToTemplateId then
			v.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
		end

		if data.clientCapabilities then
			v.client_capabilities = data.clientCapabilities
		end

		if data.hydrationStreamEnabled then
			local sduiCollectionInfo = buildSduiCollectionInfo(
				"Small",
				udim,
				FFlagSduiPreferredTextSizeLineBudgets and 3 or nil
			)

			v.collection_layout = p.CollectionLayoutInfo.new({
				items_per_row = sduiCollectionInfo.items_per_row,
				rows_above_fold = sduiCollectionInfo.rows_above_fold
			})
		end
	end

	return p.GetChartsPageRequest.new(v)
end

return buildChartsPageRequest

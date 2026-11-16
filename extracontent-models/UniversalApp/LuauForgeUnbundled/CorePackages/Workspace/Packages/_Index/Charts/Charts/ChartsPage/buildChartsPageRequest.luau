local addSystemInfoToArgs = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/DiscoveryUtils").AddSystemInfoToArgs
local buildSduiCollectionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities").buildSduiCollectionInfo
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SharedFlags")
local fFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders
local fFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets
local FFlagSduiChartsAudienceFilter = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/Flags/FFlagSduiChartsAudienceFilter")

local udim = UDim.new(1, 72)

local function buildChartsPageRequest(p2, data)
	local v5 = {}

	local v6 = {}
	addSystemInfoToArgs(v6, { "maxMemory" })

	if v6.maxMemory and v6.maxMemory ~= "" then
		v5.max_memory = v6.maxMemory
	end

	if data then
		if data.feedPageToken and data.feedPageToken ~= "" then
			v5.feed_page_token = data.feedPageToken
		end

		if data.sessionId and data.sessionId ~= "" then
			v5.session_id = data.sessionId
		end

		if data.entryPaginationKey and data.entryPaginationKey ~= "" then
			v5.entry_pagination_key = data.entryPaginationKey
		end

		if data.entryPageToken and data.entryPageToken ~= "" then
			v5.entry_page_token = data.entryPageToken
		end

		if data.pageType and data.pageType ~= "" then
			v5.page_type = data.pageType
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

			if FFlagSduiChartsAudienceFilter and filterSelections.audience and filterSelections.audience ~= "" then
				v5.audience = filterSelections.audience
			end
		end

		if fFlagSduiChartsRequestPlaceholders and data.includePlaceholders then
			v5.include_placeholders = true
		end

		if data.hydrationStreamEnabled ~= nil then
			v5.hydration_stream_enabled = data.hydrationStreamEnabled
		end

		if data.cachedRobloxComponentToTemplateId then
			v5.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
		end

		if data.clientCapabilities then
			v5.client_capabilities = data.clientCapabilities
		end

		if data.hydrationStreamEnabled then
			local sduiCollectionInfo = buildSduiCollectionInfo(
				"Small",
				udim,
				fFlagSduiPreferredTextSizeLineBudgets and 3 or nil
			)

			v5.collection_layout = p2.CollectionLayoutInfo.new({
				items_per_row = sduiCollectionInfo.items_per_row,
				rows_above_fold = sduiCollectionInfo.rows_above_fold
			})
		end
	end

	return p2.GetChartsPageRequest.new(v5)
end

return buildChartsPageRequest

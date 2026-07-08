local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)

local tryGetPathFromData = require(SduiCoreSystem.ClientBinding.tryGetPathFromData)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local SharedFlags = require(SduiCoreSystemParent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local FFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local FFlagSduiHydrationFetchIfMissing = SharedFlags.FFlagSduiHydrationFetchIfMissing
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagSduiRenderPerf = SharedFlags.FFlagSduiRenderPerf
local t1 = {
	[SduiDataBindingContentType.badge] = { "badge_id" },
	[SduiDataBindingContentType.creator] = { "creator_key" },
	[SduiDataBindingContentType.universe] = { "universe_id" },
	[SduiDataBindingContentType.ageRecommendation] = if not FFlagSduiExperienceDetailsSupport then nil else { "universe_id" },
	[SduiDataBindingContentType.socialLink] = if not FFlagSduiExperienceDetailsSupport then nil else { "social_link_id" },
	[SduiDataBindingContentType.marketplaceCatalogCategory] = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else { "marketplace_catalog_category_item_id" },
	[SduiDataBindingContentType.song] = { "song_id" },
	[SduiDataBindingContentType.marketplaceCatalogSort] = if not FFlagSduiMarketplaceCatalogSortSupport then nil else { "catalog_sort_id" },
	[SduiDataBindingContentType.gamePass] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else { "game_pass_id" },
	[SduiDataBindingContentType.gameDeveloperProduct] = if not FFlagSduiDevStoreSeeAllSupport then nil else { "developer_product_id" },
	[SduiDataBindingContentType.gameSubscription] = if not FFlagSduiDevStoreSeeAllSupport then nil else { "subscription_id" },
	[SduiDataBindingContentType.playability] = if not FFlagSduiExperienceDetailsSupport then nil else { "universe_id" },
	[SduiDataBindingContentType.universeUserVoteFeedbackMetadata] = if not FFlagSduiExperienceDetailsSupport then nil else { "root_place_id" },
	[SduiDataBindingContentType.userProfile] = if not FFlagSduiExperienceDetailsSupport then nil else { "user_id" }
}

local function buildDataBindingSourcesForTemplate(t2: {[any]: any}, t3: {[any]: any}) -- line: 102
	-- upvalues: ProtoVariableMapper (copy), FFlagSduiRenderPerf (copy), splitDottedPath (copy), tryGetPathFromData (copy), t1 (copy), FFlagSduiHydrationFetchIfMissing (copy)
	local t4 = {}

	for _, v20 in t3 do
		local v21 = ProtoVariableMapper.mapHydrationContentTypeToLua(v20.content_type)

		if not v21 then
			error(`Unsupported contentType { v20.content_type }`)
		end

		local v22 = v20.id_binding and (v20.id_binding.kind and v20.id_binding.kind.type)
		local v23 = v20.id_binding and (v20.id_binding.kind and v20.id_binding.kind.value)
		local v24 = nil

		if v22 == "literal" and v23 then
			v24 = v23
		elseif v22 == "input_path" and v23 then
			local v25 = if not FFlagSduiRenderPerf then string.split(v23, ".") else splitDottedPath(v23)
			local v26, v27 = tryGetPathFromData(t2, v25)

			if v26 and v27 ~= nil then
				v24 = v27
			else
				error(`Unable to resolve path from inputPath: { v23 } in data`)
			end
		else
			local v28 = t1[v21]

			if v28 then
				local v29, v30 = tryGetPathFromData(t2, v28)

				if v29 and v30 ~= nil then
					v24 = v30
				else
					local v31 = table.concat(v28, ",")

					error(`Unable to resolve default path: { v31 } in data for contentType { v21 }`)
				end
			else
				error(`Unable to find default for unknown contentType: { v21 }`)
			end
		end

		t4[if not v20.alias or v20.alias == "" then v21 else v20.alias] = {
			contentType = v21,
			id = v24,
			fetchIfMissing = if not FFlagSduiHydrationFetchIfMissing then nil else v20.client_fetch
		}
	end

	return t4
end

return buildDataBindingSourcesForTemplate

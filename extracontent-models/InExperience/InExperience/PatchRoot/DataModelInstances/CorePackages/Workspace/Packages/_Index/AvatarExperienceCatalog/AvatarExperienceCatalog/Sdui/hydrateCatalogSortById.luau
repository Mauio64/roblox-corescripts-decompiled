local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
require(parent.AvatarExperienceRodux)
local DataHydration = require(parent.DataHydration)
local Promise = require(parent.Promise)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
require(parent.Http)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)
local collectDedupedHydrationContent = require(AvatarExperienceCatalog.Sdui.Utils.collectDedupedHydrationContent)
local buildHydrationReduxPayload = require(AvatarExperienceCatalog.Sdui.Utils.buildHydrationReduxPayload)

local function hydrateCatalogSortById(callback, p, callback2, p2, p3: string, p4)
	local marketplaceCatalogSort = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(p3)
	local v

	if marketplaceCatalogSort and marketplaceCatalogSort.data then
		v = marketplaceCatalogSort.data(false)
	end

	if not (v and v.content) then
		return Promise.resolve()
	end

	local v2 = {}
	collectDedupedHydrationContent(v.content, v2, {}, nil)
	local v3

	if p4 then
		v3 = {}

		for _, v4 in v2 do
			local v5 = p4[tostring(v4.type)]

			if not (v5 and v5[tostring(v4.id)]) then
				table.insert(v3, v4)
			end
		end
	else
		v3 = v2
	end

	if #v3 == 0 then
		return Promise.resolve()
	end

	return p2.HydrateWidgetContent(p, v3):andThen(function(p5)
		local responseBody

		if p5 then
			responseBody = p5.responseBody
		end

		local hydratedContent

		if responseBody then
			hydratedContent = responseBody.hydratedContent
		end

		if hydratedContent == nil then
			return
		end

		callback(callback2((buildHydrationReduxPayload(hydratedContent, v3))))
	end):catch(function(p5)
		Logging.warn("hydrateCatalogSortById: HydrateWidgetContent failed for sort " .. p3 .. ": " .. tostring(p5))
	end)
end

return hydrateCatalogSortById

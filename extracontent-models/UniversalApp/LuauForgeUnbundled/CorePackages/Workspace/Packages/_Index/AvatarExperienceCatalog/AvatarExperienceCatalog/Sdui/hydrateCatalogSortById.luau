require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/DataHydration")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib").Logging
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local collectDedupedHydrationContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/collectDedupedHydrationContent")
local buildHydrationReduxPayload = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/buildHydrationReduxPayload")

local function hydrateCatalogSortById(callback, p2, callback2, p3, p4, p5)
	local marketplaceCatalogSort = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(p4)
	local v5

	if marketplaceCatalogSort and marketplaceCatalogSort.data then
		v5 = marketplaceCatalogSort.data(false)
	end

	if not (v5 and v5.content) then
		return Promise.resolve()
	end

	local v6 = {}
	collectDedupedHydrationContent(v5.content, v6, {}, nil)
	local v7

	if p5 then
		v7 = {}

		for k, v8 in v6 do
			local v9 = p5[tostring(v8.type)]

			if not (v9 and v9[tostring(v8.id)]) then
				table.insert(v7, v8)
			end
		end
	else
		v7 = v6
	end

	if #v7 == 0 then
		return Promise.resolve()
	end

	return p3.HydrateWidgetContent(p2, v7):andThen(function(p6)
		local responseBody = if p6 then p6.responseBody else nil
		local hydratedContent = if responseBody then responseBody.hydratedContent else nil

		if hydratedContent == nil then
			return
		end

		callback(callback2((buildHydrationReduxPayload(hydratedContent, v7))))
	end):catch(function(p6)
		logging.warn("hydrateCatalogSortById: HydrateWidgetContent failed for sort " .. p4 .. ": " .. tostring(p6))
	end)
end

return hydrateCatalogSortById

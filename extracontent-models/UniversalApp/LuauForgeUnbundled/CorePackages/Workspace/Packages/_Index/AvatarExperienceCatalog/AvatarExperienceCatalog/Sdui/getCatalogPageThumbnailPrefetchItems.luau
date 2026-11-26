local buildOrderedWidgetsFromCatalogPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/buildOrderedWidgetsFromCatalogPage")
local collectDedupedHydrationContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/collectDedupedHydrationContent")
local getCatalogConfigKey = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogConfigKey")
local getCatalogPageIdentifier = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogPageIdentifier")
local GetAXMarketplaceWidgetStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetAXMarketplaceWidgetStore")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local function getCatalogPageThumbnailPrefetchItems(p2, p3, p4)
	local v5 = buildOrderedWidgetsFromCatalogPage(getCatalogConfigKey(p2, (GetAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false))), getCatalogPageIdentifier(p2))
	local count = 0
	local catalogPageThumbnailPrefetchItems = {}
	local v6 = {}

	for k, v7 in v5 do
		if p3 <= count then
			break
		end

		if #v7.content == 0 then
			continue
		end

		collectDedupedHydrationContent(v7.content, catalogPageThumbnailPrefetchItems, v6, p4)
		count += 1
	end

	return catalogPageThumbnailPrefetchItems
end

return getCatalogPageThumbnailPrefetchItems

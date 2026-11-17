local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local buildOrderedWidgetsFromCatalogPage = require(AvatarExperienceCatalog.Sdui.buildOrderedWidgetsFromCatalogPage)
local collectDedupedHydrationContent = require(AvatarExperienceCatalog.Sdui.Utils.collectDedupedHydrationContent)
local getCatalogConfigKey = require(AvatarExperienceCatalog.Sdui.Utils.getCatalogConfigKey)
local getCatalogPageIdentifier = require(AvatarExperienceCatalog.Sdui.Utils.getCatalogPageIdentifier)
local GetAXMarketplaceWidgetStore = require(AvatarExperienceCatalog.Stores.GetAXMarketplaceWidgetStore)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function getCatalogPageThumbnailPrefetchItems(p: string, p2: number, p3: number)
	local orderedWidgetsFromCatalogPage = buildOrderedWidgetsFromCatalogPage(
		getCatalogConfigKey(p, (GetAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false))),
		getCatalogPageIdentifier(p)
	)
	local count = 0
	local catalogPageThumbnailPrefetchItems = {}
	local v = {}

	for _, v2 in orderedWidgetsFromCatalogPage do
		if p2 <= count then
			break
		end

		if #v2.content == 0 then
			continue
		end

		collectDedupedHydrationContent(v2.content, catalogPageThumbnailPrefetchItems, v, p3)
		count += 1
	end

	return catalogPageThumbnailPrefetchItems
end

return getCatalogPageThumbnailPrefetchItems

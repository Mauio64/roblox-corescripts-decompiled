local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local HttpService = game:GetService("HttpService")
local DataHydration = require(AvatarExperienceCatalogParent.DataHydration)
local Logging = require(AvatarExperienceCatalogParent.AppCommonLib).Logging

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function mapCardFootersToItemFooters(t1: {[any]: any}?) -- line: 43
	if not t1 then
		return nil
	end

	local t2 = {}

	for _, v13 in t1 do
		table.insert(t2, {
			contentType = v13.contentType
		})
	end

	return t2
end
local function mapCardStyle(t3: {[any]: any}?) -- line: 54
	if not t3 then
		return nil
	end

	return {
		thumbnailAspectRatio = t3.thumbnailAspectRatio
	}
end
local function buildTemplate(p1, t4: {[any]: any}) -- line: 66
	-- upvalues: mapCardFootersToItemFooters (copy)
	local v17 = t4.title or p1.title
	local v18 = t4.description or p1.description
	local t5 = {
		type = "ItemGroup",
		title = nil,
		description = nil,
		localizedTitle = v17,
		localizedDescription = v18,
		itemFooters = mapCardFootersToItemFooters(p1.cardFooters)
	}
	local cardStyle = p1.cardStyle

	t5.cardStyle = if cardStyle then {
		thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	} else nil
	t5.previewColumns = if not p1.previewColumns then nil else {
		default = p1.previewColumns
	}
	t5.previewRows = {
		default = 1
	}

	return t5
end
local function buildFocusedSortWidgetInfo(s1: string, s2: string, t6: {[any]: any}) -- line: 88
	-- upvalues: Logging (copy), DataHydration (copy), buildTemplate (copy), HttpService (copy)
	if s1 == nil or s1 == "" then
		Logging.warn("buildFocusedSortWidgetInfo: missing sortId; bailing")

		return nil
	end

	if s2 == nil or s2 == "" then
		Logging.warn("buildFocusedSortWidgetInfo: missing context for sortId=" .. s1 .. "; bailing")

		return nil
	end

	local v24 = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(s1)
	local v25 = if not v24 or not v24.data then nil else v24.data(false)

	if not v25 then
		Logging.warn("buildFocusedSortWidgetInfo: sort not in cache for sortId=" .. s1 .. " context=" .. s2)

		return nil
	end

	return {
		widgetInfo = {
			[s2] = {
				id = s1,
				type = v25.type,
				content = v25.content,
				template = buildTemplate(v25, t6),
				tagId = v25.tagId
			}
		},
		requestId = HttpService:GenerateGUID(true)
	}
end

return buildFocusedSortWidgetInfo

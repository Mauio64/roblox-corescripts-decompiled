local HttpService = game:GetService("HttpService")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/DataHydration")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib").Logging

local fFlagSduiMarketplaceCatalogSortSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagSduiMarketplaceCatalogSortSupport
local fFlagAXSduiSeeAllPageRequestId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXSduiSeeAllPageRequestId

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")

local function mapCardFootersToItemFooters(cardFooters)
	if not cardFooters then
		return nil
	end

	local result = {}

	for k, item in cardFooters do
		table.insert(result, { contentType = item.contentType })
	end

	return result
end

local function mapCardStyle(p2)
	if p2 then
		return { thumbnailAspectRatio = p2.thumbnailAspectRatio }
	end

	return nil
end

local function buildTemplate(data, p2)
	local template = {
		type = "ItemGroup",
		title = nil,
		localizedTitle = p2.title or data.title,
		description = nil,
		localizedDescription = p2.description or data.description,
		itemFooters = mapCardFootersToItemFooters(data.cardFooters),
		cardStyle = 0,
		previewColumns = 0,
		previewRows = 0
	}
	local cardStyle = data.cardStyle
	template.cardStyle = cardStyle and {
		thumbnailAspectRatio = cardStyle.thumbnailAspectRatio
	} or nil
	template.previewColumns = data.previewColumns and { default = data.previewColumns } or nil
	template.previewRows = { default = 1 }
	return template
end

local function buildFocusedSortWidgetInfo(p2, p3, p4, requestId)
	if p2 == nil or p2 == "" then
		logging.warn("buildFocusedSortWidgetInfo: missing sortId; bailing")
		return nil
	end

	if p3 == nil or p3 == "" then
		logging.warn("buildFocusedSortWidgetInfo: missing context for sortId=" .. p2 .. "; bailing")
		return nil
	end

	local marketplaceCatalogSortStore = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false)
	local v5

	if fFlagSduiMarketplaceCatalogSortSupport then
		v5 = marketplaceCatalogSortStore.getNormalizedMarketplaceCatalogSort(p2)
	else
		v5 = marketplaceCatalogSortStore.getMarketplaceCatalogSort(p2)
	end

	local v6 = if v5 and v5.data then v5.data(false) else nil

	if not v6 then
		logging.warn("buildFocusedSortWidgetInfo: sort not in cache for sortId=" .. p2 .. " context=" .. p3)
		return nil
	end

	local v7 = {
		widgetInfo = {
			[p3] = {
				id = p2,
				type = v6.type,
				content = v6.content,
				template = buildTemplate(v6, p4),
				tagId = v6.tagId
			}
		},
		requestId = 0
	}

	if not fFlagAXSduiSeeAllPageRequestId or requestId == nil or requestId == "" then
		requestId = HttpService:GenerateGUID(true)
	end

	v7.requestId = requestId
	return v7
end

return buildFocusedSortWidgetInfo

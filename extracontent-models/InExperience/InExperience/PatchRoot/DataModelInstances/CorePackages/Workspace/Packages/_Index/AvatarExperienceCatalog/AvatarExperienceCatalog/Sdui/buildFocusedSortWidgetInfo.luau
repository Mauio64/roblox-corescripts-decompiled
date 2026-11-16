local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local HttpService = game:GetService("HttpService")

local DataHydration = require(parent.DataHydration)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiSeeAllPageRequestId = AvatarExperienceFlags.FFlagAXSduiSeeAllPageRequestId

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function mapCardFootersToItemFooters(cardFooters)
	if not cardFooters then
		return nil
	end

	local result = {}

	for _, item in cardFooters do
		table.insert(result, { contentType = item.contentType })
	end

	return result
end

local function mapCardStyle(cardStyle) -- 1 equivalent call inferred from this helper
	if cardStyle then
		return { thumbnailAspectRatio = cardStyle.thumbnailAspectRatio }
	end

	return nil
end

local function buildTemplate(data, p)
	return {
		type = "ItemGroup",
		title = nil,
		localizedTitle = p.title or data.title,
		description = nil,
		localizedDescription = p.description or data.description,
		itemFooters = mapCardFootersToItemFooters(data.cardFooters),
		cardStyle = mapCardStyle(data.cardStyle), -- inferred equivalent call
		previewColumns = data.previewColumns and { default = data.previewColumns } or nil,
		previewRows = { default = 1 }
	}
end

local function buildFocusedSortWidgetInfo(id: string, p: string, p2, requestId: string?)
	if id == nil or id == "" then
		Logging.warn("buildFocusedSortWidgetInfo: missing sortId; bailing")
		return nil
	end

	if p == nil or p == "" then
		Logging.warn("buildFocusedSortWidgetInfo: missing context for sortId=" .. id .. "; bailing")
		return nil
	end

	local marketplaceCatalogSortStore = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false)
	local v

	if FFlagSduiMarketplaceCatalogSortSupport then
		v = marketplaceCatalogSortStore.getNormalizedMarketplaceCatalogSort(id)
	else
		v = marketplaceCatalogSortStore.getMarketplaceCatalogSort(id)
	end

	local v2

	if v and v.data then
		v2 = v.data(false)
	end

	if not v2 then
		Logging.warn("buildFocusedSortWidgetInfo: sort not in cache for sortId=" .. id .. " context=" .. p)
		return nil
	end

	local v3 = {
		widgetInfo = {
			[p] = {
				id = id,
				type = v2.type,
				content = v2.content,
				template = buildTemplate(v2, p2),
				tagId = v2.tagId
			}
		},
		requestId = 0
	}

	if not FFlagAXSduiSeeAllPageRequestId or requestId == nil or requestId == "" then
		requestId = HttpService:GenerateGUID(true)
	end

	v3.requestId = requestId
	return v3
end

return buildFocusedSortWidgetInfo

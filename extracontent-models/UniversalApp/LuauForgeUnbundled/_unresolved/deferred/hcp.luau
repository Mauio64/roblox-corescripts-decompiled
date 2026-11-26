local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/dPN")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module3 = require("@luauforge/deferred/hbA")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module4 = require("@luauforge/bundled/dAB")
local clearTryOns = require("@luauforge/bundled/dKU").Actions.ClearTryOns
require("@luauforge/bundled/dKT")

local unifiedLoggingSectionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.UnifiedLoggingSectionEnums

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging

local fFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions
local fFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local fFlagAXRecommendedItemsUnifiedSelectParity = AvatarExperienceFlags.FFlagAXRecommendedItemsUnifiedSelectParity
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local extended = Roact.PureComponent:extend("RecommendedItemCard")

function extended.didUpdate(p2, p3)
	local getRecommendedItems = p2.props.getRecommendedItems
	local clearTryOns2 = p2.props.clearTryOns

	if p3.purchasingStatus == module4.Fetching and p2.props.purchasingStatus == module4.Done then
		getRecommendedItems()
		clearTryOns2()
	end
end

function extended.render(p2)
	local itemId = p2.props.itemId
	local itemType = p2.props.itemType
	local index = p2.props.index
	local itemDetailsPeekViewRefs = p2.props.itemDetailsPeekViewRefs
	local resultsListRef = p2.props.resultsListRef
	local impressionsTag = if fFlagAXRecommendedItemsImpressionExposureLogging then p2.props.impressionsTag else nil
	local impressionsCategory

	if
		fFlagAXRecommendedItemsImpressionExposureLogging
		or fFlagAXEditorRecommendedItemsUnifiedImpressions
	then
		impressionsCategory = p2.props.impressionsCategory
	end

	local enableUnifiedImpressions

	if fFlagAXEditorRecommendedItemsUnifiedImpressions then
		enableUnifiedImpressions = p2.props.enableUnifiedImpressions
	end

	local v5 = if fFlagAXAvatarTabLooksYouMayAlsoLike then itemType == module2.ItemType.Look else nil
	local v6

	if fFlagAXRecommendedItemsUnifiedSelectParity then
		v6 = fFlagAXUnifiedImpressionsOnThumbnail and fFlagAXEditorRecommendedItemsUnifiedImpressions

		if v6 then
			v6 = enableUnifiedImpressions == nil and not (impressionsTag or v5)
		end
	end

	local createElement = Roact.createElement
	local v8 = {
		itemId = itemId,
		itemType = itemType,
		index = index,
		analyticsItemCountPerPage = module2.NumRecommendedItems,
		analyticsContext = module.AnalyticsContext.AvatarEditorRecommendedItem,
		itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
		resultsListRef = resultsListRef,
		isTitleVisible = true,
		isPriceVisible = true,
		gridInformation = p2.props.gridInformation,
		impressionsTag = if fFlagAXRecommendedItemsImpressionExposureLogging then impressionsTag else nil,
		impressionsCategory = 0,
		section = 0,
		skipUnifiedImpressions = 0,
		impressionsId = 0,
		impressionsSchema = 0,
		isOrganic = 0,
		lookData = 0,
		thumbailAspectRatio = 0,
		thumbnailSize = 0
	}

	if not (fFlagAXRecommendedItemsImpressionExposureLogging or fFlagAXEditorRecommendedItemsUnifiedImpressions) then
		impressionsCategory = nil
	end

	v8.impressionsCategory = impressionsCategory
	local RECOMMENDED_ITEMS

	if fFlagAXEditorRecommendedItemsUnifiedImpressions and enableUnifiedImpressions then
		RECOMMENDED_ITEMS = unifiedLoggingSectionEnums.RECOMMENDED_ITEMS
	elseif fFlagAXRecommendedItemsUnifiedSelectParity and v6 then
		RECOMMENDED_ITEMS = unifiedLoggingSectionEnums.RECOMMENDED_ITEMS
	end

	v8.section = RECOMMENDED_ITEMS

	v8.skipUnifiedImpressions = fFlagAXRecommendedItemsUnifiedSelectParity and v6 and true or nil

	local v10 = if fFlagAXRecommendedItemsImpressionExposureLogging and impressionsTag then tostring(itemId) else nil
	v8.impressionsId = v10

	v8.impressionsSchema = fFlagAXRecommendedItemsImpressionExposureLogging
		and impressionsTag
		and "defaultItem"
		or nil
	local v11

	if
		fFlagAXRecommendedItemsImpressionExposureLogging and impressionsTag
		or fFlagAXEditorRecommendedItemsUnifiedImpressions and enableUnifiedImpressions
		or fFlagAXRecommendedItemsUnifiedSelectParity and v6
	then
		v11 = true
	elseif fFlagAXAvatarTabLooksYouMayAlsoLike then
		v11 = v5
	end

	v8.isOrganic = v11

	local v12 = if fFlagAXAvatarTabLooksYouMayAlsoLike and v5 then p2.props.lookData else nil
	v8.lookData = v12

	local v13 = if fFlagAXAvatarTabLooksYouMayAlsoLike and v5 then module2.LookTileAspectRatio else nil
	v8.thumbailAspectRatio = v13

	v8.thumbnailSize = fFlagAXAvatarTabLooksYouMayAlsoLike and v5 and "w=300&h=450" or nil
	return createElement(module3, v8)
end

local function mapStateToProps(p2, p3)
	local v5 = itemData(p2.AvatarExperience.Common, p3.itemId, p3.itemType)
	local id = v5 and v5.product and tostring(v5.product.id) or ""

	local v6 = if id then performFetch.GetStatus(p2, module.PurchaseProductKey .. id) else nil
	local v7

	if fFlagAXAvatarTabLooksYouMayAlsoLike and p3.itemType == module2.ItemType.Look then
		local look = p2.AvatarExperience.Common.Widgets.HydratedWidgetData.Look
		v7 = look and look[p3.itemId]
	end

	if not fFlagAXAvatarTabLooksYouMayAlsoLike then
		v7 = nil
	end

	return { purchasingStatus = v6, lookData = v7 }
end

local function mapDispatchToProps(callback)
	return {
		clearTryOns = function()
			callback(clearTryOns())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

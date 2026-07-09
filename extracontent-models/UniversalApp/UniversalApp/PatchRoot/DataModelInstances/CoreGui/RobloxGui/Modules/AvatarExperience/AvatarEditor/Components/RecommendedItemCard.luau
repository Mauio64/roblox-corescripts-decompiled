local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogItemCardContainer = require(Modules.AvatarExperience.Catalog.Components.ItemsList.CatalogItemCardContainer)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local FFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local v16 = Roact.PureComponent:extend("RecommendedItemCard")

function v16.didUpdate(p1, p2) -- line: 31
	-- upvalues: RetrievalStatus (copy)
	local getRecommendedItems = p1.props.getRecommendedItems
	local clearTryOns = p1.props.clearTryOns

	if p2.purchasingStatus == RetrievalStatus.Fetching and p1.props.purchasingStatus == RetrievalStatus.Done then
		getRecommendedItems()
		clearTryOns()
	end
end
function v16.render(p3) -- line: 44
	-- upvalues: FFlagAXRecommendedItemsImpressionExposureLogging (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), Constants (copy), Roact (copy), CatalogItemCardContainer (copy), CatalogConstants (copy)
	local itemId = p3.props.itemId
	local itemType = p3.props.itemType
	local index = p3.props.index
	local itemDetailsPeekViewRefs = p3.props.itemDetailsPeekViewRefs
	local resultsListRef = p3.props.resultsListRef
	local v29 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else p3.props.impressionsTag
	local v30 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else p3.props.impressionsCategory
	local v31 = if not FFlagAXAvatarTabLooksYouMayAlsoLike then nil else itemType == Constants.ItemType.Look

	return Roact.createElement(CatalogItemCardContainer, {
		isTitleVisible = true,
		isPriceVisible = true,
		itemId = itemId,
		itemType = itemType,
		index = index,
		analyticsItemCountPerPage = Constants.NumRecommendedItems,
		analyticsContext = CatalogConstants.AnalyticsContext.AvatarEditorRecommendedItem,
		itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
		resultsListRef = resultsListRef,
		gridInformation = p3.props.gridInformation,
		impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v29,
		impressionsCategory = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v30,
		impressionsId = if not FFlagAXRecommendedItemsImpressionExposureLogging or not v29 then nil else tostring(itemId),
		impressionsSchema = if not FFlagAXRecommendedItemsImpressionExposureLogging or not v29 then nil else "defaultItem",
		isOrganic = FFlagAXRecommendedItemsImpressionExposureLogging and not not v29 or if not FFlagAXAvatarTabLooksYouMayAlsoLike then nil else v31,
		lookData = if not FFlagAXAvatarTabLooksYouMayAlsoLike or not v31 then nil else p3.props.lookData,
		thumbailAspectRatio = if not FFlagAXAvatarTabLooksYouMayAlsoLike or not v31 then nil else Constants.LookTileAspectRatio,
		thumbnailSize = if not FFlagAXAvatarTabLooksYouMayAlsoLike or not v31 then nil else "w=300&h=450"
	})
end

local function mapStateToProps(p4, p5) -- line: 87
	-- upvalues: ItemData (copy), PerformFetch (copy), CatalogConstants (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), Constants (copy)
	local v34 = ItemData(p4.AvatarExperience.Common, p5.itemId, p5.itemType)
	local v35 = v34 and (not not v34.product and tostring(v34.product.id)) or ""
	local v36 = nil

	if v35 then
		v36 = PerformFetch.GetStatus(p4, CatalogConstants.PurchaseProductKey .. v35)
	end

	local v37 = nil

	if FFlagAXAvatarTabLooksYouMayAlsoLike and p5.itemType == Constants.ItemType.Look then
		local Look = p4.AvatarExperience.Common.Widgets.HydratedWidgetData.Look

		v37 = Look and Look[p5.itemId]
	end

	return {
		purchasingStatus = v36,
		lookData = if not FFlagAXAvatarTabLooksYouMayAlsoLike then nil else v37
	}
end
local function mapDispatchToProps(p6) -- line: 109
	-- upvalues: ClearTryOns (copy)
	return {
		clearTryOns = function() -- line: 111
			-- upvalues: p6 (copy), ClearTryOns (copy)
			p6(ClearTryOns())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v16)

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

require("@luauforge/bundled/dPs")

local useStore = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useStore

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dPt")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local getCatalogItemUnifiedLoggingFields = AvatarExperienceAnalytics.Utils.getCatalogItemUnifiedLoggingFields
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXSponsoredItemsWidgetUnifiedLogging = AvatarExperienceFlags.FFlagAXSponsoredItemsWidgetUnifiedLogging

local fFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions
local fFlagAXRecommendedItemsUnifiedSelectParity = AvatarExperienceFlags.FFlagAXRecommendedItemsUnifiedSelectParity

local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local function useCatalogItemCardUnifiedLogging(data)
	local v5 = useStore()

	local useCallback = React.useCallback
	local function fn(p2, skipImpressionDetection)
		local v6

		if v5 and data.itemType and data.itemId then
			local widgets = v5:getState().AvatarExperience.Common.Widgets
			local v7

			if widgets and widgets.HydratedWidgetData then
				v7 = widgets.HydratedWidgetData[data.itemType]
			end

			if v7 then
				v6 = v7[data.itemId]
			end
		end

		local v7 = fFlagAXSponsoredItemsWidgetUnifiedLogging
			and v6 == nil
			and data.fallbackHydratedContentPrice ~= nil
			and { price = data.fallbackHydratedContentPrice }
			or v6

		local v9 = {
			itemType = data.itemType,
			itemId = data.itemId,
			itemData = data.itemData,
			lookData = data.lookData,
			hydratedContent = v7,
			widgetAnalyticsInfo = data.widgetAnalyticsInfo,
			isOrganic = data.isOrganic,
			isSelected = data.isSelected,
			assetAndBundleIds = data.assetAndBundleIds,
			gridPositionRow = data.gridPositionRow,
			gridPositionColumn = data.gridPositionColumn,
			itemPosition = 0,
			impressionsCategory = 0,
			impressionsSubcategory = 0,
			impressionsTaxonomyId = 0,
			section = 0
		}

		local v10 = if data.isOrganic then data.index else nil
		v9.itemPosition = v10
		v9.impressionsCategory = data.impressionsCategory
		v9.impressionsSubcategory = data.impressionsSubcategory
		v9.impressionsTaxonomyId = data.impressionsTaxonomyId
		local v11 = if fFlagAXEditorRecommendedItemsUnifiedImpressions then data.section else nil
		v9.section = v11
		local joined = getCatalogItemUnifiedLoggingFields(v9)

		if not joined then
			return
		end

		if skipImpressionDetection then
			local v12 = {}

			if data.index ~= nil then
				v12.selectedItemIndex = data.index
			end

			local v13

			if data.impressionsSearch == nil or data.impressionsSearch == "" then
				if not (data.searchKeyword == nil or data.searchKeyword == "") then
					v13 = data.searchKeyword
				end
			else
				v13 = data.impressionsSearch
			end

			if
				v13 ~= nil
				and unifiedLoggingSurface
				and getUnifiedLoggingSurface(data.avatarRoute) == unifiedLoggingSurface.SEARCH_RESULTS
			then
				v12.keyword = v13
			end

			if next(v12) ~= nil then
				joined = Cryo.Dictionary.join(joined, v12)
			end
		end

		local v14 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then data.isSelected else nil
		addUnifiedEventLogging(p2, joined, {
			hasDeferredActions = true,
			isSelected = v14,
			sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME,
			skipImpressionDetection = skipImpressionDetection
		})
	end
	local v6 = {
		data.widgetAnalyticsInfo,
		v5,
		data.isOrganic,
		data.itemId,
		data.itemType,
		data.itemData,
		data.gridPositionRow,
		data.gridPositionColumn,
		data.isSelected,
		data.impressionsCategory,
		data.impressionsSubcategory,
		data.impressionsTaxonomyId,
		data.assetAndBundleIds,
		data.lookData,
		data.index,
		data.impressionsSearch,
		nil,
		nil,
		nil,
		nil
	}
	local searchKeyword = data.searchKeyword
	local section = if fFlagAXEditorRecommendedItemsUnifiedImpressions then data.section else nil
	local avatarRoute = data.avatarRoute
	local v7 = if fFlagAXSponsoredItemsWidgetUnifiedLogging then data.fallbackHydratedContentPrice else nil
	v6[17], v6[18], v6[19], v6[20] = searchKeyword, section, avatarRoute, v7
	local v8 = useCallback(fn, v6)

	local useCallback2 = React.useCallback
	local function fn2(current)
		data.thumbnailRef.current = current

		if fFlagAXRecommendedItemsUnifiedSelectParity and data.skipThumbnailTagging then
			return
		end

		if current then
			v8(data.thumbnailRef)
		end
	end

	local thumbnailRef = data.thumbnailRef
	local v10 = if fFlagAXRecommendedItemsUnifiedSelectParity then data.skipThumbnailTagging else nil
	local v11 = useCallback2(fn2, { v8, thumbnailRef, v10 })

	local useEffect = React.useEffect
	local function fn3()
		if fFlagAXRecommendedItemsUnifiedSelectParity and data.skipThumbnailTagging then
			return
		end

		v8(data.thumbnailRef, nil)
	end

	local hydratedContentPrice = data.hydratedContentPrice
	local thumbnailRef2 = data.thumbnailRef
	local v13 = if fFlagAXRecommendedItemsUnifiedSelectParity then data.skipThumbnailTagging else nil
	useEffect(fn3, { v8, hydratedContentPrice, thumbnailRef2, v13 })

	return { applyUnifiedEventLoggingToRef = v8, assignThumbnailRef = v11 }
end

return useCatalogItemCardUnifiedLogging

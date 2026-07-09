local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.useOutfitSwitcherFrameProps)

local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local AvatarSwitcherScrollingContent = require(Modules.AvatarExperience.AvatarSwitcher.AvatarSwitcherScrollingContent)
local AvatarTileContainer = require(Modules.AvatarExperience.AvatarSwitcher.AvatarTile.AvatarTileContainer)
local v14 = if not FFlagAXOutfitPageRevamp then require(Modules.AvatarExperience.AvatarSwitcher.SettingsTile.SettingsTileContainer) else require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherSettingsTile.SettingsTileContainer)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local LoadMoreButton = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.LoadMoreButton)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local useCategoryInfo = require(Modules.AvatarExperience.Common.Hooks.useCategoryInfo)
local EmptyPage = require(Modules.AvatarExperience.AvatarEditor.Components.EmptyPage)
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local FFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local FFlagAXFixEmptyMakeupLooks = AvatarExperienceFlags.FFlagAXFixEmptyMakeupLooks
local v25 = game:DefineFastFlag("AXOutfitSwitcherImpressionLogging", false) and FFlagAXRecommendedItemsImpressionExposureLogging

local function OutfitSwitcherFrame(p1) -- line: 48
	-- upvalues: Foundation (copy), RoactGamepad (copy), React (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), useCategoryInfo (copy), Responsive (copy), v14 (copy), FFlagAXOutfitPageRevamp (copy), AvatarTileContainer (copy), FFlagAXFixEmptyMakeupLooks (copy), AvatarSwitcherScrollingContent (copy), Grid (copy), EmptyPage (copy), Constants (copy), RecommendedItems (copy), OrganicEventImpressionsReporter (copy), v25 (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy), TagBasedImpressionsDetector (copy), LoadMoreButton (copy)
	local v28 = Foundation.Hooks.useTokens()
	local v29 = RoactGamepad.useRefCache()
	local v30 = React.useRef(nil)
	local v31 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else React.useRef(nil)
	local v32 = if not FFlagAXRecommendedItemsImpressionExposureLogging then React.useRef(nil) else nil
	local v33 = useCategoryInfo()
	local v34 = Responsive.useOrientation() == Responsive.Keys.Portrait
	local v35 = React.useCallback(function(p2) -- line: 60
		-- upvalues: p1 (copy), React (copy), v14 (copy), FFlagAXOutfitPageRevamp (copy), v29 (copy), AvatarTileContainer (copy)
		local item = p2.item

		if p1.shouldRenderSettingsTile(item) then
			return (React.createElement(v14, {
				squareAspectRatio = true,
				itemWidth = p1.gridMetrics.itemWidth,
				index = p2.index,
				outfitType = if not FFlagAXOutfitPageRevamp then nil else p1.outfitType,
				ref = v29[p2.index]
			}))
		end

		return React.createElement(AvatarTileContainer, {
			impressionsSchema = "defaultItem",
			squareAspectRatio = true,
			itemWidth = p1.gridMetrics.itemWidth,
			itemId = item,
			index = p2.index,
			ref = v29[p2.index],
			isSelected = p1.itemIdsToIsWearing[item],
			hasItemFromCurrentPageEquipped = p1.hasItemFromCurrentPageEquipped,
			impressionsTag = p1.impressionsTag,
			gridInformation = p2.gridInformation
		})
	end, {
		v29,
		p1.gridMetrics,
		p1.itemIdsToIsWearing,
		p1.shouldRenderSettingsTile,
		p1.hasItemFromCurrentPageEquipped,
		p1.impressionsTag,
		if not FFlagAXOutfitPageRevamp then nil else p1.outfitType
	})
	local v36 = if not FFlagAXFixEmptyMakeupLooks then nil else React.useCallback(function(p3) -- line: 97
		return p3
	end, {})

	return React.createElement(AvatarSwitcherScrollingContent, {
		onThresholdReached = p1.onScrollingFrameThresholdReached,
		onCanvasPositionChanged = p1.onCanvasPositionChanged,
		onAbsoluteWindowSizeChanged = p1.onAbsoluteSizeChanged,
		scrollingFrameRef = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v31
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v28.Gap.Medium)
		}),
		OutfitSwitcherGridContainer = React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 1,
			padding = {
				left = if not v34 then UDim.new(0, v28.Size.Size_250) else UDim.new(0, v28.Size.Size_400),
				right = UDim.new(0, v28.Size.Size_250),
				bottom = UDim.new(0, v28.Size.Size_250),
				top = UDim.new(0, v28.Size.Size_250)
			},
			Size = UDim2.fromScale(1, 0)
		}, {
			OutfitSwitcherGrid = if not FFlagAXFixEmptyMakeupLooks then React.createElement(Grid, {
				itemsPerRow = p1.gridMetrics.itemsPerRow,
				renderItem = v35,
				items = p1.itemIds,
				gapVertical = v28.Size.Size_300,
				gapHorizontal = v28.Size.Size_200,
				getItemId = function(p4) -- line: 150
					return p4
				end,
				ref = v30
			}) else if not (#p1.itemIds > 0) then React.createElement(EmptyPage, {
				page = {
					Title = p1.outfitType ~= Constants.OutfitTypes.Makeup and "Feature.Avatar.Label.Looks" or "Feature.Avatar.Label.MakeupLooks"
				}
			}) else React.createElement(Grid, {
				itemsPerRow = p1.gridMetrics.itemsPerRow,
				renderItem = v35,
				items = p1.itemIds,
				gapVertical = v28.Size.Size_300,
				gapHorizontal = v28.Size.Size_200,
				getItemId = v36,
				ref = v30
			})
		}),
		RecommendedItemsContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = {
				left = UDim.new(0, v28.Size.Size_200),
				right = UDim.new(0, v28.Size.Size_200),
				bottom = UDim.new(0, v28.Size.Size_200)
			}
		}, {
			RecommendedItems = React.createElement(RecommendedItems, {
				categoryInfo = v33,
				itemDetailsPeekViewRefs = v29,
				baseRef = if not FFlagAXRecommendedItemsImpressionExposureLogging then v32 else p1.recommendedItemsRef,
				listFrameRef = v30,
				impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else p1.impressionsTag,
				sendShopForMoreAnalytics = function() -- line: 175
				end
			})
		}),
		ImpressionsReporter = React.createElement(OrganicEventImpressionsReporter, {
			eventName = "marketplaceOrganicFELog",
			impressionsSchema = "defaultItem",
			requestId = "",
			parentRef = if not v25 then v30 else v31,
			pageFilter = p1.impressionsPageFilter,
			onRequestImpressionsSignal = p1.requestImpressionsSignal,
			eventContext = FStringAXImpressionsEventName(),
			impressionsTag = p1.impressionsTag,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
			analyticsMetadata = p1.analyticsMetadata,
			searchUuid = p1.searchUuid
		}),
		UnifiedImpressionsReporter = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else React.createElement(TagBasedImpressionsDetector, {
			parentRef = v31,
			pageFilter = p1.impressionsPageFilter,
			requestImpressionsSignal = p1.requestImpressionsSignal,
			extensions = p1.tagBasedImpressionsDetectorExtensions
		}),
		LoadMoreButton = if not p1.showLoadMoreButton then nil else React.createElement(LoadMoreButton, {
			LayoutOrder = 2,
			onActivated = p1.fetchMoreOutfits
		})
	})
end

return OutfitSwitcherFrame

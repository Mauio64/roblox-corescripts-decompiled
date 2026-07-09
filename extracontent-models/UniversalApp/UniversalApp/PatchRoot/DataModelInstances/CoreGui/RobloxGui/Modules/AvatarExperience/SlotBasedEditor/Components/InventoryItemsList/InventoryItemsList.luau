local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local React = require(CorePackages.Packages.React)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)

require(CorePackages.Workspace.Packages.AppCommonLib)

local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local EmptyState = UIBlox.App.Indicator.EmptyState
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local getItemCountForRow = AvatarExperienceUIKit.Utils.getItemCountForRow
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local EmptyPage = require(Modules.AvatarExperience.AvatarEditor.Components.EmptyPage)
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local LoadMoreButton = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.LoadMoreButton)
local SubcategoryFiltersPill = require(Modules.AvatarExperience.SlotBasedEditor.Components.SubcategoryFilters.SubcategoryFiltersPill)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local useUnifiedEventImpressionsReporter = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventImpressionsReporter
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local useUnifiedImpressionExposer = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useUnifiedImpressionExposer
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXGeneralizeInventoryItemsList = AvatarExperienceFlags.FFlagAXGeneralizeInventoryItemsList
local FFlagAXSlotsInventoryLoadableGridView = AvatarExperienceFlags.FFlagAXSlotsInventoryLoadableGridView
local useStyle = UIBlox.Core.Style.useStyle
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local FFlagAXBodyPartsPillLabel = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBodyPartsPillLabel
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local FFlagAXItemDetailsIxpExposure = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXItemDetailsIxpExposure
local FFlagAXInventoryItemsListImpressionLogging = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXInventoryItemsListImpressionLogging
local FFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local FFlagAXInventoryDurablesExpiredFilter = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXInventoryDurablesExpiredFilter
local FStringAXRecommendedItemsExposureLayer = AvatarExperienceFlags.FStringAXRecommendedItemsExposureLayer
local FFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local EditorInventoryTTIMilestoneManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).EditorInventoryTTIMilestoneManager
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function v48(p1) -- line: 113
	return p1.ScreenSize
end
local function InventoryItemsList(t1: {[any]: any}) -- line: 119
	-- upvalues: React (copy), Foundation (copy), GridMetrics (copy), Responsive (copy), FFlagAXRootSlotBasedEditorFlag (copy), getItemCountForRow (copy), FFlagAXSlotsInventoryLoadableGridView (copy), useStyle (copy), useLocalization (copy), FFlagAXBodyPartsPillLabel (copy), useSelector (copy), v48 (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), Constants2 (copy), FFlagAXInventoryItemsListImpressionLogging (copy), FFlagAXItemDetailsIxpExposure (copy), useUnifiedEventImpressionsReporter (copy), useUnifiedImpressionExposer (copy), FStringAXRecommendedItemsExposureLayer (copy), FFlagAXTTIEditorEnableMilestones (copy), RetrievalStatus (copy), EditorInventoryTTIMilestoneManager (copy), FFlagAXInventoryDurablesExpiredFilter (copy), Constants (copy), Utils (copy), EmptyState (copy), FFlagAXGeneralizeInventoryItemsList (copy), AvatarEditorSubcategories (copy), SubcategoryFiltersPill (copy), AXRefreshScrollingFrameWithLoadMore (copy), AvatarScreen (copy), FFlagEnableLeftNavOnConsole (copy), EmptyPage (copy), LoadableGridView (copy), Grid (copy), RecommendedItems (copy), LoadMoreButton (copy), LoadingBarWithTheme (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy), TagBasedImpressionsDetector (copy)
	local v52 = React.useRef(nil)
	local items = t1.items
	local v54 = items and #items == 0
	local categoryInfo = t1.categoryInfo
	local fetchStatus = t1.fetchStatus
	local fetchUserInventory = t1.fetchUserInventory
	local v58 = t1.subcategoryFilter ~= nil
	local v59 = React.useRef(nil)
	local v60 = React.useRef(nil)
	local v61 = Foundation.Hooks.useTokens()
	local v62, v63 = React.useState(0)
	local v64 = math.max(0, v62 - v61.Gap.Medium * 2)
	local Medium = v61.Gap.Medium
	local v66 = GridMetrics.getMetricsForFixedColumns(math.max(v64, 0), Medium, 4)
	local u67 = GridMetrics.getSmallMetrics(math.max(v64, 0), Medium)
	local v68 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait

	if FFlagAXRootSlotBasedEditorFlag and v68 and v66.itemsPerRow > u67.itemsPerRow then
		u67 = v66
	end

	local v69 = getItemCountForRow(v64 + Medium, u67.itemWidth + Medium)
	local v70 = if not FFlagAXSlotsInventoryLoadableGridView then nil else useStyle()
	local u71 = math.max(v69, 1)
	local v72 = useLocalization({
		noItemsFound = "Feature.Catalog.Response.NoItemsFound",
		bodyParts = if not FFlagAXBodyPartsPillLabel then nil else "Feature.Avatar.Heading.BodyParts"
	})
	local v73 = if not FFlagAXSlotsInventoryLoadableGridView then nil else useSelector(v48)
	local v74 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else t1.categoryInfo.RecommendationsType ~= Constants2.RecommendationsType.All and (t1.categoryInfo.RecommendationsType ~= Constants2.RecommendationsType.None and t1.categoryInfo.RecommendationsType ~= Constants2.RecommendationsType.AvatarLooks)
	local v75 = nil
	local v76 = nil

	if FFlagAXInventoryItemsListImpressionLogging and FFlagAXItemDetailsIxpExposure then
		local v77 = useUnifiedEventImpressionsReporter()

		if FFlagAXRecommendedItemsImpressionExposureLogging then
			v75 = React.useRef(nil)

			local v78 = useUnifiedImpressionExposer(v75, FStringAXRecommendedItemsExposureLayer)

			v76 = React.useMemo(function() -- line: 178
				-- upvalues: v74 (copy), v77 (copy), v78 (copy)
				if v74 then
					return {
						v77,
						v78
					}
				end

				return { v77 }
			end, {
				v77,
				v78,
				v74
			})
		else
			v76 = React.useMemo(function() -- line: 191
				-- upvalues: v77 (copy)
				return { v77 }
			end, { v77 })
		end
	end

	React.useEffect(function() -- line: 201
		-- upvalues: t1 (copy)
		t1.requestImpressionsSignal:fire()
	end, { t1.requestImpressionsSignal })

	if FFlagAXTTIEditorEnableMilestones then
		local v79 = React.useRef(nil)
		local v80 = React.useRef(nil)

		React.useEffect(function() -- line: 225
			-- upvalues: fetchStatus (copy), RetrievalStatus (copy), v79 (copy), t1 (copy), fetchUserInventory (copy)
			if fetchStatus == RetrievalStatus.NotStarted then
				v79.current = t1.searchUuid
				fetchUserInventory()
			end
		end, {
			fetchStatus,
			fetchUserInventory,
			t1.searchUuid
		})
		React.useEffect(function() -- line: 241
			-- upvalues: EditorInventoryTTIMilestoneManager (copy), fetchStatus (copy), RetrievalStatus (copy), items (copy), v79 (copy), t1 (copy), v80 (copy)
			if EditorInventoryTTIMilestoneManager and (fetchStatus == RetrievalStatus.Done and items ~= nil and #items > 0 and v79.current == t1.searchUuid and v80.current ~= t1.searchUuid) then
				v80.current = t1.searchUuid
				EditorInventoryTTIMilestoneManager.endTilesTracking()
			end
		end, {
			items,
			t1.searchUuid,
			fetchStatus
		})
	else
		React.useEffect(function() -- line: 256
			-- upvalues: fetchStatus (copy), RetrievalStatus (copy), fetchUserInventory (copy)
			if fetchStatus == RetrievalStatus.NotStarted then
				fetchUserInventory()
			end
		end, {
			fetchStatus,
			fetchUserInventory
		})
	end

	React.useEffect(function() -- line: 264
		-- upvalues: v60 (copy)
		if v60.current then
			v60.current.CanvasPosition = Vector2.new()
		end
	end, {
		categoryInfo,
		t1.subcategoryFilter
	})

	local v81 = if not FFlagAXSlotsInventoryLoadableGridView then nil else React.useCallback(function(p2, p3, p4) -- line: 271
		-- upvalues: t1 (copy)
		local t2 = {
			item = p2,
			index = p3,
			gridInformation = p4
		}

		return t1.renderItem(t2)
	end, { t1.renderItem })
	local v82 = if not FFlagAXInventoryDurablesExpiredFilter then Constants.ItemTileType.AvatarEditorTile else t1.itemTileType or Constants.ItemTileType.AvatarEditorTile
	local v83 = if not FFlagAXSlotsInventoryLoadableGridView then nil else React.useMemo(function() -- line: 285
		-- upvalues: v70 (copy), u67 (ref), Constants (copy), FFlagAXInventoryDurablesExpiredFilter (copy), v82 (copy), categoryInfo (copy), Utils (copy)
		local Font = v70.Font
		local v89 = Font.CaptionBody.RelativeSize * Font.BaseSize

		if u67.itemWidth / v89 < Constants.MinTileWidthToFontHeightRatio then
			v89 = Font.CaptionBody.RelativeSize * Font.BaseSize
		end

		if FFlagAXInventoryDurablesExpiredFilter then
			local v90 = nil

			if v82 == Constants.ItemTileType.AvatarEditorTile then
				v90 = if not categoryInfo.ShowName then nil else v89
			elseif v82 == Constants.ItemTileType.CatalogItemTile then
				v90 = v89
			end

			return Utils.GridItemHeightGetter(v82, v90)
		end

		return Utils.GridItemHeightGetter(Constants.ItemTileType.AvatarEditorTile, if not categoryInfo.ShowName then nil else v89)
	end, {
		v70,
		u67.itemWidth,
		categoryInfo.ShowName,
		if not FFlagAXInventoryDurablesExpiredFilter then nil else v82
	})

	if fetchStatus == RetrievalStatus.Failed then
		return React.createElement(EmptyState, {
			onActivated = fetchUserInventory,
			text = v72.noItemsFound
		})
	end

	return React.createElement(Foundation.View, {
		tag = not FFlagAXGeneralizeInventoryItemsList and "size-full bg-surface-0 padding-x-medium" or "size-full",
		ref = v52,
		onAbsoluteSizeChanged = function(p5) -- line: 327
			-- upvalues: v63 (copy)
			v63(p5.AbsoluteSize.X)
		end
	}, {
		PillsContainer = v58 and React.createElement(Foundation.View, {
			tag = "size-full-1200 auto-y row align-y-center"
		}, {
			FiltersPillLabel = if not FFlagAXBodyPartsPillLabel or categoryInfo.Id ~= AvatarEditorSubcategories.PurchasedCharacters then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "padding-small size-30 auto-x",
				fontStyle = v61.Typography.BodyMedium,
				Text = v72.bodyParts
			}),
			FiltersPill = React.createElement(SubcategoryFiltersPill, {
				categoryInfo = t1.categoryInfo,
				LayoutOrder = if not FFlagAXBodyPartsPillLabel then nil else 2
			})
		}),
		ScrollingFrameContainer = React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 1, not v58 and 0 or -v61.Size.Size_1200),
			Position = UDim2.fromOffset(0, not v58 and 0 or v61.Size.Size_1200)
		}, {
			ItemsScrollingFrame = React.createElement(AXRefreshScrollingFrameWithLoadMore, {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0, 0),
				parentAppPage = AvatarScreen.AvatarEditor,
				ScrollingEnabled = t1.scrollingEnabled,
				onCanvasPositionChanged = t1.onCanvasPositionChanged,
				onThresholdReached = t1.onListEndReached,
				BackgroundTransparency = if not FFlagAXGeneralizeInventoryItemsList then nil else 1,
				shouldExtendIntoSafeArea = if not FFlagEnableLeftNavOnConsole then nil else {
					bottom = true
				},
				ref = v60
			}, {
				ListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v61.Gap.Medium)
				}),
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v61.Padding.Medium),
					PaddingBottom = UDim.new(0, v61.Size.Size_2500),
					PaddingLeft = UDim.new(0, v61.Size.Size_100),
					PaddingRight = UDim.new(0, v61.Size.Size_50)
				}),
				EmptyPage = v54 and React.createElement(EmptyPage, {
					page = categoryInfo
				}),
				ItemsGridContainer = not v54 and React.createElement(Foundation.View, {
					tag = "auto-y size-full-0",
					LayoutOrder = 1
				}, {
					ItemsGrid = if not FFlagAXSlotsInventoryLoadableGridView then React.createElement(Grid, {
						AutomaticSize = Enum.AutomaticSize.Y,
						itemsPerRow = u71,
						renderItem = t1.renderItem,
						items = items,
						gapVertical = Medium,
						gapHorizontal = Medium,
						getItemId = function(p6) -- line: 410
							-- upvalues: u71 (ref)
							return `{ p6.itemId }{ u71 }`
						end,
						ref = v59
					}) else React.createElement(LoadableGridView, {
						getItemMetrics = GridMetrics.makeCustomMetricsGetter(Constants2.ItemsGridMetrics),
						items = items,
						getItemHeight = v83,
						totalNumItems = items and #items or Constants.ShimmerCardsToDisplay,
						renderItem = v81,
						windowHeight = v73.Y,
						ref = v59
					})
				}),
				RecommendedItems = t1.showRecommendedItems and React.createElement(RecommendedItems, {
					LayoutOrder = 2,
					categoryInfo = categoryInfo,
					sendShopForMoreAnalytics = t1.sendShopForMoreAnalytics,
					itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
					listFrameRef = v52,
					baseRef = if not v74 then nil else v75,
					impressionsTag = if not v74 then nil else t1.impressionsTag
				}),
				LoadMoreButton = if not t1.showLoadMoreButton then nil else React.createElement(LoadMoreButton, {
					LayoutOrder = 3,
					onActivated = t1.fetchUserInventory
				}),
				LoadingBar = if t1.fetchStatus ~= RetrievalStatus.Fetching then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v61.Size.Size_700)
				}, {
					LoadingBar = React.createElement(LoadingBarWithTheme)
				}),
				ImpressionsReporter = React.createElement(OrganicEventImpressionsReporter, {
					eventName = "marketplaceOrganicFELog",
					impressionsSchema = "defaultItem",
					requestId = "",
					parentRef = v59,
					pageFilter = t1.impressionsPageFilter,
					onRequestImpressionsSignal = t1.requestImpressionsSignal,
					eventContext = FStringAXImpressionsEventName(),
					impressionsTag = t1.impressionsTag,
					surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
					analyticsMetadata = t1.analyticsMetadata,
					searchUuid = t1.searchUuid
				}),
				UnifiedImpressionsReporter = if not FFlagAXInventoryItemsListImpressionLogging then nil else React.createElement(TagBasedImpressionsDetector, {
					parentRef = if not FFlagAXRecommendedItemsImpressionExposureLogging then v59 else v60,
					pageFilter = t1.impressionsPageFilter,
					requestImpressionsSignal = t1.requestImpressionsSignal,
					extensions = v76
				})
			})
		})
	})
end

return InventoryItemsList

local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local Focusable = RoactGamepad.Focusable
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

require(Modules.AvatarExperience.EditEmotes.useEditEmotesPageProps)

local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local EquipSlots = require(Modules.AvatarExperience.AvatarEditor.Components.EquipSlots)
local EditEmotesScrollingContent = require(Modules.AvatarExperience.EditEmotes.EditEmotesScrollingContent)
local EmoteTileContainer = require(Modules.AvatarExperience.EditEmotes.EmoteTile.EmoteTileContainer)
local Grid = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).GridComponents.Grid
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local LoadMoreButton = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.LoadMoreButton)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useEditEmotesPageFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 59
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v41 = ReactFocusNavigation.useEventMap(t1, p1)
	local v42 = React.useMemo(function() -- line: 61
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 64
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v42, v41)
end
local function EditEmotesPage(p4) -- line: 74
	-- upvalues: Foundation (copy), useLocalization (copy), useSelector (copy), selectIsPortrait (copy), useAvatarRoute (copy), Responsive (copy), AvatarScreen (copy), RoactGamepad (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), useEditEmotesPageFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), EmoteTileContainer (copy), Focusable (copy), SceneInteractionFrame (copy), AvatarExperienceView (copy), TopBar (copy), GamepadFocusHandlerForPage (copy), EquipSlots (copy), Constants (copy), EditEmotesScrollingContent (copy), Grid (copy), LoadMoreButton (copy), RecommendedItems (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy)
	local v44 = Foundation.Hooks.useTokens()
	local v45 = useLocalization({
		title = "Feature.Avatar.Label.Title.Emotes"
	})
	local v46 = useSelector(selectIsPortrait)
	local v47 = useAvatarRoute()
	local v48 = Responsive.usePreferredInput() == Responsive.Input.Directional and v47.current.name == AvatarScreen.ItemDetails
	local v49 = RoactGamepad.useRefCache()
	local v50 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v51 = React.useRef(nil)
	local v52 = React.useRef(nil)
	local v53 = React.useRef(nil)
	local v54 = React.useRef(nil)
	local v55 = React.useRef(nil)
	local v56 = React.useCallback(p4.onBackButtonPressed, { p4.onBackButtonPressed })
	local v57 = useEditEmotesPageFocusNavigationBindings(nil, v56)
	local v58 = useTableWrappedCallbackRef(v57)
	local v59 = React.useCallback(function(p5) -- line: 102
		-- upvalues: React (copy), EmoteTileContainer (copy), p4 (copy), v49 (copy)
		local item = p5.item

		return React.createElement(EmoteTileContainer, {
			impressionsSchema = "defaultItem",
			itemWidth = p4.gridMetrics.itemWidth,
			itemId = item,
			index = p5.index,
			ref = v49[p5.index],
			impressionsTag = p4.impressionsTag,
			gridInformation = p5.gridInformation
		})
	end, { p4.gridMetrics })

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v50 else nil,
		ref = v58
	}, {
		EditEmotesPageSceneInteractionFrame = React.createElement(SceneInteractionFrame),
		AvatarExperienceView = React.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = true,
			showUndoRedo = true,
			isSceneFullView = p4.isSceneFullView,
			isUIFullView = p4.isUIFullView,
			topBar = React.createElement(TopBar.Container, {
				ZIndex = 2,
				titleText = v45.title,
				transparentBackground = v46,
				leftItem = TopBar.makeBackButton(p4.onBackButtonPressed),
				ref = v52,
				NextSelectionDown = v49[1]
			})
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v50
			}) else nil,
			EditEmotesContent = React.createElement(Foundation.View, {
				tag = "size-full-full bg-surface-0 col gap-medium",
				ref = v51,
				onAbsoluteSizeChanged = p4.onAbsoluteSizeChanged,
				padding = {
					bottom = UDim.new(0, v44.Size.Size_2500)
				}
			}, {
				EquipSlots = React.createElement(EquipSlots, {
					slotsCount = Constants.EmoteSlotsCount,
					onActivated = p4.onSlotActivated,
					itemsListRef = v53,
					ref = v54,
					darkenItemsGrid = v48
				}),
				EditEmotesScrollingContent = React.createElement(EditEmotesScrollingContent, {
					onCanvasPositionChanged = p4.onCanvasPositionChanged,
					onThresholdReached = p4.onScrollingFrameThresholdReached
				}, {
					ListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, v44.Gap.Medium)
					}),
					EditEmotesGridContainer = React.createElement(Foundation.View, {
						tag = "auto-xy size-full-0",
						LayoutOrder = 1,
						padding = {
							left = UDim.new(0, v44.Size.Size_400),
							right = UDim.new(0, v44.Size.Size_400)
						}
					}, {
						EditEmotesGrid = React.createElement(Grid, {
							itemsPerRow = p4.gridMetrics.itemsPerRow,
							renderItem = v59,
							items = p4.itemIds,
							gapVertical = v44.Size.Size_400,
							gapHorizontal = v44.Size.Size_300,
							getItemId = function(p6) -- line: 182
								return p6
							end,
							ref = v55
						})
					}),
					LoadMoreButton = if not p4.showLoadMoreButton then nil else React.createElement(LoadMoreButton, {
						LayoutOrder = 2,
						onActivated = p4.fetchMoreItems
					}),
					RecommendedItems = if not p4.showRecommendedItems then nil else React.createElement(RecommendedItems, {
						LayoutOrder = 3,
						categoryInfo = p4.emotesCategory,
						sendShopForMoreAnalytics = p4.sendShopForMoreAnalytics,
						itemDetailsPeekViewRefs = v53,
						listFrameRef = v51
					}),
					ImpressionsReporter = React.createElement(OrganicEventImpressionsReporter, {
						eventName = "marketplaceOrganicFELog",
						impressionsSchema = "defaultItem",
						requestId = "",
						parentRef = v55,
						pageFilter = p4.impressionsPageFilter,
						onRequestImpressionsSignal = p4.requestImpressionsSignal,
						eventContext = FStringAXImpressionsEventName(),
						impressionsTag = p4.impressionsTag,
						surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
						analyticsMetadata = p4.analyticsMetadata,
						searchUuid = p4.searchUuid
					})
				})
			})
		})
	})
end

return EditEmotesPage

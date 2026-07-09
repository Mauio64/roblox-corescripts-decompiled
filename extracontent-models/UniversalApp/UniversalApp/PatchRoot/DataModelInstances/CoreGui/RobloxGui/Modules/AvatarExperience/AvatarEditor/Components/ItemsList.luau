local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local ItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCard
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useRequest = require(Modules.AvatarExperience.Common.Hooks.useRequest)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local EmptyState = UIBlox.App.Indicator.EmptyState
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.AvatarEditor.Reducers.UserInventoryRecommendations)

local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local FitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical
local SetOwnedItemIdsBySubtype = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOwnedItemIdsBySubtype)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local Constants = require(Modules.LuaApp.Constants)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local EmptyPage = require(Modules.AvatarExperience.AvatarEditor.Components.EmptyPage)
local FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation
local v51 = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then require(Modules.AvatarExperience.AvatarEditor.Components.ItemCard_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.AvatarEditorItemCard)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local GetUserInventory = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventory)
local GetUserInventoryV2 = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventoryV2)
local GetOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfits)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local selectOwnedItemIdToIsWearing = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectOwnedItemIdToIsWearing)
local SendShopForMoreAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendShopForMoreAnalytics)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local SignalConnection = require(Modules.LuaApp.Components.SignalConnection)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad

require(Modules.AvatarExperience.Common.Types)

local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local useUnifiedEventImpressionsReporter = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventImpressionsReporter
local AXCatalogHeadCategoryCombineIXP = require(Modules.AvatarExperience.Experiments.AXCatalogHeadCategoryCombineIXP)
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local RequestStatusEnum = require(Modules.AvatarExperience.Common.Enum.RequestStatusEnum)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local v81 = game:DefineFastFlag("FixItemListHasMoreItems", false)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXItemDetailsIxpExposure = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXItemDetailsIxpExposure
local FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXAdaptiveScrollingFixForward = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAdaptiveScrollingFixForward
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXTTIEditorEnableMilestones = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXTTIEditorEnableMilestones
local v89 = GuiService:IsTenFootInterface()
local ShimmerCardsToDisplay = Constants2.ShimmerCardsToDisplay
local AddOutfitButton = Constants3.AddOutfitButton
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 149
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v108 = ReactFocusNavigation.useEventMap(t1, p1)
	local v109 = React.useMemo(function() -- line: 151
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(_) -- line: 154
					-- upvalues: p2 (copy)
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v109, v108)
end

local v94 = React.forwardRef(function(t2: {[any]: any}, p4) -- line: 167
	-- upvalues: React (copy), useTokens (copy), ItemCard (copy), Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ImageSetLabel (copy), Images (copy)
	local v112, v113 = React.useBinding(0)
	local v114 = useTokens()

	return React.createElement(ItemCard, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = t2.onActivated,
		ref = p4,
		headerSlot = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v114.Semantic.Color.Common.Placeholder else v114.Color.Common.Shimmer)).Color3,
			BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v114.Semantic.Color.Common.Placeholder else v114.Color.Common.Shimmer)).Transparency,
			ClipsDescendants = true,
			[React.Change.AbsoluteSize] = function(p5) -- line: 185
				-- upvalues: v113 (copy)
				v113(p5.AbsoluteSize.X)
			end,
			Size = v112:map(function(n1: number) -- line: 188
				return UDim2.new(1, 0, 0, n1)
			end)
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v114.Semantic.Radius.Medium else v114.Radius.Medium)
			}),
			Image = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ImageTransparency = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["icons/menu/customize"],
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, 36, 0, 36),
				ScaleType = Enum.ScaleType.Stretch
			})
		})
	})
end)
local v95 = React.forwardRef(function(t3: {[any]: any}, p6) -- line: 220
	-- upvalues: useLocalization (copy), useDesignTokens (copy), React (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy)
	local v117 = useLocalization({
		loadMore = "Feature.Catalog.Action.LoadMore"
	})
	local v118 = useDesignTokens()

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v118.Global.Size_600 else v118.Size.Size_1200),
		ref = p6,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionUp else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionDown else nil,
		LayoutOrder = t3.LayoutOrder
	}, {
		LoadMoreButton = React.createElement(Button, {
			onActivated = t3.onActivated,
			text = v117.loadMore,
			standardSize = StandardButtonSize.Regular,
			buttonType = ButtonType.Secondary,
			size = UDim2.fromScale(1, 1),
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		})
	})
end)

local function useAvatarInventoryOverride(p7) -- line: 250
	return not p7
end

local v97 = Roact.PureComponent:extend("ItemsList")

function v97.init(p8) -- line: 256
	-- upvalues: Roact (copy), RoactGamepad (copy), Signal (copy), FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation (copy), FFlagAXTTIEditorEnableMilestones (copy), Constants2 (copy), GetFFlagAXEnableSlotBasedEditor (copy), AXCatalogHeadCategoryCombineIXP (copy), Constants3 (copy)
	p8.state = {
		listWidth = 0,
		restorePreviousChildFocus = true,
		hasItemFromCurrentPageEquipped = false,
		loadableGridViewWidth = 0,
		ownedItemIdToIsWearing = {}
	}
	p8.lastYPosition = 0
	p8.isMounted = false
	p8.listFrameRef = p8.props.forwardRef or Roact.createRef()
	p8.scrollingFrameRef = Roact.createRef()
	p8.loadableGridViewRef = Roact.createRef()
	p8.recommendedItemsRef = Roact.createRef()
	p8.loadMoreRef = Roact.createRef()
	p8.emptyStateRef = Roact.createRef()
	p8.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()
	p8.requestImpressionsSignal = Signal.new()
	p8.addOutfitButtonRef = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else Roact.createRef()
	p8.resultsListRef = Roact.createRef()

	function p8.onLoadableGridViewAbsoluteSizeChanged(p9) -- line: 283
		-- upvalues: p8 (copy)
		if p8.state.loadableGridViewWidth ~= p9.AbsoluteSize.X then
			p8:setState({
				loadableGridViewWidth = p9.AbsoluteSize.X
			})
		end
	end
	function p8.checkSetListWidth(p10) -- line: 291
		-- upvalues: p8 (copy)
		if p10 and p10:IsDescendantOf(game) then
			p8:setState({
				listWidth = p10.AbsoluteSize.X
			})
		end
	end
	function p8.loadMoreUserInventoryItems() -- line: 299
		-- upvalues: p8 (copy), FFlagAXTTIEditorEnableMilestones (copy), Constants2 (copy), GetFFlagAXEnableSlotBasedEditor (copy), AXCatalogHeadCategoryCombineIXP (copy), Constants3 (copy)
		local categoryInfo = p8.props.categoryInfo
		local networking = p8.props.networking
		local isOutfitsPage = p8.props.isOutfitsPage
		local assetTypeKey = p8.props.assetTypeKey
		local v299 = if not FFlagAXTTIEditorEnableMilestones then nil else categoryInfo.PageType == Constants2.PageType.Emotes

		if GetFFlagAXEnableSlotBasedEditor() and categoryInfo.UseGetInventoryV2 or not isOutfitsPage then
			return p8.props.getUserInventoryV2(networking, categoryInfo, p8.props.nextPageCursorKey, if not FFlagAXTTIEditorEnableMilestones then nil else v299)
		end

		if AXCatalogHeadCategoryCombineIXP.isEnabled() and p8.props.enableHeadCategoryCombine and categoryInfo.OutfitType == Constants2.OutfitTypes.DynamicHead and categoryInfo.AssetTypeIdStrings then
			return p8.props.getUserInventoryV2(networking, categoryInfo, p8.props.nextPageCursorKey, if not FFlagAXTTIEditorEnableMilestones then nil else v299)
		end

		if isOutfitsPage then
			local v300 = assetTypeKey == Constants3.EditableCharacterKey
			local OutfitType = categoryInfo.OutfitType
			local v302 = assetTypeKey .. (OutfitType or "")

			return p8.props.getOutfits(assetTypeKey, v300, v302, OutfitType)
		end

		return p8.props.getUserInventory(categoryInfo)
	end
	function p8.onFocusGained() -- line: 349
		-- upvalues: p8 (copy)
		p8:setState({
			restorePreviousChildFocus = true
		})
	end
	function p8.setParentRestorePreviousChildFocus(p11) -- line: 355
		-- upvalues: p8 (copy)
		if not p8.isMounted then
			return
		end

		p8:setState({
			restorePreviousChildFocus = p11
		})
	end
	function p8.sendShopForMoreAnalytics() -- line: 365
		-- upvalues: p8 (copy)
		p8.props.sendShopForMoreAnalytics(p8.props.avatarEditorAnalytics)
	end
	function p8.scrollBackToTop() -- line: 369
		-- upvalues: p8 (copy)
		local current = p8.scrollingFrameRef.current

		if current then
			current:ScrollToTop()
		end
	end
end
function v97.renderNonOutfitItemCard(p12, p13, p14, p15, p16) -- line: 377
	-- upvalues: Constants (copy), Roact (copy), v51 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	local key = p12.props.avatarRoute.current.key
	local v127 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	return Roact.createElement(v51, {
		isOutfit = false,
		impressionsSchema = "defaultItem",
		itemId = p13,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p14 else nil,
		isWearingAssetOrOutfit = p12.props.ownedItemIdToIsWearing[p13],
		titleFontStyle = p15,
		itemDetailsPeekViewRefs = p12.itemDetailsPeekViewRefs,
		resultsListRef = p12.resultsListRef,
		impressionsTag = v127,
		gridInformation = p16
	})
end
function v97.getShowAddOutfitButton(p17) -- line: 396
	-- upvalues: v89 (copy), Constants3 (copy)
	return not v89 and p17.props.assetTypeKey == Constants3.EditableCharacterKey
end
function v97.renderNonOutfitItemCardWithOverlay(p18, p19, p20, p21, p22, p23) -- line: 401
	-- upvalues: Roact (copy)
	if typeof(p22) == "table" then
		p22 = nil
	end

	if p18.props.darkenItemsGrid then
		return Roact.createFragment({
			GamepadDarkOverlay = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = p20.Theme.Overlay.Transparency,
				BackgroundColor3 = p20.Theme.Overlay.Color
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10)
				})
			}),
			ItemCard = p18:renderNonOutfitItemCard(p22, p19, p21, p23)
		})
	end

	return p18:renderNonOutfitItemCard(p22, p19, p21, p23)
end
function v97.renderGenericItemCard(p24, p25, p26, p27, p28, p29) -- line: 424
	-- upvalues: Constants3 (copy)
	if p24.props.outfitOrAsset[p28] == Constants3.OutfitOrAsset.Outfit then
		return p24:renderOutfitItemCard(p28, p27, p29)
	end

	return p24:renderNonOutfitItemCardWithOverlay(p25, p26, p27, p28, p29)
end

if FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then
	function v97.openCreateOrUpdateCostumeMenu(p30) -- line: 436
		-- upvalues: AvatarScreen (copy)
		local v142 = p30.addOutfitButtonRef:getValue()

		if not v142 then
			return
		end

		local v143 = v142.AbsolutePosition + v142.AbsoluteSize * Vector2.new(0.5, 0.5)

		p30.props.navigateWithLock(function() -- line: 444
			-- upvalues: p30 (copy), AvatarScreen (copy), v143 (copy)
			p30.props.navigation.navigate(AvatarScreen.CreateOrUpdateOutfitMenu, {
				saveTilePosition = v143
			})
		end)
	end
end

function v97.renderOutfitItemCard(p31, p32, p33, p34) -- line: 453
	-- upvalues: FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation (copy), AddOutfitButton (copy), React (copy), v94 (copy), Constants (copy), Roact (copy), v51 (copy)
	if typeof(p32) == "table" then
		p32 = nil
	end

	if FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation and p32 == AddOutfitButton then
		return React.createElement(v94, {
			ref = p31.addOutfitButtonRef,
			onActivated = function() -- line: 461
				-- upvalues: p31 (copy)
				p31:openCreateOrUpdateCostumeMenu()
			end
		})
	end

	local key = p31.props.avatarRoute.current.key
	local v149 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	return Roact.createElement(v51, {
		isOutfit = true,
		impressionsSchema = "defaultItem",
		itemId = p32,
		isWearingAssetOrOutfit = p31.props.ownedItemIdToIsWearing[p32],
		hasItemFromCurrentPageEquipped = p31.props.hasItemFromCurrentPageEquipped,
		titleFontStyle = p33,
		itemDetailsPeekViewRefs = p31.itemDetailsPeekViewRefs,
		resultsListRef = p31.resultsListRef,
		impressionsTag = v149,
		gridInformation = p34
	})
end
function v97.renderRecommendedItems(p35, p36, _, p38, p39) -- line: 485
	-- upvalues: Constants3 (copy), Roact (copy), RecommendedItems (copy)
	if not p36.RecommendationsType or (p36.RecommendationsType == Constants3.RecommendationsType.None or not p35.props.pageFinished) then
		return nil
	end

	local sendShopForMoreAnalytics = p35.sendShopForMoreAnalytics

	return Roact.createElement(RecommendedItems, {
		LayoutOrder = 4,
		categoryInfo = p36,
		sendShopForMoreAnalytics = sendShopForMoreAnalytics,
		baseRef = p35.recommendedItemsRef,
		NextSelectionUp = if p35.props.darkenItemsGrid then nil else p39,
		itemDetailsPeekViewRefs = p35.itemDetailsPeekViewRefs,
		listFrameRef = p38 or p35.listFrameRef
	})
end
function v97.renderItemsList(t4: {[any]: any}, p40, n2: number?) -- line: 507
	-- upvalues: RetrievalStatus (copy), Constants3 (copy), AddOutfitButton (copy), Cryo (copy), ShimmerCardsToDisplay (copy), withStyle (copy), FFlagAXRootSlotBasedEditorFlag (copy), GridMetrics (copy), Constants2 (copy), GetFFlagAXEnableSlotBasedEditor (copy), AXCatalogHeadCategoryCombineIXP (copy), Constants (copy), Utils (copy), React (copy), AXRefreshScrollingFrameWithLoadMore (copy), AvatarScreen (copy), FFlagAXAdaptiveScrollingFixForward (copy), Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), SignalConnection (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FitFrameVertical (copy), Focusable (copy), LoadableGridView (copy), EmptyPage (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy), TagBasedImpressionsDetector (copy), v95 (copy), wasLastInputGamepad (copy), LoadingBarWithTheme (copy)
	local categoryInfo = t4.props.categoryInfo
	local dataStatus = t4.props.dataStatus
	local hasMoreUserInventoryItems = t4.props.hasMoreUserInventoryItems
	local screenSize = t4.props.screenSize
	local ownedItemIds = t4.state.ownedItemIds
	local itemsContainsOutfits = t4.state.itemsContainsOutfits
	local listWidth = t4.state.listWidth
	local u166 = not not ownedItemIds and (#ownedItemIds > 0 or false)
	local v167 = dataStatus == RetrievalStatus.Fetching and not u166
	local v168 = dataStatus == RetrievalStatus.NotStarted or v167
	local v169 = not (listWidth > Constants3.ItemsGridSidePadding) and 0 or Constants3.ItemsGridSidePadding
	local u170 = ownedItemIds

	if ownedItemIds and itemsContainsOutfits and ownedItemIds[1] ~= AddOutfitButton and t4:getShowAddOutfitButton() then
		u170 = Cryo.List.join({ AddOutfitButton }, ownedItemIds)
		u166 = true
	end

	local u171 = u170 and #u170 or ShimmerCardsToDisplay
	local v172 = t4.props.ownedItemIdsBySubtype[t4.props.assetTypeKey] ~= nil and #t4.props.ownedItemIdsBySubtype[t4.props.assetTypeKey] > 0

	if v168 then
		u170 = nil
		u171 = ShimmerCardsToDisplay
	elseif not u170 and v172 then
		u171 = ShimmerCardsToDisplay
	end

	local v173 = u166 or (v168 or v172)
	local v174 = t4.props.adaptiveScrolling or {}

	t4.requestImpressionsSignal:fire()

	return withStyle(function(p41) -- line: 551
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy), GridMetrics (copy), Constants3 (copy), t4 (copy), Constants2 (copy), n2 (copy), itemsContainsOutfits (copy), p40 (copy), GetFFlagAXEnableSlotBasedEditor (copy), AXCatalogHeadCategoryCombineIXP (copy), categoryInfo (copy), Constants (copy), Utils (copy), v167 (copy), v168 (copy), hasMoreUserInventoryItems (copy), v173 (copy), React (copy), AXRefreshScrollingFrameWithLoadMore (copy), AvatarScreen (copy), v174 (copy), FFlagAXAdaptiveScrollingFixForward (copy), Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), SignalConnection (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FitFrameVertical (copy), Focusable (copy), v169 (copy), LoadableGridView (copy), u170 (ref), u171 (ref), screenSize (copy), EmptyPage (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy), TagBasedImpressionsDetector (copy), v95 (copy), wasLastInputGamepad (copy), LoadingBarWithTheme (copy), u166 (ref)
		local p41Font = p41.Font
		local u307 = if not FFlagAXRootSlotBasedEditorFlag then p41Font.Header2 else p41Font.CaptionHeader
		local v308 = u307.RelativeSize * p41Font.BaseSize

		if GridMetrics.makeCustomMetricsGetter(Constants3.ItemsGridMetrics)(t4.state.loadableGridViewWidth, Constants2.LoadableGridViewCellPadding).itemWidth / v308 < Constants2.MinTileWidthToFontHeightRatio then
			u307 = p41Font.CaptionBody
			v308 = u307.RelativeSize * p41Font.BaseSize
		end

		local v309 = v308 + (n2 or 0)
		local v310 = not itemsContainsOutfits and function(p42, _, p44) -- line: 575
			-- upvalues: t4 (copy), p40 (copy), p41 (copy), u307 (ref)
			return t4:renderNonOutfitItemCardWithOverlay(p40, p41, u307, p42, p44)
		end or function(p45, _, p47) -- line: 571
			-- upvalues: t4 (copy), u307 (ref)
			return t4:renderOutfitItemCard(p45, u307, p47)
		end

		if (GetFFlagAXEnableSlotBasedEditor() or AXCatalogHeadCategoryCombineIXP.isEnabled() and t4.props.enableHeadCategoryCombine) and categoryInfo.UseGetInventoryV2 then
			function v310(p48, _, p50) -- line: 594
				-- upvalues: t4 (copy), p40 (copy), p41 (copy), u307 (ref)
				return t4:renderGenericItemCard(p40, p41, u307, p48, p50)
			end
		end

		local forwardRef = t4.props.forwardRef
		local key = t4.props.avatarRoute.current.key
		local v313 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
		local v314 = if not t4.props.categoryInfo.HideTextUnderTile then Utils.GridItemHeightGetter(Constants2.ItemTileType.AvatarEditorTile, v309) else Utils.GridItemHeightGetter(Constants2.ItemTileType.AvatarEditorTile)
		local backToTopSignal = t4.props.backToTopSignal
		local isFetchingMore = t4.props.isFetchingMore
		local enableContinuousLoad = t4.props.enableContinuousLoad
		local v318 = isFetchingMore or (v167 or v168)
		local v319 = not v318 and hasMoreUserInventoryItems
		local v320 = if not v319 or not enableContinuousLoad then nil else t4.props.loadMoreItems
		local v321 = v319 and not enableContinuousLoad
		local v322 = if not v321 then if not v173 then t4.props.NextSelectionUp else t4.loadableGridViewRef else t4.loadMoreRef
		local v323 = categoryInfo.RecommendationsType and (categoryInfo.RecommendationsType ~= Constants3.RecommendationsType.None and t4.props.pageFinished)

		return React.createElement(AXRefreshScrollingFrameWithLoadMore, {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			createEndOfScrollElement = false,
			parentAppPage = AvatarScreen.AvatarEditor,
			ScrollingEnabled = if not v174.scrollingEnabledBinding then FFlagAXAdaptiveScrollingFixForward and true or v174.scrollingEnabled else v174.scrollingEnabledBinding:map(function(p51) -- line: 638
				return p51
			end),
			[Roact.Ref] = t4.scrollingFrameRef,
			onCanvasPositionChanged = function(p52) -- line: 645
				-- upvalues: t4 (copy), v174 (copy)
				t4.requestImpressionsSignal:fire()

				local CanvasPositionY = p52.CanvasPosition.Y

				if v174 and v174.onCanvasYChanged then
					v174.onCanvasYChanged(CanvasPositionY)
				end
			end,
			onThresholdReached = v320
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p41.Tokens.Global.Space_400 else p41.Tokens.Size.Size_800)
			}),
			BackToTopSignal = if not backToTopSignal then nil else React.createElement(SignalConnection, {
				signal = backToTopSignal,
				callback = t4.scrollBackToTop
			}),
			ListWrapper = React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[FitFrameVertical] else FitFrameVertical, {
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				BackgroundTransparency = t4.props.darkenItemsGrid and p41.Theme.Overlay.Transparency or 1,
				BackgroundColor3 = t4.props.darkenItemsGrid and p41.Theme.Overlay.Color or nil,
				margin = {
					top = Constants3.ItemsGridTopPadding,
					bottom = Constants3.ItemsGridBottomPadding,
					left = v169 / 2,
					right = v169 / 2
				},
				ref = t4.loadableGridViewRef,
				defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then t4.resultsListRef else nil
			}, {
				LoadableGridView = v173 and React.createElement(LoadableGridView, {
					getItemMetrics = GridMetrics.makeCustomMetricsGetter(Constants3.ItemsGridMetrics),
					items = u170,
					totalNumItems = u171,
					renderItem = v310,
					getItemHeight = v314,
					windowHeight = screenSize.Y,
					NextSelectionDown = if not v321 then t4.recommendedItemsRef else t4.loadMoreRef,
					NextSelectionUp = t4.props.NextSelectionUp,
					NextSelectionRight = key and t4.itemDetailsPeekViewRefs[key],
					onFocusGained = not t4.state.restorePreviousChildFocus and t4.onFocusGained or nil,
					restorePreviousChildFocus = t4.state.restorePreviousChildFocus,
					onAbsoluteSizeChanged = t4.onLoadableGridViewAbsoluteSizeChanged,
					ref = t4.resultsListRef
				}) or React.createElement(EmptyPage, {
					page = categoryInfo,
					NextSelectionUp = t4.props.NextSelectionUp,
					NextSelectionDown = if not v321 then t4.recommendedItemsRef else t4.loadMoreRef
				}),
				ImpressionsReporter = Roact.createElement(OrganicEventImpressionsReporter, {
					eventName = "marketplaceOrganicFELog",
					impressionsSchema = "defaultItem",
					requestId = "",
					parentRef = t4.loadableGridViewRef,
					pageFilter = function() -- line: 722
						-- upvalues: key (copy), t4 (copy)
						return key == t4.props.navigation.state.key
					end,
					onRequestImpressionsSignal = t4.requestImpressionsSignal,
					eventContext = FStringAXImpressionsEventName(),
					impressionsTag = v313,
					surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
					searchUuid = t4.props.searchUuid
				}),
				UnifiedImpressionsReporter = React.createElement(TagBasedImpressionsDetector, {
					parentRef = t4.loadableGridViewRef,
					pageFilter = function() -- line: 736
						-- upvalues: key (copy), t4 (copy)
						return key == t4.props.navigation.state.key
					end,
					requestImpressionsSignal = t4.requestImpressionsSignal,
					extensions = t4.props.tagBasedImpressionsDetectorExtensions
				}),
				LoadMoreButton = if not v321 then nil else React.createElement(v95, {
					LayoutOrder = 3,
					onActivated = function() -- line: 744
						-- upvalues: wasLastInputGamepad (copy), t4 (copy), v173 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p40 (copy)
						if wasLastInputGamepad() then
							t4:setState({
								restorePreviousChildFocus = true
							})

							if v173 then
								if FFlagAXMigrateAXToGlobalAutofocus then
									if t4.props.focusGuiObject and t4.resultsListRef.current then
										t4.props.focusGuiObject(t4.resultsListRef.current)
									end
								else
									p40.moveFocusTo(t4.resultsListRef)
								end
							end
						end

						t4.props.loadMoreItems()
					end,
					ref = t4.loadMoreRef,
					NextSelectionDown = if not v323 then nil else t4.recommendedItemsRef,
					NextSelectionUp = if not v173 then t4.props.NextSelectionUp else t4.resultsListRef
				}),
				LoadingBar = if not v318 then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then p41.Tokens.Global.Size_700 else p41.Tokens.Size.Size_1400)
				}, {
					LoadingBar = React.createElement(LoadingBarWithTheme)
				})
			}),
			RecommendedItems = t4:renderRecommendedItems(categoryInfo, u166, forwardRef, v322)
		})
	end)
end
function v97.render(p53) -- line: 801
	-- upvalues: withTextSizeOffset (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy)
	return withTextSizeOffset(function(p54) -- line: 802
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p53 (copy), RoactGamepad (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			return p53:renderWithProviders(nil, p54)
		end

		return RoactGamepad.withFocusController(function(p55) -- line: 806
			-- upvalues: p53 (copy), p54 (copy)
			return p53:renderWithProviders(p55, p54)
		end)
	end)
end
function v97.renderWithProviders(t5: {[any]: any}, p56, n3: number?) -- line: 812
	-- upvalues: RetrievalStatus (copy), withLocalization (copy), Roact (copy), EmptyState (copy), wasLastInputGamepad (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad (copy), Focusable (copy), AvatarScreen (copy), RoactGamepad (copy)
	local v179 = t5.props.dataStatus == RetrievalStatus.Failed
	local v180 = withLocalization({
		noItemsFound = "Feature.Catalog.Response.NoItemsFound"
	})(function(p57) -- line: 818
		-- upvalues: Roact (copy), EmptyState (copy), t5 (copy), wasLastInputGamepad (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p56 (copy)
		return Roact.createElement(EmptyState, {
			onActivated = function() -- line: 824
				-- upvalues: t5 (copy), wasLastInputGamepad (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p56 (copy)
				t5.loadMoreUserInventoryItems()

				if wasLastInputGamepad() then
					t5:setState({
						restorePreviousChildFocus = false
					})

					if FFlagAXMigrateAXToGlobalAutofocus then
						if t5.props.focusGuiObject and t5.props.NextSelectionUp and t5.props.NextSelectionUp.current then
							t5.props.focusGuiObject()

							return
						end
					else
						p56.moveFocusTo(t5.props.NextSelectionUp)
					end
				end
			end or t5.loadMoreUserInventoryItems,
			text = p57.noItemsFound,
			[Roact.Ref] = t5.emptyStateRef,
			NextSelectionUp = t5.props.NextSelectionUp
		})
	end)
	local v181 = t5.props.ownedItemIdsBySubtype[t5.props.assetTypeKey] ~= nil and #t5.props.ownedItemIdsBySubtype[t5.props.assetTypeKey] > 0
	local v182 = t5:getShowAddOutfitButton()
	local v183 = if not v179 then if not v181 and not v182 then t5.recommendedItemsRef else t5.loadableGridViewRef else t5.emptyStateRef
	local name = t5.props.avatarRoute.current.name
	local forwardRef = t5.props.forwardRef

	if FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Ref] = t5.props.focusNavigationRef
		}, Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Change.AbsoluteSize] = t5.checkSetListWidth,
			[Roact.Event.AncestryChanged] = t5.checkSetListWidth,
			[Roact.Ref] = forwardRef or t5.listFrameRef,
			defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v183 else nil,
			restorePreviousChildFocus = if not FFlagAXMigrateAXToGlobalAutofocus then t5.state.restorePreviousChildFocus else nil,
			onFocusChanged = if not FFlagAXMigrateAXToGlobalAutofocus then t5.props.onFocusChanged else nil
		}, {
			FailedState = v179 and v180,
			ItemsList = not v179 and t5:renderItemsList(p56, n3)
		}))
	end

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = t5.checkSetListWidth,
		[Roact.Event.AncestryChanged] = t5.checkSetListWidth,
		[Roact.Ref] = forwardRef or t5.listFrameRef,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v183 else nil,
		restorePreviousChildFocus = if not FFlagAXMigrateAXToGlobalAutofocus then t5.state.restorePreviousChildFocus else nil,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus then name ~= AvatarScreen.ItemDetails and {
			NavUp = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 914
				-- upvalues: t5 (copy), p56 (copy)
				if t5.props.NextSelectionUp then
					p56.moveFocusTo(t5.props.NextSelectionUp)

					return
				end

				if t5.props.buttonBInputRef then
					p56.moveFocusTo(t5.props.buttonBInputRef)
				end
			end)
		} or nil else nil,
		onFocusChanged = if not FFlagAXMigrateAXToGlobalAutofocus then t5.props.onFocusChanged else nil
	}, {
		FailedState = v179 and v180,
		ItemsList = not v179 and t5:renderItemsList(p56, n3)
	})
end

local function getOwnedItemIds(p58, p59, p60) -- line: 934
	local t6 = {}

	if not p60 then
		return t6
	end

	local v190 = p58[p60]

	if not v190 then
		return t6
	end

	if not p59 or #p59 == 0 then
		return v190
	end

	local t7 = {}
	local n4 = 0

	for i = 1, #p59 do
		local v194 = p59[i]

		t7[v194] = true
		t6[i] = v194
		n4 = i
	end

	for i = 1, #v190 do
		local v196 = v190[i]

		if not t7[v196] then
			n4 += 1
			t6[n4] = v196
		end
	end

	return t6
end

function v97.getEquippedOutfit(p61, p62) -- line: 972
	-- upvalues: Utils2 (copy)
	local outfitInfos = p61.props.outfitInfos
	local ownedItemIdsBySubtype = p61.props.ownedItemIdsBySubtype
	local avatarType = p61.props.avatarType
	local bodyColor3s = p61.props.bodyColor3s
	local equippedAssets = p61.props.equippedAssets
	local scales = p61.props.scales
	local v205 = ownedItemIdsBySubtype[p62]

	if not v205 then
		return nil
	end

	for _, v207 in v205 do
		local v208 = outfitInfos[tostring(v207)]

		if v208 and Utils2.isWearingOutfitNoState(v208, avatarType, bodyColor3s, equippedAssets, scales) then
			return v207
		end
	end

	return nil
end
function v97.updateItems(p63, p64) -- line: 1000
	-- upvalues: Constants2 (copy), Utils2 (copy), Cryo (copy), getOwnedItemIds (copy), AddOutfitButton (copy)
	local assetTypeKey = p63.props.assetTypeKey
	local categoryInfo = p63.props.categoryInfo
	local equippedEmote = p63.props.equippedEmote
	local equippedAssets = p63.props.equippedAssets
	local isOutfitsPage = p63.props.isOutfitsPage
	local initialEquippedAssets = p63.state.initialEquippedAssets
	local ownedItemIdsBySubtype = p63.props.ownedItemIdsBySubtype
	local v218 = categoryInfo.PageType == Constants2.PageType.Emotes
	local t8 = {}

	if p64 then
		if v218 then
			initialEquippedAssets = equippedEmote and {
				[equippedEmote.assetId] = {}
			} or {}

			if equippedEmote then
				table.insert(t8, equippedEmote.assetId)
			end
		elseif isOutfitsPage then
			local v220 = p63:getEquippedOutfit(assetTypeKey)

			initialEquippedAssets = v220 and {
				[v220] = {}
			} or {}

			if v220 then
				table.insert(t8, v220)
			end
		else
			initialEquippedAssets = Utils2.getEquippedAssetIdsForCategory(equippedAssets, categoryInfo)
			t8 = Cryo.Dictionary.join(t8, initialEquippedAssets)
		end

		if next(initialEquippedAssets) ~= nil then
			p63.props.dispatchSetOwnedItemIdsBySubtype(assetTypeKey, t8)
		end

		p63:setState({
			initialEquippedAssets = initialEquippedAssets
		})
	end

	local v221 = getOwnedItemIds(ownedItemIdsBySubtype, initialEquippedAssets, assetTypeKey)

	if v221 and isOutfitsPage and v221[1] ~= AddOutfitButton and p63:getShowAddOutfitButton() then
		v221 = Cryo.List.join({ AddOutfitButton }, v221)
	end

	p63:setState({
		ownedItemIds = v221,
		itemsContainsOutfits = isOutfitsPage
	})
end
function v97.didMount(p65) -- line: 1060
	-- upvalues: RetrievalStatus (copy)
	p65.isMounted = true

	local v223 = p65.props.forwardRef or p65.listFrameRef

	p65.checkSetListWidth(v223.current)

	if p65.props.dataStatus == RetrievalStatus.NotStarted then
		p65.loadMoreUserInventoryItems()

		return
	end

	p65:updateItems(true)
end
function v97.willUnmount(p66) -- line: 1076
	p66.isMounted = false
end
function v97.didUpdate(p67, p68, _) -- line: 1080
	-- upvalues: AvatarScreen (copy), RetrievalStatus (copy)
	local name = p67.props.avatarRoute.current.name
	local name2 = p67.props.avatarRoute.opaque.name
	local name3 = p68.avatarRoute.opaque.name
	local categoryInfo = p67.props.categoryInfo
	local dataStatus = p67.props.dataStatus
	local dataStatus2 = p68.dataStatus
	local ownedItemIdsBySubtype = p67.props.ownedItemIdsBySubtype
	local v235 = p67.props.emoteSlot ~= p68.emoteSlot
	local v236 = p67.props.assetTypeKey ~= p68.assetTypeKey
	local v237 = p67.props.categoryIndex ~= p68.categoryIndex
	local v238 = p67.props.subcategoryIndex ~= p68.subcategoryIndex
	local v239 = p67.props.categoryIndex == 1 and p67.props.subcategoryIndex == 1
	local v240 = ownedItemIdsBySubtype ~= p68.ownedItemIdsBySubtype
	local v241 = v237 or (v238 or v239)

	if (name == AvatarScreen.AvatarEditor or name2 == AvatarScreen.AvatarEditor) and (v241 and categoryInfo.RenderItemTiles and dataStatus == RetrievalStatus.NotStarted) then
		p67.loadMoreUserInventoryItems()
	end

	if v237 or v238 then
		local current = p67.scrollingFrameRef.current

		if current then
			current.CanvasPosition = Vector2.new(0, 0)
		end

		p67:setState({
			restorePreviousChildFocus = false
		})
	end

	local v243 = dataStatus == RetrievalStatus.Done and dataStatus2 == RetrievalStatus.Fetching

	if v236 or v235 or v240 or v243 then
		p67:updateItems(v236 or (v235 or v243))
	end

	if name2 ~= name3 and name2 == AvatarScreen.AvatarEditor then
		local v244 = p67.scrollingFrameRef:getValue()

		if v244 then
			v244.CanvasPosition = Vector2.new(0, 0)
			p67.setParentRestorePreviousChildFocus(false)
		end
	end
end

local function mapStateToProps(p70, p71) -- line: 1138
	-- upvalues: Utils (copy), Utils2 (copy), RetrievalStatus (copy), GetFFlagAXEnableSlotBasedEditor (copy), AXCatalogHeadCategoryCombineIXP (copy), PerformFetch (copy), v81 (copy), selectOwnedItemIdToIsWearing (copy), FFlagAXRootSlotBasedEditorFlag (copy), DeviceOrientationMode (copy)
	local category = p70.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p70.AvatarExperience.AvatarEditor.Categories.subcategory
	local selectedSlot = p70.AvatarExperience.AvatarEditor.EquippedEmotes.selectedSlot
	local slotInfo = p70.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
	local v251 = Utils.getAvatarEditorCategoryInfoFromState(p70)
	local v252 = v251.RenderOutfitItemTiles == true
	local v253 = Utils2.selectAssetTypeKey(p70)
	local Failed = RetrievalStatus.Failed
	local v255 = false
	local v256 = nil

	if GetFFlagAXEnableSlotBasedEditor() or (AXCatalogHeadCategoryCombineIXP.isEnabled() and p71.enableHeadCategoryCombine or not v252) then
		v256 = v251 and v251.UseGetInventoryV2 or not v252
	end

	local v257 = Utils.getNextPageCursorKey(v253, v252, v251.OutfitType)
	local v258 = nil

	if v253 then
		local subButton = p70.AvatarExperience.AvatarEditor.Categories.subButton
		local v260

		v258, v260 = Utils2.getSearchUuidAndAssetTypes(v251, subButton)

		if (GetFFlagAXEnableSlotBasedEditor() or (AXCatalogHeadCategoryCombineIXP.isEnabled() and p71.enableHeadCategoryCombine or not v252)) and (v256 and v258) then
			Failed = PerformFetch.GetStatus(p70, v258)
			v257 = v258
		elseif v252 then
			local v261 = Utils.getPerformFetchKey(v253, v252, v251.OutfitType)

			Failed = PerformFetch.GetStatus(p70, v261)
		else
			local v262 = Utils.getPerformFetchKey(v253, v252, v251.OutfitType)

			Failed = PerformFetch.GetStatus(p70, v262)
		end

		v255 = not p70.AvatarExperience.AvatarEditor.PageFinished[if not v81 then v253 else v257]
	end

	local v263, v264 = selectOwnedItemIdToIsWearing(p70, v253)
	local BodyColor3s = p70.AvatarExperience.AvatarEditor.Character.BodyColor3s

	return {
		recommendationData = nil,
		userInventoryRecommendationsFetchStatus = nil,
		pageFinished = p70.AvatarExperience.AvatarEditor.PageFinished[v257],
		nextPageCursorKey = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else v257,
		categoryInfo = v251,
		dataStatus = Failed,
		hasMoreUserInventoryItems = v255,
		assetTypeKey = v253,
		categoryIndex = category,
		subcategoryIndex = subcategory,
		emoteSlot = selectedSlot,
		equippedEmote = slotInfo[selectedSlot],
		isOutfitsPage = v252,
		ownedItemIdToIsWearing = v263,
		hasItemFromCurrentPageEquipped = v264,
		outfitInfos = p70.AvatarExperience.AvatarEditor.OutfitInfos,
		avatarType = p70.AvatarExperience.AvatarEditor.Character.AvatarType,
		bodyColor3s = BodyColor3s,
		scales = p70.AvatarExperience.AvatarEditor.Character.AvatarScales,
		equippedAssets = p70.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		outfitOrAsset = p70.AvatarExperience.AvatarEditor.Character.OutfitOrAsset,
		ownedItemIdsBySubtype = p70.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype,
		screenSize = p70.ScreenSize,
		isPortrait = if not FFlagAXRootSlotBasedEditorFlag then nil else p70.DeviceOrientation == DeviceOrientationMode.Portrait,
		analyticsMetadata = p70.AvatarExperience.AnalyticsMetadata,
		searchUuid = v258
	}
end
local function mapDispatchToProps(p72) -- line: 1245
	-- upvalues: GetUserInventory (copy), GetUserInventoryV2 (copy), GetOutfits (copy), SendShopForMoreAnalytics (copy), FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation (copy), NavigateWithLock (copy), SetOwnedItemIdsBySubtype (copy)
	return {
		getUserInventory = function(p73) -- line: 1247
			-- upvalues: p72 (copy), GetUserInventory (copy)
			return p72(GetUserInventory(p73))
		end,
		getUserInventoryV2 = function(p74, p75, p76, p77) -- line: 1251
			-- upvalues: p72 (copy), GetUserInventoryV2 (copy)
			return p72(GetUserInventoryV2(p74, p75, p76, nil, nil, p77))
		end,
		getOutfits = function(p78, p79, p80, p81) -- line: 1255
			-- upvalues: p72 (copy), GetOutfits (copy)
			return p72(GetOutfits(p78, p79, p80, p81))
		end,
		sendShopForMoreAnalytics = function(p82) -- line: 1259
			-- upvalues: p72 (copy), SendShopForMoreAnalytics (copy)
			p72(SendShopForMoreAnalytics(p82))
		end,
		navigateWithLock = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else function(p83) -- line: 1264
			-- upvalues: p72 (copy), NavigateWithLock (copy)
			p72(NavigateWithLock(p83))
		end,
		dispatchSetOwnedItemIdsBySubtype = function(s1: string, p84) -- line: 1269
			-- upvalues: p72 (copy), SetOwnedItemIdsBySubtype (copy)
			return p72(SetOwnedItemIdsBySubtype(s1, p84))
		end
	}
end

local v101 = RoactServices.connect({
	networking = RoactNetworking,
	avatarEditorAnalytics = Analytics
})(v97)
local v102 = withAdaptiveScrolling((withNavigation((withAvatarRoute((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v101)))))))

if AXCatalogHeadCategoryCombineIXP.isEnabled() then
	v102 = IxpUtils.connectTestVariables({
		enableHeadCategoryCombine = AXCatalogHeadCategoryCombineIXP.EnableHeadCategoryCombination
	})(v102)
end

local u103 = RoactAppPolicy.connect(function(p85, _) -- line: 1294
	return {
		enableContinuousLoad = p85.getEnableContinuousLoad()
	}
end)(v102)

local function selectCategoryInfo(p87) -- line: 1300
	-- upvalues: Utils (copy)
	return Utils.getAvatarEditorCategoryInfoFromState(p87)
end
local function selectAssetTypeKey(p88) -- line: 1304
	-- upvalues: Utils2 (copy)
	return Utils2.selectAssetTypeKey(p88)
end

return Roact.forwardRef(function(p89, p90) -- line: 1308
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad (copy), RoactGamepad (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useSelector (copy), selectCategoryInfo (copy), selectAssetTypeKey (copy), IxpUtils (copy), AXCatalogHeadCategoryCombineIXP (copy), FFlagAXItemDetailsIxpExposure (copy), useUnifiedEventImpressionsReporter (copy), React (copy), Utils (copy), Utils2 (copy), GetFFlagAXEnableSlotBasedEditor (copy), GetUserInventoryV2 (copy), Constants2 (copy), Constants3 (copy), GetOutfits (copy), GetUserInventory (copy), useRequest (copy), RequestStatusEnum (copy), useFocusGuiObject (copy), useFocusNavigationBindings (copy), Roact (copy), u103 (ref), Cryo (copy)
	local NextSelectionUp = p89.NextSelectionUp
	local buttonBInputRef = p89.buttonBInputRef
	local v275 = if not FFlagAXMigrateAXToGlobalAutofocus then if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else RoactGamepad.useFocusController() else nil
	local v276 = useRoactService(RoactNetworking)
	local v277 = useDispatch()
	local v278 = useSelector(selectCategoryInfo)
	local v279 = useSelector(selectAssetTypeKey)
	local v280 = IxpUtils.useTestVariables(AXCatalogHeadCategoryCombineIXP.EnableHeadCategoryCombination)
	local v281 = AXCatalogHeadCategoryCombineIXP.isEnabled()
	local v282 = nil

	if FFlagAXItemDetailsIxpExposure then
		local v283 = useUnifiedEventImpressionsReporter()

		v282 = React.useMemo(function() -- line: 1325
			-- upvalues: v283 (copy)
			return { v283 }
		end, { v283 })
	end

	local v284 = React.useCallback(function() -- line: 1330
		-- upvalues: v278 (copy), Utils (copy), v279 (copy), Utils2 (copy), GetFFlagAXEnableSlotBasedEditor (copy), v281 (copy), v280 (copy), v277 (copy), GetUserInventoryV2 (copy), v276 (copy), Constants2 (copy), Constants3 (copy), GetOutfits (copy), GetUserInventory (copy)
		local v339 = v278.RenderOutfitItemTiles == true
		local v340 = Utils.getNextPageCursorKey(v279, v339, v278.OutfitType)
		local v341, _ = Utils2.getSearchUuidAndAssetTypes(v278, nil)

		if v279 and ((GetFFlagAXEnableSlotBasedEditor() or v281 and v280) and (v278 and v278.UseGetInventoryV2 and v341)) then
			v340 = v341
		end

		if GetFFlagAXEnableSlotBasedEditor() and v278.UseGetInventoryV2 or not v339 then
			return v277(GetUserInventoryV2(v276, v278, v340))
		end

		if v281 and v280 and v278.OutfitType == Constants2.OutfitTypes.DynamicHead and v278.AssetTypeIdStrings then
			return v277(GetUserInventoryV2(v276, v278, v340))
		end

		if v339 then
			local v343 = v279 == Constants3.EditableCharacterKey
			local OutfitType = v278.OutfitType
			local v345 = v279 .. (OutfitType or "")

			return v277(GetOutfits(v279, v343, v345, OutfitType))
		end

		return v277(GetUserInventory(v278))
	end, {
		v276,
		v277,
		v278,
		v279,
		v280,
		v281
	})
	local v285, v286 = useRequest(v284)
	local v287 = v285.status == RequestStatusEnum.Pending
	local v288 = nil
	local v289 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useFocusGuiObject()

	if FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		local v290 = React.useCallback(function() -- line: 1386
			-- upvalues: NextSelectionUp (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v289 (copy), v275 (copy), buttonBInputRef (copy)
			if NextSelectionUp then
				if not FFlagAXMigrateAXToGlobalAutofocus then
					v275.moveFocusTo(NextSelectionUp.current)

					return
				end

				if v289 and NextSelectionUp.current then
					v289(NextSelectionUp.current)

					return
				end
			elseif buttonBInputRef then
				if FFlagAXMigrateAXToGlobalAutofocus then
					if v289 and buttonBInputRef and buttonBInputRef.current then
						v289(buttonBInputRef.current)

						return
					end
				else
					v275.moveFocusTo(buttonBInputRef)
				end
			end
		end, {
			NextSelectionUp,
			buttonBInputRef,
			if not FFlagAXMigrateAXToGlobalAutofocus then v275 else v289
		})

		v288 = useFocusNavigationBindings(nil, v290)
	end

	return Roact.createElement(u103, Cryo.Dictionary.join(p89, {
		forwardRef = p90,
		focusNavigationRef = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else v288,
		focusController = if FFlagAXMigrateAXToGlobalAutofocus or not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else v275,
		focusGuiObject = v289,
		loadMoreItems = v286,
		isFetchingMore = v287,
		tagBasedImpressionsDetectorExtensions = v282
	}))
end)

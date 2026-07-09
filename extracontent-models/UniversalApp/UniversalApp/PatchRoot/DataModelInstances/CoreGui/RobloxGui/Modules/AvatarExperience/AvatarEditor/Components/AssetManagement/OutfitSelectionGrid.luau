local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local FitFrame = require(CorePackages.Packages.FitFrame)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local Focusable = RoactGamepad.Focusable
local FitFrameVertical = FitFrame.FitFrameVertical
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local GridMetrics = UIBlox.App.Grid.GridMetrics
local ItemTile = UIBlox.Tile.ItemTile
local withStyle = UIBlox.Style.withStyle
local EmptyState = UIBlox.App.Indicator.EmptyState
local Images = UIBlox.App.ImageSet.Images
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants3 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local GetEditableOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetEditableOutfits)
local OutfitSelectionGridItem = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitSelectionGridItem)
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)
local RequestStatusEnum = require(Modules.AvatarExperience.Common.Enum.RequestStatusEnum)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRequest = require(Modules.AvatarExperience.Common.Hooks.useRequest)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local FFlagAXUpdateSlotBasedEditorToastAndPrompts = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUpdateSlotBasedEditorToastAndPrompts
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXFixGamepadNavigationOnOutfitManagement = AvatarExperienceFlags.FFlagAXFixGamepadNavigationOnOutfitManagement
local FFlagAXManageOutfitsCatalogItemCard = AvatarExperienceFlags.FFlagAXManageOutfitsCatalogItemCard
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local InventoryItemAvailability = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local v50 = Images["icons/navigation/pushBack"]
local v51 = GridMetrics.makeCustomMetricsGetter(Constants.ItemsGridMetrics)
local v52 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 96
	-- upvalues: useLocalization (copy), useDesignTokens (copy), React (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy)
	local v60 = useLocalization({
		loadMore = "Feature.Catalog.Action.LoadMore"
	})
	local v61 = useDesignTokens()

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v61.Global.Size_600 else v61.Size.Size_1200),
		ref = p1,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionUp else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionDown else nil,
		LayoutOrder = t1.LayoutOrder
	}, {
		LoadMoreButton = React.createElement(Button, {
			onActivated = t1.onActivated,
			text = v60.loadMore,
			standardSize = StandardButtonSize.Regular,
			buttonType = ButtonType.Secondary,
			size = UDim2.fromScale(1, 1),
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		})
	})
end)

local function getOutfitItemStatus(p2) -- line: 126
	-- upvalues: FFlagAXManageOutfitsCatalogItemCard (copy), InventoryItemAvailability (copy), FFlagAXModeratedItemIconUpdates (copy)
	if not FFlagAXManageOutfitsCatalogItemCard or not p2 then
		return nil
	end

	local availabilityStatus = p2.availabilityStatus

	if availabilityStatus == InventoryItemAvailability.Unavailable then
		return {
			type = "placeholder",
			iconType = not FFlagAXModeratedItemIconUpdates and "Error" or "Unavailable"
		}
	end

	if availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems then
		return {
			type = "icon",
			iconType = "Unavailable"
		}
	end

	return nil
end

local v54 = React.PureComponent:extend("OutfitSelectionGrid")

v54.validateProps = t.strictInterface({
	onToggleOutfitCard = t.optional(t.callback),
	selectedOutfits = t.array(t.string),
	selectionUpdated = t.callback,
	canScrollUpdated = t.optional(t.callback),
	multiSelect = t.optional(t.boolean),
	goBack = t.callback,
	pageOwner = t.string,
	loadMoreItems = t.callback,
	isFetchingMore = t.boolean,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	forwardRef = t.table,
	showCustomOutfitNames = t.boolean,
	enableContinuousLoad = t.boolean,
	outfitInfos = t.table,
	editableOwnedOutfitIds = t.array(t.string),
	screenSize = t.Vector2,
	hasMoreItems = t.boolean,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	focusGuiObject = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t.optional(t.callback)
})
v54.defaultProps = {
	multiSelect = false
}

function v54.getItemIconType(p3, p4) -- line: 182
	-- upvalues: Utils (copy)
	local outfitInfos = p3.props.outfitInfos
	local v67 = outfitInfos and outfitInfos[p4]

	if v67 then
		return Utils.getItemIconTypeFromOutfit(v67)
	end

	return nil
end
function v54.init(p5) -- line: 193
	-- upvalues: React (copy), Constants (copy), wasLastInputGamepad (copy), Constants2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	p5.loadableGridViewRef = React.createRef()
	p5.emptyStateRef = React.createRef()
	p5.loadMoreRef = React.createRef()

	local n1 = 0
	local n2 = 0

	local function checkCanScroll() -- line: 200
		-- upvalues: p5 (copy), Constants (copy), n2 (ref), n1 (ref)
		if p5.props.canScrollUpdated then
			local v128 = Constants.ItemsGridTopPadding + Constants.ItemsGridBottomPadding

			p5.props.canScrollUpdated(n2 + v128 > n1)
		end
	end

	function p5.absoluteSizeChanged(p6) -- line: 207
		-- upvalues: n1 (ref), p5 (copy), Constants (copy), n2 (ref)
		n1 = p6.AbsoluteSize.Y

		if p5.props.canScrollUpdated then
			local v130 = Constants.ItemsGridTopPadding + Constants.ItemsGridBottomPadding

			p5.props.canScrollUpdated(n2 + v130 > n1)
		end
	end
	function p5.contentSizeChanged(p7) -- line: 212
		-- upvalues: n2 (ref), p5 (copy), Constants (copy), n1 (ref)
		n2 = p7.AbsoluteContentSize.Y

		if p5.props.canScrollUpdated then
			local v132 = Constants.ItemsGridTopPadding + Constants.ItemsGridBottomPadding

			p5.props.canScrollUpdated(n2 + v132 > n1)
		end
	end
	function p5.onLoadMoreButtonActivated() -- line: 217
		-- upvalues: wasLastInputGamepad (copy), p5 (copy), Constants2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		local v133 = wasLastInputGamepad()
		local v134 = not (p5.props.hasMoreItems and #p5.props.editableOwnedOutfitIds == 0) and p5.props.editableOwnedOutfitIds or nil
		local ShimmerCardsToDisplay = Constants2.ShimmerCardsToDisplay
		local v136 = (v134 and #v134 or ShimmerCardsToDisplay) > 0

		if v133 then
			p5:setState({
				restorePreviousChildFocus = true
			})

			if v136 then
				if FFlagAXMigrateAXToGlobalAutofocus then
					if p5.props.focusGuiObject and p5.loadableGridViewRef.current then
						p5.props.focusGuiObject(p5.loadableGridViewRef.current)
					end
				else
					p5.props.focusController.moveFocusTo(p5.loadableGridViewRef)
				end
			end
		end

		p5.props.loadMoreItems()
	end
end
function v54.renderItem(p8, p9) -- line: 242
	-- upvalues: Cryo (copy), Constants3 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants2 (copy), FFlagAXManageOutfitsCatalogItemCard (copy), React (copy), OutfitSelectionGridItem (copy), getOutfitItemStatus (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ItemTile (copy), Focusable (copy), RoactGamepad (copy)
	if typeof(p9) == "table" then
		p9 = nil
	end

	local v75 = Cryo.List.find(p8.props.selectedOutfits, p9) ~= nil

	local function toggleSelectOutfit() -- line: 248
		-- upvalues: p8 (copy), v75 (copy), Cryo (copy), p9 (ref)
		if p8.props.multiSelect then
			local v137 = if not v75 then Cryo.List.join(p8.props.selectedOutfits, { p9 }) else Cryo.List.removeValue(p8.props.selectedOutfits, p9)

			p8.props.selectionUpdated(v137)

			return
		end

		if v75 then
			p8.props.selectionUpdated({})

			if p8.props.onToggleOutfitCard then
				p8.props.onToggleOutfitCard(false)

				return
			end
		else
			p8.props.selectionUpdated({ p9 })

			if p8.props.onToggleOutfitCard then
				p8.props.onToggleOutfitCard(true, p9)
			end
		end
	end

	local v77 = nil
	local v78 = nil

	if p9 then
		local v79 = p8.props.outfitInfos[tostring(p9)]

		v77 = v79 and v79.name or nil

		local Outfit = Constants3.RbxthumbTypes.Outfit

		v78 = getRbxthumbWithTypeSizeAndOptions(p9, Outfit, 150)

		if v79 then
			v78 ..= "&filters=" .. v79.updateCounter
		end
	end

	local ItemTileTitleMaxLines = Constants2.ItemTileTitleMaxLines

	if not p8.props.showCustomOutfitNames then
		ItemTileTitleMaxLines = 0
	end

	if FFlagAXManageOutfitsCatalogItemCard then
		local v82 = p9 and p8.props.outfitInfos[tostring(p9)] or nil

		return React.createElement(OutfitSelectionGridItem, {
			useCatalogItemCard = true,
			isSelected = v75,
			multiSelect = p8.props.multiSelect,
			toggleSelectOutfit = toggleSelectOutfit,
			name = if not p8.props.showCustomOutfitNames then nil else v77,
			thumbnail = v78,
			itemId = p9,
			selectionUpdated = p8.props.selectionUpdated,
			selectedOutfits = p8.props.selectedOutfits,
			onToggleOutfitCard = p8.props.onToggleOutfitCard,
			itemStatus = getOutfitItemStatus(v82)
		})
	end

	if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
		return React.createElement(OutfitSelectionGridItem, {
			isSelected = v75,
			multiSelect = p8.props.multiSelect,
			itemIconType = p8:getItemIconType(p9),
			toggleSelectOutfit = toggleSelectOutfit,
			name = v77,
			titleTextLineCount = ItemTileTitleMaxLines,
			thumbnail = v78,
			itemId = p9,
			selectionUpdated = p8.props.selectionUpdated,
			selectedOutfits = p8.props.selectedOutfits,
			onToggleOutfitCard = p8.props.onToggleOutfitCard
		})
	end

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[ItemTile] else ItemTile, {
		isSelected = v75,
		multiSelect = p8.props.multiSelect,
		itemIconType = p8:getItemIconType(p9),
		onActivated = toggleSelectOutfit,
		name = v77,
		titleTextLineCount = ItemTileTitleMaxLines,
		thumbnail = v78,
		Selectable = not not FFlagAXMigrateAXToGlobalAutofocus or nil,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus then {
			ToggleSelect = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, toggleSelectOutfit, {
				key = not v75 and "Feature.Avatar.Action.Select" or "Feature.Avatar.Action.Unselect"
			})
		} else nil
	})
end
function v54.renderWithProviders(p10, p11, p12) -- line: 346
	-- upvalues: Constants2 (copy), Utils (copy), React (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), AXRefreshScrollingFrameWithLoadMore (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), FitFrameVertical (copy), Constants (copy), LoadableGridView (copy), v51 (copy), v52 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), LoadingBarWithTheme (copy), EmptyState (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), v50 (copy)
	local v86 = p10.props.hasMoreItems and #p10.props.editableOwnedOutfitIds == 0
	local v87 = not v86 and p10.props.editableOwnedOutfitIds or nil
	local ShimmerCardsToDisplay = Constants2.ShimmerCardsToDisplay
	local v89 = v87 and #v87 or ShimmerCardsToDisplay
	local v90 = v89 > 0
	local p11Font = p11.Font
	local v92 = p11Font.BaseSize * p11Font.Header2.RelativeSize
	local v93 = if not p10.props.showCustomOutfitNames then Utils.GridItemHeightGetter(Constants2.ItemTileType.BundleItemTileNoText) else Utils.GridItemHeightGetter(Constants2.ItemTileType.BundleItemTile, v92)
	local v94 = if not v90 then p10.emptyStateRef else p10.loadableGridViewRef
	local v95 = p12.noItemsLabel:gsub("({itemType})", p12.itemType)
	local forwardRef = p10.props.forwardRef
	local isFetchingMore = p10.props.isFetchingMore
	local enableContinuousLoad = p10.props.enableContinuousLoad
	local v99 = isFetchingMore or v86
	local v100 = not v99 and p10.props.hasMoreItems
	local v101 = if not v100 or not enableContinuousLoad then nil else p10.props.loadMoreItems
	local v102 = v100 and not enableContinuousLoad

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = p10.absoluteSizeChanged,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then p10.props.NextSelectionLeft else nil,
		NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then p10.props.NextSelectionRight else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p10.props.NextSelectionDown else nil,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p10.props.NextSelectionUp else nil,
		ref = forwardRef,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v94 else nil,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil
	}, {
		RefreshScrollingFrameWithLoadMore = v90 and React.createElement(AXRefreshScrollingFrameWithLoadMore, {
			BackgroundTransparency = 1,
			createEndOfScrollElement = false,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			parentAppPage = p10.props.pageOwner,
			onThresholdReached = v101,
			Selectable = not FFlagAXFixGamepadNavigationOnOutfitManagement and nil
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				[React.Change.AbsoluteContentSize] = p10.contentSizeChanged
			}),
			ListWrapper = React.createElement(FitFrameVertical, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				margin = {
					top = Constants.ItemsGridTopPadding,
					bottom = Constants.ItemsGridBottomPadding,
					left = Constants.ItemsGridSidePadding / 2,
					right = Constants.ItemsGridSidePadding / 2
				}
			}, {
				LoadableGridView = React.createElement(LoadableGridView, {
					getItemMetrics = v51,
					items = v87,
					totalNumItems = v89,
					renderItem = function(p13) -- line: 435
						-- upvalues: p10 (copy)
						return p10:renderItem(p13)
					end,
					getItemHeight = v93,
					windowHeight = p10.props.screenSize.Y,
					ref = p10.loadableGridViewRef,
					NextSelectionDown = if not v52 then nil else p10.loadMoreRef
				})
			}),
			LoadMoreButton = if not v102 or not v52 then nil else React.createElement(v52, {
				LayoutOrder = 2,
				onActivated = p10.onLoadMoreButtonActivated,
				ref = p10.loadMoreRef,
				NextSelectionUp = p10.loadableGridViewRef
			}),
			LoadingBar = if not v99 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then p11.Tokens.Global.Size_700 else p11.Tokens.Size.Size_1400)
			}, {
				LoadingBar = React.createElement(LoadingBarWithTheme)
			})
		}),
		EmptyState = not v90 and React.createElement(EmptyState, {
			buttonIcon = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then v50 else "",
			icon = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else "",
			buttonText = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else p12.backLabel,
			iconSize = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else UDim2.fromScale(0, 0),
			onActivated = p10.props.goBack,
			text = v95,
			ref = p10.emptyStateRef
		})
	})
end
function v54.render(p14) -- line: 489
	-- upvalues: withStyle (copy), withLocalization (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy)
	return withStyle(function(p15) -- line: 490
		-- upvalues: withLocalization (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), p14 (copy)
		return withLocalization({
			noItemsLabel = "Feature.Avatar.Label.NoItems",
			itemType = not FFlagAXUpdateSlotBasedEditorToastAndPrompts and "Feature.Catalog.Label.Characters" or "Feature.Avatar.Label.Avatars",
			backLabel = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else "Feature.Avatar.Label.Back"
		})(function(p16) -- line: 497
			-- upvalues: p14 (copy), p15 (copy)
			return p14:renderWithProviders(p15, p16)
		end)
	end)
end
function v54.didMount(p17) -- line: 503
	if p17.props.hasMoreItems then
		p17.props.loadMoreItems()
	end
end
function v54.didUpdate(p18, p19, _) -- line: 509
	-- upvalues: Cryo (copy)
	if p18.props.multiSelect ~= p19.multiSelect and not p18.props.multiSelect then
		p18.props.selectionUpdated({})
	end

	local v108 = p18.props.editableOwnedOutfitIds ~= p19.editableOwnedOutfitIds
	local v109 = p18.props.selectedOutfits ~= p19.selectedOutfits

	if v108 or v109 then
		local t2 = {}
		local v111 = false

		for _, v113 in p18.props.selectedOutfits do
			if Cryo.List.find(p18.props.editableOwnedOutfitIds, v113) then
				t2[#t2 + 1] = v113
			else
				v111 = true
			end
		end

		if v111 then
			p18.props.selectionUpdated(t2)
		end
	end
end

local v55 = RoactAppPolicy.connect(function(p21, _) -- line: 540
	return {
		showCustomOutfitNames = p21.getCustomOutfitNames(),
		enableContinuousLoad = p21.getEnableContinuousLoad()
	}
end)(v54)

local function mapStateToProps(p23, _) -- line: 547
	-- upvalues: Constants (copy)
	local v118 = p23.AvatarExperience.AvatarEditor.PageFinished[Constants.EditableCharacterKey]
	local OutfitInfos = p23.AvatarExperience.AvatarEditor.OutfitInfos

	return {
		editableOwnedOutfitIds = p23.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[Constants.EditableCharacterKey] or {},
		outfitInfos = OutfitInfos,
		screenSize = p23.ScreenSize,
		hasMoreItems = not v118
	}
end

local u57 = RoactRodux.connect(mapStateToProps)(v55)

return React.forwardRef(function(p25, p26) -- line: 565
	-- upvalues: useDispatch (copy), React (copy), GetEditableOutfits (copy), useRequest (copy), RequestStatusEnum (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useFocusGuiObject (copy), u57 (ref), Cryo (copy), RoactGamepad (copy)
	local v122 = useDispatch()
	local v123 = React.useCallback(function() -- line: 568
		-- upvalues: v122 (copy), GetEditableOutfits (copy)
		return v122(GetEditableOutfits())
	end, {})
	local v124, v125 = useRequest(v123)
	local v126 = v124.status == RequestStatusEnum.Pending

	if FFlagAXMigrateAXToGlobalAutofocus then
		local v127 = useFocusGuiObject()

		return React.createElement(u57, Cryo.Dictionary.join(p25, {
			forwardRef = p26,
			loadMoreItems = v125,
			isFetchingMore = v126,
			focusGuiObject = v127
		}))
	end

	return RoactGamepad.withFocusController(function(p27) -- line: 588
		-- upvalues: React (copy), u57 (ref), Cryo (copy), p25 (copy), p26 (copy), v125 (copy), v126 (copy)
		return React.createElement(u57, Cryo.Dictionary.join(p25, {
			forwardRef = p26,
			loadMoreItems = v125,
			isFetchingMore = v126,
			focusController = p27
		}))
	end)
end)

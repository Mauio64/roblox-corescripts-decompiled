local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local FitFrame = require(CorePackages.Packages.FitFrame)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local fitFrameVertical = FitFrame.FitFrameVertical

require("@luauforge/bundled/dKT")
local module = require("@luauforge/deferred/gRU")

local gridMetrics = UIBlox.App.Grid.GridMetrics
local itemTile = UIBlox.Tile.ItemTile
local withStyle = UIBlox.Style.withStyle
local emptyState = UIBlox.App.Indicator.EmptyState

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/fCe")
local module3 = require("@luauforge/bundled/dRg")
local module4 = require("@luauforge/bundled/dPN")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")

local module6 = require("@luauforge/bundled/ciE")
local constants = module6.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module6.Utils.getRbxthumbWithTypeSizeAndOptions

local module7 = require("@luauforge/deferred/gLC")

local module8 = require("@luauforge/deferred/hjD")

local module9 = require("@luauforge/deferred/gSa")
local module10 = require("@luauforge/deferred/gRT")
local module11 = require("@luauforge/bundled/egE")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module12 = require("@luauforge/deferred/gRV")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local fFlagAXScrollTelemetryIntegration2 = SharedFlags.FFlagAXScrollTelemetryIntegration2
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXManageOutfitsCatalogItemCard = AvatarExperienceFlags.FFlagAXManageOutfitsCatalogItemCard
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates

local inventoryItemAvailability = require("@luauforge/bundled/fCn").Enums.InventoryItemAvailability

local customMetricsGetter = gridMetrics.makeCustomMetricsGetter(module3.ItemsGridMetrics)

local forwardRef = React.forwardRef(function(p2, p3)
	local v5 = useLocalization({ loadMore = "Feature.Catalog.Action.LoadMore" })

	local v6 = useDesignTokens()
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v6.Size.Size_1200),
			ref = p3,
			LayoutOrder = p2.LayoutOrder
		},
		{
			LoadMoreButton = React.createElement(button, {
				onActivated = p2.onActivated,
				text = v5.loadMore,
				standardSize = standardButtonSize.Regular,
				buttonType = buttonType.Secondary,
				size = UDim2.fromScale(1, 1),
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5)
			})
		}
	)
end)

local function getOutfitItemStatus(p2)
	if not (fFlagAXManageOutfitsCatalogItemCard and p2) then
		return nil
	end

	local availabilityStatus = p2.availabilityStatus

	if availabilityStatus == inventoryItemAvailability.Unavailable then
		return {
			type = "placeholder",
			iconType = fFlagAXModeratedItemIconUpdates and "Unavailable" or "Error"
		}
	end

	if availabilityStatus == inventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems then
		return { type = "icon", iconType = "Unavailable" }
	end

	return nil
end

local extended = React.PureComponent:extend("OutfitSelectionGrid")

extended.validateProps = t.strictInterface({
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
	focusGuiObject = t.optional(t.callback)
})

extended.defaultProps = { multiSelect = false }

function extended:getItemIconType(p3)
	local outfitInfos = self.props.outfitInfos
	local v5 = outfitInfos and outfitInfos[p3]

	if v5 then
		return module2.getItemIconTypeFromOutfit(v5)
	end

	return nil
end

function extended:init()
	self.loadableGridViewRef = React.createRef()
	self.emptyStateRef = React.createRef()
	self.loadMoreRef = React.createRef()

	local v5 = 0
	local v6 = 0
	local function checkCanScroll()
		if self.props.canScrollUpdated then
			local v7 = module3.ItemsGridTopPadding + module3.ItemsGridBottomPadding
			local canScrollUpdated = self.props.canScrollUpdated
			local v8 = v6 + v7
			canScrollUpdated(v5 < v8)
		end
	end

	function self.absoluteSizeChanged(p2)
		v5 = p2.AbsoluteSize.Y

		if self.props.canScrollUpdated then
			local v7 = module3.ItemsGridTopPadding + module3.ItemsGridBottomPadding
			local canScrollUpdated = self.props.canScrollUpdated
			local v8 = v6 + v7
			canScrollUpdated(v5 < v8)
		end
	end

	function self.contentSizeChanged(p2)
		v6 = p2.AbsoluteContentSize.Y

		if self.props.canScrollUpdated then
			local v7 = module3.ItemsGridTopPadding + module3.ItemsGridBottomPadding
			local canScrollUpdated = self.props.canScrollUpdated
			local v8 = v6 + v7
			canScrollUpdated(v5 < v8)
		end
	end

	function self.onLoadMoreButtonActivated()
		local v7 = wasLastInputGamepad()
		local editableOwnedOutfitIds

		if not (self.props.hasMoreItems and #self.props.editableOwnedOutfitIds == 0) then
			editableOwnedOutfitIds = self.props.editableOwnedOutfitIds or nil
		end

		local shimmerCardsToDisplay = module4.ShimmerCardsToDisplay
		local v8 = (editableOwnedOutfitIds and (#editableOwnedOutfitIds or shimmerCardsToDisplay) or shimmerCardsToDisplay) > 0

		if v7 then
			self:setState({ restorePreviousChildFocus = true })

			if v8 and self.props.focusGuiObject and self.loadableGridViewRef.current then
				self.props.focusGuiObject(self.loadableGridViewRef.current)
			end
		end

		self.props.loadMoreItems()
	end
end

function extended:renderItem(itemId)
	if typeof(itemId) == "table" then
		itemId = nil
	end

	local v5 = Cryo.List.find(self.props.selectedOutfits, itemId) ~= nil
	local function toggleSelectOutfit()
		if self.props.multiSelect then
			local v6 = if v5 then Cryo.List.removeValue(self.props.selectedOutfits, itemId) else Cryo.List.join(self.props.selectedOutfits, { itemId })

			self.props.selectionUpdated(v6)
		elseif v5 then
			self.props.selectionUpdated({})

			if self.props.onToggleOutfitCard then
				self.props.onToggleOutfitCard(false)
			end
		else
			self.props.selectionUpdated({ itemId })

			if self.props.onToggleOutfitCard then
				self.props.onToggleOutfitCard(true, itemId)
			end
		end
	end

	local name, v6

	if itemId then
		local outfitInfo = self.props.outfitInfos[tostring(itemId)]

		if outfitInfo then
			name = outfitInfo.name or nil
		end

		v6 = getRbxthumbWithTypeSizeAndOptions(itemId, constants.RbxthumbTypes.Outfit, 150)

		if outfitInfo then
			v6 ..= "&filters=" .. outfitInfo.updateCounter
		end
	end

	local itemTileTitleMaxLines = module4.ItemTileTitleMaxLines
	local v7 = not self.props.showCustomOutfitNames and 0 or itemTileTitleMaxLines

	if fFlagAXManageOutfitsCatalogItemCard then
		local v8 = if itemId then self.props.outfitInfos[tostring(itemId)] or nil else nil
		local createElement = React.createElement
		local v10 = {
			isSelected = v5,
			multiSelect = self.props.multiSelect,
			toggleSelectOutfit = toggleSelectOutfit,
			name = 0,
			thumbnail = 0,
			itemId = 0,
			selectionUpdated = 0,
			selectedOutfits = 0,
			onToggleOutfitCard = 0,
			itemStatus = 0,
			useCatalogItemCard = true
		}

		if not self.props.showCustomOutfitNames then
			name = nil
		end

		v10.name = name
		v10.thumbnail = v6
		v10.itemId = itemId
		v10.selectionUpdated = self.props.selectionUpdated
		v10.selectedOutfits = self.props.selectedOutfits
		v10.onToggleOutfitCard = self.props.onToggleOutfitCard
		v10.itemStatus = getOutfitItemStatus(v8)
		return createElement(module8, v10)
	elseif fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
		return React.createElement(module8, {
			isSelected = v5,
			multiSelect = self.props.multiSelect,
			itemIconType = self:getItemIconType(itemId),
			toggleSelectOutfit = toggleSelectOutfit,
			name = name,
			titleTextLineCount = v7,
			thumbnail = v6,
			itemId = itemId,
			selectionUpdated = self.props.selectionUpdated,
			selectedOutfits = self.props.selectedOutfits,
			onToggleOutfitCard = self.props.onToggleOutfitCard
		})
	else
		return React.createElement(itemTile, {
			isSelected = v5,
			multiSelect = self.props.multiSelect,
			itemIconType = self:getItemIconType(itemId),
			onActivated = toggleSelectOutfit,
			name = name,
			titleTextLineCount = v7,
			thumbnail = v6,
			Selectable = true
		})
	end
end

function extended:renderWithProviders(p2, props2)
	local v5 = self.props.hasMoreItems and #self.props.editableOwnedOutfitIds == 0

	local editableOwnedOutfitIds = if not v5 then self.props.editableOwnedOutfitIds or nil else nil
	local shimmerCardsToDisplay = module4.ShimmerCardsToDisplay
	local v6 = editableOwnedOutfitIds and (#editableOwnedOutfitIds or shimmerCardsToDisplay)
		or shimmerCardsToDisplay
	local v7 = v6 > 0
	local font = p2.Font
	local v8 = font.BaseSize * font.Header2.RelativeSize
	local v9

	if self.props.showCustomOutfitNames then
		v9 = module2.GridItemHeightGetter(module4.ItemTileType.BundleItemTile, v8)
	else
		v9 = module2.GridItemHeightGetter(module4.ItemTileType.BundleItemTileNoText)
	end

	local v10 = props2.noItemsLabel:gsub("({itemType})", props2.itemType)

	local forwardRef2 = self.props.forwardRef

	local isFetchingMore = self.props.isFetchingMore
	local enableContinuousLoad = self.props.enableContinuousLoad
	local v11 = isFetchingMore or v5
	local hasMoreItems = not v11 and self.props.hasMoreItems
	local loadMoreItems = if hasMoreItems and enableContinuousLoad then self.props.loadMoreItems else nil
	local v12 = hasMoreItems and not enableContinuousLoad
	local createElement = React.createElement
	local absoluteSizeChangedsByAbsoluteSize = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = self.absoluteSizeChanged,
		ref = forwardRef2
	}
	local v15

	if v7 then
		local createElement2 = React.createElement
		local v17 = {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			createEndOfScrollElement = false,
			parentAppPage = self.props.pageOwner,
			scrollPerformanceIntervalName = 0,
			onThresholdReached = 0,
			Selectable = false
		}

		local v18 = if fFlagAXScrollTelemetryIntegration2 then module.OutfitGridAssetMgmt else nil
		v17.scrollPerformanceIntervalName = v18

		v17.onThresholdReached = loadMoreItems

		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				[React.Change.AbsoluteContentSize] = self.contentSizeChanged
			}),
			ListWrapper = 0,
			LoadMoreButton = 0,
			LoadingBar = 0
		}

		local createElement4 = React.createElement
		local v20 = {
			width = UDim.new(1, 0),
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			margin = {
				top = module3.ItemsGridTopPadding,
				bottom = module3.ItemsGridBottomPadding,
				left = module3.ItemsGridSidePadding / 2,
				right = module3.ItemsGridSidePadding / 2
			}
		}

		local createElement5 = React.createElement
		local v23 = {
			getItemMetrics = customMetricsGetter,
			items = editableOwnedOutfitIds,
			totalNumItems = v6,
			renderItem = function(p3)
				return self:renderItem(p3)
			end,
			getItemHeight = v9,
			windowHeight = self.props.screenSize.Y,
			ref = self.loadableGridViewRef,
			NextSelectionDown = 0
		}

		local v24 = if forwardRef then self.loadMoreRef else nil
		v23.NextSelectionDown = v24
		children.ListWrapper = createElement4(fitFrameVertical, v20, {
			LoadableGridView = createElement5(DefaultMetricsGridView, v23)
		})

		local v25 = if v12 and forwardRef then React.createElement(forwardRef, {
			onActivated = self.onLoadMoreButtonActivated,
			LayoutOrder = 2,
			ref = self.loadMoreRef,
			NextSelectionUp = self.loadableGridViewRef
		}) else nil
		children.LoadMoreButton = v25

		local v26 = if v11 then React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, p2.Tokens.Size.Size_1400),
				LayoutOrder = 3
			},
			{ LoadingBar = React.createElement(module11) }
		) else nil
		children.LoadingBar = v26
		v15 = createElement2(module9, v17, children)
	else
		v15 = v7
	end

	return createElement("Frame", absoluteSizeChangedsByAbsoluteSize, {
		RefreshScrollingFrameWithLoadMore = v15,
		EmptyState = not v7 and React.createElement(emptyState, {
			buttonIcon = "",
			icon = "",
			buttonText = props2.backLabel,
			iconSize = UDim2.fromScale(0, 0),
			onActivated = self.props.goBack,
			text = v10,
			ref = self.emptyStateRef
		})
	})
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			itemType = "Feature.Avatar.Label.Avatars",
			noItemsLabel = "Feature.Avatar.Label.NoItems",
			backLabel = "Feature.Avatar.Label.Back"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended.didMount(p2)
	if p2.props.hasMoreItems then
		p2.props.loadMoreItems()
	end
end

function extended.didUpdate(p2, data, p3)
	if p2.props.multiSelect ~= data.multiSelect and not p2.props.multiSelect then
		p2.props.selectionUpdated({})
	end

	local v5 = p2.props.editableOwnedOutfitIds ~= data.editableOwnedOutfitIds
	local v6 = p2.props.selectedOutfits ~= data.selectedOutfits

	if v5 or v6 then
		local selectedOutfits = {}
		local flag = false

		for k, selectedOutfit in p2.props.selectedOutfits do
			if Cryo.List.find(p2.props.editableOwnedOutfitIds, selectedOutfit) then
				selectedOutfits[#selectedOutfits + 1] = selectedOutfit
			else
				flag = true
			end
		end

		if flag then
			p2.props.selectionUpdated(selectedOutfits)
		end
	end
end

local v5 = roactAppPolicy.connect(function(p2, p3)
	return {
		showCustomOutfitNames = p2.getCustomOutfitNames(),
		enableContinuousLoad = p2.getEnableContinuousLoad()
	}
end)(extended)

local function mapStateToProps(p2, p3)
	local v6 = not p2.AvatarExperience.AvatarEditor.PageFinished[module3.EditableCharacterKey]

	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	return {
		editableOwnedOutfitIds = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[module3.EditableCharacterKey] or {},
		outfitInfos = outfitInfos,
		screenSize = p2.ScreenSize,
		hasMoreItems = v6
	}
end

local v6 = RoactRodux.connect(mapStateToProps)(v5)

return React.forwardRef(function(p2, p3)
	local v7 = useDispatch()

	local v9, v10 = module12((React.useCallback(function()
		return v7(module7())
	end, {})))
	local v11 = v9.status == module10.Pending

	local v12 = useFocusGuiObject()
	return React.createElement(
		v6,
		Cryo.Dictionary.join(p2, {
			forwardRef = p3,
			loadMoreItems = v10,
			isFetchingMore = v11,
			focusGuiObject = v12
		})
	)
end)

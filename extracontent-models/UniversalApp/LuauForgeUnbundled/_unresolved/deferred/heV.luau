local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local createComputed = Signals.createComputed
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local tutils = require(CorePackages.Packages.tutils)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameHorizontal = roactFitComponents.FitFrameHorizontal

local withStyle = UIBlox.Style.withStyle
local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local findValueKeyInRefCache = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module2 = require("@luauforge/bundled/dzD")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/dRg")
local module5 = require("@luauforge/bundled/fCI")
local module6 = require("@luauforge/deferred/heR")
local module7 = require("@luauforge/deferred/heQ")
require("@luauforge/bundled/dKT")

local module8 = require("@luauforge/deferred/gQM")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module9 = require("@luauforge/deferred/heW")

local module10 = require("@luauforge/bundled/dPR")
local module11 = require("@luauforge/bundled/dRF")

local module12 = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ScrollingListWithArrowsAndGradient")
local module13 = require("@luauforge/bundled/dRs")
local module14 = require("@luauforge/deferred/heU")

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXCategoryUnifiedLogging = AvatarExperienceFlags.FFlagAXCategoryUnifiedLogging
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventLogForInstance

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties

local v5 = { navigation = true }

local extended = Roact.PureComponent:extend("SubNavigation")

local v6 = {
	Style = true,
	Heads = not module11.isEnabled() or nil
}

local v7 = { dampingRatio = 1, frequency = 3.5 }

local function findSubcategoryIndexById(items, p2)
	if not (items and p2) then
		return nil
	end

	for k, item in items do
		if item.Id == p2 then
			return k
		end
	end

	return nil
end

local strictInterface = t.strictInterface
local v8 = {
	layoutOrder = t.number,
	navHeight = t.number,
	selectedCategoryIndex = t.optional(t.number),
	selectedSubcategoryIndex = t.optional(t.number),
	selectSubcategory = t.optional(t.callback),
	selectedCategoryId = t.optional(t.string),
	selectedSubcategoryId = t.optional(t.string),
	selectSubcategoryId = t.optional(t.callback),
	shouldUseCategoryId = t.optional(t.boolean),
	subcategories = t.optional(t.table),
	onSubNavigationPropsDidUpdate = t.callback,
	isHidden = 0,
	NextSelectionUp = 0,
	NextSelectionDown = 0,
	BackgroundColor3 = 0,
	BackgroundTransparency = 0,
	subNavigationRef = 0,
	lastInputGroup = 0,
	newItemNotifications = 0,
	unifiedLoggingSurface = 0,
	navigation = 0,
	frameRef = 0,
	navButtonRefs = 0
}

local v9 = if module11.isEnabled() then t.optional(t.boolean) else nil
v8.isHidden = v9

v8.NextSelectionUp = t.optional(t.table)
v8.NextSelectionDown = t.optional(t.table)
local v10 = if module13() then t.optional(t.Color3) else nil
v8.BackgroundColor3 = v10
local v11 = if module13() then t.optional(t.number) else nil
v8.BackgroundTransparency = v11

v8.subNavigationRef = t.optional(t.table)

v8.lastInputGroup = t.string
v8.newItemNotifications = t.table
local v12 = if fFlagAXCategoryUnifiedLogging then t.optional(t.integer) else nil
v8.unifiedLoggingSurface = v12

v8.navigation = t.table

v8.frameRef = t.table
v8.navButtonRefs = t.table
extended.validateProps = strictInterface(v8)

local function animatedFrameMapValuesToProps(p2)
	return { Size = UDim2.new(1, 0, 0, p2.height) }
end

function extended:init()
	self.scrollingFrameRef = Roact.createRef()
	self.categoryButtonRefs = {}

	self:setState({ selectedCategoryButtonInstance = nil, renderHighlight = false })

	function self.onNavFrameSizeChanged(p2)
		if self.scrollingFrameRef.current then
			self.scrollingFrameRef.current.CanvasSize = UDim2.new(0, p2.AbsoluteSize.X, 1, 0)
		end
	end
end

function extended:getCategoryButtonRef(p3)
	if not self.categoryButtonRefs[p3] then
		self.categoryButtonRefs[p3] = Roact.createRef()
	end

	return self.categoryButtonRefs[p3]
end

function extended:tryUpdateScrollingFramePosition(value, p3)
	local v13 = self.scrollingFrameRef and self.scrollingFrameRef:getValue()

	local v14 = (value or 0) - 50

	if v13 then
		local x = v13.AbsoluteWindowSize.X

		if not x or x == 0 then
			return
		end

		local v15 = value + p3 > 0 and value + p3 < x
		local v16 = value > 0 and value < x

		if not (v16 or v15) then
			v13.CanvasPosition = Vector2.new(v14, v13.CanvasPosition.Y)
		end
	end
end

function extended:setCategoryPositionAndWidthState(): boolean
	if self.props.shouldUseCategoryId then
		if not (self.categoryButtonRefs and self.props.selectedSubcategoryId and self.categoryButtonRefs[self.props.selectedSubcategoryId]) then
			self:setState({ renderHighlight = false })

			return false
		end
	elseif not (self.categoryButtonRefs and self.props.selectedSubcategoryIndex and self.categoryButtonRefs[self.props.selectedSubcategoryIndex]) then
		self:setState({ renderHighlight = false })

		return false
	end

	local categoryButtonRefs = self.categoryButtonRefs
	local v13

	if self.props.shouldUseCategoryId then
		v13 = self.props.selectedSubcategoryId
	else
		v13 = self.props.selectedSubcategoryIndex
	end

	local value = categoryButtonRefs[v13]:getValue()

	if value == nil then
		self:setState({ renderHighlight = false })

		return false
	end

	self:tryUpdateScrollingFramePosition(value.AbsolutePosition.X, value.AbsoluteSize.X)
	self:setState({ selectedCategoryButtonInstance = value, renderHighlight = true })

	return true
end

function extended:didMount()
	self:setCategoryPositionAndWidthState()

	if self.scrollingFrameRef.current then
		self.scrollingFrameRef.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function()
			self:setCategoryPositionAndWidthState()
		end)
	end
end

function extended:didUpdate(data)
	self.props.onSubNavigationPropsDidUpdate(data, self.scrollingFrameRef)

	if self.props.shouldUseCategoryId then
		if
			self.props.selectedSubcategoryId ~= data.selectedSubcategoryId
			or self.props.selectedCategoryId ~= data.selectedCategoryId
		then
			self:setCategoryPositionAndWidthState()
		end
	elseif
		self.props.selectedSubcategoryIndex ~= data.selectedSubcategoryIndex
		or self.props.selectedCategoryIndex ~= data.selectedCategoryIndex
	then
		self:setCategoryPositionAndWidthState()
	end
end

function extended:getRouteName()
	return self.props.navigation.state.routeName
end

local function hasOutfitNotification(p2, p3)
	local v13 = p2.SearchUuid == module4.PurchasedCharacterKey and p3[module3.NewOutfitNotificationKey]
	local v14 = p2.OutfitType == module3.OutfitTypes.DynamicHead and p3[module3.NewDHOutfitNotificationKey]

	return v13 or v14
end

function extended:hasNewItemNotification(p2, p3)
	if self:getRouteName() ~= avatarScreen.AvatarEditor then
		return false
	end

	local newItemNotifications = self.props.newItemNotifications
	local v13 = p3[p2]

	if module13() then
		return module5.shouldNotifyCategory(v13, newItemNotifications)
	end

	local assetTypeIdStrings = v13.AssetTypeIdStrings

	if assetTypeIdStrings and module5.shouldNotifyAssetTypes(assetTypeIdStrings, newItemNotifications) then
		return true
	end

	local v14

	if v13.SearchUuid == module4.PurchasedCharacterKey then
		v14 = newItemNotifications[module3.NewOutfitNotificationKey]
	else
		v14 = false
	end

	local v15

	if v13.OutfitType == module3.OutfitTypes.DynamicHead then
		v15 = newItemNotifications[module3.NewDHOutfitNotificationKey]
	else
		v15 = false
	end

	if v14 or v15 then
		return true
	end

	return false
end

function extended:hasNewItemNotificationV2(data)
	if self:getRouteName() ~= avatarScreen.AvatarEditor then
		return false
	end

	local newItemNotifications = self.props.newItemNotifications

	if module13() then
		return module5.shouldNotifyCategory(data, newItemNotifications)
	end

	local assetTypeIdStrings = data.AssetTypeIdStrings

	if assetTypeIdStrings and module5.shouldNotifyAssetTypes(assetTypeIdStrings, newItemNotifications) then
		return true
	end

	local v13

	if data.SearchUuid == module4.PurchasedCharacterKey then
		v13 = newItemNotifications[module3.NewOutfitNotificationKey]
	else
		v13 = false
	end

	local v14

	if data.OutfitType == module3.OutfitTypes.DynamicHead then
		v14 = newItemNotifications[module3.NewDHOutfitNotificationKey]
	else
		v14 = false
	end

	if v13 or v14 then
		return true
	end

	return false
end

function extended.onTooltipDismiss(p2, p3)
	if v6[p3.Name] then
		module9.setSeenTimestamp()
	end
end

function extended:renderCategoryButton(p2, p3, p4, layoutOrder, props)
	local v13 = p4 == layoutOrder

	if self.props.shouldUseCategoryId then
		v13 = self.props.selectedSubcategoryId == props.Id
	end

	local subcategories = self.props.subcategories
	local selectSubcategory = self.props.selectSubcategory
	local selectSubcategoryId = self.props.selectSubcategoryId
	local v14

	if module11.isEnabled() then
		v14 = module10.readTestVariable(module11.EnableHeadCategoryCombination)
	end

	local navButtonRefs = self.props.navButtonRefs

	if module11.isEnabled() and v14 then
		return withLocalization({
			headCombineTooltipTitle = "Feature.Avatar.Label.HeadRefinement.CombinedCategories.Tooltip"
		})(function(p5)
			local headCombineTooltipTitle = if v6[props.Name] and module9.shouldShowTooltip() then p5.headCombineTooltipTitle else nil

			local createElement = Roact.createElement
			local v15 = focusable[module6]
			local v16 = {}
			v16.categoryTitle = props.Title
			local v17 = if fFlagAXCatalogCategoriesSDUI then props.LocalizedTitle else nil
			v16.localizedCategoryTitle = v17
			v16.layoutOrder = layoutOrder
			v16.isSelected = v13
			v16.shouldUseCategoryId = self.props.shouldUseCategoryId
			local v18 = if self.props.shouldUseCategoryId then self:hasNewItemNotificationV2(props) else self:hasNewItemNotification(layoutOrder, subcategories)
			v16.hasNewItemNotification = v18

			local v20 = if self.props.shouldUseCategoryId then props.Id else layoutOrder
			v16.frameRef = self:getCategoryButtonRef(v20)

			function v16.onActivate()
				if fFlagAXCategoryUnifiedLogging then
					local v22 = if self.props.shouldUseCategoryId then props.Id else layoutOrder
					local v23 = navButtonRefs[v22]

					if v23 and v23.current then
						sendUnifiedEventLogForInstance(v23.current, {
							action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
							elementName = "SELECT_SUBCATEGORY_" .. string.upper(props.Name),
							surface = self.props.unifiedLoggingSurface
						})
					end
				end

				if self.props.shouldUseCategoryId then
					selectSubcategoryId(p3, props.Id)
				else
					selectSubcategory(p3, layoutOrder)
				end
			end

			v16.tooltipTitle = headCombineTooltipTitle
			v16.isHidden = self.props.isHidden
			function v16.onTooltipDismiss()
				self:onTooltipDismiss(props)
			end

			local ref = Roact.Ref
			local v22 = if self.props.shouldUseCategoryId then props.Id else layoutOrder
			v16[ref] = navButtonRefs[v22]
			local v23

			if layoutOrder > 1 then
				local v25 = if self.props.shouldUseCategoryId then subcategories[layoutOrder - 1].Id else layoutOrder - 1
				v23 = navButtonRefs[v25]
			end

			v16.NextSelectionLeft = v23
			local v24

			if layoutOrder < #subcategories then
				local v26 = if self.props.shouldUseCategoryId then subcategories[layoutOrder + 1].Id else layoutOrder + 1
				v24 = navButtonRefs[v26]
			end

			v16.NextSelectionRight = v24
			return createElement(v15, v16)
		end)
	end

	local createElement = Roact.createElement
	local v15 = focusable[module6]
	local v16 = {}
	v16.shouldUseCategoryId = self.props.shouldUseCategoryId
	v16.categoryTitle = props.Title
	local v17 = if fFlagAXCatalogCategoriesSDUI then props.LocalizedTitle else nil
	v16.localizedCategoryTitle = v17
	v16.layoutOrder = layoutOrder
	v16.isSelected = v13
	local v18 = if self.props.shouldUseCategoryId then self:hasNewItemNotificationV2(props) else self:hasNewItemNotification(layoutOrder, subcategories)
	v16.hasNewItemNotification = v18

	local v19 = if self.props.shouldUseCategoryId then props.Id else layoutOrder
	v16.frameRef = self:getCategoryButtonRef(v19)
	function v16.onActivate()
		if fFlagAXCategoryUnifiedLogging then
			local v21 = if self.props.shouldUseCategoryId then props.Id else layoutOrder
			local v22 = navButtonRefs[v21]

			if v22 and v22.current then
				sendUnifiedEventLogForInstance(v22.current, {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					elementName = "SELECT_SUBCATEGORY_" .. string.upper(props.Name),
					surface = self.props.unifiedLoggingSurface
				})
			end
		end

		if self.props.shouldUseCategoryId then
			selectSubcategoryId(p3, props.Id)
		else
			selectSubcategory(p3, layoutOrder)
		end
	end

	local ref = Roact.Ref
	local v20 = if self.props.shouldUseCategoryId then props.Id else layoutOrder
	v16[ref] = navButtonRefs[v20]
	local v21

	if layoutOrder > 1 then
		local v22 = if self.props.shouldUseCategoryId then subcategories[layoutOrder - 1].Id else layoutOrder - 1
		v21 = navButtonRefs[v22]
	end

	v16.NextSelectionLeft = v21
	local v22

	if layoutOrder < #subcategories then
		local v23 = if self.props.shouldUseCategoryId then subcategories[layoutOrder + 1].Id else layoutOrder + 1
		v22 = navButtonRefs[v23]
	end

	v16.NextSelectionRight = v22
	return createElement(v15, v16)
end

function extended:renderSubNavFrameChildren(p2)
	local subcategories = self.props.subcategories
	local selectedSubcategoryIndex = self.props.selectedSubcategoryIndex
	local selectedCategoryIndex = self.props.selectedCategoryIndex

	local subNavFrameChildren = {}

	if not subcategories then
		return subNavFrameChildren
	end

	for k, subcategory in subcategories do
		local v13 = if self.props.shouldUseCategoryId then tostring(subcategory.Id) else subcategory.Name
		local v14

		if self.props.shouldUseCategoryId then
			v14 = self.props.selectedCategoryId
		else
			v14 = selectedCategoryIndex
		end

		local v15

		if self.props.shouldUseCategoryId then
			v15 = self.props.selectedSubcategoryId
		else
			v15 = selectedSubcategoryIndex
		end

		subNavFrameChildren[v13] = self:renderCategoryButton(p2, v14, v15, k, subcategory)
	end

	return subNavFrameChildren
end

function extended:getScrollingListChildren()
	local subNavigationRef = self.props.subNavigationRef
	local renderHighlight = self.props.lastInputGroup ~= module2.InputType.Gamepad
		and self.state.renderHighlight

	local selectedSubcategoryIndex = self.props.selectedSubcategoryIndex

	local udim = UDim.new(0, 15)
	local rectangle = roactFitComponents.Rect.rectangle(10, 0)
	local navButtonRefs = self.props.navButtonRefs

	local v13 = (selectedSubcategoryIndex == 0 or selectedSubcategoryIndex == nil) and 1
		or selectedSubcategoryIndex

	if self.props.shouldUseCategoryId then
		local subcategories = self.props.subcategories

		if self.props.selectedSubcategoryId then
			v13 = self.props.selectedSubcategoryId
		else
			v13 = if subcategories and #subcategories > 0 then subcategories[1].Id else nil
		end
	end

	local createElement = Roact.createElement
	local v14 = focusable[fitFrameHorizontal]
	local v15 = {
		height = UDim.new(1, 0),
		contentPadding = udim,
		margin = rectangle,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal,
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onNavFrameSizeChanged,
		[Roact.Ref] = subNavigationRef,
		NextSelectionUp = self.props.NextSelectionUp,
		NextSelectionDown = self.props.NextSelectionDown
	}
	local v16 = if v13 then navButtonRefs[v13] else nil
	v15.defaultChild = v16
	return {
		SubNavFrame = createElement(v14, v15, self:renderSubNavFrameChildren()),
		Highlight = renderHighlight and Roact.createElement(module7, {
			scrollingFrameRef = self.scrollingFrameRef,
			selectedCategoryButtonInstance = self.state.selectedCategoryButtonInstance
		})
	}
end

function extended:getSubNavigationChildren(p2, p3)
	local selectedCategoryIndex = self.props.selectedCategoryIndex
	local v13

	if self.props.shouldUseCategoryId then
		v13 = self.props.selectedCategoryId
	else
		v13 = tostring(selectedCategoryIndex)
	end

	return {
		ScrollingListWithArrowsAndGradient = Roact.createElement(module12, {
			getScollingListContent = function()
				return self:getScrollingListChildren()
			end,
			listHeight = p3,
			scrollingFrameRef = self.scrollingFrameRef,
			buttonRefs = self.categoryButtonRefs,
			childWidgetIndex = v13,
			useIntroScroll = true,
			buttonPadding = 15
		})
	}
end

function extended:render()
	local layoutOrder = self.props.layoutOrder
	local navHeight = self.props.navHeight
	local v13 = not self.props.subcategories and 0 or navHeight

	return (withStyle(function(p2)
		local theme = p2.Theme

		local createElement = Roact.createElement
		local animatedFrame = springAnimatedItem.AnimatedFrame
		local frameRefsByRef = {}
		frameRefsByRef.Size = UDim2.new(1, 0, 0, 0)
		local v15 = if module13() and self.props.BackgroundColor3 then self.props.BackgroundColor3 else theme.BackgroundContrast.Color
		frameRefsByRef.BackgroundColor3 = v15

		local v16 = if module13() and self.props.BackgroundTransparency then self.props.BackgroundTransparency else theme.BackgroundContrast.Transparency
		frameRefsByRef.BackgroundTransparency = v16

		frameRefsByRef.BorderSizePixel = 0
		frameRefsByRef.LayoutOrder = layoutOrder
		frameRefsByRef.ClipsDescendants = true
		frameRefsByRef[Roact.Ref] = self.props.frameRef
		return createElement(animatedFrame, {
			regularProps = frameRefsByRef,
			animatedValues = { height = v13 },
			mapValuesToProps = animatedFrameMapValuesToProps,
			springOptions = v7
		}, self:getSubNavigationChildren(theme, v13))
	end))
end

local v13 = RoactRodux.connect(function(p2, p3)
	local v14 = nil
	local v15

	if fFlagAXCategoryUnifiedLogging then
		if not fFlagSignalsNavP3gAvatarExperience then
			if fFlagUseNavigationSelectors then
				v14 = selectors.selectCurrentRoactNavigationRoute(p2)
			else
				v14 = p2.Navigation and p2.Navigation.currentRoute
			end
		end

		v15 = v14 and avatarScreenProperties[v14.routeName]
	end

	local v16 = {
		newItemNotifications = p2.AvatarExperience.AvatarEditor.NewItemNotifications,
		unifiedLoggingSurface = 0
	}

	local v17 = if fFlagAXCategoryUnifiedLogging and v15 and v15.analyticsData then v15.analyticsData.unifiedLoggingSurface else nil
	v16.unifiedLoggingSurface = v17
	return v16
end, nil)(extended)

if fFlagSignalsNavP3gAvatarExperience then
	local v14 = v13

	local function SubNavigationWithSignals(p2)
		local legacyNavigationStore = getLegacyNavigationStore(false)
		local v16 = useSignalState((React.useMemo(function()
			return createComputed(function(p3)
				local currentRoute = legacyNavigationStore.getCurrentRoute(p3)
				local v16 = currentRoute and avatarScreenProperties[currentRoute.routeName]

				if fFlagAXCategoryUnifiedLogging and v16 and v16.analyticsData then
					return v16.analyticsData.unifiedLoggingSurface
				end

				return nil
			end)
		end, { legacyNavigationStore })))
		return React.createElement(v14, Cryo.Dictionary.union(p2, {
			unifiedLoggingSurface = v16
		}))
	end

	v13 = React.memo(SubNavigationWithSignals, function(p2, p3)
		return tutils.shallowEqual(p2, p3, v5)
			and p2.navigation.state.routeName == p3.navigation.state.routeName
	end)
end

local v14 = module8(v13)

local v15 = RoactNavigation.withNavigation(v14)

return function(props)
	local v16 = RoactGamepad.useRefCache()
	local v17 = useFocusGuiObject()

	local v22 = useTableWrappedCallbackRef((module14({
		onTabBackward = React.useCallback(function(p2)
			p2.cancelled = true
			local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v16)

			if props.shouldUseCategoryId then
				local subcategories = props.subcategories
				local v19

				if subcategories and valueKeyInRefCache then
					for k, subcategory in subcategories do
						if subcategory.Id == valueKeyInRefCache then
							v19 = k
							break
						end
					end
				end

				if v19 and v19 > 1 then
					local id = props.subcategories[v19 - 1].Id

					if v17 and v16[id] then
						v17(v16[id].current)
					end
				end
			elseif valueKeyInRefCache and valueKeyInRefCache > 1 and v17 then
				v17(v16[valueKeyInRefCache - 1].current)
			end
		end, { v17, props.shouldUseCategoryId, props.subcategories }),
		onTabForward = React.useCallback(function(p2)
			p2.cancelled = true
			local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v16)

			if props.shouldUseCategoryId then
				local subcategories = props.subcategories
				local v20

				if subcategories and valueKeyInRefCache then
					for k, subcategory in subcategories do
						if subcategory.Id == valueKeyInRefCache then
							v20 = k
							break
						end
					end
				end

				if v20 and subcategories and v20 < #subcategories then
					local id = subcategories[v20 + 1].Id

					if v17 and v16[id] then
						v17(v16[id].current)
					end
				end
			elseif valueKeyInRefCache and valueKeyInRefCache < #v16 and v17 then
				v17(v16[valueKeyInRefCache + 1].current)
			end
		end, { v17, props.shouldUseCategoryId, props.subcategories }),
		onNavigateBack = React.useCallback(function(p2)
			p2.cancelled = true

			if v17 and props.NextSelectionUp and props.NextSelectionUp.current then
				v17(props.NextSelectionUp.current)
			end
		end, { v17, props.NextSelectionUp })
	})))

	local clone = table.clone(props)
	clone.frameRef = v22
	clone.navButtonRefs = v16

	return React.createElement(v15, clone)
end

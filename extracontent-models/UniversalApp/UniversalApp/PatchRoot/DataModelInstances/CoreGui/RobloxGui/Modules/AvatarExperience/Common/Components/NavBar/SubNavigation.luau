local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local withStyle = UIBlox.Style.withStyle
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local findValueKeyInRefCache = AvatarExperienceCommon.Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateMainNavigationInputBindings = AvatarExperienceFlags.FFlagAXMigrateMainNavigationInputBindings
local Constants = require(Modules.LuaApp.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local DEPRECATED_CategoryButton = require(Modules.AvatarExperience.Common.Components.NavBar.DEPRECATED_CategoryButton)
local NavHighlight = require(Modules.AvatarExperience.Common.Components.NavBar.NavHighlight)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local HeadCategoryTooltipStorage = require(Modules.AvatarExperience.Common.Util.HeadCategoryTooltipStorage)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXCatalogHeadCategoryCombineIXP = require(Modules.AvatarExperience.Experiments.AXCatalogHeadCategoryCombineIXP)
local ScrollingListWithArrowsAndGradient = require(Modules.AvatarExperience.Common.Components.ScrollingListWithArrowsAndGradient)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local useTabNavigationFocusNavigationBindings = require(script.Parent.useTabNavigationFocusNavigationBindings)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCategoryUnifiedLogging = AvatarExperienceFlags.FFlagAXCategoryUnifiedLogging
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local Cryo = require(CorePackages.Packages.Cryo)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v46 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local sendUnifiedEventLogForInstance = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventLogForInstance
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local v50 = Roact.PureComponent:extend("SubNavigation")
local t1 = {
	Style = true,
	Heads = not AXCatalogHeadCategoryCombineIXP.isEnabled() or nil
}
local t2 = {
	dampingRatio = 1,
	frequency = 3.5
}

local function findSubcategoryIndexById(p1, p2) -- line: 94
	if not p1 or not p2 then
		return nil
	end

	for v62, v63 in p1 do
		if p2 == v63.Id then
			return v62
		end
	end

	return nil
end

v50.validateProps = t.strictInterface({
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
	isHidden = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else t.optional(t.boolean),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	BackgroundColor3 = if not GetFFlagAXEnableSlotBasedEditor() then nil else t.optional(t.Color3),
	BackgroundTransparency = if not GetFFlagAXEnableSlotBasedEditor() then nil else t.optional(t.number),
	subNavigationRef = t.optional(t.table),
	lastInputGroup = t.string,
	newItemNotifications = t.table,
	unifiedLoggingSurface = if not FFlagAXCategoryUnifiedLogging then nil else t.optional(t.integer),
	navigation = t.table,
	frameRef = if not FFlagAXMigrateMainNavigationInputBindings then nil else t.table,
	navButtonRefs = if not FFlagAXMigrateMainNavigationInputBindings then nil else t.table
})

local function animatedFrameMapValuesToProps(p3) -- line: 146
	return {
		Size = UDim2.new(1, 0, 0, p3.height)
	}
end

function v50.init(p4) -- line: 152
	-- upvalues: Roact (copy), FFlagAXMigrateMainNavigationInputBindings (copy), RoactGamepad (copy)
	p4.scrollingFrameRef = Roact.createRef()
	p4.navButtonRefs = if not FFlagAXMigrateMainNavigationInputBindings then RoactGamepad.createRefCache() else nil
	p4.categoryButtonRefs = {}
	p4:setState({
		selectedCategoryButtonInstance = nil,
		renderHighlight = false
	})

	function p4.onNavFrameSizeChanged(p5) -- line: 164
		-- upvalues: p4 (copy)
		if p4.scrollingFrameRef.current then
			p4.scrollingFrameRef.current.CanvasSize = UDim2.new(0, p5.AbsoluteSize.X, 1, 0)
		end
	end
end
function v50.getCategoryButtonRef(p6, p7) -- line: 171
	-- upvalues: Roact (copy)
	if not p6.categoryButtonRefs[p7] then
		p6.categoryButtonRefs[p7] = Roact.createRef()
	end

	return p6.categoryButtonRefs[p7]
end
function v50.tryUpdateScrollingFramePosition(p8, p9, p10) -- line: 179
	local v71 = p8.scrollingFrameRef and p8.scrollingFrameRef:getValue()
	local v72 = (p9 or 0) - 50

	if v71 then
		local AbsoluteWindowSizeX = v71.AbsoluteWindowSize.X

		if not AbsoluteWindowSizeX or AbsoluteWindowSizeX == 0 then
			return
		end

		local v74 = p9 + p10 > 0 and AbsoluteWindowSizeX > p9 + p10

		if (not (p9 > 0) or not (p9 < AbsoluteWindowSizeX)) and not v74 then
			v71.CanvasPosition = Vector2.new(v72, v71.CanvasPosition.Y)
		end
	end
end
function v50.setCategoryPositionAndWidthState(p11) -- line: 202
	if p11.props.shouldUseCategoryId then
		if not p11.categoryButtonRefs or not p11.props.selectedSubcategoryId or not p11.categoryButtonRefs[p11.props.selectedSubcategoryId] then
			p11:setState({
				renderHighlight = false
			})

			return false
		end
	elseif not p11.categoryButtonRefs or not p11.props.selectedSubcategoryIndex or not p11.categoryButtonRefs[p11.props.selectedSubcategoryIndex] then
		p11:setState({
			renderHighlight = false
		})

		return false
	end

	local v76 = p11.categoryButtonRefs[(if not p11.props.shouldUseCategoryId then p11.props.selectedSubcategoryIndex else p11.props.selectedSubcategoryId)]:getValue()

	if v76 == nil then
		p11:setState({
			renderHighlight = false
		})

		return false
	end

	p11:tryUpdateScrollingFramePosition(v76.AbsolutePosition.X, v76.AbsoluteSize.X)
	p11:setState({
		renderHighlight = true,
		selectedCategoryButtonInstance = v76
	})

	return true
end
function v50.didMount(p12) -- line: 256
	p12:setCategoryPositionAndWidthState()

	if p12.scrollingFrameRef.current then
		p12.scrollingFrameRef.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function() -- line: 267
			-- upvalues: p12 (copy)
			p12:setCategoryPositionAndWidthState()
		end)
	end
end
function v50.didUpdate(p13, p14) -- line: 273
	p13.props.onSubNavigationPropsDidUpdate(p14, p13.scrollingFrameRef)

	if p13.props.shouldUseCategoryId then
		if p13.props.selectedSubcategoryId ~= p14.selectedSubcategoryId or p13.props.selectedCategoryId ~= p14.selectedCategoryId then
			p13:setCategoryPositionAndWidthState()

			return
		end
	elseif p13.props.selectedSubcategoryIndex ~= p14.selectedSubcategoryIndex or p13.props.selectedCategoryIndex ~= p14.selectedCategoryIndex then
		p13:setCategoryPositionAndWidthState()
	end
end
function v50.getRouteName(p15) -- line: 294
	return p15.props.navigation.state.routeName
end

local function hasOutfitNotification(p16, p17) -- line: 299
	-- upvalues: Constants3 (copy), Constants2 (copy)
	local v83 = p16.SearchUuid == Constants3.PurchasedCharacterKey and p17[Constants2.NewOutfitNotificationKey]
	local v84 = p16.OutfitType == Constants2.OutfitTypes.DynamicHead and p17[Constants2.NewDHOutfitNotificationKey]

	return v83 or v84
end

function v50.hasNewItemNotification(p18, p19, p20) -- line: 308
	-- upvalues: AvatarScreen (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), Constants3 (copy), Constants2 (copy)
	if p18:getRouteName() ~= AvatarScreen.AvatarEditor then
		return false
	end

	local newItemNotifications = p18.props.newItemNotifications
	local v89 = p20[p19]

	if GetFFlagAXEnableSlotBasedEditor() then
		return Utils.shouldNotifyCategory(v89, newItemNotifications)
	end

	local AssetTypeIdStrings = v89.AssetTypeIdStrings

	if AssetTypeIdStrings and Utils.shouldNotifyAssetTypes(AssetTypeIdStrings, newItemNotifications) then
		return true
	end

	local v91 = v89.SearchUuid == Constants3.PurchasedCharacterKey and newItemNotifications[Constants2.NewOutfitNotificationKey]
	local v92 = v89.OutfitType == Constants2.OutfitTypes.DynamicHead and newItemNotifications[Constants2.NewDHOutfitNotificationKey]

	if v91 or v92 then
		return true
	end

	return false
end
function v50.hasNewItemNotificationV2(p21, p22) -- line: 332
	-- upvalues: AvatarScreen (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), Constants3 (copy), Constants2 (copy)
	if p21:getRouteName() ~= AvatarScreen.AvatarEditor then
		return false
	end

	local newItemNotifications = p21.props.newItemNotifications

	if GetFFlagAXEnableSlotBasedEditor() then
		return Utils.shouldNotifyCategory(p22, newItemNotifications)
	end

	local AssetTypeIdStrings = p22.AssetTypeIdStrings

	if AssetTypeIdStrings and Utils.shouldNotifyAssetTypes(AssetTypeIdStrings, newItemNotifications) then
		return true
	end

	local v97 = p22.SearchUuid == Constants3.PurchasedCharacterKey and newItemNotifications[Constants2.NewOutfitNotificationKey]
	local v98 = p22.OutfitType == Constants2.OutfitTypes.DynamicHead and newItemNotifications[Constants2.NewDHOutfitNotificationKey]

	if v97 or v98 then
		return true
	end

	return false
end
function v50.onTooltipDismiss(_, p24) -- line: 355
	-- upvalues: t1 (copy), HeadCategoryTooltipStorage (copy)
	if t1[p24.Name] then
		HeadCategoryTooltipStorage.setSeenTimestamp()
	end
end
function v50.renderCategoryButton(p25, p26, p27, p28, p29, p30) -- line: 361
	-- upvalues: AXCatalogHeadCategoryCombineIXP (copy), IxpUtils (copy), FFlagAXMigrateMainNavigationInputBindings (copy), withLocalization (copy), t1 (copy), HeadCategoryTooltipStorage (copy), Roact (copy), Focusable (copy), DEPRECATED_CategoryButton (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXCategoryUnifiedLogging (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), RoactGamepad (copy)
	local u107 = p28 == p29

	if p25.props.shouldUseCategoryId then
		u107 = p25.props.selectedSubcategoryId == p30.Id
	end

	local subcategories = p25.props.subcategories
	local selectSubcategory = p25.props.selectSubcategory
	local selectSubcategoryId = p25.props.selectSubcategoryId
	local v111 = nil

	if AXCatalogHeadCategoryCombineIXP.isEnabled() then
		v111 = IxpUtils.readTestVariable(AXCatalogHeadCategoryCombineIXP.EnableHeadCategoryCombination)
	end

	local v112 = if not FFlagAXMigrateMainNavigationInputBindings then p25.navButtonRefs else p25.props.navButtonRefs

	if AXCatalogHeadCategoryCombineIXP.isEnabled() and v111 then
		return withLocalization({
			headCombineTooltipTitle = "Feature.Avatar.Label.HeadRefinement.CombinedCategories.Tooltip"
		})(function(p31) -- line: 388
			-- upvalues: t1 (copy), p30 (copy), HeadCategoryTooltipStorage (copy), Roact (copy), Focusable (copy), DEPRECATED_CategoryButton (copy), FFlagAXCatalogCategoriesSDUI (copy), p29 (copy), u107 (ref), p25 (copy), subcategories (copy), FFlagAXCategoryUnifiedLogging (copy), v112 (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), selectSubcategoryId (copy), p27 (copy), selectSubcategory (copy)
			local headCombineTooltipTitle = nil

			if t1[p30.Name] and HeadCategoryTooltipStorage.shouldShowTooltip() then
				headCombineTooltipTitle = p31.headCombineTooltipTitle
			end

			return Roact.createElement(Focusable[DEPRECATED_CategoryButton], {
				categoryTitle = p30.Title,
				localizedCategoryTitle = if not FFlagAXCatalogCategoriesSDUI then nil else p30.LocalizedTitle,
				layoutOrder = p29,
				isSelected = u107,
				shouldUseCategoryId = p25.props.shouldUseCategoryId,
				hasNewItemNotification = if not p25.props.shouldUseCategoryId then p25:hasNewItemNotification(p29, subcategories) else p25:hasNewItemNotificationV2(p30),
				frameRef = p25:getCategoryButtonRef(if not p25.props.shouldUseCategoryId then p29 else p30.Id),
				onActivate = function() -- line: 407
					-- upvalues: FFlagAXCategoryUnifiedLogging (copy), v112 (copy), p25 (copy), p30 (copy), p29 (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), selectSubcategoryId (copy), p27 (copy), selectSubcategory (copy)
					if FFlagAXCategoryUnifiedLogging then
						local v179 = v112[if not p25.props.shouldUseCategoryId then p29 else p30.Id]

						if v179 and v179.current then
							sendUnifiedEventLogForInstance(v179.current, {
								action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
								elementName = "SELECT_SUBCATEGORY_" .. string.upper(p30.Name),
								surface = p25.props.unifiedLoggingSurface
							})
						end
					end

					if p25.props.shouldUseCategoryId then
						selectSubcategoryId(p27, p30.Id)

						return
					end

					selectSubcategory(p27, p29)
				end,
				tooltipTitle = headCombineTooltipTitle,
				isHidden = p25.props.isHidden,
				onTooltipDismiss = function() -- line: 428
					-- upvalues: p25 (copy), p30 (copy)
					p25:onTooltipDismiss(p30)
				end,
				[Roact.Ref] = v112[if not p25.props.shouldUseCategoryId then p29 else p30.Id],
				NextSelectionLeft = if not (p29 > 1) then nil else v112[if not p25.props.shouldUseCategoryId then p29 - 1 else subcategories[p29 - 1].Id],
				NextSelectionRight = if not (p29 < #subcategories) then nil else v112[if not p25.props.shouldUseCategoryId then p29 + 1 else subcategories[p29 + 1].Id]
			})
		end)
	end

	return Roact.createElement(Focusable[DEPRECATED_CategoryButton], {
		shouldUseCategoryId = p25.props.shouldUseCategoryId,
		categoryTitle = p30.Title,
		localizedCategoryTitle = if not FFlagAXCatalogCategoriesSDUI then nil else p30.LocalizedTitle,
		layoutOrder = p29,
		isSelected = u107,
		hasNewItemNotification = if not p25.props.shouldUseCategoryId then p25:hasNewItemNotification(p29, subcategories) else p25:hasNewItemNotificationV2(p30),
		frameRef = p25:getCategoryButtonRef(if not p25.props.shouldUseCategoryId then p29 else p30.Id),
		onActivate = function() -- line: 457
			-- upvalues: FFlagAXCategoryUnifiedLogging (copy), v112 (copy), p25 (copy), p30 (copy), p29 (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), selectSubcategoryId (copy), p27 (copy), selectSubcategory (copy)
			if FFlagAXCategoryUnifiedLogging then
				local v159 = v112[if not p25.props.shouldUseCategoryId then p29 else p30.Id]

				if v159 and v159.current then
					sendUnifiedEventLogForInstance(v159.current, {
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						elementName = "SELECT_SUBCATEGORY_" .. string.upper(p30.Name),
						surface = p25.props.unifiedLoggingSurface
					})
				end
			end

			if p25.props.shouldUseCategoryId then
				selectSubcategoryId(p27, p30.Id)

				return
			end

			selectSubcategory(p27, p29)
		end,
		[Roact.Ref] = v112[if not p25.props.shouldUseCategoryId then p29 else p30.Id],
		NextSelectionLeft = if not (p29 > 1) then nil else v112[if not p25.props.shouldUseCategoryId then p29 - 1 else subcategories[p29 - 1].Id],
		NextSelectionRight = if not (p29 < #subcategories) then nil else v112[if not p25.props.shouldUseCategoryId then p29 + 1 else subcategories[p29 + 1].Id],
		inputBindings = if not FFlagAXMigrateMainNavigationInputBindings then p26 ~= nil and {
			ShiftLeft = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL1, function() -- line: 489
				-- upvalues: p29 (copy), p26 (copy)
				if p29 > 1 then
					p26.moveFocusLeft()
				end
			end),
			ShiftRight = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR1, function() -- line: 494
				-- upvalues: p29 (copy), subcategories (copy), p26 (copy)
				if p29 < #subcategories then
					p26.moveFocusRight()
				end
			end)
		} or nil else nil
	})
end
function v50.renderSubNavFrameChildren(p32, p33) -- line: 503
	local subcategories = p32.props.subcategories
	local selectedSubcategoryIndex = p32.props.selectedSubcategoryIndex
	local selectedCategoryIndex = p32.props.selectedCategoryIndex
	local t3 = {}

	if subcategories then
		for v119, v120 in subcategories do
			t3[if not p32.props.shouldUseCategoryId then v120.Name else tostring(v120.Id)] = p32:renderCategoryButton(p33, if not p32.props.shouldUseCategoryId then selectedCategoryIndex else p32.props.selectedCategoryId, if not p32.props.shouldUseCategoryId then selectedSubcategoryIndex else p32.props.selectedSubcategoryId, v119, v120)
		end
	end

	return t3
end
function v50.getScrollingListChildren(p34) -- line: 528
	-- upvalues: Constants (copy), RoactFitComponents (copy), FFlagAXMigrateMainNavigationInputBindings (copy), Roact (copy), Focusable (copy), FitFrameHorizontal (copy), NavHighlight (copy)
	local subNavigationRef = p34.props.subNavigationRef
	local v123 = p34.props.lastInputGroup ~= Constants.InputType.Gamepad and p34.state.renderHighlight
	local selectedSubcategoryIndex = p34.props.selectedSubcategoryIndex
	local uDim = UDim.new(0, 15)
	local v126 = RoactFitComponents.Rect.rectangle(10, 0)
	local v127 = if not FFlagAXMigrateMainNavigationInputBindings then p34.navButtonRefs else p34.props.navButtonRefs
	local v128 = if selectedSubcategoryIndex ~= 0 and selectedSubcategoryIndex ~= nil then selectedSubcategoryIndex else 1

	if p34.props.shouldUseCategoryId then
		local subcategories = p34.props.subcategories

		v128 = if not p34.props.selectedSubcategoryId then if not subcategories or not (#subcategories > 0) then nil else subcategories[1].Id else p34.props.selectedSubcategoryId
	end

	return {
		SubNavFrame = Roact.createElement(Focusable[FitFrameHorizontal], {
			height = UDim.new(1, 0),
			contentPadding = uDim,
			margin = v126,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p34.onNavFrameSizeChanged,
			[Roact.Ref] = subNavigationRef,
			NextSelectionUp = p34.props.NextSelectionUp,
			NextSelectionDown = p34.props.NextSelectionDown,
			defaultChild = if not v128 then nil else v127[v128]
		}, p34:renderSubNavFrameChildren()),
		Highlight = v123 and Roact.createElement(NavHighlight, {
			scrollingFrameRef = p34.scrollingFrameRef,
			selectedCategoryButtonInstance = p34.state.selectedCategoryButtonInstance
		})
	}
end
function v50.getSubNavigationChildren(p35, _, p37) -- line: 580
	-- upvalues: Roact (copy), ScrollingListWithArrowsAndGradient (copy)
	local selectedCategoryIndex = p35.props.selectedCategoryIndex
	local v134 = if not p35.props.shouldUseCategoryId then tostring(selectedCategoryIndex) else p35.props.selectedCategoryId

	return {
		ScrollingListWithArrowsAndGradient = Roact.createElement(ScrollingListWithArrowsAndGradient, {
			useIntroScroll = true,
			buttonPadding = 15,
			getScollingListContent = function() -- line: 593
				-- upvalues: p35 (copy)
				return p35:getScrollingListChildren()
			end,
			listHeight = p37,
			scrollingFrameRef = p35.scrollingFrameRef,
			buttonRefs = p35.categoryButtonRefs,
			childWidgetIndex = v134
		})
	}
end
function v50.render(p38) -- line: 606
	-- upvalues: withStyle (copy), Roact (copy), SpringAnimatedItem (copy), GetFFlagAXEnableSlotBasedEditor (copy), FFlagAXMigrateMainNavigationInputBindings (copy), animatedFrameMapValuesToProps (copy), t2 (copy)
	local layoutOrder = p38.props.layoutOrder
	local navHeight = p38.props.navHeight

	if not p38.props.subcategories then
		navHeight = 0
	end

	return (withStyle(function(p39) -- line: 615
		-- upvalues: Roact (copy), SpringAnimatedItem (copy), GetFFlagAXEnableSlotBasedEditor (copy), p38 (copy), layoutOrder (copy), FFlagAXMigrateMainNavigationInputBindings (copy), navHeight (ref), animatedFrameMapValuesToProps (copy), t2 (copy)
		local Theme = p39.Theme

		return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundColor3 = if not GetFFlagAXEnableSlotBasedEditor() or not p38.props.BackgroundColor3 then Theme.BackgroundContrast.Color else p38.props.BackgroundColor3,
				BackgroundTransparency = if not GetFFlagAXEnableSlotBasedEditor() or not p38.props.BackgroundTransparency then Theme.BackgroundContrast.Transparency else p38.props.BackgroundTransparency,
				BorderSizePixel = 0,
				LayoutOrder = layoutOrder,
				ClipsDescendants = true,
				[Roact.Ref] = if not FFlagAXMigrateMainNavigationInputBindings then nil else p38.props.frameRef
			},
			animatedValues = {
				height = navHeight
			},
			mapValuesToProps = animatedFrameMapValuesToProps,
			springOptions = t2
		}, p38:getSubNavigationChildren(Theme, navHeight))
	end))
end

local v56 = RoactRodux.connect(function(p40, _) -- line: 643
	-- upvalues: FFlagAXCategoryUnifiedLogging (copy), FFlagSignalsNavP3gAvatarExperience (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy)
	local v140 = nil
	local v141 = nil

	if FFlagAXCategoryUnifiedLogging then
		if not FFlagSignalsNavP3gAvatarExperience then
			v140 = if not FFlagUseNavigationSelectors then p40.Navigation and p40.Navigation.currentRoute else Selectors.selectCurrentRoactNavigationRoute(p40)
		end

		v141 = v140 and AvatarScreenProperties[v140.routeName]
	end

	return {
		newItemNotifications = p40.AvatarExperience.AvatarEditor.NewItemNotifications,
		unifiedLoggingSurface = if not FFlagAXCategoryUnifiedLogging or (not v141 or not v141.analyticsData) then nil else v141.analyticsData.unifiedLoggingSurface
	}
end, nil)(v50)

if FFlagSignalsNavP3gAvatarExperience then
	local v57 = v56

	function v56(p42) -- line: 667
		-- upvalues: v46 (copy), useSignalState (copy), AvatarScreenProperties (copy), FFlagAXCategoryUnifiedLogging (copy), React (copy), v57 (copy), Cryo (copy)
		local v143 = v46(false)
		local v144 = useSignalState(v143.getCurrentRoute)
		local v145 = v144 and AvatarScreenProperties[v144.routeName]
		local v146 = if not FFlagAXCategoryUnifiedLogging or (not v145 or not v145.analyticsData) then nil else v145.analyticsData.unifiedLoggingSurface

		return React.createElement(v57, Cryo.Dictionary.union(p42, {
			unifiedLoggingSurface = v146
		}))
	end
end

local v58 = withLastInputGroup(v56)
local u59 = RoactNavigation.withNavigation(v58)

if FFlagAXMigrateMainNavigationInputBindings then
	return function(p43) -- line: 691
		-- upvalues: RoactGamepad (copy), useFocusGuiObject (copy), React (copy), findValueKeyInRefCache (copy), GuiService (copy), useTabNavigationFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), u59 (ref)
		local v148 = RoactGamepad.useRefCache()
		local v149 = useFocusGuiObject()
		local v150 = React.useCallback(function(p44) -- line: 695
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v148 (copy), p43 (copy), v149 (copy)
			p44.cancelled = true

			local v163 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v148)

			if p43.shouldUseCategoryId then
				local subcategories = p43.subcategories
				local v165, g168

				if not subcategories or not v163 then
					v165 = nil
				else
					g168 = nil
					v165 = nil

					for v166, v167 in subcategories do
						if v163 == v167.Id then
							v165 = v166
							g168 = true
						end

						if g168 then
							break
						end
					end

					if not g168 then
						v165 = nil
					end
				end

				g168 = false

				if v165 and v165 > 1 then
					local Id = p43.subcategories[v165 - 1].Id

					if v149 and v148[Id] then
						v149(v148[Id].current)

						return
					end
				end
			elseif v163 and v163 > 1 and v149 then
				v149(v148[v163 - 1].current)
			end
		end, {
			v149,
			p43.shouldUseCategoryId,
			p43.subcategories
		})
		local v151 = React.useCallback(function(p45) -- line: 721
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v148 (copy), p43 (copy), v149 (copy)
			p45.cancelled = true

			local v171 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v148)

			if p43.shouldUseCategoryId then
				local subcategories = p43.subcategories
				local v173, g176

				if not subcategories or not v171 then
					v173 = nil
				else
					g176 = nil
					v173 = nil

					for v174, v175 in subcategories do
						if v171 == v175.Id then
							v173 = v174
							g176 = true
						end

						if g176 then
							break
						end
					end

					if not g176 then
						v173 = nil
					end
				end

				g176 = false

				if v173 and subcategories and v173 < #subcategories then
					local Id = subcategories[v173 + 1].Id

					if v149 and v148[Id] then
						v149(v148[Id].current)

						return
					end
				end
			elseif v171 and v171 < #v148 and v149 then
				v149(v148[v171 + 1].current)
			end
		end, {
			v149,
			p43.shouldUseCategoryId,
			p43.subcategories
		})
		local v152 = React.useCallback(function(p46) -- line: 748
			-- upvalues: v149 (copy), p43 (copy)
			p46.cancelled = true

			if v149 and (p43.NextSelectionUp and p43.NextSelectionUp.current) then
				v149(p43.NextSelectionUp.current)
			end
		end, {
			v149,
			p43.NextSelectionUp
		})
		local v153 = useTabNavigationFocusNavigationBindings({
			onTabBackward = v150,
			onTabForward = v151,
			onNavigateBack = v152
		})
		local v154 = useTableWrappedCallbackRef(v153)
		local v155 = table.clone(p43)

		v155.frameRef = v154
		v155.navButtonRefs = v148

		return React.createElement(u59, v155)
	end
end

return u59

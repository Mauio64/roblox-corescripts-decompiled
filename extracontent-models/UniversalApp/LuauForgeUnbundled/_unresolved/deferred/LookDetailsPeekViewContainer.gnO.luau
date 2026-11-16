local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Cryo = require(CorePackages.Packages.Cryo)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
require("@luauforge/bundled/dHK")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useAXAnimateScrollFrame = AvatarExperienceCommon.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame
local selectTryOnsLookId = AvatarExperienceCommon.State.Selectors.selectTryOnsLookId

local peekView = require("@luauforge/bundled/dzD").PeekView
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
require("@luauforge/bundled/dMc")
local module2 = require("@luauforge/deferred/gnP")

local module3 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module4 = require("@luauforge/bundled/fvF")
local module5 = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module6 = require("@luauforge/bundled/dME")
local module7 = require("@luauforge/bundled/dwA")
local module8 = require("@luauforge/bundled/dHL")
local removeLookItemsFromTryOn = module8.Actions.RemoveLookItemsFromTryOn
local removeUnselectedItemsFromTryOn = module8.Actions.RemoveUnselectedItemsFromTryOn
local setTryOnManagerPeekViewState = module8.Actions.SetTryOnManagerPeekViewState
local setLookDetailsPeekViewSelectedTab = module8.Actions.SetLookDetailsPeekViewSelectedTab
local module9 = require("@luauforge/deferred/gnQ")
local module10 = require("@luauforge/deferred/gnS")
local module11 = require("@luauforge/deferred/gob")
local fullView = AvatarExperienceCommon.Enums.FullView
local module12 = require("@luauforge/deferred/ggF")
local module13 = require("@luauforge/deferred/gmh")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module14 = require("@luauforge/bundled/gfm")
local module15 = require("@luauforge/bundled/goe")
local module16 = require("@luauforge/deferred/gof")
local module17 = require("@luauforge/bundled/fuD")
local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local module18 = require("@luauforge/deferred/goi")

local module19 = require("@luauforge/deferred/gko")

local withStyle = UIBlox.Style.withStyle
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local module20 = require("@luauforge/deferred/gol")
local module21 = require("@luauforge/deferred/god")
local defineFastFlag = game:DefineFastFlag("AXDisableNonFullviewAnimation", false)

local fFlagAXMigrateLookDetailsPeekViewToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateLookDetailsPeekViewToFocusNavigation

local fFlagStackedBottomNavMarketplaceCTA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagStackedBottomNavMarketplaceCTA

local fFlagRemoveBottomNavOnLookDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveBottomNavOnLookDetails
local visibilityControl = require("@luauforge/bundled/dHu").VisibilityControl

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport

local actionBarHeight = module6.ActionBar.ActionBarHeight
local actionBarGradientHeight = module6.ActionBar.ActionBarGradientHeight

local iconsnavigationclose = images["icons/navigation/close"]
local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]

local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo

local module22 = require("@luauforge/deferred/gou")

local extended = Roact.PureComponent:extend("LookDetailsPeekView")

local fn = fFlagAXCatalogMakeupSupport and function(p2)
	if p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledLookType == module5.LookType.Makeup then
		return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
	end

	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end or nil

local function fn2(p2)
	return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end

local function fn3(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local function fn4(p2)
	local v6

	if fFlagAXCatalogMakeupSupport then
		v6 = fn(p2)
	else
		v6 = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
	end

	local looks = p2.AvatarExperience.AvatarScene.Looks

	if looks and v6 and looks[v6] then
		return looks[v6]
	end

	return nil
end

local v6 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.ToggleTryOnManager
}

local function useFocusNavigationBindings(p2, callback, p3)
	local v7 = ReactFocusNavigation.useEventMap(v6, p2)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					callback()
				end)
			},
			[focusNavigationEventNameEnum.ToggleTryOnManager] = {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, { callback, p3 })
	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

local interface = t.interface
local v7 = {
	focusGuiObject = t.optional(t.callback),
	isTryOn = t.optional(t.boolean),
	is10ftUI = t.boolean,
	initialPeekViewState = t.optional(t.valueOf(peekViewState)),
	showPeekViewInSuperBrief = t.optional(t.boolean),
	resolvedFocusNavigationRef = 0,
	resolvedActionBarRef = 0,
	scrollingFrameRef = 0,
	navigation = 0,
	avatarRoute = 0,
	isPortrait = 0,
	topBarHeight = 0,
	tryOnItems = 0,
	lookId = 0,
	lookDetails = 0,
	globalGuiInset = 0,
	screenSize = 0,
	fullView = 0,
	boundInputs = 0,
	peekViewState = 0,
	selectedTab = 0,
	removeUnselectedItemsFromTryOn = 0,
	removeLookItemsFromTryOn = 0,
	setTryOnManagerPeekViewState = 0,
	setSelectedTab = 0,
	closeFocusedScreen = 0,
	catalogAnalytics = 0,
	namedRefs = 0,
	lastInputGroup = 0
}
local v8 = if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then t.table else nil
v7.resolvedFocusNavigationRef = v8
local v9 = if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then t.table else nil
v7.resolvedActionBarRef = v9
v7.scrollingFrameRef = t.table

v7.navigation = t.table
v7.avatarRoute = t.table

v7.isPortrait = t.boolean
v7.topBarHeight = t.number
v7.tryOnItems = t.optional(t.table)
v7.lookId = t.optional(t.string)
v7.lookDetails = t.optional(t.table)
v7.globalGuiInset = t.table
v7.screenSize = t.Vector2
v7.fullView = t.optional(t.userdata)
v7.boundInputs = t.optional(t.table)
v7.peekViewState = t.optional(t.valueOf(peekViewState))
v7.selectedTab = t.optional(t.number)

v7.removeUnselectedItemsFromTryOn = t.callback
v7.removeLookItemsFromTryOn = t.callback
v7.setTryOnManagerPeekViewState = t.callback
v7.setSelectedTab = t.callback
v7.closeFocusedScreen = t.callback

v7.catalogAnalytics = t.table

v7.namedRefs = t.table

v7.lastInputGroup = t.string
extended.validateProps = interface(v7)

local function isMouseAndKeyboard(p2): boolean
	return module7.InputTypeMap[p2] == module7.InputType.MouseAndKeyboard
end

function extended:init()
	local lastInputType = UserInputService:GetLastInputType()
	self:setState({
		isMouseAndKeyboard = module7.InputTypeMap[lastInputType] == module7.InputType.MouseAndKeyboard
	})

	self.frameRef = self.props.namedRefs[avatarScreen.LookDetails]
	local ref = if not fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then Roact.createRef() else nil
	self.actionBarRef = ref
	self.itemsListRef = Roact.createRef()
	self.closeButtonRef = Roact.createRef()
	self.tryOnElementRefCache = RoactGamepad.createRefCache()
	self.contentFrameRef = Roact.createRef()

	self.robuxBalanceRef = Roact.createRef()

	if fFlagStackedBottomNavMarketplaceCTA and not fFlagRemoveBottomNavOnLookDetails then
		self.footerVisibilityBinding = visibilityControl.getFooterBinding()
	end

	function self.onPeekViewClosed()
		if self.props.lookId == nil then
			self.props.removeUnselectedItemsFromTryOn()
		else
			self.props.removeLookItemsFromTryOn(self.props.lookId, self.props.lookDetails)
		end
	end

	function self.navigateBack()
		self.onPeekViewClosed()
		self.props.closeFocusedScreen(self.props.navigation)
	end

	function self.viewStateChanged(p2, p3)
		self.props.setTryOnManagerPeekViewState(p2)
		local catalogAnalytics = self.props.catalogAnalytics

		if p2 == peekViewState.Closed then
			self.props.closeFocusedScreen(self.props.navigation)
		end

		local v11 = self.props.avatarRoute.opaque.name == avatarScreen.MySharedAvatars

		if
			p2 == peekViewState.SuperBrief
			and not self.props.isTryOn
			and not v11
			and self.props.avatarRoute.isVisible
		then
			self.props.closeFocusedScreen(self.props.navigation)
		end

		if p2 == peekViewState.Brief then
			if p3 == peekViewState.Full or p3 == peekViewState.Extended then
				catalogAnalytics.resizeOutfitScreen("minimize")
			end
		elseif p2 == peekViewState.Full and p3 == peekViewState.Brief then
			catalogAnalytics.resizeOutfitScreen("expand")
		end
	end

	function self.onCloseButtonPressed()
		if self.props.lookId ~= module5.DraftLookId then
			self.props.closeFocusedScreen(self.props.navigation)
			self.props.setTryOnManagerPeekViewState(peekViewState.SuperBrief)
		else
			self.onPeekViewClosed()
			self.props.setTryOnManagerPeekViewState(peekViewState.Closed)
		end
	end
end

function extended:getActionBarTotalHeight(p3)
	local v10 = not p3 and 20 or p3.Tokens.Size.Size_500

	local v12 = 0
	local v13 = 0

	if
		self.props.is10ftUI
		and self.props.lastInputGroup == module7.InputType.Gamepad
		and not Cryo.isEmpty(self.props.boundInputs)
	then
		v12 = module7.GAMEPAD_BOTTOM_BAR_SIZE
	elseif self.props.lookId ~= nil then
		v13 = v10
	end

	local v14 = if self.props.peekViewState == peekViewState.SuperBrief then p3.Tokens.Size.Size_400 else -p3.Tokens.Size.Size_200

	local v15 = self.props.showPeekViewInSuperBrief and 0 or v14

	return actionBarHeight + v12 + v13 - v15
end

function extended:getBriefViewHeight(p3)
	local offset = getSafeAreaSize(self.props.screenSize, self.props.globalGuiInset).Y.Offset

	local size_600 = p3.Tokens.Size.Size_600

	if not self.props.isPortrait then
		return (offset - self.props.topBarHeight - size_600) * 0.5
	end

	local v10 = offset * module5.PortraitSceneHeight
	return offset - self.props.topBarHeight - v10 - size_600
end

function extended:renderActionBar(p2)
	local theme = p2.Theme
	local actionBarTotalHeight = self:getActionBarTotalHeight(p2)
	local v10 = self.props.peekViewState == peekViewState.SuperBrief
	local udim

	if v10 and not self.props.showPeekViewInSuperBrief then
		udim = UDim.new(0, -p2.Tokens.Size.Size_350)
	else
		udim = UDim.new(0, p2.Tokens.Size.Size_250)
	end

	local size_100 = p2.Tokens.Size.Size_100
	local v11 = self.props.lookId == module5.DraftLookId
	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local v13 = {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		BackgroundTransparency = 0,
		Size = UDim2.new(1, 0, 0, actionBarTotalHeight),
		Position = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		ZIndex = 2,
		ref = 0
	}

	local v14 = if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then self.props.resolvedActionBarRef else self.actionBarRef
	v13.ref = v14
	local children = {
		BottomContainer = createElement("Frame", v13, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = udim
			}),
			DraftLookBottomBar = v11 and Roact.createElement(module11),
			LookDetailsBottomBar = not v11 and Roact.createElement(module10, {
				hideDescriptor = true,
				centered = self.props.isTryOn and true or nil,
				isTryOnFromOutsideAX = self.props.isTryOn,
				alwaysBuyAll = not self.props.isTryOn
			})
		}),
		TopFrame = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, size_100),
			Position = UDim2.new(0, 0, 1, -actionBarTotalHeight),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BorderSizePixel = 0
		}),
		Gradient = 0
	}

	local v15 = if not (v10 and self.props.showPeekViewInSuperBrief) then Roact.createElement("ImageLabel", {
		Size = UDim2.new(1, 0, 0, actionBarGradientHeight),
		Position = UDim2.new(0, 0, 1, -actionBarTotalHeight - size_100),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
		ImageColor3 = theme.BackgroundDefault.Color
	}) else nil
	children.Gradient = v15
	return createFragment(children)
end

function extended:renderTopContent(props2, p2, callback)
	local theme = props2.Theme
	local font = props2.Font
	local size_900 = props2.Tokens.Size.Size_900
	local size_350 = props2.Tokens.Size.Size_350
	local size_100 = props2.Tokens.Size.Size_100
	local v10 = self.props.lookId == module5.DraftLookId
	local v11

	if v10 and self.props.isPortrait then
		v11 = props2.Tokens.Size.Size_1000
	else
		v11 = props2.Tokens.Size.Size_600
	end

	local v12

	if v10 then
		v12 = Roact.createElement(iconButton, {
			size = UDim2.fromOffset(0, 0),
			iconSize = iconSize.Medium,
			icon = images["icons/navigation/close"],
			position = UDim2.new(0, props2.Tokens.Size.Size_600, 0.5, 0),
			onActivated = self.onCloseButtonPressed,
			anchorPoint = Vector2.new(0, 0.5)
		})
	end

	local createFragment = Roact.createFragment
	local v13 = {
		UIPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, v11) }),
		CloseButton = 0,
		Title = 0
	}

	if not v10 then
		v12 = Roact.createElement(imageSetButton, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, size_350, 0.5, 0),
			Size = UDim2.fromOffset(size_900 + size_100, size_900 + size_100),
			Image = iconsnavigationclose,
			ImageColor3 = theme.SystemPrimaryDefault.Color,
			ImageTransparency = theme.SystemPrimaryDefault.Transparency,
			[Roact.Event.Activated] = self.onCloseButtonPressed,
			ref = self.closeButtonRef,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		})
	end

	v13.CloseButton = v12

	local createElement = Roact.createElement
	local v15 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, size_900),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Text = not v10 and "" or not module21() and "Preview" or p2.previewHeader,
		TextSize = font.BaseSize * font.Header1.RelativeSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local v16 = if not foundationFontFaceMigration then font.Header1.Font else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.HeadingSmall.Font) else nil
	v15.FontFace = v17

	v15.TextColor3 = theme.IconEmphasis.Color
	v15.TextTransparency = theme.IconEmphasis.Transparency
	v15.TextTruncate = Enum.TextTruncate.AtEnd
	v15.TextXAlignment = Enum.TextXAlignment.Center
	v15.TextYAlignment = Enum.TextYAlignment.Center
	v13.Title = createElement("TextLabel", v15)
	return createFragment(v13)
end

function extended:orderTryOns(items)
	local result = {}

	for k, item in items do
		table.insert(result, item)
	end

	if self.props.lookId and self.props.lookDetails then
		local lookDetails = self.props.lookDetails

		if
			lookDetails
			and (lookDetails.lookType == module5.LookType.Avatar or fFlagAXCatalogMakeupSupport and lookDetails.lookType == module5.LookType.Makeup)
		then
			table.sort(result, function(a, b): boolean
				if a.itemRecency and b.itemRecency then
					return a.itemRecency < b.itemRecency
				end

				return false
			end)
		end
	end

	return result
end

function extended:renderTryOnManagerContents(p2, p3, p4)
	local theme = p2.Theme
	local size_400 = p2.Tokens.Size.Size_400
	local v10 = self.props.lookId == module5.DraftLookId

	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 20)
		})
	}

	if self.props.lookDetails == nil then
		return children
	end

	local v11 = 1

	children["list-header-padding"] = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 5),
		LayoutOrder = v11
	})

	local v12 = v11 + 1

	local orderTryOns = self:orderTryOns(self.props.tryOnItems)
	local v13 = v12
	local v14 = false

	for k, orderTryOn in orderTryOns do
		local v15 = nil

		if v13 < v12 then
			v15 = self.tryOnElementRefCache[orderTryOns[k - 1].itemId]
		elseif p4 then
			v15 = self.closeButtonRef
		end

		local v16

		if v12 < #orderTryOns and orderTryOns[k + 1] then
			v16 = self.tryOnElementRefCache[orderTryOns[k + 1].itemId]
		elseif fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
			v16 = self.props.resolvedActionBarRef
		else
			v16 = self.actionBarRef
		end

		local v17

		if orderTryOn.itemType == module5.ItemType.Asset then
			v17 = self.props.lookDetails.lookAssetInfos[orderTryOn.itemId]
		elseif orderTryOn.itemType == module5.ItemType.Bundle then
			v17 = self.props.lookDetails.lookBundleInfos[orderTryOn.itemId]
		else
			continue
		end

		local itemSelectable = module17.isItemSelectable(v17)

		if k > 1 and v14 ~= itemSelectable then
			children["divider-" .. v12] = Roact.createElement("Frame", {
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -(size_400 * 2), 0, 1),
				Position = UDim2.new(0, 0, 1, -1),
				LayoutOrder = v12
			})

			v12 += 1
		end

		if v17 then
			children[orderTryOn.itemId] = Roact.createElement(module9, {
				tryOnItem = orderTryOn,
				itemInfo = v17,
				layoutOrder = v12,
				allowAutomaticPeekViewStateChanges = self.props.lookId == nil,
				disableInteractions = v10,
				forceShowPrice = v10,
				horizontalPadding = size_400,
				elementRef = self.tryOnElementRefCache[orderTryOn.itemId],
				NextSelectionUp = v15,
				NextSelectionDown = v16
			})

			v12 += 1
		end

		v14 = module17.isItemSelectable(v17)
	end

	return children
end

function extended:renderDetailsContents()
	return {
		LookDetails = Roact.createElement(module18, {
			lookId = self.props.lookId,
			width = not module20() and 500 or nil,
			listPadding = self.props.listPadding,
			lookDetails = self.props.lookDetails,
			isTryOn = self.props.isTryOn
		})
	}
end

function extended:renderWithProviders(p2, p3, p4)
	local theme = p2.Theme

	local v10 = p2.Tokens.Size.Size_900
	local size_350 = p2.Tokens.Size.Size_350

	local size_1200 = p2.Tokens.Size.Size_1200
	local v11 = p2.Tokens.Size.Size_800

	local isTryOn = self.props.isTryOn
	local udim

	if isTryOn then
		udim = UDim2.new(0.5, 0, 0, self.props.topBarHeight)
	else
		udim = UDim2.fromOffset(0, self.props.topBarHeight)
	end

	local udim2 = UDim2.new(1, 0, 1, -self.props.topBarHeight)

	if not self.props.isPortrait then
		if not isTryOn then
			local newUDim2 = UDim2.new
			local v12 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module5.LandscapeNavWidth
			udim = newUDim2(v12, 0, 0, self.props.topBarHeight)
		end

		local newUDim2 = UDim2.new
		local v12 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module5.LandscapeSceneWidth
		udim2 = newUDim2(v12, 0, 1, -self.props.topBarHeight)
	end

	local v12

	if
		fFlagStackedBottomNavMarketplaceCTA
		and not fFlagRemoveBottomNavOnLookDetails
		and self.footerVisibilityBinding
	then
		v12 = self.footerVisibilityBinding:map(function(p5)
			return udim2 + UDim2.new(0, 0, 0, -(module7.BOTTOM_BAR_SIZE - 8) * p5)
		end)
	else
		v12 = udim2
	end

	local briefViewHeight = self:getBriefViewHeight(p2)
	local v13 = if self.props.lookId ~= nil then self:getActionBarTotalHeight(p2) else nil
	local actionBarTotalHeight = self:getActionBarTotalHeight(p2)

	local v14 = self.props.screenSize.Y - self.props.topBarHeight - self.props.globalGuiInset.bottom

	local v15 = (self.props.peekViewState == peekViewState.Full or self.props.peekViewState == peekViewState.Extended)
		and "regular"
		or "none"

	local v16 = self.state.isMouseAndKeyboard and self.props.peekViewState == peekViewState.Brief
	local v17 = true
	local v18 = self.props.peekViewState == peekViewState.SuperBrief
	local v19 = self.props.lookId == module5.DraftLookId
	local v20 = self.props.avatarRoute.opaque.name == avatarScreen.MySharedAvatars

	local v21 = v19 and self.props.peekViewState ~= peekViewState.Closed and "regular" or v15

	local v22 = self.props.peekViewState == peekViewState.Full
		or self.props.peekViewState == peekViewState.Extended

	local v23 = self.props.isTryOn and "tryOn" or v21

	if not self.props.showPeekViewInSuperBrief then
		v17 = not v18
	end

	if v19 then
		v16 = false
	end

	local v24 = not defineFastFlag or self.props.peekViewState == peekViewState.Full

	if v19 then
		v24 = false
	end

	if self.props.isTryOn then
		v24 = false
	end

	local function fn5(p5)
		self.props.setSelectedTab(p5)
	end

	local detailsTabTitle = p3.detailsTabTitle
	local count = 0

	if self.props.tryOnItems then
		for k, tryOnItem in pairs(self.props.tryOnItems) do
			count += 1
		end
	end

	local v25 = {
		{ Title = detailsTabTitle, Name = "Details" },
		{
			Title = p3.tryOnTabTitle:gsub("{numItems}", count),
			Name = "TryOns"
		}
	}

	if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
		local createElement = Roact.createElement

		local v28 = if isTryOn then Vector2.new(0.5, 0) else nil
		local v27 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v12,
			Position = udim,
			AnchorPoint = v28,
			Visible = self.props.fullView ~= fullView.SceneFullView,
			SelectionGroup = true,
			ref = self.frameRef
		}
		local children = {
			LookDetailsTryOnTopBar = v23 == "tryOn" and Roact.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = v22 and 0 or 1,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				Size = UDim2.new(1, 0, 0, self.props.topBarHeight),
				Position = UDim2.fromOffset(0, -self.props.topBarHeight),
				BorderSizePixel = 0
			}, {
				TopContent = Roact.createElement(module22, {
					stylePalette = p2,
					showDropDownButton = v22,
					navigateBack = self.navigateBack,
					onCloseButtonPressed = self.onCloseButtonPressed,
					robuxBalanceRef = self.robuxBalanceRef
				})
			}),
			LookDetailsTopBar = v23 == "regular" and Roact.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = 0,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				Size = UDim2.new(1, 0, 0, self.props.topBarHeight),
				Position = UDim2.fromOffset(0, -self.props.topBarHeight),
				BorderSizePixel = 0,
				Active = true
			}, {
				TopContent = self:renderTopContent(p2, p3, p4)
			}),
			CloseButton = 0,
			PeekViewContainer = 0,
			LastInputTypeChangedConnection = 0
		}

		if v16 then
			local createElement2 = Roact.createElement
			local onCloseButtonPressedsByActivated = {}
			onCloseButtonPressedsByActivated.AnchorPoint = Vector2.new(0, 1)
			onCloseButtonPressedsByActivated.BackgroundTransparency = 1
			local newUDim2 = UDim2.new

			local v34 = -self:getBriefViewHeight(p2)

			if not self.props.isTryOn then
				v11 = v10
			end

			onCloseButtonPressedsByActivated.Position = newUDim2(0, size_350, 1, v34 - v11)

			local newUDim2_2 = UDim2.new

			local v36 = if not self.props.isTryOn then v10 else nil

			if self.props.isTryOn then
				v10 = size_1200
			end

			onCloseButtonPressedsByActivated.Size = newUDim2_2(0, v36, 0, v10)

			local v38 = if self.props.isTryOn then iconsactionstruncationExpand else iconsnavigationclose
			onCloseButtonPressedsByActivated.Image = v38
			onCloseButtonPressedsByActivated.ImageColor3 = theme.SystemPrimaryDefault.Color
			onCloseButtonPressedsByActivated[Roact.Event.Activated] = self.onCloseButtonPressed
			v16 = createElement2(imageSetButton, onCloseButtonPressedsByActivated)
		end

		children.CloseButton = v16

		local createElement2 = Roact.createElement
		local v32 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3,
			ClipsDescendants = true
		}

		local createElement3 = Roact.createElement

		local v35 = {
			shouldCaptureFocus = false,
			scrollingFrameRef = self.props.scrollingFrameRef,
			briefViewContentHeight = UDim.new(0, briefViewHeight),
			mountAnimation = v24,
			mountAsFullView = false,
			canDragFullViewToBrief = true,
			showDraggerInClosedState = false,
			returnToFullView = true,
			thumbstickScrollEnabled = true,
			viewStateChanged = self.viewStateChanged,
			showDropShadow = not self.props.isTryOn and module2(self.props.peekViewState),
			superBriefViewContentHeight = 0,
			stateOnMount = 0,
			bottomDockedContainerHeight = 0,
			bottomDockedContainerContent = 0,
			backgroundColor3 = 0,
			backgroundTransparency = 0,
			peekHeaderClose = false,
			isScrollingEnabled = 0,
			peekViewState = 0,
			hideDraggerInSuperBrief = 0,
			customBackground = 0,
			minimizeToSuperBrief = 0
		}
		local v37 = if self.props.lookId ~= nil then UDim.new(0, v13) else nil
		v35.superBriefViewContentHeight = v37
		local v38

		if self.props.initialPeekViewState then
			v38 = self.props.initialPeekViewState
		elseif self.props.lookId then
			v38 = self.props.peekViewState
		end

		v35.stateOnMount = v38

		v35.bottomDockedContainerHeight = actionBarTotalHeight
		v35.bottomDockedContainerContent = self:renderActionBar(p2)

		v35.backgroundColor3 = theme.BackgroundDefault.Color
		v35.backgroundTransparency = theme.BackgroundUIDefault.Transparency

		v35.isScrollingEnabled = v17
		v35.peekViewState = self.props.peekViewState

		v35.hideDraggerInSuperBrief = not self.props.showPeekViewInSuperBrief
		v35.customBackground = theme.BackgroundDefault.Color

		v35.minimizeToSuperBrief = self.props.lookId ~= module5.DraftLookId

		local createElement4 = Roact.createElement
		local resolvedFocusNavigationRefsByRef = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			[Roact.Ref] = self.props.resolvedFocusNavigationRef
		}
		local v40 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 0)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 0),
				PaddingBottom = UDim.new(0, 8)
			}),
			NavBar = 0,
			DetailsContainer = 0,
			TryOnManagerContainer = 0
		}

		local v41 = if v19 or v20 or self.props.isTryOn then Roact.createElement(module16, {
			layoutOrderMain = 1,
			navHeightMain = module5.LooksDetailsTabBarHeight,
			tabs = v25,
			selectedTabIndex = self.props.selectedTab,
			selectTab = fn5,
			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.props.NextSelectionDown
		}) else nil
		v40.NavBar = v41

		local v42 = if self.props.selectedTab == 1 then Roact.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v14),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			self:renderDetailsContents()
		) else nil
		v40.DetailsContainer = v42

		local v43 = if self.props.selectedTab == 2 then Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v14),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = self.itemsListRef
		}, self:renderTryOnManagerContents(p2, p3, v23 == "regular")) else nil
		v40.TryOnManagerContainer = v43
		children.PeekViewContainer = createElement2("Frame", v32, {
			PeekView = createElement3(
				peekView,
				v35,
				createElement4("Frame", resolvedFocusNavigationRefsByRef, v40)
			)
		})

		children.LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p5)
				if p5 then
					local v44 = module7.InputTypeMap[p5] == module7.InputType.MouseAndKeyboard

					if v44 ~= self.state.isMouseAndKeyboard then
						self:setState({ isMouseAndKeyboard = v44 })
					end
				end
			end
		})
		return createElement("Frame", v27, children)
	else
		local createElement = Roact.createElement

		local v28 = if isTryOn then Vector2.new(0.5, 0) else nil
		local v27 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v12,
			Position = udim,
			AnchorPoint = v28,
			Visible = self.props.fullView ~= fullView.SceneFullView,
			ref = self.frameRef
		}
		local children = {
			LookDetailsTryOnTopBar = v23 == "tryOn" and Roact.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = v22 and 0 or 1,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				Size = UDim2.new(1, 0, 0, self.props.topBarHeight),
				Position = UDim2.fromOffset(0, -self.props.topBarHeight),
				BorderSizePixel = 0
			}, {
				TopContent = Roact.createElement(module22, {
					stylePalette = p2,
					showDropDownButton = v22,
					navigateBack = self.navigateBack,
					onCloseButtonPressed = self.onCloseButtonPressed,
					robuxBalanceRef = self.robuxBalanceRef
				})
			}),
			LookDetailsTopBar = v23 == "regular" and Roact.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = 0,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				Size = UDim2.new(1, 0, 0, self.props.topBarHeight),
				Position = UDim2.fromOffset(0, -self.props.topBarHeight),
				BorderSizePixel = 0,
				Active = true
			}, {
				TopContent = self:renderTopContent(p2, p3, p4)
			}),
			CloseButton = 0,
			PeekViewContainer = 0,
			LastInputTypeChangedConnection = 0
		}

		if v16 then
			local createElement2 = Roact.createElement
			local onCloseButtonPressedsByActivated = {}
			onCloseButtonPressedsByActivated.AnchorPoint = Vector2.new(0, 1)
			onCloseButtonPressedsByActivated.BackgroundTransparency = 1
			local newUDim2 = UDim2.new

			local v34 = -self:getBriefViewHeight(p2)

			if not self.props.isTryOn then
				v11 = v10
			end

			onCloseButtonPressedsByActivated.Position = newUDim2(0, size_350, 1, v34 - v11)

			local newUDim2_2 = UDim2.new

			local v36 = if not self.props.isTryOn then v10 else nil

			if self.props.isTryOn then
				v10 = size_1200
			end

			onCloseButtonPressedsByActivated.Size = newUDim2_2(0, v36, 0, v10)

			local v38 = if self.props.isTryOn then iconsactionstruncationExpand else iconsnavigationclose
			onCloseButtonPressedsByActivated.Image = v38
			onCloseButtonPressedsByActivated.ImageColor3 = theme.SystemPrimaryDefault.Color
			onCloseButtonPressedsByActivated[Roact.Event.Activated] = self.onCloseButtonPressed
			v16 = createElement2(imageSetButton, onCloseButtonPressedsByActivated)
		end

		children.CloseButton = v16

		local createElement2 = Roact.createElement
		local v32 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3,
			ClipsDescendants = true
		}

		local createElement3 = Roact.createElement
		local v35 = {
			scrollingFrameRef = self.props.scrollingFrameRef,
			briefViewContentHeight = UDim.new(0, briefViewHeight),
			mountAnimation = v24,
			mountAsFullView = false,
			canDragFullViewToBrief = true,
			showDraggerInClosedState = false,
			returnToFullView = true,
			thumbstickScrollEnabled = true,
			viewStateChanged = self.viewStateChanged,
			showDropShadow = not self.props.isTryOn and module2(self.props.peekViewState),
			superBriefViewContentHeight = 0,
			stateOnMount = 0,
			bottomDockedContainerHeight = 0,
			bottomDockedContainerContent = 0,
			shouldCaptureFocus = false,
			backgroundColor3 = 0,
			backgroundTransparency = 0,
			peekHeaderClose = false,
			isScrollingEnabled = 0,
			peekViewState = 0,
			hideDraggerInSuperBrief = 0,
			customBackground = 0,
			minimizeToSuperBrief = 0
		}
		local v37 = if self.props.lookId ~= nil then UDim.new(0, v13) else nil
		v35.superBriefViewContentHeight = v37
		local v38

		if self.props.initialPeekViewState then
			v38 = self.props.initialPeekViewState
		elseif self.props.lookId then
			v38 = self.props.peekViewState
		end

		v35.stateOnMount = v38

		v35.bottomDockedContainerHeight = actionBarTotalHeight
		v35.bottomDockedContainerContent = self:renderActionBar(p2)

		v35.backgroundColor3 = theme.BackgroundDefault.Color
		v35.backgroundTransparency = theme.BackgroundUIDefault.Transparency

		v35.isScrollingEnabled = v17
		v35.peekViewState = self.props.peekViewState

		v35.hideDraggerInSuperBrief = not self.props.showPeekViewInSuperBrief
		v35.customBackground = theme.BackgroundDefault.Color

		v35.minimizeToSuperBrief = self.props.lookId ~= module5.DraftLookId
		local v39 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 0)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 0),
				PaddingBottom = UDim.new(0, 8)
			}),
			NavBar = 0,
			DetailsContainer = 0,
			TryOnManagerContainer = 0
		}

		local v40 = if v19 or v20 or self.props.isTryOn then Roact.createElement(module16, {
			layoutOrderMain = 1,
			navHeightMain = module5.LooksDetailsTabBarHeight,
			tabs = v25,
			selectedTabIndex = self.props.selectedTab,
			selectTab = fn5,
			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.props.NextSelectionDown
		}) else nil
		v39.NavBar = v40

		local v41 = if self.props.selectedTab == 1 then Roact.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v14),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			self:renderDetailsContents()
		) else nil
		v39.DetailsContainer = v41

		local v42 = if self.props.selectedTab == 2 then Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v14),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = self.itemsListRef
		}, self:renderTryOnManagerContents(p2, p3, v23 == "regular")) else nil
		v39.TryOnManagerContainer = v42
		children.PeekViewContainer = createElement2("Frame", v32, {
			PeekView = createElement3(peekView, v35, v39)
		})

		children.LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p5)
				if p5 then
					local v43 = module7.InputTypeMap[p5] == module7.InputType.MouseAndKeyboard

					if v43 ~= self.state.isMouseAndKeyboard then
						self:setState({ isMouseAndKeyboard = v43 })
					end
				end
			end
		})
		return createElement("Frame", v27, children)
	end
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			detailsTabTitle = "Feature.Catalog.Label.Details",
			tryOnTabTitle = "Feature.Catalog.Label.TryOnsMultiple",
			previewHeader = module21() and "Feature.Avatar.Title.Preview" or nil
		})(function(p3)
			return withSelectionCursorProvider(function(p4)
				return self:renderWithProviders(p2, p3, p4)
			end)
		end)
	end)
end

function extended.didUpdate(data, p2, p3)
	if p2.lookId and not data.props.lookId then
		data.onPeekViewClosed()
		data.props.setTryOnManagerPeekViewState(peekViewState.Closed)
	end

	if not wasLastInputGamepad() then
		return
	end

	if
		data.props.peekViewState ~= p2.peekViewState
		and data.props.peekViewState ~= peekViewState.Closed
		and data.props.peekViewState == peekViewState.Brief
	then
		local current

		if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
			current = data.props.resolvedActionBarRef.current
		else
			current = data.actionBarRef.current
		end

		if data.props.focusGuiObject and current then
			data.props.focusGuiObject(current)
		end
	end
end

local function mapStateToProps(data, p2)
	local v10 = module14(data)
	local name = p2.avatarRoute.opaque.name
	local v11

	if fFlagAXCatalogMakeupSupport then
		v11 = fn(data)
	else
		v11 = data.AvatarExperience.AvatarScene.OutfitTryOn.LookId
	end

	local looks = data.AvatarExperience.AvatarScene.Looks
	local v12 = looks and v11 and looks[v11]
	local tryOnItems = data.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return {
		isPortrait = v10,
		topBarHeight = data.TopBar.topBarHeight,
		tryOnItems = tryOnItems,
		lookId = v11,
		lookDetails = v12,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize,
		fullView = module15(data, name),
		boundInputs = data.GamepadBottomBar.boundInputs,
		peekViewState = data.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState,
		selectedTab = data.AvatarExperience.Common.ItemDetailsPeekView.lookDetailsSelectedTab
	}
end

local function mapDispatchToProps(callback)
	return {
		removeUnselectedItemsFromTryOn = function()
			return callback(removeUnselectedItemsFromTryOn())
		end,
		removeLookItemsFromTryOn = function(p2, p3)
			if not (p2 and p3) then
				return
			end

			local v10 = {}

			for k in p3.lookAssetInfos do
				table.insert(v10, k)
			end

			local v11 = {}

			for k in p3.lookBundleInfos do
				table.insert(v11, k)
			end

			return callback(removeLookItemsFromTryOn(p2, v10, v11))
		end,
		setTryOnManagerPeekViewState = function(p2)
			callback(setTryOnManagerPeekViewState(p2))
		end,
		setSelectedTab = function(p2)
			return callback(setLookDetailsPeekViewSelectedTab(p2))
		end,
		closeFocusedScreen = function(p2)
			callback(module19(p2))
		end
	}
end

local v10 = module13((module12((roactServices.connect({ catalogAnalytics = module4 })(extended)))))

local v11 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v10)

local function LookDetailsPeekViewContainer(props)
	local v12 = useUiModeInfo().uiMode == uiMode.TenFoot
	local v13, v14

	if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
		local v15 = useDispatch()
		local v17 = if fFlagAXCatalogMakeupSupport then selectTryOnsLookId else fn3
		local v18 = useSelector(v17)
		local v19 = useSelector(fn4)
		local v20 = useSelector(fn2)

		local v21 = React.useCallback(function()
			if props.isTryOn then
				if v18 == nil or not v19 then
					v15(removeUnselectedItemsFromTryOn())
				else
					local v22 = {}

					for k in v19.lookAssetInfos do
						table.insert(v22, k)
					end

					local v23 = {}

					if v19.lookBundleInfos then
						for k in v19.lookBundleInfos do
							table.insert(v23, k)
						end
					end

					v15(removeLookItemsFromTryOn(v18, v22, v23))
				end
			end

			props.navigation.goBack()
		end, { props.navigation, v15, v18, v19 })

		local v22 = React.useCallback(function()
			if v20 == peekViewState.Full or v20 == peekViewState.Extended then
				v15(setTryOnManagerPeekViewState(peekViewState.Brief))
			else
				v15(setTryOnManagerPeekViewState(peekViewState.Full))
			end
		end, { v20, v15 })

		v13 = useTableWrappedCallbackRef((useFocusNavigationBindings(
			props.namedRefs[avatarScreen.LookDetails],
			v21,
			v22
		)))

		v14 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, v21, v22)))
	end

	local v15 = useFocusGuiObject()

	local ref = React.useRef(nil)
	useAXAnimateScrollFrame(ref)

	return Roact.createElement(v11, Cryo.Dictionary.join({
		is10ftUI = v12,
		resolvedFocusNavigationRef = v13,
		resolvedActionBarRef = v14,
		focusGuiObject = v15,
		scrollingFrameRef = ref
	}, props))
end

if fFlagAXMigrateLookDetailsPeekViewToFocusNavigation then
	return module12(LookDetailsPeekViewContainer)
end

return LookDetailsPeekViewContainer

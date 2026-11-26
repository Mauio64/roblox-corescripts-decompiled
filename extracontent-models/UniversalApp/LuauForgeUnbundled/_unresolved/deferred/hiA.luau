local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local t = require(CorePackages.Packages.t)
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = AvatarExperienceCommon.Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local module3 = require("@luauforge/bundled/eie")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
local module4 = require("@luauforge/bundled/fAe")

local module5 = require("@luauforge/deferred/gJH")

local module6 = require("@luauforge/deferred/gRz")
local module7 = require("@luauforge/deferred/hiB")
local module8 = require("@luauforge/deferred/hiK")
local module9 = require("@luauforge/bundled/gTf")
local module10 = require("@luauforge/bundled/fvR")
local module11 = require("@luauforge/deferred/hft")
local module12 = require("@luauforge/bundled/dWU")

local fFlagAXUseSignalsForLayeredClothingLastSavedSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingLastSavedSort
local getLayeredClothingLastSavedSortStore

if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
	getLayeredClothingLastSavedSortStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingLastSavedSortStore
else
	getLayeredClothingLastSavedSortStore = nil
end

local module13 = require("@luauforge/bundled/dWW")
local module14 = require("@luauforge/bundled/dFm")
local module15 = require("@luauforge/bundled/gSD")
local module16 = require("@luauforge/bundled/dWZ")
local module17 = require("@luauforge/bundled/dzE")
local fullView = AvatarExperienceCommon.Enums.FullView
local module18 = require("@luauforge/deferred/gTm")
local module19 = require("@luauforge/deferred/gLv")

local module20 = require("@luauforge/deferred/hiC")
local module21 = require("@luauforge/bundled/gJS")
local module22 = require("@luauforge/deferred/hiL")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module23 = require("@luauforge/deferred/gKK")
local module24 = require("@luauforge/bundled/dXb")
local fFlagAXUseSignalsForLayeredClothingEntryPage = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingEntryPage
local getLayeredClothingEntryPageStore

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	getLayeredClothingEntryPageStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingEntryPageStore
else
	getLayeredClothingEntryPageStore = nil
end

local module25 = require("@luauforge/bundled/dXe")
local module26 = require("@luauforge/deferred/gKL")

local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = AvatarExperienceFlags.FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice
local module27 = require("@luauforge/deferred/hhY")
local module28 = require("@luauforge/deferred/hic")
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput
local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getIsLocalUserSoothsayerStore

if fFlagUseSignalsForIsLocalUserSoothsayer then
	getIsLocalUserSoothsayerStore = require("@luauforge/bundled/gil").GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

local module29 = require("@luauforge/deferred/gTx")
local module30 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module30.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module31 = require("@luauforge/bundled/dRs")

local module32 = require("@luauforge/deferred/hiM")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local v5 = {
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt
}

local function useFocusNavigationBindings(p2, callback, p3)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					callback()
				end)
			},
			[focusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = p3 and {
				handler = InputHandlers.onRelease(p3)
			} or nil
		}
	end, { callback, p3 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local v6 = {
	toastMessage = "Feature.Avatar.Message.LCSortClassicWarning",
	isLocalized = false,
	toastType = module17.InformationMessage
}

local iconsmenuabout_large = images["icons/menu/about_large"]

local udim = UDim.new(0, 10)

local extended = Roact.PureComponent:extend("LayeredClothingSortPage")

extended.validateProps = t.strictInterface({
	wrappedFrameRef = t.table,
	setWrapperIsGamepad = t.callback,
	tokens = t.table,
	isPortrait = t.boolean,
	topBarHeight = t.number,
	equippedLCAssetIdsOrdered = t.table,
	equippedAssets = t.table,
	hasClassicAccessories = t.boolean,
	removedList = t.optional(t.table),
	isLocalUserSoothSayer = t.optional(t.boolean),
	setLastSavedSort = t.callback,
	setCurrentToastMessage = t.callback,
	setFullView = t.callback,
	setCurrentSort = t.callback,
	sendAnalytics = t.callback,
	setEntryPage = t.callback,
	clearRemovedItems = t.callback,
	unlockCharacterUpdates = t.callback,
	navigation = t.table,
	avatarRoute = t.table,
	avatarExperienceAnalytics = t.table,
	analytics = t.table
})

function extended:init()
	self.numAssetsUponPageEntry = nil

	self.verticalClothingListRef = Roact.createRef()
	self.topBarRef = Roact.createRef()
	self.refinementNavBarRef = Roact.createRef()

	self:setState({
		lastInputIsGamepad = not isVRAppBuild() and isGamepadInput(UserInputService:GetLastInputType()),
		isDragging = false
	})

	self.props.setWrapperIsGamepad(not isVRAppBuild() and isGamepadInput(UserInputService:GetLastInputType()))

	function self.onBackFromTopBar()
		self.props.unlockCharacterUpdates()

		self.props.navigation.pop()

		self.props.sendAnalytics(self.props.analytics.avatarRefineGoBack)
		self.props.setEntryPage(avatarScreen.None)
	end

	function self.lastInputTypeChangedCallback(p2)
		local gamepadInput = isGamepadInput(p2)

		if gamepadInput ~= self.state.lastInputIsGamepad then
			self:setState({ lastInputIsGamepad = gamepadInput })

			self.props.setWrapperIsGamepad(gamepadInput)
		end
	end

	function self.onOverlayClosed()
		return function()
			if
				self.state.lastInputIsGamepad
				and self.props.avatarRoute.opaque.name == avatarScreen.LayeredClothingSort
			then
				logOnOverlayClosed("LayeredClothingSort")
			end
		end
	end

	function self.onDragChange(p2)
		self:setState({ isDragging = p2 })
	end

	self.backButton = module11(self.onBackFromTopBar)
end

function extended:saveSortOnPageEnter()
	local v7 = {}

	for k, v8 in self.props.equippedLCAssetIdsOrdered do
		if self.props.equippedAssets[v8.typeId] and self.props.equippedAssets[v8.typeId][v8.id] then
			v8.equipped = true
		end

		table.insert(v7, v8)
	end

	self.props.setLastSavedSort(v7)
	self.props.setCurrentSort(self.props.equippedLCAssetIdsOrdered)
	self.numAssetsUponPageEntry = #self.props.equippedLCAssetIdsOrdered
end

function extended:onPageEntry()
	self:saveSortOnPageEnter()
	self.props.setFullView(self.props.avatarExperienceAnalytics, fullView.SceneFullView)

	if self.props.hasClassicAccessories then
		self.props.setCurrentToastMessage(v6)
	end
end

function extended:renderTopBar()
	return withLocalization({ clothingSorting = "Feature.Avatar.Title.LCSortPage" })(function(p2)
		return Roact.createElement(module10.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = p2.clothingSorting,
			transparentBackground = true,
			hideSiteMessageBanner = self.props.isPortrait,
			leftItem = self.backButton,
			ZIndex = 1,
			[Roact.Ref] = self.topBarRef,
			NextSelectionRight = self.verticalClothingListRef,
			NextSelectionDown = self.refinementNavBarRef
		})
	end)
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			noItemText = "Feature.Avatar.Message.LCSortNoEquipped"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended:renderWithProviders(p2, p3)
	local theme = p2.Theme
	local v7 = #self.props.equippedLCAssetIdsOrdered > 0
	local v8 = not v7 and self.numAssetsUponPageEntry == 0
	local v9 = if v7 then self.verticalClothingListRef else self.topBarRef

	local createElement = Roact.createElement
	local v11 = {
		Size = UDim2.new(1, 0, 1, -self.props.topBarHeight),
		Position = UDim2.fromOffset(0, self.props.topBarHeight),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local v12 = {
		SceneInteractionFrame = Roact.createElement(module9),
		VerticalClothingList = 0,
		ResetButton = 0,
		VRAvatarRotateHandler = 0,
		NoItemsMessage = 0
	}
	local v13 = not v8

	if v13 then
		v13 = Roact.createElement(RoactGamepad.Focusable[module7], {
			[Roact.Ref] = self.verticalClothingListRef,
			NextSelectionLeft = self.refinementNavBarRef,
			lastInputIsGamepad = self.state.lastInputIsGamepad,
			topBarRef = self.topBarRef,
			onDragChange = self.onDragChange
		})
	end

	v12.VerticalClothingList = v13

	v12.ResetButton = not v8
		and Roact.createElement(module8, {
			lastInputIsGamepad = self.state.lastInputIsGamepad,
			isDragging = self.state.isDragging
		})

	local v14 = if isVRAppBuild() then Roact.createElement(module18) else nil
	v12.VRAvatarRotateHandler = v14

	if v8 then
		local createElement2 = Roact.createElement
		local v16 = {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, module19.NoItem.BottomPadding),
			Size = 0,
			BackgroundColor3 = 0,
			BackgroundTransparency = 0
		}
		local v17 = if isVRAppBuild() then UDim2.new(1, 0, 0, 50) else UDim2.new(1, 0, 0, 100)
		v16.Size = v17
		v16.BackgroundColor3 = theme.BackgroundDefault.Color
		v16.BackgroundTransparency = isVRAppBuild() and 0 or 1

		local v19 = if isVRAppBuild() then Roact.createElement("UICorner", {
			CornerRadius = udim
		}) else nil
		v8 = createElement2("Frame", v16, {
			UICorner = v19,
			NoItemsTextLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0, 0),
				Text = p3.noItemText,
				FontFace = normalizeFontFace(p2.Tokens.Typography.CaptionLarge.Font),
				TextSize = self.props.tokens.Typography.BodyMedium.FontSize,
				TextColor3 = theme.IconEmphasis.Color,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				NoItemsIcon = Roact.createElement(imageSetLabel, {
					Image = iconsmenuabout_large,
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -2, 0.5, 0),
					Size = UDim2.fromOffset(module19.NoItem.IconSize, module19.NoItem.IconSize),
					ImageColor3 = theme.IconEmphasis.Color
				})
			})
		})
	end

	v12.NoItemsMessage = v8
	local element = createElement("Frame", v11, v12)

	local v15 = {
		TopBar = self:renderTopBar(p3),
		RefinementControlBar = 0,
		RefinementNavBar = 0,
		LayeredClothingSortPageFrame = 0,
		LastInputTypeChangedConnection = 0
	}
	local v16 = if module31() then React.createElement(module28, {
		ref = self.refinementNavBarRef,
		NextSelectionUp = self.topBarRef,
		NextSelectionRight = self.verticalClothingListRef,
		hideUndoRedo = true,
		ZIndex = module32 and 3 or nil
	}) else nil
	v15.RefinementControlBar = v16

	local v17 = if not module31() then Roact.createElement(module27, {
		defaultChildRef = self.refinementNavBarRef,
		NextSelectionUp = self.topBarRef,
		NextSelectionRight = self.verticalClothingListRef
	}) else nil
	v15.RefinementNavBar = v17

	v15.LayeredClothingSortPageFrame = element
	v15.LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = self.lastInputTypeChangedCallback
	})

	if isVRAppBuild() then
		return element
	end

	return Roact.createElement(
		RoactGamepad.Focusable.Frame,
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[Roact.Ref] = self.props.wrappedFrameRef,
			defaultChild = v9
		},
		{
			SceneGamepadHandler = Roact.createElement(module29, nil, v15)
		}
	)
end

function extended:didMount()
	if self.props.avatarRoute.opaque.name == avatarScreen.LayeredClothingSort then
		self:onPageEntry()
	end
end

function extended:didUpdate(p2, p3)
	if
		self.props.avatarRoute.opaque.name ~= p2.avatarRoute.opaque.name
		and self.props.avatarRoute.opaque.name == avatarScreen.LayeredClothingSort
	then
		self:onPageEntry()
	end

	if
		self.props.avatarRoute.opaque.name == avatarScreen.LayeredClothingSort
		and self.props.avatarRoute.isVisible
		and not p2.avatarRoute.isVisible
	then
		self:onPageEntry()
	end
end

function extended.willUnmount(p2)
	p2.props.unlockCharacterUpdates()
end

local function mapStateToProps(data, p2)
	local v7 = {
		isPortrait = module21(data),
		topBarHeight = isVRAppBuild() and 0 or data.TopBar.topBarHeight,
		equippedLCAssetIdsOrdered = module20(data),
		equippedAssets = data.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		hasClassicAccessories = module22(data),
		removedList = 0,
		isLocalUserSoothSayer = 0
	}

	local v8 = if not fFlagAXUseSignalsForLayeredClothingCurrentSort then data.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList else nil
	v7.removedList = v8

	local v9 = if not fFlagUseSignalsForIsLocalUserSoothsayer then data.IsLocalUserSoothsayer else nil
	v7.isLocalUserSoothSayer = v9
	return v7
end

local function mapDispatchToProps(callback)
	return {
		setLastSavedSort = function(p2)
			if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
				getLayeredClothingLastSavedSortStore(false).setLastSavedSort(p2)
			else
				callback(module12(p2))
			end
		end,
		setCurrentSort = function(p2)
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).setCurrentSort(p2)
			else
				callback(module13(p2))
			end
		end,
		setCurrentToastMessage = function(p2)
			callback(module14(p2))
		end,
		setFullView = function(p2, p3)
			callback(module15(p2, avatarScreen.LayeredClothingSort, p3))
		end,
		sendAnalytics = function(p2)
			callback(module26(p2))
		end,
		setEntryPage = function(p2)
			if fFlagAXUseSignalsForLayeredClothingEntryPage then
				getLayeredClothingEntryPageStore(false).setEntryPage(p2)
			else
				callback(module24(p2))
			end
		end,
		clearRemovedItems = function()
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).clearRemovedItems()
			else
				callback(module16())
			end
		end,
		unlockCharacterUpdates = function()
			if not fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
				callback(module25())
			end
		end
	}
end

local v7 = roactServices.connect({
	analytics = module23,
	avatarExperienceAnalytics = avatarExperienceAnalyticsService
})(extended)

local v8 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v7)

if fFlagUseSignalsForIsLocalUserSoothsayer then
	local v9 = v8
	v8 = React.memo(function(p2)
		local v10 = useSignalState(getIsLocalUserSoothsayerStore(false).getIsLocalUserSoothsayer)
		return React.createElement(v9, Cryo.Dictionary.union(p2, {
			isLocalUserSoothSayer = v10
		}))
	end)
end

local v9 = module6((module4((module5(v8)))))

return function(p2)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v10 = useSelector(module20)
	local v11 = useDispatch()
	local v12 = module3(module23)
	local v13 = useAvatarRoute()

	local v14 = useTokens()

	local v15 = React.useCallback(function()
		if not fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
			v11(module25())
		end

		p2.navigation.popToTop()
		v11(module26(v12.avatarRefineGoBack))

		if fFlagAXUseSignalsForLayeredClothingEntryPage then
			getLayeredClothingEntryPageStore(false).setEntryPage(avatarScreen.None)
		else
			v11(module24(avatarScreen.None))
		end
	end, { v11, p2.navigation, v12 })

	local v16 = React.useCallback(function()
		local function onOverlayClosed()
			if state and v13.opaque.name == avatarScreen.LayeredClothingSort then
				logOnOverlayClosed("LayeredClothingSort")
			end
		end

		p2.navigation.navigate(avatarScreen.ResetLayeredItemsSortPrompt, {
			onOverlayClosed = onOverlayClosed
		})
	end, { p2.navigation, state, v13 })

	if not (#v10 > 0) then
		v16 = nil
	end

	local v19 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, v15, v16)))

	local joined = Cryo.Dictionary.join(p2, {
		wrappedFrameRef = v19,
		setWrapperIsGamepad = setState,
		tokens = v14
	})

	return React.createElement(v9, joined)
end

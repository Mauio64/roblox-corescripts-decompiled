local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local withStyle = UIBlox.Style.withStyle

local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/bundled/fvR")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module4 = require("@luauforge/bundled/dAB")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module5 = require("@luauforge/bundled/eie")

local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local loadingStatePage = UIBlox.App.Container.LoadingStatePage
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module7 = require("@luauforge/bundled/fDf")
local module8 = require("@luauforge/deferred/gTt")
local module9 = require("@luauforge/deferred/gJK")
local module10 = require("@luauforge/deferred/gRz")
local module11 = require("@luauforge/bundled/gSD")
local fullView = AvatarExperienceCommon.Enums.FullView
local module12 = require("@luauforge/bundled/fCe")
local module13 = require("@luauforge/deferred/hgS")
local module14 = require("@luauforge/deferred/fCu")
local setItemDetailsPeekViewState = require("@luauforge/bundled/dKU").Actions.SetItemDetailsPeekViewState
local module15 = require("@luauforge/bundled/dXh")
local module16 = require("@luauforge/bundled/gSI")
local module17 = require("@luauforge/deferred/gQN")
local module18 = require("@luauforge/deferred/gQQ")
local fFlagUpdateNoInternetConnectionText = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagUpdateNoInternetConnectionText

local module19 = require("@luauforge/bundled/ehL")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module19.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module20 = require("@luauforge/deferred/fDS")
local module21 = require("@luauforge/deferred/hha")
local module22 = require("@luauforge/deferred/hhc")
local module23 = require("@luauforge/deferred/hhd")
local module24 = require("@luauforge/bundled/fCW")

local fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation

local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXPPEReturnToEntrySurface

local extended = Roact.PureComponent:extend("ProfilePictureEditorEmotesPage")

local v5 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
	[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenCatalogContextMenu
}

local function useFocusNavigationBindings(p2, callback, callback2, callback3)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			},
			[focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = callback2 and {
				handler = InputHandlers.onRelease(function(p3)
					callback2()
				end)
			} or nil,
			[focusNavigationEventNameEnum.OpenCatalogContextMenu] = callback3 and {
				handler = InputHandlers.onRelease(function(p3)
					callback3()
				end)
			} or nil
		}
	end, { callback, callback2, callback3 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local strictInterface = t.strictInterface
local v6 = {
	avatarRoute = t.table,
	navigation = t.table,
	networking = t.callback,
	avatarExperienceAnalytics = t.table,
	profilePictureEditorAnalytics = t.table,
	fullView = t.userdata,
	fetchingStatus = t.string,
	isPortrait = t.boolean,
	itemDetailsExpanded = t.boolean,
	emoteAssetId = t.optional(t.string),
	tryOnItems = t.table,
	fetchPPEConfig = t.callback,
	setFullView = t.callback,
	navigateIntoQuickMenu = t.callback,
	setItemDetailsPeekViewState = t.callback,
	overlayClosedCallback = t.callback,
	resolvedFocusNavigationRef = 0,
	topBarRef = 0
}
local v7 = if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then t.table else nil
v6.resolvedFocusNavigationRef = v7
local v8 = if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then t.table else nil
v6.topBarRef = v8
extended.validateProps = strictInterface(v6)

function extended:init()
	self.sceneUIContainerRef = Roact.createRef()
	self.emotesScrollViewRef = Roact.createRef()

	if not fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then
		self.topBarRef = Roact.createRef()
	end

	self.bottomBarRef = Roact.createRef()

	self:setState({
		lastInputIsGamepad = isGamepadInput((UserInputService:GetLastInputType())),
		bottomBarHeight = 72
	})

	function self.fetchPPEConfig()
		self.props.fetchPPEConfig(self.props.networking)
	end

	function self.onAbsoluteSizeChanged(p2)
		self:setState({ bottomBarHeight = p2.Y })
	end

	function self.changeView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		local newFullViewEnum = module12.getNewFullViewEnum(self.props.fullView)
		self.props.setFullView(
			avatarExperienceAnalytics,
			self.props.avatarRoute.opaque.name,
			newFullViewEnum
		)
	end

	function self.onBackFromTopBar()
		if fFlagAXPPEReturnToEntrySurface then
			module15.restoreEntryOrigin(self.props.navigation, module2.Home)
			return
		end

		local v9 = self.props.navigation.getParam("prevNavPage") or module2.Home

		self.props.navigation.navigate(v9)
	end

	self.backButton = module3.makeBackButton(self.onBackFromTopBar)

	function self.onNext()
		self.props.profilePictureEditorAnalytics.clickNextFromEmotesPage(self.props.emoteAssetId)
		local navigation = self.props.navigation
		navigation.navigate(
			avatarScreen.ProfilePictureEditorCamera,
			not fFlagAXPPEReturnToEntrySurface and {} or module15.getEntryOriginParams(navigation)
		)
	end

	function self.onDone()
		local navigation = self.props.navigation
		navigation.navigate(
			avatarScreen.ProfilePictureEditorFinal,
			not fFlagAXPPEReturnToEntrySurface and {} or module15.getEntryOriginParams(navigation)
		)
	end

	function self.onRevertBtnClicked()
		self.props.navigation.navigate(avatarScreen.ProfilePictureEditorRevertToDefaultPrompt, {
			onBack = self.onBackFromTopBar
		})
	end

	function self.renderBottomBar()
		local v9 = not Cryo.isEmpty(self.props.tryOnItems)
		local v10 = {
			textKey = "Feature.Avatar.Action.Revert",
			onActivated = self.onRevertBtnClicked,
			isDisabled = false
		}

		return Roact.createElement(module22, {
			button1 = v10,
			button2 = {
				textKey = "Authentication.CrossDevice.Action.Next",
				onActivated = self.onNext,
				isDisabled = v9
			},
			NextSelectionUp = self.emotesScrollViewRef,
			onAbsoluteSizeChanged = self.onAbsoluteSizeChanged,
			baseRef = self.bottomBarRef
		})
	end

	function self.lastInputTypeChangedCallback(p2)
		local gamepadInput = isGamepadInput(p2)

		if gamepadInput ~= self.state.lastInputIsGamepad then
			self:setState({ lastInputIsGamepad = gamepadInput })
		end
	end
end

function extended:renderTopBar()
	local isPortrait = self.props.isPortrait

	return withLocalization({ title = "Feature.Avatar.Action.EditProfilePicture" })(function(p2)
		local createElement = Roact.createElement
		local container = module3.Container
		local v9 = {
			["tag"] = nil,
			["tag"] = nil,
			["tag"] = nil,
			["tag"] = nil,
			["tag"] = nil,
			["tag"] = nil,
			["tag"] = nil,
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0
		}

		local ref = Roact.Ref
		local v10 = if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then self.props.topBarRef else self.topBarRef
		v9[ref] = v10

		v9.NextSelectionDown = self.emotesScrollViewRef
		v9.titleText = p2.title
		v9.transparentBackground = isPortrait
		v9.hideSiteMessageBanner = isPortrait
		v9.leftItem = self.backButton
		v9.useParentSizeForCenterItem = true
		return createElement(container, v9)
	end)
end

function extended:render()
	local v9 = not self.props.isPortrait and 0 or self.state.bottomBarHeight
	local fetchingStatus = self.props.fetchingStatus

	local v10 = self.props.fullView == fullView.UIFullView
	local v11 = self.props.fullView == fullView.SceneFullView

	return withStyle(function(p2)
		return withLocalization({
			failedMessage = fFlagUpdateNoInternetConnectionText and "Feature.DisplayName.ErrorMessage.SomethingWentWrong" or "Feature.EmptyStatePage.Message.NoInternet"
		})(function(p3)
			local createElement = Roact.createElement
			local frame = focusable.Frame
			local v12 = {
				["BackgroundTransparency"] = nil,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				defaultChild = self.emotesScrollViewRef,
				restorePreviousChildFocus = false
			}

			local ref = Roact.Ref
			local v13 = if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then self.props.resolvedFocusNavigationRef else self.ref
			v12[ref] = v13
			return createElement(frame, v12, {
				NavigationEventsLogger = Roact.createElement(module9, {
					pageName = "ProfilePictureEditorEmotes"
				}),
				LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
					event = UserInputService.LastInputTypeChanged,
					callback = self.lastInputTypeChangedCallback
				}),
				AvatarExperienceView = Roact.createElement(module8, {
					bottomBarEnabled = false,
					allowAdaptiveScrolling = true,
					changeViewFunction = self.changeView,
					isSceneFullView = v11,
					isUIFullView = v10,
					topBar = self:renderTopBar(),
					[Roact.Ref] = self.sceneUIContainerRef,
					NextSelectionDown = self.emotesScrollViewRef
				}, {
					LoadingStateContainer = Roact.createElement(loadingStateContainer, {
						dataStatus = retrievalStatus.fromRawValue(fetchingStatus),
						renderOnLoading = function()
							return Roact.createElement(
								"Frame",
								{
									Size = UDim2.new(1, 0, 1, 0),
									BackgroundTransparency = p2.Theme.BackgroundDefault.Transparency,
									BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
									BorderSizePixel = 0
								},
								Roact.createElement(loadingStatePage)
							)
						end,
						renderOnLoaded = function()
							local createFragment = Roact.createFragment
							local createElement3 = Roact.createElement
							local v18 = {
								baseRef = self.emotesScrollViewRef,
								NextSelectionUp = 0,
								NextSelectionDown = 0,
								bottomBarHeight = 0
							}

							local v19 = if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then self.props.topBarRef else self.topBarRef
							v18.NextSelectionUp = v19

							v18.NextSelectionDown = self.bottomBarRef
							v18.bottomBarHeight = v9
							return createFragment({
								EmotesScrollView = createElement3(module23, v18),
								BottomBar = self.renderBottomBar()
							})
						end,
						renderOnFailed = function()
							return self:renderOnFailed(p3)
						end
					})
				})
			})
		end)
	end)
end

function extended.renderOnFailed(props, p2)
	local createElement = Roact.createElement

	local v11 = if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then props.props.topBarRef else props.topBarRef
	return createElement(emptyState, {
		NextSelectionUp = v11,
		onActivated = props.fetchPPEConfig,
		text = p2.failedMessage
	})
end

function extended.didMount(p2)
	if p2.props.fetchingStatus == module4.NotStarted then
		p2.fetchPPEConfig()
	end
end

local v9 = roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService,
	profilePictureEditorAnalytics = module20,
	networking = module
})(extended)

local v10 = module10((RoactRodux.connect(function(p2, p3)
	local ppeConfigFetchStatusKey = module24.PPEConfigFetchStatusKey
	local v11 = module16(p2, avatarScreen.ProfilePictureEditorEmotes)
	local v12 = p2.DeviceOrientation == deviceOrientationMode.Portrait
	local emoteAssetId = p2.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId

	return {
		fullView = v11,
		fetchingStatus = performFetch.GetStatus(p2, ppeConfigFetchStatusKey),
		itemDetailsExpanded = p2.AvatarExperience.Common.ItemDetailsExpanded,
		isPortrait = v12,
		emoteAssetId = emoteAssetId,
		tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	}
end, function(callback)
	return {
		fetchPPEConfig = function(p2)
			callback(module21(p2))
		end,
		setFullView = function(p2, p3, p4)
			callback(module11(p2, p3, p4))
		end,
		navigateIntoQuickMenu = function(p2, p3)
			callback(module13(p2, p3))
		end,
		setItemDetailsPeekViewState = function(p2)
			callback(setItemDetailsPeekViewState(p2))
		end
	}
end)(v9)))

local function ProfilePictureEditorEmotesPageContainer(p2)
	local v11 = module18()
	local v12 = module17({ overlayClosedCallback = v11 })
	local joined

	if fFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then
		local ref = React.useRef(nil)
		local v13 = useDispatch()

		local v14 = useAvatarRoute()
		local v15 = module5(module)
		local v16 = module5(module7)
		local v17 = useFocusGuiObject()

		local v18 = React.useCallback(function()
			if v17 and ref and ref.current then
				v17(ref.current)
			end
		end, { v17 })

		local v19 = React.useCallback(function()
			module15.closeFocusedScreen(p2.navigation)
		end, { p2.navigation })

		local v20 = React.useCallback(function()
			v13(module14(v15, v16, v11, p2.navigation, v14))
		end, { v13, v15, v16, v11, p2.navigation, v14 })

		local v21 = React.useCallback(function()
			p2.navigation.navigate(avatarScreen.CatalogContextMenu, {
				itemId = v14.current.params.itemId,
				itemType = v14.current.params.itemType,
				onOverlayClosed = v11
			})
		end, { p2.navigation, v14, v11 })

		if v14.current.name == avatarScreen.ItemDetails then
			v18 = v19
		end

		if v14.current.name ~= avatarScreen.ItemDetails then
			v20 = nil
		end

		if v14.current.name ~= avatarScreen.ItemDetails then
			v21 = nil
		end

		local v25 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, v18, v20, v21)))

		joined = Cryo.Dictionary.join(p2, {
			overlayClosedCallback = v11,
			topBarRef = ref,
			resolvedFocusNavigationRef = v25
		})
	else
		joined = Cryo.Dictionary.join(p2, { overlayClosedCallback = v11 })
	end

	return Roact.createElement(
		"Frame",
		{ [Roact.Ref] = v12, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		React.createElement(v10, joined)
	)
end

return ProfilePictureEditorEmotesPageContainer

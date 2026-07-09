local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withStyle = UIBlox.Style.withStyle
local AppPage = require(Modules.LuaApp.AppPage)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local LoadingStatePage = UIBlox.App.Container.LoadingStatePage
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Common = Modules.AvatarExperience.Common
local Analytics = require(Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local AvatarExperienceView = require(Common.Components.AvatarExperienceView)
local makeTitleDropDown = require(Common.Components.TopBar.makeTitleDropDown)
local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local withStackVisibilityWrapper = require(Common.Components.RoactNavigation.withStackVisibilityWrapper)
local SetFullView = require(Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local Utils = require(Common.Utils)
local OpenQuickMenu = require(Common.Thunks.OpenQuickMenu)
local OpenItemPrompt = require(Common.Thunks.OpenItemPrompt)
local SetItemDetailsPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetItemDetailsPeekViewState
local NavigationUtils = require(Common.Components.RoactNavigation.NavigationUtils)
local selectIsFullView = require(Common.Selectors.selectIsFullView)
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagUpdateNoInternetConnectionText = AvatarExperienceFlags.FFlagUpdateNoInternetConnectionText
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local ProfilePictureEditor = Modules.AvatarExperience.ProfilePictureEditor
local Analytics3 = require(ProfilePictureEditor.Services.Analytics)
local FetchPPEConfig = require(ProfilePictureEditor.Thunks.FetchPPEConfig)
local ProfilePictureEditorBottomBar = require(ProfilePictureEditor.Components.ProfilePictureEditorBottomBar)
local EmotesScrollView = require(ProfilePictureEditor.Components.EmotesScrollView)
local Constants = require(ProfilePictureEditor.Constants)
local FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation
local FFlagAXOpaqueMarketplaceTopbar = AvatarExperienceFlags.FFlagAXOpaqueMarketplaceTopbar
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local v67 = Roact.PureComponent:extend("ProfilePictureEditorEmotesPage")
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
	[Enum.KeyCode.ButtonL3] = FocusNavigationEventNameEnum.OpenCatalogContextMenu
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 111
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v77 = ReactFocusNavigation.useEventMap(t1, p1)
	local v78 = React.useMemo(function() -- line: 118
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy), p3 (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p5) -- line: 121
					-- upvalues: p2 (copy)
					p5.cancelled = true
					p2()
				end)
			},
			[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = if not p3 then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 128
					-- upvalues: p3 (copy)
					p3()
				end)
			},
			[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = if not p4 then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 135
					-- upvalues: p4 (copy)
					p4()
				end)
			}
		}
	end, {
		p2,
		p3,
		p4
	})

	return ReactFocusNavigation.useEventHandlerMap(v78, v77)
end

v67.validateProps = t.strictInterface({
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
	is10ftUI = t.boolean,
	overlayClosedCallback = t.callback,
	resolvedFocusNavigationRef = if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then nil else t.table,
	topBarRef = if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then nil else t.table
})

function v67.init(p8) -- line: 175
	-- upvalues: Roact (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), UserInputService (copy), isGamepadInput (copy), Utils (copy), AvatarScreen (copy), AppPage (copy), TopBar (copy), Cryo (copy), ProfilePictureEditorBottomBar (copy), makeTitleDropDown (copy)
	p8.sceneUIContainerRef = Roact.createRef()
	p8.emotesScrollViewRef = Roact.createRef()

	if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then
		p8.topBarRef = Roact.createRef()
	end

	p8.bottomBarRef = Roact.createRef()

	local LastInputType = UserInputService:GetLastInputType()

	p8:setState({
		bottomBarHeight = 72,
		lastInputIsGamepad = isGamepadInput(LastInputType)
	})

	function p8.fetchPPEConfig() -- line: 189
		-- upvalues: p8 (copy)
		p8.props.fetchPPEConfig(p8.props.networking)
	end
	function p8.onAbsoluteSizeChanged(p9) -- line: 193
		-- upvalues: p8 (copy)
		p8:setState({
			bottomBarHeight = p9.Y
		})
	end
	function p8.changeView() -- line: 199
		-- upvalues: p8 (copy), Utils (copy)
		local avatarExperienceAnalytics = p8.props.avatarExperienceAnalytics
		local v116 = Utils.getNewFullViewEnum(p8.props.fullView)

		p8.props.setFullView(avatarExperienceAnalytics, p8.props.avatarRoute.opaque.name, v116)
	end
	function p8.onBackFromTopBar() -- line: 206
		-- upvalues: p8 (copy), AvatarScreen (copy), AppPage (copy)
		local v117 = p8.props.navigation.getParam("prevNavPage") or if not p8.props.is10ftUI then AppPage.Home else AvatarScreen.AvatarExperienceLandingPage

		p8.props.navigation.navigate(v117)
	end

	p8.backButton = TopBar.makeBackButton(p8.onBackFromTopBar)

	function p8.onNext() -- line: 221
		-- upvalues: p8 (copy), AvatarScreen (copy)
		p8.props.profilePictureEditorAnalytics.clickNextFromEmotesPage(p8.props.emoteAssetId)
		p8.props.navigation.navigate(AvatarScreen.ProfilePictureEditorCamera, {})
	end
	function p8.onDone() -- line: 227
		-- upvalues: p8 (copy), AvatarScreen (copy)
		p8.props.navigation.navigate(AvatarScreen.ProfilePictureEditorFinal, {})
	end
	function p8.onRevertBtnClicked() -- line: 232
		-- upvalues: p8 (copy), AvatarScreen (copy)
		p8.props.navigation.navigate(AvatarScreen.ProfilePictureEditorRevertToDefaultPrompt, {
			onBack = p8.onBackFromTopBar
		})
	end
	function p8.renderBottomBar() -- line: 238
		-- upvalues: Cryo (copy), p8 (copy), Roact (copy), ProfilePictureEditorBottomBar (copy)
		local v118 = Cryo.isEmpty(p8.props.tryOnItems)
		local t2 = {
			textKey = "Feature.Avatar.Action.Revert",
			isDisabled = false,
			onActivated = p8.onRevertBtnClicked
		}

		return Roact.createElement(ProfilePictureEditorBottomBar, {
			button1 = t2,
			button2 = {
				textKey = "Authentication.CrossDevice.Action.Next",
				onActivated = p8.onNext,
				isDisabled = not v118
			},
			NextSelectionUp = p8.emotesScrollViewRef,
			onAbsoluteSizeChanged = p8.onAbsoluteSizeChanged,
			baseRef = p8.bottomBarRef
		})
	end
	function p8.lastInputTypeChangedCallback(p10) -- line: 259
		-- upvalues: isGamepadInput (copy), p8 (copy)
		local v121 = isGamepadInput(p10)

		if v121 ~= p8.state.lastInputIsGamepad then
			p8:setState({
				lastInputIsGamepad = v121
			})
		end
	end

	p8.titleDropDown = makeTitleDropDown("Feature.Avatar.Action.EditProfilePicture", p8.props.overlayClosedCallback)
end
function v67.renderTopBar(p11) -- line: 271
	-- upvalues: withLocalization (copy), Roact (copy), TopBar (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), FFlagAXOpaqueMarketplaceTopbar (copy), FFlagEnableLeftNavOnConsole (copy)
	local isPortrait = p11.props.isPortrait

	return withLocalization({
		title = "Feature.Avatar.Action.EditProfilePicture"
	})(function(p12) -- line: 276
		-- upvalues: p11 (copy), Roact (copy), TopBar (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), FFlagAXOpaqueMarketplaceTopbar (copy), FFlagEnableLeftNavOnConsole (copy), isPortrait (copy)
		local v123 = if not p11.props.is10ftUI then nil else p11.titleDropDown

		return Roact.createElement(TopBar.Container, {
			[Roact.Ref] = if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then p11.topBarRef else p11.props.topBarRef,
			NextSelectionDown = p11.emotesScrollViewRef,
			titleText = p12.title,
			transparentBackground = not FFlagAXOpaqueMarketplaceTopbar and not FFlagEnableLeftNavOnConsole or (isPortrait and true or false),
			hideSiteMessageBanner = isPortrait,
			leftItem = p11.backButton,
			centerItem = v123,
			useParentSizeForCenterItem = true
		})
	end)
end
function v67.render(p13) -- line: 296
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), FullView (copy), withStyle (copy), withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), Roact (copy), Focusable (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), NavigationEventsLogger (copy), ExternalEventConnection (copy), UserInputService (copy), AvatarExperienceView (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), LoadingStatePage (copy), EmotesScrollView (copy)
	local v84 = if not FFlagEnableLeftNavOnConsole then p13.state.bottomBarHeight else not p13.props.isPortrait and 0 or p13.state.bottomBarHeight
	local fetchingStatus = p13.props.fetchingStatus
	local v86 = p13.props.fullView == FullView.UIFullView
	local v87 = p13.props.fullView == FullView.SceneFullView

	return withStyle(function(p14) -- line: 305
		-- upvalues: withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), Roact (copy), Focusable (copy), p13 (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), NavigationEventsLogger (copy), ExternalEventConnection (copy), UserInputService (copy), AvatarExperienceView (copy), v87 (copy), v86 (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), fetchingStatus (copy), LoadingStatePage (copy), EmotesScrollView (copy), v84 (copy)
		return withLocalization({
			failedMessage = not FFlagUpdateNoInternetConnectionText and "Feature.EmptyStatePage.Message.NoInternet" or "Feature.DisplayName.ErrorMessage.SomethingWentWrong"
		})(function(p15) -- line: 310
			-- upvalues: Roact (copy), Focusable (copy), p13 (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), NavigationEventsLogger (copy), ExternalEventConnection (copy), UserInputService (copy), AvatarExperienceView (copy), v87 (copy), v86 (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), fetchingStatus (copy), p14 (copy), LoadingStatePage (copy), EmotesScrollView (copy), v84 (copy)
			return Roact.createElement(Focusable.Frame, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				defaultChild = p13.emotesScrollViewRef,
				restorePreviousChildFocus = false,
				[Roact.Ref] = if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then p13.ref else p13.props.resolvedFocusNavigationRef
			}, {
				NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
					pageName = "ProfilePictureEditorEmotes"
				}),
				LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
					event = UserInputService.LastInputTypeChanged,
					callback = p13.lastInputTypeChangedCallback
				}),
				AvatarExperienceView = Roact.createElement(AvatarExperienceView, {
					bottomBarEnabled = false,
					allowAdaptiveScrolling = true,
					changeViewFunction = p13.changeView,
					isSceneFullView = v87,
					isUIFullView = v86,
					topBar = p13:renderTopBar(),
					[Roact.Ref] = p13.sceneUIContainerRef,
					NextSelectionDown = p13.emotesScrollViewRef
				}, {
					LoadingStateContainer = Roact.createElement(LoadingStateContainer, {
						dataStatus = RetrievalStatus2.fromRawValue(fetchingStatus),
						renderOnLoading = function() -- line: 339
							-- upvalues: Roact (copy), p14 (copy), LoadingStatePage (copy)
							return Roact.createElement("Frame", {
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = p14.Theme.BackgroundDefault.Transparency,
								BackgroundColor3 = p14.Theme.BackgroundDefault.Color
							}, Roact.createElement(LoadingStatePage))
						end,
						renderOnLoaded = function() -- line: 347
							-- upvalues: Roact (copy), EmotesScrollView (copy), p13 (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), v84 (copy)
							return Roact.createFragment({
								EmotesScrollView = Roact.createElement(EmotesScrollView, {
									baseRef = p13.emotesScrollViewRef,
									NextSelectionUp = if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then p13.topBarRef else p13.props.topBarRef,
									NextSelectionDown = p13.bottomBarRef,
									bottomBarHeight = v84
								}),
								BottomBar = p13.renderBottomBar()
							})
						end,
						renderOnFailed = function() -- line: 360
							-- upvalues: p13 (copy), p15 (copy)
							return p13:renderOnFailed(p15)
						end
					})
				})
			})
		end)
	end)
end
function v67.renderOnFailed(p16, p17) -- line: 370
	-- upvalues: Roact (copy), EmptyState (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy)
	return Roact.createElement(EmptyState, {
		NextSelectionUp = if not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then p16.topBarRef else p16.props.topBarRef,
		onActivated = p16.fetchPPEConfig,
		text = p17.failedMessage
	})
end
function v67.didMount(p18) -- line: 380
	-- upvalues: RetrievalStatus (copy)
	if p18.props.fetchingStatus == RetrievalStatus.NotStarted then
		p18.fetchPPEConfig()
	end
end

local v70 = RoactServices.connect({
	avatarExperienceAnalytics = Analytics,
	profilePictureEditorAnalytics = Analytics3,
	networking = RoactNetworking
})(v67)
local u71 = withStackVisibilityWrapper((RoactRodux.connect(function(p19, _) -- line: 392
	-- upvalues: Constants (copy), selectIsFullView (copy), AvatarScreen (copy), DeviceOrientationMode (copy), PerformFetch (copy)
	local PPEConfigFetchStatusKey = Constants.PPEConfigFetchStatusKey
	local v94 = selectIsFullView(p19, AvatarScreen.ProfilePictureEditorEmotes)
	local v95 = p19.DeviceOrientation == DeviceOrientationMode.Portrait
	local emoteAssetId = p19.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId

	return {
		fullView = v94,
		fetchingStatus = PerformFetch.GetStatus(p19, PPEConfigFetchStatusKey),
		itemDetailsExpanded = p19.AvatarExperience.Common.ItemDetailsExpanded,
		isPortrait = v95,
		emoteAssetId = emoteAssetId,
		tryOnItems = p19.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	}
end, function(p21) -- line: 407
	-- upvalues: FetchPPEConfig (copy), SetFullView (copy), OpenQuickMenu (copy), SetItemDetailsPeekViewState (copy)
	return {
		fetchPPEConfig = function(p22) -- line: 409
			-- upvalues: p21 (copy), FetchPPEConfig (copy)
			p21(FetchPPEConfig(p22))
		end,
		setFullView = function(p23, p24, p25) -- line: 412
			-- upvalues: p21 (copy), SetFullView (copy)
			p21(SetFullView(p23, p24, p25))
		end,
		navigateIntoQuickMenu = function(p26, p27) -- line: 415
			-- upvalues: p21 (copy), OpenQuickMenu (copy)
			p21(OpenQuickMenu(p26, p27))
		end,
		setItemDetailsPeekViewState = function(p28) -- line: 418
			-- upvalues: p21 (copy), SetItemDetailsPeekViewState (copy)
			p21(SetItemDetailsPeekViewState(p28))
		end
	}
end)(v70)))

local function ProfilePictureEditorEmotesPageContainer(p29) -- line: 426
	-- upvalues: useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation (copy), React (copy), useDispatch (copy), useAvatarRoute (copy), useRoactService (copy), RoactNetworking (copy), Analytics2 (copy), useFocusGuiObject (copy), NavigationUtils (copy), OpenItemPrompt (copy), AvatarScreen (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Cryo (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), Roact (copy), u71 (ref)
	local v99 = useOverlayClosedCallback()
	local v100 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v99
	})
	local v113

	if FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation then
		local v101 = React.useRef(nil)
		local v102 = useDispatch()
		local v103 = useAvatarRoute()
		local v104 = useRoactService(RoactNetworking)
		local v105 = useRoactService(Analytics2)
		local v106 = useFocusGuiObject()
		local v107 = React.useCallback(function() -- line: 442
			-- upvalues: v106 (copy), v101 (copy)
			if v106 and (v101 and v101.current) then
				v106(v101.current)
			end
		end, { v106 })
		local v108 = React.useCallback(function() -- line: 448
			-- upvalues: NavigationUtils (copy), p29 (copy)
			NavigationUtils.closeFocusedScreen(p29.navigation)
		end, { p29.navigation })
		local v109 = React.useCallback(function() -- line: 453
			-- upvalues: v102 (copy), OpenItemPrompt (copy), v104 (copy), v105 (copy), v99 (copy), p29 (copy), v103 (copy)
			v102(OpenItemPrompt(v104, v105, v99, p29.navigation, v103))
		end, {
			v102,
			v104,
			v105,
			v99,
			p29.navigation,
			v103
		})
		local v110 = React.useCallback(function() -- line: 469
			-- upvalues: p29 (copy), AvatarScreen (copy), v103 (copy), v99 (copy)
			p29.navigation.navigate(AvatarScreen.CatalogContextMenu, {
				itemId = v103.current.params.itemId,
				itemType = v103.current.params.itemType,
				onOverlayClosed = v99
			})
		end, {
			p29.navigation,
			v103,
			v99
		})
		local v111 = useFocusNavigationBindings(nil, if v103.current.name ~= AvatarScreen.ItemDetails then v107 else v108, if v103.current.name ~= AvatarScreen.ItemDetails then nil else v109, if v103.current.name ~= AvatarScreen.ItemDetails then nil else v110)
		local v112 = useTableWrappedCallbackRef(v111)

		v113 = Cryo.Dictionary.join(p29, {
			overlayClosedCallback = v99,
			is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole,
			topBarRef = v101,
			resolvedFocusNavigationRef = v112
		})
	else
		v113 = Cryo.Dictionary.join(p29, {
			overlayClosedCallback = v99,
			is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole
		})
	end

	return Roact.createElement("Frame", {
		[Roact.Ref] = v100,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, React.createElement(u71, v113))
end

return ProfilePictureEditorEmotesPageContainer

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ArgCheck = require(parent.ArgCheck)
local React = require(parent.React)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local RoactNavigation = require(parent.RoactNavigation)
local FocusBehaviors = require(parent.FocusBehaviors)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local EnumScreens = require(AppChat.EnumScreens)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local ChatDetailsTelemetryState = require(AppChat.Contexts.TelemetryState.ChatDetailsTelemetryState)
local TopBarProvider = require(AppChat.TopBarProvider)

local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local FFlagAppChatIxpParallelScreenLayers = require(AppChat.Flags.FFlagAppChatIxpParallelScreenLayers)

local FStringAppChatLandingConversationRowsIxpLayer = require(AppChat.Flags.FStringAppChatLandingConversationRowsIxpLayer)

local FStringAppChatLandingConversationListIxpLayer = require(AppChat.Flags.FStringAppChatLandingConversationListIxpLayer)
local FStringAppChatLandingPerformanceIxpLayer = require(AppChat.Flags.FStringAppChatLandingPerformanceIxpLayer)
local ChatLandingTopBar = require(AppChat.Components.TopBar.ChatLandingTopBar)
local conversationSwitchNavigator = require(AppChat.Navigators.Wide.conversationSwitchNavigator)
local ConversationStackNavigationFocusListener = require(script.Parent.ConversationStackNavigationFocusListener)

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local resetForSquadLobbyForWideMode = require(AppChat.Utils.resetForSquadLobbyForWideMode)
local ChatSearchBox = require(script.Parent.ChatSearchBox)
local ChatLandingSearchRow = require(AppChat.Components.TopBar.ChatLandingSearchRow)
local FFlagAppChatWideAlwaysVisibleSearchBox = require(AppChat.Flags.FFlagAppChatWideAlwaysVisibleSearchBox)
local FFlagAppChatFixInExpSearchRowLayoutOrder = require(AppChat.Flags.FFlagAppChatFixInExpSearchRowLayoutOrder)
local ChatLandingContainer = require(script.Parent.ChatLandingContainer)
local Logger = require(script.Parent.Logger)
local getCurrentRoute = require(script.Parent.Utils.getCurrentRoute)
local withStyle = UIBlox.Style.withStyle
local Provider = require(AppChat.Contexts.ChatPagePadding.Provider)
local Context = require(AppChat.Contexts.ChatWideModeFocus.Context)
local useGetAndSetRef = require(AppChat.Hooks.useGetAndSetRef)
local useIsChatSearchAllowed = require(AppChat.Hooks.useIsChatSearchAllowed)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatFoundationHeaderBar = require(AppChat.Flags.FFlagAppChatFoundationHeaderBar)

local function LeftContainerTelemetryProviders(p)
	local get, set = useGetAndSetRef({})
	local v = React.useCallback(function()
		local v = get()
		return {
			chatLandingListCount = v.chatLandingListCount,
			pendingConversationCount = v.pendingConversationCount,
			unfilteredConversationCount = v.unfilteredConversationCount,
			searchSessionId = v.searchSessionId,
			activeFilters = v.activeFilters
		}
	end, { get })
	local v2 = React.useMemo(function()
		return { get = get, set = set }
	end, { get, set })
	local v3

	if FFlagAppChatWideAlwaysVisibleSearchBox then
		v3 = useIsChatSearchAllowed()
	else
		v3 = false
	end

	local v4

	if p.renderChildren then
		v4 = p.renderChildren(v3)
	else
		v4 = p.children
	end

	return React.createElement(ChatLandingTelemetryState.Provider, { value = v2 }, {
		React.createElement(ChatLandingTelemetryLayer.Provider, { value = v }, v4)
	})
end

local function RightContainerTelemetryProviders(p)
	local get, set = useGetAndSetRef({})
	local v = React.useCallback(function()
		local v = get()
		return {
			conversationId = v.conversationId,
			moderationType = v.moderationType,
			userPendingStatus = v.userPendingStatus
		}
	end, { get })

	local _children = p.children

	local get2, set2 = useGetAndSetRef({})
	local v2 = React.useCallback(function()
		local v2 = get2()
		return { participantsCount = v2.participantsCount, isGroupOwner = v2.isGroupOwner }
	end, { get2, get })
	local v3 = React.useMemo(function()
		return { get = get2, set = set2 }
	end, { get2, set2 })
	local v4 = React.useMemo(function()
		return { get = get, set = set }
	end, { get, set })

	local element = React.createElement(
		ChatDetailsTelemetryState.Provider,
		{ value = v3 },
		React.createElement(ChatDetailsTelemetryLayer.Provider, { value = v2 }, p.children)
	)

	return React.createElement(ChatConversationTelemetryState.Provider, { value = v4 }, {
		React.createElement(ChatConversationTelemetryLayer.Provider, { value = v }, element)
	})
end

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePartyQuickStartButton = SharedFlags2.FFlagEnablePartyQuickStartButton

local extended = Roact.PureComponent:extend("ChatLandingScreenWithSwitchNavigator")
extended.router = conversationSwitchNavigator.router
extended.defaultProps = { navigation = nil }

function extended:init()
	local ixpSubscription

	if FFlagAppChatIxpScreenExposure then
		ixpSubscription = IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.LandingPage")
	end

	self.ixpSubscription = ixpSubscription
	local conversationRowsIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		conversationRowsIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatLandingConversationRowsIxpLayer
		)
	end

	self.conversationRowsIxpSubscription = conversationRowsIxpSubscription
	local conversationListIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		conversationListIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatLandingConversationListIxpLayer
		)
	end

	self.conversationListIxpSubscription = conversationListIxpSubscription
	local performanceIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		performanceIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatLandingPerformanceIxpLayer
		)
	end

	self.performanceIxpSubscription = performanceIxpSubscription

	function self.navigateToConversation(conversationId)
		Logger:info("Navigate To Conversation: {} from {screen}", conversationId)
		self.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = conversationId
		})
	end

	function self.navigateToCreateChat()
		Logger:info("Navigate To CreateNewChat from {screen}")
		self.props.navigation.navigate(EnumScreens.CreateNewChat)
	end

	function self.navigateToToast(p)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p)
	end

	function self.navigateToNotifications()
		local v = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Notifications]

		if not v then
			Logger:warning("Notifications page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To Notifications from {screen}")
		v()
	end

	function self.navigateToPrivacy()
		local v = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if not v then
			Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To PrivacySettings from {screen}")
		v()
	end

	function self.navigateToSquadLobby(conversationId)
		Logger:info("Navigate To SquadLobby from {screen}")
		local currentRoute = getCurrentRoute(self.props.navigation.state)

		if
			currentRoute
			and currentRoute.params
			and currentRoute.params.conversationId == conversationId
			and currentRoute.routeName == EnumScreens.ChatConversation
		then
			self.props.navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = conversationId
			})
		elseif FFlagEnablePartyQuickStartButton then
			resetForSquadLobbyForWideMode(self.props.navigation, conversationId)
		else
			self.props.navigation.navigate(EnumScreens.ChatLanding, nil, RoactNavigation.StackActions.reset({
				index = 2,
				actions = {
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.ChatConversation,
						params = { conversationId = conversationId }
					}),
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.SquadLobby,
						params = { conversationId = conversationId }
					})
				}
			}))
		end
	end

	function self.setScreenTopBar(p)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p)
	end
	self.leftContainerRef = Roact.createRef()
	self.rightContainerRef = Roact.createRef()
	self.conversationTopBarRef = Roact.createRef()
	self.conversationPanelRef = Roact.createRef()
	self.wideModeFocusValue = {
		conversationListRef = self.leftContainerRef,
		conversationTopBarRef = self.conversationTopBarRef,
		conversationPanelRef = self.conversationPanelRef
	}

	self.focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

function extended.render(data)
	Logger:info("{screen} render")
	local notNil = ArgCheck.isNotNil(data.props.navigation, "navigation in ChatLandingScreenWithSwitchNavigator")
	local v = notNil and notNil.getParam("key", "") or ""
	local screenProps = notNil.getScreenProps("showSearchRow", true)
	local screenProps2 = notNil.getScreenProps("topBarHeight", 0)
	local screenProps3 = notNil.getScreenProps("isInExperience", false)

	return withStyle(function(p)
		local function fn(flag: boolean)
			local v2 = FFlagAppChatWideAlwaysVisibleSearchBox and not screenProps3 and flag
			local v3 = screenProps or v2
			return {
				LeftContainer = Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p2)
						local screenTopBar = p2.getScreenTopBar(EnumScreens.ChatLanding)
						ArgCheck.isType(screenTopBar, "table", "screenTopBar")

						local shouldRenderCenter = screenTopBar.shouldRenderCenter or v3
						local filterBox

						if v3 then
							if v2 then
								filterBox = Roact.createElement(ChatLandingSearchRow, {
									hasExit = false,
									height = screenProps2,
									paddingHorizontal = notNil.getScreenProps("appChatOuterPadding", 12),
									LayoutOrder = 0,
									testId = "ChatInlineSearch",
									reportFocusAsSearchEntry = true
								})
							else
								filterBox = Roact.createElement(ChatSearchBox, {
									height = screenProps2,
									initialText = screenTopBar.filterText,
									onFilter = function(filterText)
										p2.setScreenTopBar(EnumScreens.ChatLanding, {
											filterText = filterText
										})
									end,
									layoutOrder = FFlagAppChatFixInExpSearchRowLayoutOrder and 0 or nil
								})
							end
						end

						local createElement = Roact.createElement
						local leftContainerRefsByRef = {
							["Size"] = UDim2.new(0.37, 0, 1, 0),
							Position = UDim2.new(0, 0, 0, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							SelectionGroup = FFlagAppChatConsoleFocusFixes and true or nil
						}
						local selectionBehaviorDown

						if FFlagAppChatConsoleFocusFixes then
							selectionBehaviorDown = Enum.SelectionBehavior.Stop
						end

						leftContainerRefsByRef.SelectionBehaviorDown = selectionBehaviorDown
						local selectionBehaviorUp

						if FFlagAppChatConsoleFocusFixes then
							selectionBehaviorUp = Enum.SelectionBehavior.Stop
						end

						leftContainerRefsByRef.SelectionBehaviorUp = selectionBehaviorUp

						leftContainerRefsByRef[Roact.Ref] = data.leftContainerRef
						return createElement("Frame", leftContainerRefsByRef, {
							layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							leftTopBar = Roact.createElement(ChatLandingTopBar, {
								screenName = EnumScreens.ChatLanding,
								navigation = notNil
							}),
							filterBox = filterBox,
							content = Roact.createElement(Provider, {
								value = {
									left = notNil.getScreenProps("appChatOuterPadding", 12),
									right = notNil.getScreenProps("appChatInnerPadding", 12)
								}
							}, {
								ChatLanding = Roact.createElement("Frame", {
									BorderSizePixel = 0,
									Size = UDim2.new(
										1,
										0,
										1,
										-notNil.getScreenProps("topBarHeight", 0) - (not v3 and 0 or screenProps2)
									),
									LayoutOrder = 2,
									BackgroundTransparency = p.Tokens.Color.None.Transparency
								}, { Roact.createElement(ChatLandingContainer, {
										isShowingFilterBox = shouldRenderCenter,
										filterText = screenTopBar.filterText,
										navigateToConversation = data.navigateToConversation,
										navigateToCreateChat = data.navigateToCreateChat,
										navigateToPrivacy = data.navigateToPrivacy,
										navigateToSquadLobby = data.navigateToSquadLobby,
										navigateToToast = data.navigateToToast,
										navigateToAddFriends = data.props.navigation.getScreenProps(
											"navigateToAddFriends",
											{}
										),
										key = "ChatLanding" .. v
									}) })
							})
						})
					end
				})
			}
		end

		local v2 = {
			LeftContainerProviders = Roact.createElement(LeftContainerTelemetryProviders, {
				renderChildren = fn
			}),
			Border = Roact.createElement("Frame", {
				BackgroundColor3 = p.Theme.Divider.Color,
				BackgroundTransparency = p.Theme.Divider.Transparency,
				BorderSizePixel = 0,
				Position = UDim2.new(0.37, 0, 0, 0),
				Size = UDim2.new(0, 1, 1, 0)
			}),
			RightContainerProviders = 0
		}

		local createElement = Roact.createElement
		local createElement2 = Roact.createElement
		local rightContainerRefsByRef = {
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.new(0.63, -1, 1, 0),
			Position = UDim2.new(0.37, 1, 0, 0),
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Ref] = data.rightContainerRef,
			SelectionGroup = FFlagAppChatConsoleFocusFixes and true or nil
		}
		local selectionBehaviorDown

		if FFlagAppChatConsoleFocusFixes then
			selectionBehaviorDown = Enum.SelectionBehavior.Stop
		end

		rightContainerRefsByRef.SelectionBehaviorDown = selectionBehaviorDown
		local selectionBehaviorUp

		if FFlagAppChatConsoleFocusFixes then
			selectionBehaviorUp = Enum.SelectionBehavior.Stop
		end

		rightContainerRefsByRef.SelectionBehaviorUp = selectionBehaviorUp

		local createElement3 = Roact.createElement
		local v3 = {
			value = {
				left = notNil.getScreenProps("appChatInnerPadding", 12),
				right = notNil.getScreenProps("appChatOuterPadding", 12)
			}
		}

		local createElement4 = Roact.createElement
		local v4 = { navigation = notNil, screenProps = 0 }
		local screenProps4

		if FFlagAppChatFoundationHeaderBar then
			screenProps4 = data.props.screenProps
		end

		v4.screenProps = screenProps4
		v2.RightContainerProviders = createElement(RightContainerTelemetryProviders, {}, {
			RightContainer = createElement2("Frame", rightContainerRefsByRef, {
				Content = createElement3(Provider, v3, {
					ConversationSwitchNavigator = createElement4(conversationSwitchNavigator, v4)
				})
			})
		})

		return React.createElement(Context.Provider, { value = data.wideModeFocusValue }, {
			FocusListener = Roact.createElement(ConversationStackNavigationFocusListener, {
				navigation = notNil,
				leftContainerRef = data.leftContainerRef,
				rightContainerRef = data.rightContainerRef,
				conversationTopBarRef = data.conversationTopBarRef,
				conversationPanelRef = data.conversationPanelRef
			}, v2)
		})
	end)
end

function extended.didMount(data)
	Logger:info("{screen} mounted")

	local navigation = data.props.navigation
	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)
	local screenProps2 = navigation.getScreenProps("isInExperience", false)

	local v = GetFFlagEnableAppChatInExperience() and screenProps2
	local screenProps3 = navigation.getScreenProps("appChatInnerPadding", 12)

	if SharedFlags.FFlagEnableHeaderBarButtonsUpdate then
		screenProps3 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local headerText = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and { raw = "CommonUI.Features.Label.Chat", shouldLocalize = true }
		or { raw = "Feature.Squads.Label.Party", shouldLocalize = true }

	data.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = "",
		headerText = headerText,
		backButtonEnabled = false,
		closeButtonEnabled = v and (screenProps and true or false),
		isRoot = true,
		isTitleLeftAligned = true,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = screenProps3,
		shouldBoldHeader = true
	})

	if data.focusNavigationService then
		data.focusNavigationService:registerFocusBehavior(data.leftContainerRef.current, FocusBehaviors.mostRecent())
		data.focusNavigationService:registerFocusBehavior(data.rightContainerRef.current, FocusBehaviors.mostRecent())
	end
end

function extended.willUnmount(data)
	if data.ixpSubscription then
		data.ixpSubscription.remove()
	end

	if data.conversationRowsIxpSubscription then
		data.conversationRowsIxpSubscription.remove()
	end

	if data.conversationListIxpSubscription then
		data.conversationListIxpSubscription.remove()
	end

	if data.performanceIxpSubscription then
		data.performanceIxpSubscription.remove()
	end

	data.focusNavigationService:teardown()
end

return extended

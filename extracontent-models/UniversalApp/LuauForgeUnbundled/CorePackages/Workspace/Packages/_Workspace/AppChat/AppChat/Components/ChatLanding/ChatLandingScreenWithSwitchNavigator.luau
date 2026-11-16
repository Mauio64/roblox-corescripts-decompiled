local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local FocusBehaviors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusBehaviors")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
local ChatLandingTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatLandingTelemetryState")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local ChatConversationTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatConversationTelemetryState")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ChatDetailsTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatDetailsTelemetryState")
local TopBarProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/TopBarProvider")

local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")
local FFlagAppChatIxpParallelScreenLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpParallelScreenLayers")

local FStringAppChatLandingConversationRowsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatLandingConversationRowsIxpLayer")

local FStringAppChatLandingConversationListIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatLandingConversationListIxpLayer")
local FStringAppChatLandingPerformanceIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatLandingPerformanceIxpLayer")
local ChatLandingTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatLandingTopBar")
local conversationSwitchNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/conversationSwitchNavigator")
local ConversationStackNavigationFocusListener = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationStackNavigationFocusListener")

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")
local resetForSquadLobbyForWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/resetForSquadLobbyForWideMode")
local ChatSearchBox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatSearchBox")
local ChatLandingSearchRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatLandingSearchRow")
local FFlagAppChatWideAlwaysVisibleSearchBox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatWideAlwaysVisibleSearchBox")
local module31 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger")
local getCurrentRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getCurrentRoute")
local withStyle = UIBlox.Style.withStyle
local Provider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/Provider")
local Context = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatWideModeFocus/Context")
local useGetAndSetRef = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetAndSetRef")
local useIsChatSearchAllowed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatSearchAllowed")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local getFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience

local defineFastFlag = game:DefineFastFlag("AppChatFixChatLandingContainerKeyPropConflict", false)
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")

local function LeftContainerTelemetryProviders(p2)
	local v5, v6 = useGetAndSetRef({})
	local v7 = React.useCallback(function()
		local v8 = v5()
		return {
			chatLandingListCount = v8.chatLandingListCount,
			pendingConversationCount = v8.pendingConversationCount,
			unfilteredConversationCount = v8.unfilteredConversationCount,
			searchSessionId = v8.searchSessionId,
			activeFilters = v8.activeFilters
		}
	end, { v5 })
	local v8 = React.useMemo(function()
		return { get = v5, set = v6 }
	end, { v5, v6 })

	local v9 = if FFlagAppChatWideAlwaysVisibleSearchBox then useIsChatSearchAllowed() else false

	local v10 = if p2.renderChildren then p2.renderChildren(v9) else p2.children

	return React.createElement(ChatLandingTelemetryState.Provider, { value = v8 }, {
		React.createElement(ChatLandingTelemetryLayer.Provider, { value = v7 }, v10)
	})
end

local function RightContainerTelemetryProviders(p2)
	local v5, v6 = useGetAndSetRef({})
	local v7 = React.useCallback(function()
		local v8 = v5()
		return {
			conversationId = v8.conversationId,
			moderationType = v8.moderationType,
			userPendingStatus = v8.userPendingStatus
		}
	end, { v5 })

	local children = p2.children

	local v8, v9 = useGetAndSetRef({})
	local v10 = React.useCallback(function()
		local v11 = v8()
		return {
			participantsCount = v11.participantsCount,
			isGroupOwner = v11.isGroupOwner
		}
	end, { v8, v5 })
	local v11 = React.useMemo(function()
		return { get = v8, set = v9 }
	end, { v8, v9 })
	local v12 = React.useMemo(function()
		return { get = v5, set = v6 }
	end, { v5, v6 })

	local element = React.createElement(
		ChatDetailsTelemetryState.Provider,
		{ value = v11 },
		React.createElement(ChatDetailsTelemetryLayer.Provider, { value = v10 }, p2.children)
	)

	return React.createElement(ChatConversationTelemetryState.Provider, { value = v12 }, {
		React.createElement(ChatConversationTelemetryLayer.Provider, { value = v7 }, element)
	})
end

local fFlagEnablePartyQuickStartButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnablePartyQuickStartButton

local extended = Roact.PureComponent:extend("ChatLandingScreenWithSwitchNavigator")
extended.router = conversationSwitchNavigator.router
extended.defaultProps = { navigation = nil }

function extended:init()
	local v5 = if FFlagAppChatIxpScreenExposure then IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.LandingPage") else nil
	self.ixpSubscription = v5

	local v6 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatLandingConversationRowsIxpLayer
	) else nil
	self.conversationRowsIxpSubscription = v6

	local v7 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatLandingConversationListIxpLayer
	) else nil
	self.conversationListIxpSubscription = v7

	local v8 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatLandingPerformanceIxpLayer
	) else nil
	self.performanceIxpSubscription = v8

	function self.navigateToConversation(p2)
		Logger:info("Navigate To Conversation: {} from {screen}", p2)
		self.props.navigation.navigate(EnumScreens.ChatConversation, { conversationId = p2 })
	end

	function self.navigateToCreateChat()
		Logger:info("Navigate To CreateNewChat from {screen}")
		self.props.navigation.navigate(EnumScreens.CreateNewChat)
	end

	function self.navigateToToast(p2)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p2)
	end

	function self.navigateToNotifications()
		local v9 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Notifications]

		if not v9 then
			Logger:warning("Notifications page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To Notifications from {screen}")
		v9()
	end

	function self.navigateToPrivacy()
		local v9 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if not v9 then
			Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To PrivacySettings from {screen}")
		v9()
	end

	function self.navigateToSquadLobby(p2)
		Logger:info("Navigate To SquadLobby from {screen}")
		local v9 = getCurrentRoute(self.props.navigation.state)

		if
			v9
			and v9.params
			and v9.params.conversationId == p2
			and v9.routeName == EnumScreens.ChatConversation
		then
			self.props.navigation.navigate(EnumScreens.SquadLobby, { conversationId = p2 })
		elseif fFlagEnablePartyQuickStartButton then
			resetForSquadLobbyForWideMode(self.props.navigation, p2)
		else
			self.props.navigation.navigate(EnumScreens.ChatLanding, nil, RoactNavigation.StackActions.reset({
				index = 2,
				actions = {
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.ChatConversation,
						params = { conversationId = p2 }
					}),
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.SquadLobby,
						params = { conversationId = p2 }
					})
				}
			}))
		end
	end

	function self.setScreenTopBar(p2)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p2)
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
	local notNil = ArgCheck.isNotNil(
		data.props.navigation,
		"navigation in ChatLandingScreenWithSwitchNavigator"
	)
	local v5 = notNil and notNil.getParam("key", "") or ""
	local screenProps = notNil.getScreenProps("showSearchRow", true)
	local screenProps2 = notNil.getScreenProps("topBarHeight", 0)
	local screenProps3 = notNil.getScreenProps("isInExperience", false)

	return withStyle(function(p2)
		local function fn(p3)
			local v6 = FFlagAppChatWideAlwaysVisibleSearchBox and not screenProps3 and p3
			local v7 = screenProps or v6
			return {
				LeftContainer = Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p4)
						local screenTopBar = p4.getScreenTopBar(EnumScreens.ChatLanding)
						ArgCheck.isType(screenTopBar, "table", "screenTopBar")

						local shouldRenderCenter = screenTopBar.shouldRenderCenter or v7
						local v8

						if v7 then
							if v6 then
								v8 = Roact.createElement(ChatLandingSearchRow, {
									hasExit = false,
									height = screenProps2,
									paddingHorizontal = notNil.getScreenProps("appChatOuterPadding", 12),
									LayoutOrder = 0,
									testId = "ChatInlineSearch",
									reportFocusAsSearchEntry = true
								})
							else
								v8 = Roact.createElement(ChatSearchBox, {
									height = screenProps2,
									initialText = screenTopBar.filterText,
									onFilter = function(p5)
										p4.setScreenTopBar(EnumScreens.ChatLanding, {
											filterText = p5
										})
									end
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

						local v10 = if FFlagAppChatConsoleFocusFixes then Enum.SelectionBehavior.Stop else nil
						leftContainerRefsByRef.SelectionBehaviorDown = v10

						local v11 = if FFlagAppChatConsoleFocusFixes then Enum.SelectionBehavior.Stop else nil
						leftContainerRefsByRef.SelectionBehaviorUp = v11

						leftContainerRefsByRef[Roact.Ref] = data.leftContainerRef
						local v12 = {
							layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							leftTopBar = Roact.createElement(ChatLandingTopBar, {
								screenName = EnumScreens.ChatLanding,
								navigation = notNil
							}),
							filterBox = v8,
							content = 0
						}

						local createElement2 = Roact.createElement
						local v14 = {
							value = {
								left = notNil.getScreenProps("appChatOuterPadding", 12),
								right = notNil.getScreenProps("appChatInnerPadding", 12)
							}
						}

						local createElement3 = Roact.createElement
						local v17 = {
							BorderSizePixel = 0,
							Size = UDim2.new(
								1,
								0,
								1,
								-notNil.getScreenProps("topBarHeight", 0) - (not v7 and 0 or screenProps2)
							),
							LayoutOrder = 2,
							BackgroundTransparency = p2.Tokens.Color.None.Transparency
						}

						local v19 = if not defineFastFlag then Roact.createElement(module31, {
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
							key = "ChatLanding" .. v5
						}) else nil
						v12.content = createElement2(Provider, v14, {
							ChatLanding = createElement3("Frame", v17, {
								ChatLandingContainer = v19,
								if defineFastFlag then Roact.createElement(module31, {
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
									key = "ChatLanding" .. v5
								}) else nil
							})
						})
						return createElement("Frame", leftContainerRefsByRef, v12)
					end
				})
			}
		end

		local v6 = {
			LeftContainerProviders = Roact.createElement(LeftContainerTelemetryProviders, {
				renderChildren = fn
			}),
			Border = Roact.createElement("Frame", {
				BackgroundColor3 = p2.Theme.Divider.Color,
				BackgroundTransparency = p2.Theme.Divider.Transparency,
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

		local v11 = if FFlagAppChatConsoleFocusFixes then Enum.SelectionBehavior.Stop else nil
		rightContainerRefsByRef.SelectionBehaviorDown = v11
		local v12 = if FFlagAppChatConsoleFocusFixes then Enum.SelectionBehavior.Stop else nil
		rightContainerRefsByRef.SelectionBehaviorUp = v12
		v6.RightContainerProviders = createElement(RightContainerTelemetryProviders, {}, {
			RightContainer = createElement2("Frame", rightContainerRefsByRef, {
				Content = Roact.createElement(Provider, {
					value = {
						left = notNil.getScreenProps("appChatInnerPadding", 12),
						right = notNil.getScreenProps("appChatOuterPadding", 12)
					}
				}, {
					ConversationSwitchNavigator = Roact.createElement(conversationSwitchNavigator, {
						navigation = notNil
					})
				})
			})
		})

		return React.createElement(Context.Provider, {
			value = data.wideModeFocusValue
		}, {
			FocusListener = Roact.createElement(ConversationStackNavigationFocusListener, {
				navigation = notNil,
				leftContainerRef = data.leftContainerRef,
				rightContainerRef = data.rightContainerRef,
				conversationTopBarRef = data.conversationTopBarRef,
				conversationPanelRef = data.conversationPanelRef
			}, v6)
		})
	end)
end

function extended.didMount(data)
	Logger:info("{screen} mounted")

	local navigation = data.props.navigation
	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)
	local screenProps2 = navigation.getScreenProps("isInExperience", false)

	local v6 = getFFlagEnableAppChatInExperience() and screenProps2
	local screenProps3 = navigation.getScreenProps("appChatInnerPadding", 12)

	if SharedFlags.FFlagEnableHeaderBarButtonsUpdate then
		screenProps3 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local v7 = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and { raw = "CommonUI.Features.Label.Chat", shouldLocalize = true }
		or { raw = "Feature.Squads.Label.Party", shouldLocalize = true }

	data.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = "",
		headerText = v7,
		backButtonEnabled = false,
		closeButtonEnabled = v6 and (screenProps and true or false),
		isRoot = true,
		isTitleLeftAligned = true,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = screenProps3,
		shouldBoldHeader = true
	})

	if data.focusNavigationService then
		data.focusNavigationService:registerFocusBehavior(
			data.leftContainerRef.current,
			FocusBehaviors.mostRecent()
		)
		data.focusNavigationService:registerFocusBehavior(
			data.rightContainerRef.current,
			FocusBehaviors.mostRecent()
		)
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

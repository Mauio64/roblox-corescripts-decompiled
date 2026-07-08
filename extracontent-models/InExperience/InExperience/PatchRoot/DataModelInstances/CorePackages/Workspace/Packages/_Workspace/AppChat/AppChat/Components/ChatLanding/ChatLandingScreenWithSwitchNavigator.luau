local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ArgCheck = require(AppChatParent.ArgCheck)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local UIBlox = require(AppChatParent.UIBlox)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local FocusBehaviors = require(AppChatParent.FocusBehaviors)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local EnumScreens = require(AppChat.EnumScreens)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local ChatDetailsTelemetryState = require(AppChat.Contexts.TelemetryState.ChatDetailsTelemetryState)
local TopBarProvider = require(AppChat.TopBarProvider)
local createChatTopBar = require(AppChat.createChatTopBar)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ChatLandingTopBar = require(AppChat.Components.TopBar.ChatLandingTopBar)
local conversationSwitchNavigator = require(AppChat.Navigators.Wide.conversationSwitchNavigator)
local ConversationStackNavigationFocusListener = require(script.Parent.ConversationStackNavigationFocusListener)
local resetForSquadLobbyForWideMode = require(AppChat.Utils.resetForSquadLobbyForWideMode)
local ChatLandingScreen = require(script.Parent.ChatLandingScreen)
local ChatSearchBox = require(script.Parent.ChatSearchBox)
local ChatLandingContainer = require(script.Parent.ChatLandingContainer)
local Logger = require(script.Parent.Logger)
local getCurrentRoute = require(script.Parent.Utils.getCurrentRoute)
local withStyle = UIBlox.Style.withStyle
local Provider = require(AppChat.Contexts.ChatPagePadding.Provider)
local useGetAndSetRef = require(AppChat.Hooks.useGetAndSetRef)
local SharedFlags = require(AppChatParent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience
local v39 = game:DefineFastFlag("AppChatFixChatLandingContainerKeyPropConflict", false)
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation

local function LeftContainerTelemetryProviders(t1: {[any]: any}) -- line: 52
	-- upvalues: useGetAndSetRef (copy), React (copy), ChatLandingTelemetryState (copy), ChatLandingTelemetryLayer (copy)
	local v46, v47 = useGetAndSetRef({})
	local v48 = React.useCallback(function() -- line: 55
		-- upvalues: v46 (copy)
		local v72 = v46()

		return {
			chatLandingListCount = v72.chatLandingListCount,
			pendingConversationCount = v72.pendingConversationCount,
			unfilteredConversationCount = v72.unfilteredConversationCount
		}
	end, { v46 })

	return React.createElement(ChatLandingTelemetryState.Provider, {
		value = {
			get = v46,
			set = v47
		}
	}, { React.createElement(ChatLandingTelemetryLayer.Provider, {
		value = v48
	}, t1.children) })
end
local function RightContainerTelemetryProviders(t2: {[any]: any}) -- line: 79
	-- upvalues: useGetAndSetRef (copy), React (copy), ChatDetailsTelemetryState (copy), ChatDetailsTelemetryLayer (copy), ChatConversationTelemetryState (copy), ChatConversationTelemetryLayer (copy)
	local v50, v51 = useGetAndSetRef({})
	local v52 = React.useCallback(function() -- line: 82
		-- upvalues: v50 (copy)
		local v73 = v50()

		return {
			conversationId = v73.conversationId,
			moderationType = v73.moderationType,
			userPendingStatus = v73.userPendingStatus
		}
	end, { v50 })
	local _ = t2.children
	local v54, v55 = useGetAndSetRef({})
	local v56 = React.useCallback(function() -- line: 94
		-- upvalues: v54 (copy)
		local v74 = v54()

		return {
			participantsCount = v74.participantsCount,
			isGroupOwner = v74.isGroupOwner
		}
	end, {
		v54,
		v50
	})
	local v57 = React.createElement(ChatDetailsTelemetryState.Provider, {
		value = {
			get = v54,
			set = v55
		}
	}, React.createElement(ChatDetailsTelemetryLayer.Provider, {
		value = v56
	}, t2.children))

	return React.createElement(ChatConversationTelemetryState.Provider, {
		value = {
			get = v50,
			set = v51
		}
	}, { React.createElement(ChatConversationTelemetryLayer.Provider, {
		value = v52
	}, v57) })
end

local FFlagEnablePartyQuickStartButton = require(AppChatParent.SharedFlags).FFlagEnablePartyQuickStartButton
local v44 = Roact.PureComponent:extend("ChatLandingScreenWithSwitchNavigator")

v44.router = conversationSwitchNavigator.router
v44.defaultProps = {
	navigation = nil
}

function v44.init(p1) -- line: 138
	-- upvalues: Logger (copy), EnumScreens (copy), getCurrentRoute (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForWideMode (copy), RoactNavigation (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ArgCheck (copy), Roact (copy), ReactFocusNavigation (copy)
	function p1.navigateToConversation(p2) -- line: 139
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p2)
		p1.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p2
		})
	end
	function p1.navigateToCreateChat() -- line: 144
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To CreateNewChat from {screen}")
		p1.props.navigation.navigate(EnumScreens.CreateNewChat)
	end
	function p1.navigateToToast(p3) -- line: 149
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p1.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end
	function p1.navigateToNotifications() -- line: 154
		-- upvalues: p1 (copy), EnumScreens (copy), Logger (copy)
		local v77 = p1.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Notifications]

		if v77 then
			Logger:info("Navigate To Notifications from {screen}")
			v77()

			return
		end

		Logger:warning("Notifications page was not set in navigateToLuaAppPages screenProps")
	end
	function p1.navigateToPrivacy() -- line: 165
		-- upvalues: p1 (copy), EnumScreens (copy), Logger (copy)
		local v78 = p1.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if v78 then
			Logger:info("Navigate To PrivacySettings from {screen}")
			v78()

			return
		end

		Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")
	end
	function p1.navigateToSquadLobby(p4) -- line: 176
		-- upvalues: Logger (copy), getCurrentRoute (copy), p1 (copy), EnumScreens (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForWideMode (copy), RoactNavigation (copy)
		Logger:info("Navigate To SquadLobby from {screen}")

		local v80 = getCurrentRoute(p1.props.navigation.state)

		if v80 and (v80.params and p4 == v80.params.conversationId and v80.routeName == EnumScreens.ChatConversation) then
			p1.props.navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = p4
			})

			return
		end

		if FFlagEnablePartyQuickStartButton then
			resetForSquadLobbyForWideMode(p1.props.navigation, p4)

			return
		end

		p1.props.navigation.navigate(EnumScreens.ChatLanding, nil, RoactNavigation.StackActions.reset({
			index = 2,
			actions = {
				RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatConversation,
					params = {
						conversationId = p4
					}
				}),
				RoactNavigation.Actions.navigate({
					routeName = EnumScreens.SquadLobby,
					params = {
						conversationId = p4
					}
				})
			}
		}))
	end
	function p1.setScreenTopBar(p5) -- line: 213
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p1 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p5)

			return
		end

		local v82 = p1.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v82, "setScreenTopBar in screenProps")
		v82(EnumScreens.ChatLanding, p5)
	end

	p1.leftContainerRef = Roact.createRef()
	p1.rightContainerRef = Roact.createRef()
	p1.focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end
function v44.render(p6) -- line: 228
	-- upvalues: Logger (copy), ArgCheck (copy), withStyle (copy), Roact (copy), LeftContainerTelemetryProviders (copy), TopBarProvider (copy), EnumScreens (copy), FFlagAppChatTopBarConfigDriven (copy), ChatLandingTopBar (copy), createChatTopBar (copy), Cryo (copy), ChatLandingScreen (copy), ChatSearchBox (copy), Provider (copy), v39 (copy), ChatLandingContainer (copy), RightContainerTelemetryProviders (copy), conversationSwitchNavigator (copy), ConversationStackNavigationFocusListener (copy)
	Logger:info("{screen} render")

	local v60 = ArgCheck.isNotNil(p6.props.navigation, "navigation in ChatLandingScreenWithSwitchNavigator")
	local v61 = v60 and v60.getParam("key", "") or ""
	local v62 = v60.getScreenProps("showSearchRow", true)
	local v63 = v60.getScreenProps("topBarHeight", 0)

	return withStyle(function(p7) -- line: 235
		-- upvalues: Roact (copy), LeftContainerTelemetryProviders (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), p6 (copy), FFlagAppChatTopBarConfigDriven (copy), ChatLandingTopBar (copy), v60 (copy), createChatTopBar (copy), Cryo (copy), ChatLandingScreen (copy), v62 (copy), ChatSearchBox (copy), v63 (copy), Provider (copy), v39 (copy), ChatLandingContainer (copy), v61 (copy), RightContainerTelemetryProviders (copy), conversationSwitchNavigator (copy), ConversationStackNavigationFocusListener (copy)
		local t3 = {
			LeftContainerProviders = Roact.createElement(LeftContainerTelemetryProviders, {}, {
				LeftContainer = Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p8) -- line: 240
						-- upvalues: EnumScreens (copy), ArgCheck (copy), Roact (copy), p6 (copy), FFlagAppChatTopBarConfigDriven (copy), ChatLandingTopBar (copy), v60 (copy), createChatTopBar (copy), Cryo (copy), ChatLandingScreen (copy), v62 (copy), ChatSearchBox (copy), v63 (copy), Provider (copy), p7 (copy), v39 (copy), ChatLandingContainer (copy), v61 (copy)
						local v86 = p8.getScreenTopBar(EnumScreens.ChatLanding)

						ArgCheck.isType(v86, "table", "screenTopBar")

						return Roact.createElement("Frame", {
							Size = UDim2.new(0.37, 0, 1, 0),
							Position = UDim2.new(0, 0, 0, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							[Roact.Ref] = p6.leftContainerRef
						}, {
							layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							leftTopBar = if not FFlagAppChatTopBarConfigDriven() then createChatTopBar(Cryo.Dictionary.join(v86, {
								navigation = v60
							}, ChatLandingScreen.navigationOptions({
								screenProps = nil,
								navigationOptions = nil,
								navigation = v60
							}), {
								backButtonEnabled = false,
								shouldBoldHeader = true
							})) else Roact.createElement(ChatLandingTopBar, {
								screenName = EnumScreens.ChatLanding,
								navigation = v60
							}),
							filterBox = if not v62 then nil else Roact.createElement(ChatSearchBox, {
								height = v63,
								initialText = v86.filterText,
								onFilter = function(p9) -- line: 278
									-- upvalues: p8 (copy), EnumScreens (copy)
									p8.setScreenTopBar(EnumScreens.ChatLanding, {
										filterText = p9
									})
								end
							}),
							content = Roact.createElement(Provider, {
								value = {
									left = v60.getScreenProps("appChatOuterPadding", 12),
									right = v60.getScreenProps("appChatInnerPadding", 12)
								}
							}, {
								ChatLanding = Roact.createElement("Frame", {
									BorderSizePixel = 0,
									LayoutOrder = 2,
									Size = UDim2.new(1, 0, 1, -v60.getScreenProps("topBarHeight", 0) - (not v62 and 0 or v63)),
									BackgroundTransparency = p7.Tokens.Color.None.Transparency
								}, {
									ChatLandingContainer = if not v39 then Roact.createElement(ChatLandingContainer, {
										isShowingFilterBox = v86.shouldRenderCenter,
										filterText = v86.filterText,
										navigateToConversation = p6.navigateToConversation,
										navigateToCreateChat = p6.navigateToCreateChat,
										navigateToPrivacy = p6.navigateToPrivacy,
										navigateToSquadLobby = p6.navigateToSquadLobby,
										navigateToToast = p6.navigateToToast,
										navigateToAddFriends = p6.props.navigation.getScreenProps("navigateToAddFriends", {}),
										key = "ChatLanding" .. v61
									}) else nil,
									if not v39 then nil else Roact.createElement(ChatLandingContainer, {
										isShowingFilterBox = v86.shouldRenderCenter,
										filterText = v86.filterText,
										navigateToConversation = p6.navigateToConversation,
										navigateToCreateChat = p6.navigateToCreateChat,
										navigateToPrivacy = p6.navigateToPrivacy,
										navigateToSquadLobby = p6.navigateToSquadLobby,
										navigateToToast = p6.navigateToToast,
										navigateToAddFriends = p6.props.navigation.getScreenProps("navigateToAddFriends", {}),
										key = "ChatLanding" .. v61
									})
								})
							})
						})
					end
				})
			}),
			Border = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = p7.Theme.Divider.Color,
				BackgroundTransparency = p7.Theme.Divider.Transparency,
				Position = UDim2.new(0.37, 0, 0, 0),
				Size = UDim2.new(0, 1, 1, 0)
			}),
			RightContainerProviders = Roact.createElement(RightContainerTelemetryProviders, {}, {
				RightContainer = Roact.createElement("Frame", {
					Size = UDim2.new(0.63, -1, 1, 0),
					Position = UDim2.new(0.37, 1, 0, 0),
					ClipsDescendants = true,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[Roact.Ref] = p6.rightContainerRef
				}, {
					Content = Roact.createElement(Provider, {
						value = {
							left = v60.getScreenProps("appChatInnerPadding", 12),
							right = v60.getScreenProps("appChatOuterPadding", 12)
						}
					}, {
						ConversationSwitchNavigator = Roact.createElement(conversationSwitchNavigator, {
							navigation = v60
						})
					})
				})
			})
		}

		return Roact.createElement(ConversationStackNavigationFocusListener, {
			navigation = v60,
			leftContainerRef = p6.leftContainerRef,
			rightContainerRef = p6.rightContainerRef
		}, t3)
	end)
end
function v44.didMount(p10) -- line: 378
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagEnableAppChatInExperience (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy), FocusBehaviors (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p10.props.navigation
		local v66 = navigation.getScreenProps("navigateToRootStack", nil)
		local v67 = navigation.getScreenProps("isInExperience", false)
		local v68 = GetFFlagEnableAppChatInExperience() and v67
		local v69 = navigation.getScreenProps("appChatInnerPadding", 12)
		local v70 = if not ArgoPartyExperimentation.getIsRenameEnabled() then if not GetFFlagIsSquadEnabled() then {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} else {
			raw = "Feature.Squads.Label.Party",
			shouldLocalize = true
		} else if not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() then {
			raw = "Feature.Squads.Label.Party",
			shouldLocalize = true
		} else {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		}

		p10.setScreenTopBar({
			shouldRenderCenter = false,
			filterText = "",
			backButtonEnabled = false,
			isRoot = true,
			isTitleLeftAligned = true,
			shouldBoldHeader = true,
			headerText = v70,
			closeButtonEnabled = v68 and not not v66,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v69
		})
	else
		p10.setScreenTopBar({
			shouldRenderCenter = false,
			filterText = ""
		})
	end

	if p10.focusNavigationService then
		p10.focusNavigationService:registerFocusBehavior(p10.leftContainerRef.current, FocusBehaviors.mostRecent())
		p10.focusNavigationService:registerFocusBehavior(p10.rightContainerRef.current, FocusBehaviors.mostRecent())
	end
end
function v44.willUnmount(p11) -- line: 434
	p11.focusNavigationService:teardown()
end

return v44

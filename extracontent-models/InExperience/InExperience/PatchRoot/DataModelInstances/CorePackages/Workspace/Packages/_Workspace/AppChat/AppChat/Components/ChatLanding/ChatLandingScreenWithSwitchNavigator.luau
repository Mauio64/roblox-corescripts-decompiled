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
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local ChatLandingTopBar = require(AppChat.Components.TopBar.ChatLandingTopBar)
local conversationSwitchNavigator = require(AppChat.Navigators.Wide.conversationSwitchNavigator)
local ConversationStackNavigationFocusListener = require(script.Parent.ConversationStackNavigationFocusListener)
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
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
local v41 = game:DefineFastFlag("AppChatFixChatLandingContainerKeyPropConflict", false)
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation

local function LeftContainerTelemetryProviders(t1: {[any]: any}) -- line: 54
	-- upvalues: useGetAndSetRef (copy), React (copy), ChatLandingTelemetryState (copy), ChatLandingTelemetryLayer (copy)
	local v48, v49 = useGetAndSetRef({})
	local v50 = React.useCallback(function() -- line: 57
		-- upvalues: v48 (copy)
		local v74 = v48()

		return {
			chatLandingListCount = v74.chatLandingListCount,
			pendingConversationCount = v74.pendingConversationCount,
			unfilteredConversationCount = v74.unfilteredConversationCount
		}
	end, { v48 })

	return React.createElement(ChatLandingTelemetryState.Provider, {
		value = {
			get = v48,
			set = v49
		}
	}, { React.createElement(ChatLandingTelemetryLayer.Provider, {
		value = v50
	}, t1.children) })
end
local function RightContainerTelemetryProviders(t2: {[any]: any}) -- line: 81
	-- upvalues: useGetAndSetRef (copy), React (copy), ChatDetailsTelemetryState (copy), ChatDetailsTelemetryLayer (copy), ChatConversationTelemetryState (copy), ChatConversationTelemetryLayer (copy)
	local v52, v53 = useGetAndSetRef({})
	local v54 = React.useCallback(function() -- line: 84
		-- upvalues: v52 (copy)
		local v75 = v52()

		return {
			conversationId = v75.conversationId,
			moderationType = v75.moderationType,
			userPendingStatus = v75.userPendingStatus
		}
	end, { v52 })
	local _ = t2.children
	local v56, v57 = useGetAndSetRef({})
	local v58 = React.useCallback(function() -- line: 96
		-- upvalues: v56 (copy)
		local v76 = v56()

		return {
			participantsCount = v76.participantsCount,
			isGroupOwner = v76.isGroupOwner
		}
	end, {
		v56,
		v52
	})
	local v59 = React.createElement(ChatDetailsTelemetryState.Provider, {
		value = {
			get = v56,
			set = v57
		}
	}, React.createElement(ChatDetailsTelemetryLayer.Provider, {
		value = v58
	}, t2.children))

	return React.createElement(ChatConversationTelemetryState.Provider, {
		value = {
			get = v52,
			set = v53
		}
	}, { React.createElement(ChatConversationTelemetryLayer.Provider, {
		value = v54
	}, v59) })
end

local FFlagEnablePartyQuickStartButton = require(AppChatParent.SharedFlags).FFlagEnablePartyQuickStartButton
local v46 = Roact.PureComponent:extend("ChatLandingScreenWithSwitchNavigator")

v46.router = conversationSwitchNavigator.router
v46.defaultProps = {
	navigation = nil
}

function v46.init(p1) -- line: 140
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), Logger (copy), EnumScreens (copy), getCurrentRoute (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForWideMode (copy), RoactNavigation (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ArgCheck (copy), Roact (copy), ReactFocusNavigation (copy)
	p1.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p1.props.navigation, "Party.LandingPage")

	function p1.navigateToConversation(p2) -- line: 145
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p2)
		p1.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p2
		})
	end
	function p1.navigateToCreateChat() -- line: 150
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To CreateNewChat from {screen}")
		p1.props.navigation.navigate(EnumScreens.CreateNewChat)
	end
	function p1.navigateToToast(p3) -- line: 155
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p1.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end
	function p1.navigateToNotifications() -- line: 160
		-- upvalues: p1 (copy), EnumScreens (copy), Logger (copy)
		local v79 = p1.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Notifications]

		if v79 then
			Logger:info("Navigate To Notifications from {screen}")
			v79()

			return
		end

		Logger:warning("Notifications page was not set in navigateToLuaAppPages screenProps")
	end
	function p1.navigateToPrivacy() -- line: 171
		-- upvalues: p1 (copy), EnumScreens (copy), Logger (copy)
		local v80 = p1.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if v80 then
			Logger:info("Navigate To PrivacySettings from {screen}")
			v80()

			return
		end

		Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")
	end
	function p1.navigateToSquadLobby(p4) -- line: 182
		-- upvalues: Logger (copy), getCurrentRoute (copy), p1 (copy), EnumScreens (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForWideMode (copy), RoactNavigation (copy)
		Logger:info("Navigate To SquadLobby from {screen}")

		local v82 = getCurrentRoute(p1.props.navigation.state)

		if v82 and (v82.params and p4 == v82.params.conversationId and v82.routeName == EnumScreens.ChatConversation) then
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
	function p1.setScreenTopBar(p5) -- line: 219
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p1 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p5)

			return
		end

		local v84 = p1.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v84, "setScreenTopBar in screenProps")
		v84(EnumScreens.ChatLanding, p5)
	end

	p1.leftContainerRef = Roact.createRef()
	p1.rightContainerRef = Roact.createRef()
	p1.focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end
function v46.render(p6) -- line: 234
	-- upvalues: Logger (copy), ArgCheck (copy), withStyle (copy), Roact (copy), LeftContainerTelemetryProviders (copy), TopBarProvider (copy), EnumScreens (copy), FFlagAppChatTopBarConfigDriven (copy), ChatLandingTopBar (copy), createChatTopBar (copy), Cryo (copy), ChatLandingScreen (copy), ChatSearchBox (copy), Provider (copy), v41 (copy), ChatLandingContainer (copy), RightContainerTelemetryProviders (copy), conversationSwitchNavigator (copy), ConversationStackNavigationFocusListener (copy)
	Logger:info("{screen} render")

	local v62 = ArgCheck.isNotNil(p6.props.navigation, "navigation in ChatLandingScreenWithSwitchNavigator")
	local v63 = v62 and v62.getParam("key", "") or ""
	local v64 = v62.getScreenProps("showSearchRow", true)
	local v65 = v62.getScreenProps("topBarHeight", 0)

	return withStyle(function(p7) -- line: 241
		-- upvalues: Roact (copy), LeftContainerTelemetryProviders (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), p6 (copy), FFlagAppChatTopBarConfigDriven (copy), ChatLandingTopBar (copy), v62 (copy), createChatTopBar (copy), Cryo (copy), ChatLandingScreen (copy), v64 (copy), ChatSearchBox (copy), v65 (copy), Provider (copy), v41 (copy), ChatLandingContainer (copy), v63 (copy), RightContainerTelemetryProviders (copy), conversationSwitchNavigator (copy), ConversationStackNavigationFocusListener (copy)
		local t3 = {
			LeftContainerProviders = Roact.createElement(LeftContainerTelemetryProviders, {}, {
				LeftContainer = Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p8) -- line: 246
						-- upvalues: EnumScreens (copy), ArgCheck (copy), Roact (copy), p6 (copy), FFlagAppChatTopBarConfigDriven (copy), ChatLandingTopBar (copy), v62 (copy), createChatTopBar (copy), Cryo (copy), ChatLandingScreen (copy), v64 (copy), ChatSearchBox (copy), v65 (copy), Provider (copy), p7 (copy), v41 (copy), ChatLandingContainer (copy), v63 (copy)
						local v88 = p8.getScreenTopBar(EnumScreens.ChatLanding)

						ArgCheck.isType(v88, "table", "screenTopBar")

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
							leftTopBar = if not FFlagAppChatTopBarConfigDriven() then createChatTopBar(Cryo.Dictionary.join(v88, {
								navigation = v62
							}, ChatLandingScreen.navigationOptions({
								screenProps = nil,
								navigationOptions = nil,
								navigation = v62
							}), {
								backButtonEnabled = false,
								shouldBoldHeader = true
							})) else Roact.createElement(ChatLandingTopBar, {
								screenName = EnumScreens.ChatLanding,
								navigation = v62
							}),
							filterBox = if not v64 then nil else Roact.createElement(ChatSearchBox, {
								height = v65,
								initialText = v88.filterText,
								onFilter = function(p9) -- line: 284
									-- upvalues: p8 (copy), EnumScreens (copy)
									p8.setScreenTopBar(EnumScreens.ChatLanding, {
										filterText = p9
									})
								end
							}),
							content = Roact.createElement(Provider, {
								value = {
									left = v62.getScreenProps("appChatOuterPadding", 12),
									right = v62.getScreenProps("appChatInnerPadding", 12)
								}
							}, {
								ChatLanding = Roact.createElement("Frame", {
									BorderSizePixel = 0,
									LayoutOrder = 2,
									Size = UDim2.new(1, 0, 1, -v62.getScreenProps("topBarHeight", 0) - (not v64 and 0 or v65)),
									BackgroundTransparency = p7.Tokens.Color.None.Transparency
								}, {
									ChatLandingContainer = if not v41 then Roact.createElement(ChatLandingContainer, {
										isShowingFilterBox = v88.shouldRenderCenter,
										filterText = v88.filterText,
										navigateToConversation = p6.navigateToConversation,
										navigateToCreateChat = p6.navigateToCreateChat,
										navigateToPrivacy = p6.navigateToPrivacy,
										navigateToSquadLobby = p6.navigateToSquadLobby,
										navigateToToast = p6.navigateToToast,
										navigateToAddFriends = p6.props.navigation.getScreenProps("navigateToAddFriends", {}),
										key = "ChatLanding" .. v63
									}) else nil,
									if not v41 then nil else Roact.createElement(ChatLandingContainer, {
										isShowingFilterBox = v88.shouldRenderCenter,
										filterText = v88.filterText,
										navigateToConversation = p6.navigateToConversation,
										navigateToCreateChat = p6.navigateToCreateChat,
										navigateToPrivacy = p6.navigateToPrivacy,
										navigateToSquadLobby = p6.navigateToSquadLobby,
										navigateToToast = p6.navigateToToast,
										navigateToAddFriends = p6.props.navigation.getScreenProps("navigateToAddFriends", {}),
										key = "ChatLanding" .. v63
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
							left = v62.getScreenProps("appChatInnerPadding", 12),
							right = v62.getScreenProps("appChatOuterPadding", 12)
						}
					}, {
						ConversationSwitchNavigator = Roact.createElement(conversationSwitchNavigator, {
							navigation = v62
						})
					})
				})
			})
		}

		return Roact.createElement(ConversationStackNavigationFocusListener, {
			navigation = v62,
			leftContainerRef = p6.leftContainerRef,
			rightContainerRef = p6.rightContainerRef
		}, t3)
	end)
end
function v46.didMount(p10) -- line: 384
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagEnableAppChatInExperience (copy), SharedFlags (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy), FocusBehaviors (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p10.props.navigation
		local v68 = navigation.getScreenProps("navigateToRootStack", nil)
		local v69 = navigation.getScreenProps("isInExperience", false)
		local v70 = GetFFlagEnableAppChatInExperience() and v69
		local v71 = navigation.getScreenProps("appChatInnerPadding", 12)

		if SharedFlags.FFlagEnableHeaderBarButtonsUpdate then
			v71 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
		end

		local v72 = if not ArgoPartyExperimentation.getIsRenameEnabled() then if not GetFFlagIsSquadEnabled() then {
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
			headerText = v72,
			closeButtonEnabled = v70 and not not v68,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v71
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
function v46.willUnmount(p11) -- line: 446
	if p11.ixpSubscription then
		p11.ixpSubscription.remove()
	end

	p11.focusNavigationService:teardown()
end

return v46

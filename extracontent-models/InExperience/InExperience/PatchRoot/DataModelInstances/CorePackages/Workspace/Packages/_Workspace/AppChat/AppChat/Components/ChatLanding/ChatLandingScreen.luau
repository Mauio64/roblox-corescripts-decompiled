local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local Constants = require(AppChat.Constants)
local EnumScreens = require(AppChat.EnumScreens)
local SnoozeToastNotificationsButton = require(AppChat.Components.ChatLanding.SnoozeToastNotificationsButton)
local TopBarProvider = require(AppChat.TopBarProvider)
local ArgCheck = require(AppChatParent.ArgCheck)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local withLocalization = require(AppChatParent.Localization).withLocalization
local UIBlox = require(AppChatParent.UIBlox)
local Foundation = require(AppChatParent.Foundation)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local SearchTopBar = require(script.Parent.SearchTopBar)
local ChatLandingContainer = require(script.Parent.ChatLandingContainer)
local Logger = require(script.Parent.Logger)
local getCurrentRoute = require(script.Parent.Utils.getCurrentRoute)
local ChatSearchBox = require(script.Parent.ChatSearchBox)
local CheckAndOpenChatPushUpsell = require(script.Parent.CheckAndOpenChatPushUpsell)
local withTelemetry = require(AppChat.Telemetry.withTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(script.Parent.ChatLandingTelemetryEvents)
local resetForSquadLobbyForCompactMode = require(AppChat.Utils.resetForSquadLobbyForCompactMode)
local StreamNotificationsBellIcon = require(AppChatParent.StreamNotifications).StreamNotificationsBellIcon
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagStreamNotificationBellEntryPoint = require(AppChatParent.SharedFlags).FFlagStreamNotificationBellEntryPoint
local GetFFlagEnableAppChatInExperience = require(AppChatParent.SharedFlags).GetFFlagEnableAppChatInExperience
local FFlagEnablePartyQuickStartButton = require(AppChatParent.SharedFlags).FFlagEnablePartyQuickStartButton
local GetFFlagEnablePushNotificationsUpsellModalChat = require(AppChatParent.SharedFlags).GetFFlagEnablePushNotificationsUpsellModalChat
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagEnableHeaderBarButtonsUpdate = require(AppChatParent.SharedFlags).FFlagEnableHeaderBarButtonsUpdate
local FFlagAppChatChatLandingScreenRenameFixEnabled = require(AppChatParent.SharedFlags).FFlagAppChatChatLandingScreenRenameFixEnabled
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local v42 = Roact.PureComponent:extend("ChatLandingScreen")

v42.defaultProps = {
	navigation = nil
}

local function v43() -- line: 60
	-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), SearchTopBar (copy)
	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p1) -- line: 63
			-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), Roact (copy), SearchTopBar (copy)
			local v68 = p1.getScreenTopBar(EnumScreens.ChatLanding)

			ArgCheck.isType(v68, "table", "screenTopBar")

			return withLocalization({
				searchPlaceholderText = "Feature.Chat.Label.SearchWord",
				cancelText = "Feature.Chat.Action.Cancel"
			})(function(p2) -- line: 70
				-- upvalues: Roact (copy), SearchTopBar (copy), v68 (copy), p1 (copy), EnumScreens (copy)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					filterBox = Roact.createElement(SearchTopBar, {
						initialInputText = v68.filterText,
						cancelText = p2.cancelText,
						searchPlaceholderText = p2.searchPlaceholderText,
						captureFocusOnMount = v68.shouldAutoFocusCenter,
						onSelectCallback = v68.closeInputBar or function() -- line: 80
						end,
						resetOnMount = function() -- line: 82
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								shouldAutoFocusCenter = false
							})
						end,
						cancelCallback = function() -- line: 88
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								shouldRenderCenter = false,
								filterText = ""
							})
						end,
						textChangedCallback = function(p3) -- line: 95
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								filterText = p3
							})
						end
					})
				})
			end)
		end
	})
end

function v42.navigationOptions(p4) -- line: 107
	-- upvalues: Constants (copy), GetFFlagEnableAppChatInExperience (copy), FFlagEnableHeaderBarButtonsUpdate (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy), FFlagAppChatTopBarConfigDriven (copy), v43 (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy)
	local navigation = p4.navigation
	local v46 = navigation.getScreenProps("navigateToRootStack", nil)
	local v47 = navigation.getScreenProps("wideMode", false)
	local IconButtonWidth = Constants:GetIconButtonWidth(v47)
	local v49 = navigation.getScreenProps("isInExperience", false)
	local v50 = not not v46
	local v51 = GetFFlagEnableAppChatInExperience() and v49
	local v52 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)

	if FFlagEnableHeaderBarButtonsUpdate then
		v52 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local v53 = if not ArgoPartyExperimentation.getIsRenameEnabled() then if not GetFFlagIsSquadEnabled() then {
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

	if FFlagAppChatTopBarConfigDriven() then
		return {
			backButtonEnabled = false,
			isRoot = true,
			isTitleLeftAligned = true,
			shouldBoldHeader = true,
			headerText = v53,
			closeButtonEnabled = v51 and v50,
			tabBarVisible = not v46 or nil,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v52
		}
	end

	return {
		isRoot = true,
		isTitleLeftAligned = true,
		shouldBoldHeader = true,
		headerText = v53,
		backButtonEnabled = not v51 and v50,
		closeButtonEnabled = v51 and v50,
		tabBarVisible = not v46 or nil,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = v52,
		renderCenter = v43,
		renderRight = function() -- line: 178
			-- upvalues: withTelemetry (copy), ChatLandingTelemetryLayer (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v47 (copy)
			return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p5) -- line: 179
				-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v47 (copy)
				return Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p6) -- line: 182
						-- upvalues: EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), p5 (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v47 (copy)
						local v85 = p6.getScreenTopBar(EnumScreens.ChatLanding)

						ArgCheck.isType(v85, "table", "screenTopBar")

						local v86 = navigation.getScreenProps("notificationCount", 0)
						local v87 = navigation.getScreenProps("topBarShowSearch", false)
						local v88 = navigation.getScreenProps("topBarShowCreateChatGroup", false)
						local v89 = navigation.getScreenProps("topBarShowNotifications", false)
						local v90 = navigation.getScreenProps("topBarShowSnoozeNotifications", false)

						if v85.shouldRenderCenter then
							return nil
						end

						if FFlagEnableHeaderBarButtonsUpdate then
							return Roact.createElement(Foundation.View, {
								tag = "auto-xy row align-x-right align-y-center gap-xsmall"
							}, {
								filter = if not v87 then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 1,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.MagnifyingGlass,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("search"),
									onActivated = function() -- line: 210
										-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
										p6.setScreenTopBar(EnumScreens.ChatLanding, {
											shouldRenderCenter = true,
											shouldAutoFocusCenter = true,
											isSecondary = true
										})
										p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
									end
								}),
								createNewChat = if not v88 then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 2,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.PlusLarge,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("createChat"),
									onActivated = function() -- line: 230
										-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
										navigation.navigate(EnumScreens.CreateNewChat)
										p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
									end
								}),
								notifications = if not v89 then nil else Roact.createElement(StreamNotificationsBellIcon, {
									layoutOrder = 3,
									notificationCount = v86,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
								}),
								snoozeChatNotifications = if not v90 then nil else Roact.createElement(SnoozeToastNotificationsButton, {
									layoutOrder = 4,
									size = UDim2.new(0, IconButtonWidth, 1, 0)
								})
							})
						end

						return Roact.createFragment({
							filter = v87 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(IconButton, {
								layoutOrder = 1,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = Images["icons/common/search"],
								onActivated = function() -- line: 281
									-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									p6.setScreenTopBar(EnumScreens.ChatLanding, {
										shouldRenderCenter = true,
										shouldAutoFocusCenter = true,
										isSecondary = true
									})
									p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
								end
							}) else Roact.createElement(Foundation.IconButton, {
								isCircular = true,
								LayoutOrder = 1,
								size = Foundation.Enums.InputSize.Medium,
								icon = Foundation.Enums.IconName.MagnifyingGlass,
								testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("search"),
								onActivated = function() -- line: 267
									-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									p6.setScreenTopBar(EnumScreens.ChatLanding, {
										shouldRenderCenter = true,
										shouldAutoFocusCenter = true,
										isSecondary = true
									})
									p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
								end
							}),
							createNewChat = v88 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(IconButton, {
								layoutOrder = 2,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = if not GetFFlagIsSquadEnabled() then Images["icons/actions/compose"] else Images["icons/common/plus"],
								onActivated = function() -- line: 316
									-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									navigation.navigate(EnumScreens.CreateNewChat)
									p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
								end
							}) else Roact.createElement(Foundation.IconButton, {
								isCircular = true,
								LayoutOrder = 2,
								size = Foundation.Enums.InputSize.Medium,
								icon = Foundation.Enums.IconName.PlusLarge,
								testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("createChat"),
								onActivated = function() -- line: 302
									-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									navigation.navigate(EnumScreens.CreateNewChat)
									p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
								end
							}),
							notifications = v89 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(StreamNotificationsBellIcon, {
								layoutOrder = 3,
								notificationCount = v86,
								compactWidth = not v47,
								entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
							}) else Roact.createElement(Foundation.View, {
								tag = "radius-circle row align-x-center align-y-center",
								Size = UDim2.new(0, IconButtonWidth, 0, IconButtonWidth),
								testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
							}, {
								BellIcon = Roact.createElement(StreamNotificationsBellIcon, {
									notificationCount = v86,
									compactWidth = not v47,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
								})
							}),
							snoozeChatNotifications = if not v90 then nil else Roact.createElement(SnoozeToastNotificationsButton, {
								layoutOrder = 4,
								size = UDim2.new(0, IconButtonWidth, 1, 0)
							})
						})
					end
				})
			end)
		end
	}
end
function v42.init(p7) -- line: 361
	-- upvalues: Logger (copy), EnumScreens (copy), getCurrentRoute (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForCompactMode (copy), RoactNavigation (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ArgCheck (copy)
	function p7.navigateToConversation(p8) -- line: 362
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p8)
		p7.props.navigation.navigate(EnumScreens.ChatConversation, {
			navigatedWithFocus = false,
			conversationId = p8
		})
		p7.resetScreenTopBar()
	end
	function p7.navigateToCreateChat() -- line: 371
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To CreateNewChat from {screen}")
		p7.props.navigation.push(EnumScreens.CreateNewChat)
	end
	function p7.navigateToToast(p9) -- line: 376
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p7.props.navigation.navigate(EnumScreens.RoactChatToast, p9)
	end
	function p7.navigateToPrivacy() -- line: 381
		-- upvalues: p7 (copy), EnumScreens (copy), Logger (copy)
		local v71 = p7.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if v71 then
			Logger:info("Navigate To PrivacySettings from {screen}")
			v71()

			return
		end

		Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")
	end
	function p7.navigateToSquadLobby(p10) -- line: 392
		-- upvalues: Logger (copy), getCurrentRoute (copy), p7 (copy), EnumScreens (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForCompactMode (copy), RoactNavigation (copy)
		Logger:info("Navigate To SquadLobby from {screen}")

		local v73 = getCurrentRoute(p7.props.navigation.state)

		if v73 and (v73.params and p10 == v73.params.conversationId and v73.routeName == EnumScreens.ChatConversation) then
			p7.props.navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = p10
			})

			return
		end

		if FFlagEnablePartyQuickStartButton then
			resetForSquadLobbyForCompactMode(p7.props.navigation, p10)

			return
		end

		p7.props.navigation.reset({
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = {
					conversationId = p10
				}
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = {
					conversationId = p10
				}
			})
		}, 3)
	end
	function p7.setScreenTopBar(p11) -- line: 424
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p7 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p11)

			return
		end

		local v75 = p7.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v75, "setScreenTopBar in screenProps")
		v75(EnumScreens.ChatLanding, p11)
	end
	function p7.resetScreenTopBar() -- line: 434
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy), p7 (copy)
		local v76 = if not FFlagAppChatTopBarSignalsStore then ArgCheck.isNotNil(p7.props.navigation.getScreenProps("getScreenTopBar", nil), "getScreenTopBar in screenProps")(EnumScreens.ChatLanding) else GetTopBarStore(false).getScreenTopBar(EnumScreens.ChatLanding)(false) or {}

		if v76.filterText == "" and v76.shouldRenderCenter then
			p7.setScreenTopBar({
				shouldRenderCenter = false,
				isSecondary = false
			})
		end
	end
end
function v42.render(p12) -- line: 454
	-- upvalues: Logger (copy), ArgCheck (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ChatLandingContainer (copy), ChatSearchBox (copy), GetFFlagEnablePushNotificationsUpsellModalChat (copy), CheckAndOpenChatPushUpsell (copy)
	Logger:info("{screen} render")

	local v56 = ArgCheck.isNotNil(p12.props.navigation, "navigation in ChatLandingScreen")
	local v57 = v56 and v56.getParam("key", "") or ""
	local v58 = v56.getScreenProps("showSearchRow", true)
	local v59 = v56.getScreenProps("topBarHeight", 0)

	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p13) -- line: 463
			-- upvalues: EnumScreens (copy), ArgCheck (copy), Roact (copy), ChatLandingContainer (copy), v56 (copy), p12 (copy), v57 (copy), v58 (copy), ChatSearchBox (copy), v59 (copy), GetFFlagEnablePushNotificationsUpsellModalChat (copy), CheckAndOpenChatPushUpsell (copy)
			local v78 = p13.getScreenTopBar(EnumScreens.ChatLanding)

			ArgCheck.isType(v78, "table", "screenTopBar")

			local v79 = Roact.createElement(ChatLandingContainer, {
				isShowingFilterBox = v78.shouldRenderCenter,
				filterText = v78.filterText,
				topBarHeight = v56.getScreenProps("topBarHeight", 0),
				navigateToAddFriends = p12.props.navigation.getScreenProps("navigateToAddFriends", {}),
				navigateToConversation = p12.navigateToConversation,
				navigateToCreateChat = p12.navigateToCreateChat,
				navigateToPrivacy = p12.navigateToPrivacy,
				navigateToSquadLobby = p12.navigateToSquadLobby,
				navigateToToast = p12.navigateToToast,
				key = "ChatLanding" .. v57
			})

			if v58 then
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						VerticalFlex = Enum.UIFlexAlignment.Fill,
						Padding = UDim.new(0, 0)
					}),
					ChatSearchBox = Roact.createElement(ChatSearchBox, {
						height = v59,
						initialText = v78.filterText,
						onFilter = function(p14) -- line: 494
							-- upvalues: p13 (copy), EnumScreens (copy)
							p13.setScreenTopBar(EnumScreens.ChatLanding, {
								filterText = p14
							})
						end
					}),
					v79
				})
			end

			if GetFFlagEnablePushNotificationsUpsellModalChat() then
				return Roact.createFragment({
					v79,
					CheckAndOpenChatPushUpsell = Roact.createElement(CheckAndOpenChatPushUpsell)
				})
			end

			return v79
		end
	})
end
function v42.didMount(p15) -- line: 515
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagEnableAppChatInExperience (copy), FFlagAppChatChatLandingScreenRenameFixEnabled (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p15.props.navigation
		local v62 = navigation.getScreenProps("navigateToRootStack", nil)
		local v63 = navigation.getScreenProps("isInExperience", false)
		local v64 = GetFFlagEnableAppChatInExperience() and v63
		local v65 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)
		local v66 = if not FFlagAppChatChatLandingScreenRenameFixEnabled then if ArgoPartyExperimentation.getIsRenameEnabled() or not GetFFlagIsSquadEnabled() then {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} else {
			raw = "Feature.Squads.Label.Party",
			shouldLocalize = true
		} else if not ArgoPartyExperimentation.getIsRenameEnabled() then if not GetFFlagIsSquadEnabled() then {
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

		p15.setScreenTopBar({
			shouldRenderCenter = false,
			filterText = "",
			backButtonEnabled = false,
			isRoot = true,
			isTitleLeftAligned = true,
			shouldBoldHeader = true,
			headerText = v66,
			closeButtonEnabled = v64 and not not v62,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v65
		})

		return
	end

	p15.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = ""
	})
end

return v42

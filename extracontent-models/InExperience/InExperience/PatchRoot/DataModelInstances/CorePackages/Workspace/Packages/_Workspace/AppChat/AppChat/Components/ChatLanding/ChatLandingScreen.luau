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
local SharedFlags = require(AppChatParent.SharedFlags)
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagAppChatChatLandingScreenRenameFixEnabled = SharedFlags.FFlagAppChatChatLandingScreenRenameFixEnabled
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local v45 = Roact.PureComponent:extend("ChatLandingScreen")

v45.defaultProps = {
	navigation = nil
}

local function v46() -- line: 63
	-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), SearchTopBar (copy)
	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p1) -- line: 66
			-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), Roact (copy), SearchTopBar (copy)
			local v72 = p1.getScreenTopBar(EnumScreens.ChatLanding)

			ArgCheck.isType(v72, "table", "screenTopBar")

			return withLocalization({
				searchPlaceholderText = "Feature.Chat.Label.SearchWord",
				cancelText = "Feature.Chat.Action.Cancel"
			})(function(p2) -- line: 73
				-- upvalues: Roact (copy), SearchTopBar (copy), v72 (copy), p1 (copy), EnumScreens (copy)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					filterBox = Roact.createElement(SearchTopBar, {
						initialInputText = v72.filterText,
						cancelText = p2.cancelText,
						searchPlaceholderText = p2.searchPlaceholderText,
						captureFocusOnMount = v72.shouldAutoFocusCenter,
						onSelectCallback = v72.closeInputBar or function() -- line: 83
						end,
						resetOnMount = function() -- line: 85
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								shouldAutoFocusCenter = false
							})
						end,
						cancelCallback = function() -- line: 91
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								shouldRenderCenter = false,
								filterText = ""
							})
						end,
						textChangedCallback = function(p3) -- line: 98
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

function v45.navigationOptions(p4) -- line: 110
	-- upvalues: Constants (copy), GetFFlagEnableAppChatInExperience (copy), FFlagEnableHeaderBarButtonsUpdate (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy), FFlagAppChatTopBarConfigDriven (copy), v46 (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy)
	local navigation = p4.navigation
	local v49 = navigation.getScreenProps("navigateToRootStack", nil)
	local v50 = navigation.getScreenProps("wideMode", false)
	local IconButtonWidth = Constants:GetIconButtonWidth(v50)
	local v52 = navigation.getScreenProps("isInExperience", false)
	local v53 = not not v49
	local v54 = GetFFlagEnableAppChatInExperience() and v52
	local v55 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)

	if FFlagEnableHeaderBarButtonsUpdate then
		v55 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local v56 = if not ArgoPartyExperimentation.getIsRenameEnabled() then if not GetFFlagIsSquadEnabled() then {
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
			headerText = v56,
			closeButtonEnabled = v54 and v53,
			tabBarVisible = not v49 or nil,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v55
		}
	end

	return {
		isRoot = true,
		isTitleLeftAligned = true,
		shouldBoldHeader = true,
		headerText = v56,
		backButtonEnabled = not v54 and v53,
		closeButtonEnabled = v54 and v53,
		tabBarVisible = not v49 or nil,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = v55,
		renderCenter = v46,
		renderRight = function() -- line: 182
			-- upvalues: withTelemetry (copy), ChatLandingTelemetryLayer (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v50 (copy)
			return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p5) -- line: 183
				-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v50 (copy)
				return Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p6) -- line: 186
						-- upvalues: EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), p5 (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v50 (copy)
						local v89 = p6.getScreenTopBar(EnumScreens.ChatLanding)

						ArgCheck.isType(v89, "table", "screenTopBar")

						local v90 = navigation.getScreenProps("notificationCount", 0)
						local v91 = navigation.getScreenProps("topBarShowSearch", false)
						local v92 = navigation.getScreenProps("topBarShowCreateChatGroup", false)
						local v93 = navigation.getScreenProps("topBarShowNotifications", false)
						local v94 = navigation.getScreenProps("topBarShowSnoozeNotifications", false)

						if v89.shouldRenderCenter then
							return nil
						end

						if FFlagEnableHeaderBarButtonsUpdate then
							return Roact.createElement(Foundation.View, {
								tag = "auto-xy row align-x-right align-y-center gap-xsmall"
							}, {
								filter = if not v91 then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 1,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.MagnifyingGlass,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("search"),
									onActivated = function() -- line: 214
										-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
										p6.setScreenTopBar(EnumScreens.ChatLanding, {
											shouldRenderCenter = true,
											shouldAutoFocusCenter = true,
											isSecondary = true
										})
										p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
									end
								}),
								createNewChat = if not v92 then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 2,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.PlusLarge,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("createChat"),
									onActivated = function() -- line: 234
										-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
										navigation.navigate(EnumScreens.CreateNewChat)
										p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
									end
								}),
								notifications = if not v93 then nil else Roact.createElement(StreamNotificationsBellIcon, {
									layoutOrder = 3,
									notificationCount = v90,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
								}),
								snoozeChatNotifications = if not v94 then nil else Roact.createElement(SnoozeToastNotificationsButton, {
									layoutOrder = 4,
									size = UDim2.new(0, IconButtonWidth, 1, 0)
								})
							})
						end

						return Roact.createFragment({
							filter = v91 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(IconButton, {
								layoutOrder = 1,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = Images["icons/common/search"],
								onActivated = function() -- line: 285
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
								onActivated = function() -- line: 271
									-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									p6.setScreenTopBar(EnumScreens.ChatLanding, {
										shouldRenderCenter = true,
										shouldAutoFocusCenter = true,
										isSecondary = true
									})
									p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
								end
							}),
							createNewChat = v92 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(IconButton, {
								layoutOrder = 2,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = if not GetFFlagIsSquadEnabled() then Images["icons/actions/compose"] else Images["icons/common/plus"],
								onActivated = function() -- line: 320
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
								onActivated = function() -- line: 306
									-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									navigation.navigate(EnumScreens.CreateNewChat)
									p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
								end
							}),
							notifications = v93 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(StreamNotificationsBellIcon, {
								layoutOrder = 3,
								notificationCount = v90,
								compactWidth = not v50,
								entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
							}) else Roact.createElement(Foundation.View, {
								tag = "radius-circle row align-x-center align-y-center",
								Size = UDim2.new(0, IconButtonWidth, 0, IconButtonWidth),
								testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
							}, {
								BellIcon = Roact.createElement(StreamNotificationsBellIcon, {
									notificationCount = v90,
									compactWidth = not v50,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
								})
							}),
							snoozeChatNotifications = if not v94 then nil else Roact.createElement(SnoozeToastNotificationsButton, {
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
function v45.init(p7) -- line: 365
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), Logger (copy), EnumScreens (copy), getCurrentRoute (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForCompactMode (copy), RoactNavigation (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ArgCheck (copy)
	p7.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p7.props.navigation, "Party.LandingPage")

	function p7.navigateToConversation(p8) -- line: 370
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p8)
		p7.props.navigation.navigate(EnumScreens.ChatConversation, {
			navigatedWithFocus = false,
			conversationId = p8
		})
		p7.resetScreenTopBar()
	end
	function p7.navigateToCreateChat() -- line: 379
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To CreateNewChat from {screen}")
		p7.props.navigation.push(EnumScreens.CreateNewChat)
	end
	function p7.navigateToToast(p9) -- line: 384
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p7.props.navigation.navigate(EnumScreens.RoactChatToast, p9)
	end
	function p7.navigateToPrivacy() -- line: 389
		-- upvalues: p7 (copy), EnumScreens (copy), Logger (copy)
		local v75 = p7.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if v75 then
			Logger:info("Navigate To PrivacySettings from {screen}")
			v75()

			return
		end

		Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")
	end
	function p7.navigateToSquadLobby(p10) -- line: 400
		-- upvalues: Logger (copy), getCurrentRoute (copy), p7 (copy), EnumScreens (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForCompactMode (copy), RoactNavigation (copy)
		Logger:info("Navigate To SquadLobby from {screen}")

		local v77 = getCurrentRoute(p7.props.navigation.state)

		if v77 and (v77.params and p10 == v77.params.conversationId and v77.routeName == EnumScreens.ChatConversation) then
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
	function p7.setScreenTopBar(p11) -- line: 432
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p7 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p11)

			return
		end

		local v79 = p7.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v79, "setScreenTopBar in screenProps")
		v79(EnumScreens.ChatLanding, p11)
	end
	function p7.resetScreenTopBar() -- line: 442
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy), p7 (copy)
		local v80 = if not FFlagAppChatTopBarSignalsStore then ArgCheck.isNotNil(p7.props.navigation.getScreenProps("getScreenTopBar", nil), "getScreenTopBar in screenProps")(EnumScreens.ChatLanding) else GetTopBarStore(false).getScreenTopBar(EnumScreens.ChatLanding)(false) or {}

		if v80.filterText == "" and v80.shouldRenderCenter then
			p7.setScreenTopBar({
				shouldRenderCenter = false,
				isSecondary = false
			})
		end
	end
end
function v45.render(p12) -- line: 462
	-- upvalues: Logger (copy), ArgCheck (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ChatLandingContainer (copy), ChatSearchBox (copy), GetFFlagEnablePushNotificationsUpsellModalChat (copy), CheckAndOpenChatPushUpsell (copy)
	Logger:info("{screen} render")

	local v59 = ArgCheck.isNotNil(p12.props.navigation, "navigation in ChatLandingScreen")
	local v60 = v59 and v59.getParam("key", "") or ""
	local v61 = v59.getScreenProps("showSearchRow", true)
	local v62 = v59.getScreenProps("topBarHeight", 0)

	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p13) -- line: 471
			-- upvalues: EnumScreens (copy), ArgCheck (copy), Roact (copy), ChatLandingContainer (copy), v59 (copy), p12 (copy), v60 (copy), v61 (copy), ChatSearchBox (copy), v62 (copy), GetFFlagEnablePushNotificationsUpsellModalChat (copy), CheckAndOpenChatPushUpsell (copy)
			local v82 = p13.getScreenTopBar(EnumScreens.ChatLanding)

			ArgCheck.isType(v82, "table", "screenTopBar")

			local v83 = Roact.createElement(ChatLandingContainer, {
				isShowingFilterBox = v82.shouldRenderCenter,
				filterText = v82.filterText,
				topBarHeight = v59.getScreenProps("topBarHeight", 0),
				navigateToAddFriends = p12.props.navigation.getScreenProps("navigateToAddFriends", {}),
				navigateToConversation = p12.navigateToConversation,
				navigateToCreateChat = p12.navigateToCreateChat,
				navigateToPrivacy = p12.navigateToPrivacy,
				navigateToSquadLobby = p12.navigateToSquadLobby,
				navigateToToast = p12.navigateToToast,
				key = "ChatLanding" .. v60
			})

			if v61 then
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
						height = v62,
						initialText = v82.filterText,
						onFilter = function(p14) -- line: 502
							-- upvalues: p13 (copy), EnumScreens (copy)
							p13.setScreenTopBar(EnumScreens.ChatLanding, {
								filterText = p14
							})
						end
					}),
					v83
				})
			end

			if GetFFlagEnablePushNotificationsUpsellModalChat() then
				return Roact.createFragment({
					v83,
					CheckAndOpenChatPushUpsell = Roact.createElement(CheckAndOpenChatPushUpsell)
				})
			end

			return v83
		end
	})
end
function v45.didMount(p15) -- line: 523
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagEnableAppChatInExperience (copy), SharedFlags (copy), FFlagAppChatChatLandingScreenRenameFixEnabled (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p15.props.navigation
		local v65 = navigation.getScreenProps("navigateToRootStack", nil)
		local v66 = navigation.getScreenProps("isInExperience", false)
		local v67 = GetFFlagEnableAppChatInExperience() and v66
		local v68 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)

		if SharedFlags.FFlagEnableHeaderBarButtonsUpdate then
			v68 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
		end

		local v69 = if not FFlagAppChatChatLandingScreenRenameFixEnabled then if ArgoPartyExperimentation.getIsRenameEnabled() or not GetFFlagIsSquadEnabled() then {
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
			headerText = v69,
			closeButtonEnabled = v67 and not not v65,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v68
		})

		return
	end

	p15.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = ""
	})
end
function v45.willUnmount(p16) -- line: 596
	if p16.ixpSubscription then
		p16.ixpSubscription.remove()
	end
end

return v45

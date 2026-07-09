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
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local v41 = Roact.PureComponent:extend("ChatLandingScreen")

v41.defaultProps = {
	navigation = nil
}

local function v42() -- line: 58
	-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), SearchTopBar (copy)
	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p1) -- line: 61
			-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), Roact (copy), SearchTopBar (copy)
			local v67 = p1.getScreenTopBar(EnumScreens.ChatLanding)

			ArgCheck.isType(v67, "table", "screenTopBar")

			return withLocalization({
				searchPlaceholderText = "Feature.Chat.Label.SearchWord",
				cancelText = "Feature.Chat.Action.Cancel"
			})(function(p2) -- line: 68
				-- upvalues: Roact (copy), SearchTopBar (copy), v67 (copy), p1 (copy), EnumScreens (copy)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					filterBox = Roact.createElement(SearchTopBar, {
						initialInputText = v67.filterText,
						cancelText = p2.cancelText,
						searchPlaceholderText = p2.searchPlaceholderText,
						captureFocusOnMount = v67.shouldAutoFocusCenter,
						onSelectCallback = v67.closeInputBar or function() -- line: 78
						end,
						resetOnMount = function() -- line: 80
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								shouldAutoFocusCenter = false
							})
						end,
						cancelCallback = function() -- line: 86
							-- upvalues: p1 (copy), EnumScreens (copy)
							p1.setScreenTopBar(EnumScreens.ChatLanding, {
								shouldRenderCenter = false,
								filterText = ""
							})
						end,
						textChangedCallback = function(p3) -- line: 93
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

function v41.navigationOptions(p4) -- line: 105
	-- upvalues: Constants (copy), GetFFlagEnableAppChatInExperience (copy), FFlagEnableHeaderBarButtonsUpdate (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy), FFlagAppChatTopBarConfigDriven (copy), v42 (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy)
	local navigation = p4.navigation
	local v45 = navigation.getScreenProps("navigateToRootStack", nil)
	local v46 = navigation.getScreenProps("wideMode", false)
	local IconButtonWidth = Constants:GetIconButtonWidth(v46)
	local v48 = navigation.getScreenProps("isInExperience", false)
	local v49 = not not v45
	local v50 = GetFFlagEnableAppChatInExperience() and v48
	local v51 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)

	if FFlagEnableHeaderBarButtonsUpdate then
		v51 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local v52 = if not ArgoPartyExperimentation.getIsRenameEnabled() then if not GetFFlagIsSquadEnabled() then {
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
			headerText = v52,
			closeButtonEnabled = v50 and v49,
			tabBarVisible = not v45 or nil,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v51
		}
	end

	return {
		isRoot = true,
		isTitleLeftAligned = true,
		shouldBoldHeader = true,
		headerText = v52,
		backButtonEnabled = not v50 and v49,
		closeButtonEnabled = v50 and v49,
		tabBarVisible = not v45 or nil,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = v51,
		renderCenter = v42,
		renderRight = function() -- line: 176
			-- upvalues: withTelemetry (copy), ChatLandingTelemetryLayer (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v46 (copy)
			return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p5) -- line: 177
				-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v46 (copy)
				return Roact.createElement(TopBarProvider, {
					screenName = EnumScreens.ChatLanding,
					render = function(p6) -- line: 180
						-- upvalues: EnumScreens (copy), ArgCheck (copy), navigation (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), p5 (copy), ChatLandingTelemetryEvents (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), FFlagAppChatDomLocatorFoundationMigration (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v46 (copy)
						local v84 = p6.getScreenTopBar(EnumScreens.ChatLanding)

						ArgCheck.isType(v84, "table", "screenTopBar")

						local v85 = navigation.getScreenProps("notificationCount", 0)
						local v86 = navigation.getScreenProps("topBarShowSearch", false)
						local v87 = navigation.getScreenProps("topBarShowCreateChatGroup", false)
						local v88 = navigation.getScreenProps("topBarShowNotifications", false)
						local v89 = navigation.getScreenProps("topBarShowSnoozeNotifications", false)

						if v84.shouldRenderCenter then
							return nil
						end

						if FFlagEnableHeaderBarButtonsUpdate then
							return Roact.createElement(Foundation.View, {
								tag = "auto-xy row align-x-right align-y-center gap-xsmall"
							}, {
								filter = if not v86 then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 1,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.MagnifyingGlass,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("search"),
									onActivated = function() -- line: 208
										-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
										p6.setScreenTopBar(EnumScreens.ChatLanding, {
											shouldRenderCenter = true,
											shouldAutoFocusCenter = true,
											isSecondary = true
										})
										p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
									end
								}),
								createNewChat = if not v87 then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 2,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.PlusLarge,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("createChat"),
									onActivated = function() -- line: 228
										-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
										navigation.navigate(EnumScreens.CreateNewChat)
										p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
									end
								}),
								notifications = if not v88 then nil else Roact.createElement(StreamNotificationsBellIcon, {
									layoutOrder = 3,
									notificationCount = v85,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
								}),
								snoozeChatNotifications = if not v89 then nil else Roact.createElement(SnoozeToastNotificationsButton, {
									layoutOrder = 4,
									size = UDim2.new(0, IconButtonWidth, 1, 0)
								})
							})
						end

						return Roact.createFragment({
							filter = v86 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(IconButton, {
								layoutOrder = 1,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = Images["icons/common/search"],
								onActivated = function() -- line: 279
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
								onActivated = function() -- line: 265
									-- upvalues: p6 (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									p6.setScreenTopBar(EnumScreens.ChatLanding, {
										shouldRenderCenter = true,
										shouldAutoFocusCenter = true,
										isSecondary = true
									})
									p5.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
								end
							}),
							createNewChat = v87 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(IconButton, {
								layoutOrder = 2,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = if not GetFFlagIsSquadEnabled() then Images["icons/actions/compose"] else Images["icons/common/plus"],
								onActivated = function() -- line: 314
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
								onActivated = function() -- line: 300
									-- upvalues: navigation (copy), EnumScreens (copy), p5 (copy), ChatLandingTelemetryEvents (copy)
									navigation.navigate(EnumScreens.CreateNewChat)
									p5.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
								end
							}),
							notifications = v88 and if not FFlagAppChatDomLocatorFoundationMigration then Roact.createElement(StreamNotificationsBellIcon, {
								layoutOrder = 3,
								notificationCount = v85,
								compactWidth = not v46,
								entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
							}) else Roact.createElement(Foundation.View, {
								tag = "radius-circle row align-x-center align-y-center",
								Size = UDim2.new(0, IconButtonWidth, 0, IconButtonWidth),
								testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
							}, {
								BellIcon = Roact.createElement(StreamNotificationsBellIcon, {
									notificationCount = v85,
									compactWidth = not v46,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
								})
							}),
							snoozeChatNotifications = if not v89 then nil else Roact.createElement(SnoozeToastNotificationsButton, {
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
function v41.init(p7) -- line: 359
	-- upvalues: Logger (copy), EnumScreens (copy), getCurrentRoute (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForCompactMode (copy), RoactNavigation (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ArgCheck (copy)
	function p7.navigateToConversation(p8) -- line: 360
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p8)
		p7.props.navigation.navigate(EnumScreens.ChatConversation, {
			navigatedWithFocus = false,
			conversationId = p8
		})
		p7.resetScreenTopBar()
	end
	function p7.navigateToCreateChat() -- line: 369
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To CreateNewChat from {screen}")
		p7.props.navigation.push(EnumScreens.CreateNewChat)
	end
	function p7.navigateToToast(p9) -- line: 374
		-- upvalues: Logger (copy), p7 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p7.props.navigation.navigate(EnumScreens.RoactChatToast, p9)
	end
	function p7.navigateToPrivacy() -- line: 379
		-- upvalues: p7 (copy), EnumScreens (copy), Logger (copy)
		local v70 = p7.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if v70 then
			Logger:info("Navigate To PrivacySettings from {screen}")
			v70()

			return
		end

		Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")
	end
	function p7.navigateToSquadLobby(p10) -- line: 390
		-- upvalues: Logger (copy), getCurrentRoute (copy), p7 (copy), EnumScreens (copy), FFlagEnablePartyQuickStartButton (copy), resetForSquadLobbyForCompactMode (copy), RoactNavigation (copy)
		Logger:info("Navigate To SquadLobby from {screen}")

		local v72 = getCurrentRoute(p7.props.navigation.state)

		if v72 and (v72.params and p10 == v72.params.conversationId and v72.routeName == EnumScreens.ChatConversation) then
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
	function p7.setScreenTopBar(p11) -- line: 422
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p7 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p11)

			return
		end

		local v74 = p7.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v74, "setScreenTopBar in screenProps")
		v74(EnumScreens.ChatLanding, p11)
	end
	function p7.resetScreenTopBar() -- line: 432
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy), p7 (copy)
		local v75 = if not FFlagAppChatTopBarSignalsStore then ArgCheck.isNotNil(p7.props.navigation.getScreenProps("getScreenTopBar", nil), "getScreenTopBar in screenProps")(EnumScreens.ChatLanding) else GetTopBarStore(false).getScreenTopBar(EnumScreens.ChatLanding)(false) or {}

		if v75.filterText == "" and v75.shouldRenderCenter then
			p7.setScreenTopBar({
				shouldRenderCenter = false,
				isSecondary = false
			})
		end
	end
end
function v41.render(p12) -- line: 452
	-- upvalues: Logger (copy), ArgCheck (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ChatLandingContainer (copy), ChatSearchBox (copy), GetFFlagEnablePushNotificationsUpsellModalChat (copy), CheckAndOpenChatPushUpsell (copy)
	Logger:info("{screen} render")

	local v55 = ArgCheck.isNotNil(p12.props.navigation, "navigation in ChatLandingScreen")
	local v56 = v55 and v55.getParam("key", "") or ""
	local v57 = v55.getScreenProps("showSearchRow", true)
	local v58 = v55.getScreenProps("topBarHeight", 0)

	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p13) -- line: 461
			-- upvalues: EnumScreens (copy), ArgCheck (copy), Roact (copy), ChatLandingContainer (copy), v55 (copy), p12 (copy), v56 (copy), v57 (copy), ChatSearchBox (copy), v58 (copy), GetFFlagEnablePushNotificationsUpsellModalChat (copy), CheckAndOpenChatPushUpsell (copy)
			local v77 = p13.getScreenTopBar(EnumScreens.ChatLanding)

			ArgCheck.isType(v77, "table", "screenTopBar")

			local v78 = Roact.createElement(ChatLandingContainer, {
				isShowingFilterBox = v77.shouldRenderCenter,
				filterText = v77.filterText,
				topBarHeight = v55.getScreenProps("topBarHeight", 0),
				navigateToAddFriends = p12.props.navigation.getScreenProps("navigateToAddFriends", {}),
				navigateToConversation = p12.navigateToConversation,
				navigateToCreateChat = p12.navigateToCreateChat,
				navigateToPrivacy = p12.navigateToPrivacy,
				navigateToSquadLobby = p12.navigateToSquadLobby,
				navigateToToast = p12.navigateToToast,
				key = "ChatLanding" .. v56
			})

			if v57 then
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
						height = v58,
						initialText = v77.filterText,
						onFilter = function(p14) -- line: 492
							-- upvalues: p13 (copy), EnumScreens (copy)
							p13.setScreenTopBar(EnumScreens.ChatLanding, {
								filterText = p14
							})
						end
					}),
					v78
				})
			end

			if GetFFlagEnablePushNotificationsUpsellModalChat() then
				return Roact.createFragment({
					v78,
					CheckAndOpenChatPushUpsell = Roact.createElement(CheckAndOpenChatPushUpsell)
				})
			end

			return v78
		end
	})
end
function v41.didMount(p15) -- line: 513
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagEnableAppChatInExperience (copy), ArgoPartyExperimentation (copy), GetFFlagIsSquadEnabled (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p15.props.navigation
		local v61 = navigation.getScreenProps("navigateToRootStack", nil)
		local v62 = navigation.getScreenProps("isInExperience", false)
		local v63 = GetFFlagEnableAppChatInExperience() and v62
		local v64 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)
		local v65 = if ArgoPartyExperimentation.getIsRenameEnabled() or not GetFFlagIsSquadEnabled() then {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} else {
			raw = "Feature.Squads.Label.Party",
			shouldLocalize = true
		}

		p15.setScreenTopBar({
			shouldRenderCenter = false,
			filterText = "",
			backButtonEnabled = false,
			isRoot = true,
			isTitleLeftAligned = true,
			shouldBoldHeader = true,
			headerText = v65,
			closeButtonEnabled = v63 and not not v61,
			leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
			rightPaddingOverride = v64
		})

		return
	end

	p15.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = ""
	})
end

return v41

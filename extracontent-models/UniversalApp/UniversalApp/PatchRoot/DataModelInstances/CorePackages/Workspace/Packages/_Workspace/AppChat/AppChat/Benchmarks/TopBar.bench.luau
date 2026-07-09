local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local JestGlobals = require(AppChatParent.Dev.JestGlobals)
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local ReactTestingLibrary = require(AppChatParent.Dev.ReactTestingLibrary)
local render = ReactTestingLibrary.render
local act = ReactTestingLibrary.act
local benchmark = require(AppChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(AppChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local mountComponentTimes = BenchmarkUtils.mountComponentTimes
local wrapWithProviders = require(script.Parent.Utils.wrapWithProviders)
local EnumScreens = require(AppChat.EnumScreens)
local createChatTopBar = require(AppChat.createChatTopBar)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local ChatTopBarBase = require(AppChat.Components.TopBar.ChatTopBarBase)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local ChatConversationTopBar = require(AppChat.Components.TopBar.ChatConversationTopBar)
local ChatLandingTopBar = require(AppChat.Components.TopBar.ChatLandingTopBar)
local UIBlox = require(AppChatParent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(AppChatParent.Foundation)
local StreamNotificationsBellIcon = require(AppChatParent.StreamNotifications).StreamNotificationsBellIcon
local useChatLandingVisibility = require(AppChat.Hooks.useChatLandingVisibility)
local withTelemetry = require(AppChat.Telemetry.withTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)
local SnoozeToastNotificationsButton = require(AppChat.Components.ChatLanding.SnoozeToastNotificationsButton)
local Constants = require(AppChat.Constants)
local SharedFlags = require(AppChatParent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local FFlagAppChatRemoveNotifications = SharedFlags.FFlagAppChatRemoveNotifications
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local DomLocators = require(AppChat.Utils.DomLocators)
local t1 = {
	ChatAppReducer = {
		ChatSettings = {
			chatEnabled = true
		},
		Presence = {
			byUserId = {}
		}
	},
	NotificationBadgeCounts = {
		TopBarNotificationIcon = 3
	}
}

local function createMockNavigation() -- line: 89
	return {
		getScreenProps = function(s1: string, p1) -- line: 91
			local v52 = ({
				isInExperience = false,
				topBarHeight = 48,
				navigateToRootStack = nil,
				wideMode = false
			})[s1]

			if v52 ~= nil then
				return v52
			end

			return p1
		end,
		pop = function() -- line: 104
		end,
		navigate = function() -- line: 105
		end,
		goBack = function() -- line: 106
		end,
		state = {
			routeName = "Benchmark",
			key = "bench-1",
			params = {}
		}
	}
end

local v45 = createMockNavigation()

local function setupStore(s2: string, p2) -- line: 113
	-- upvalues: GetTopBarStore (copy)
	local v49 = GetTopBarStore(false)

	v49.resetStore()
	v49.setScreenTopBar(s2, p2)
end

benchFile(script, function() -- line: 119
	-- upvalues: beforeEach (copy), GetTopBarStore (copy), describe (copy), createChatTopBar (copy), benchmark (copy), render (copy), wrapWithProviders (copy), React (copy), v45 (copy), t1 (copy), EnumScreens (copy), ChatTopBarBase (copy), createSystemMenuButton (copy), SystemMenuTopBar (copy), ChatConversationTopBar (copy), Constants (copy), useChatLandingVisibility (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), FFlagAppChatRemoveNotifications (copy), ChatLandingTelemetryEvents (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), ChatLandingTopBar (copy), act (copy), mountComponentTimes (copy)
	beforeEach(function() -- line: 120
		-- upvalues: GetTopBarStore (copy)
		GetTopBarStore(false).resetStore()
	end)
	describe("Simple header (back + title)", function() -- line: 129
		-- upvalues: createChatTopBar (copy), benchmark (copy), render (copy), wrapWithProviders (copy), React (copy), v45 (copy), t1 (copy), EnumScreens (copy), GetTopBarStore (copy), ChatTopBarBase (copy)
		local function LegacySimpleHeader(p3) -- line: 130
			-- upvalues: createChatTopBar (copy)
			return createChatTopBar({
				backButtonEnabled = true,
				navigation = p3.navigation,
				headerText = {
					raw = "Feature.Chat.Label.Details",
					shouldLocalize = true
				}
			})
		end

		benchmark("Legacy: createChatTopBar", function() -- line: 138
			-- upvalues: render (copy), wrapWithProviders (copy), React (copy), LegacySimpleHeader (copy), v45 (copy), t1 (copy)
			render(wrapWithProviders(React.createElement(LegacySimpleHeader, {
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
		benchmark("Config-driven: ChatTopBarBase", function() -- line: 148
			-- upvalues: EnumScreens (copy), GetTopBarStore (copy), render (copy), wrapWithProviders (copy), React (copy), ChatTopBarBase (copy), v45 (copy), t1 (copy)
			local ChatDetails = EnumScreens.ChatDetails
			local t2 = {
				backButtonEnabled = true,
				headerText = {
					raw = "Feature.Chat.Label.Details",
					shouldLocalize = true
				}
			}
			local v69 = GetTopBarStore(false)

			v69.resetStore()
			v69.setScreenTopBar(ChatDetails, t2)
			render(wrapWithProviders(React.createElement(ChatTopBarBase, {
				screenName = EnumScreens.ChatDetails,
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
	end)
	describe("System menu (create/edit)", function() -- line: 168
		-- upvalues: createChatTopBar (copy), createSystemMenuButton (copy), benchmark (copy), render (copy), wrapWithProviders (copy), React (copy), v45 (copy), t1 (copy), EnumScreens (copy), GetTopBarStore (copy), SystemMenuTopBar (copy)
		local function LegacySystemMenu(p4) -- line: 169
			-- upvalues: createChatTopBar (copy), createSystemMenuButton (copy)
			return createChatTopBar({
				closeButtonEnabled = true,
				navigation = p4.navigation,
				headerText = {
					raw = "Feature.Chat.Action.NewChat",
					shouldLocalize = true
				},
				renderRight = function() -- line: 174
					-- upvalues: createSystemMenuButton (copy)
					return createSystemMenuButton({
						isDisabled = false,
						localizedStrings = {
							systemButtonText = "Feature.Chat.Action.Add"
						},
						onActivated = function() -- line: 178
						end
					})
				end
			})
		end

		benchmark("Legacy: createChatTopBar + systemMenuButton", function() -- line: 184
			-- upvalues: render (copy), wrapWithProviders (copy), React (copy), LegacySystemMenu (copy), v45 (copy), t1 (copy)
			render(wrapWithProviders(React.createElement(LegacySystemMenu, {
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
		benchmark("Config-driven: SystemMenuTopBar", function() -- line: 194
			-- upvalues: EnumScreens (copy), GetTopBarStore (copy), render (copy), wrapWithProviders (copy), React (copy), SystemMenuTopBar (copy), v45 (copy), t1 (copy)
			local CreateNewChat = EnumScreens.CreateNewChat
			local t3 = {
				closeButtonEnabled = true,
				systemButtonEnabled = true,
				systemButtonText = "Feature.Chat.Action.Add",
				headerText = {
					raw = "Feature.Chat.Action.NewChat",
					shouldLocalize = true
				}
			}
			local v73 = GetTopBarStore(false)

			v73.resetStore()
			v73.setScreenTopBar(CreateNewChat, t3)
			render(wrapWithProviders(React.createElement(SystemMenuTopBar, {
				screenName = EnumScreens.CreateNewChat,
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
	end)
	describe("Conversation header (face pile + squad join)", function() -- line: 217
		-- upvalues: createChatTopBar (copy), benchmark (copy), render (copy), wrapWithProviders (copy), React (copy), v45 (copy), t1 (copy), EnumScreens (copy), GetTopBarStore (copy), ChatConversationTopBar (copy)
		local function LegacyConversationHeader(p5) -- line: 218
			-- upvalues: createChatTopBar (copy)
			return createChatTopBar({
				backButtonEnabled = true,
				conversationId = "bench-conv-123",
				navigation = p5.navigation,
				headerText = {
					raw = "Test Conversation",
					shouldLocalize = false
				},
				navigateToChatDetails = function() -- line: 224
				end
			})
		end

		benchmark("Legacy: createChatTopBar + conversationId", function() -- line: 228
			-- upvalues: render (copy), wrapWithProviders (copy), React (copy), LegacyConversationHeader (copy), v45 (copy), t1 (copy)
			render(wrapWithProviders(React.createElement(LegacyConversationHeader, {
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
		benchmark("Config-driven: ChatConversationTopBar", function() -- line: 238
			-- upvalues: EnumScreens (copy), GetTopBarStore (copy), render (copy), wrapWithProviders (copy), React (copy), ChatConversationTopBar (copy), v45 (copy), t1 (copy)
			local ChatConversation = EnumScreens.ChatConversation
			local t4 = {
				backButtonEnabled = true,
				conversationId = "bench-conv-123",
				headerText = {
					raw = "Test Conversation",
					shouldLocalize = false
				},
				navigateToChatDetails = function() -- line: 243
				end
			}
			local v77 = GetTopBarStore(false)

			v77.resetStore()
			v77.setScreenTopBar(ChatConversation, t4)
			render(wrapWithProviders(React.createElement(ChatConversationTopBar, {
				screenName = EnumScreens.ChatConversation,
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
	end)
	describe("Landing (visibility hooks + icon row)", function() -- line: 263
		-- upvalues: Constants (copy), useChatLandingVisibility (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), FFlagAppChatRemoveNotifications (copy), ChatLandingTelemetryEvents (copy), EnumScreens (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), createChatTopBar (copy), benchmark (copy), render (copy), wrapWithProviders (copy), React (copy), v45 (copy), t1 (copy), GetTopBarStore (copy), ChatLandingTopBar (copy)
		local function LegacyLandingWithVisibility(p6) -- line: 264
			-- upvalues: Constants (copy), useChatLandingVisibility (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), FFlagAppChatRemoveNotifications (copy), ChatLandingTelemetryEvents (copy), EnumScreens (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), createChatTopBar (copy)
			local navigation = p6.navigation
			local v80 = navigation.getScreenProps("wideMode", false)
			local IconButtonWidth = Constants:GetIconButtonWidth(v80)
			local v82 = useChatLandingVisibility()

			return createChatTopBar({
				isTitleLeftAligned = true,
				shouldBoldHeader = true,
				isRoot = true,
				navigation = navigation,
				headerText = {
					raw = "Feature.Chat.Label.ChatTitle",
					shouldLocalize = true
				},
				renderRight = function() -- line: 270
					-- upvalues: withTelemetry (copy), ChatLandingTelemetryLayer (copy), v82 (copy), FFlagAppChatRemoveNotifications (copy), ChatLandingTelemetryEvents (copy), navigation (copy), EnumScreens (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v80 (copy)
					return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p7) -- line: 271
						-- upvalues: v82 (copy), FFlagAppChatRemoveNotifications (copy), ChatLandingTelemetryEvents (copy), navigation (copy), EnumScreens (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v80 (copy)
						local topBarShowSearch = v82.topBarShowSearch
						local topBarShowCreateChatGroup = v82.topBarShowCreateChatGroup
						local v95 = not FFlagAppChatRemoveNotifications and v82.topBarShowNotifications
						local topBarShowSnoozeNotifications = v82.topBarShowSnoozeNotifications
						local notificationCount = v82.notificationCount

						local function v98() -- line: 279
							-- upvalues: p7 (copy), ChatLandingTelemetryEvents (copy)
							p7.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
						end
						local function v99() -- line: 283
							-- upvalues: navigation (copy), EnumScreens (copy), p7 (copy), ChatLandingTelemetryEvents (copy)
							navigation.navigate(EnumScreens.CreateNewChat)
							p7.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
						end

						if FFlagEnableHeaderBarButtonsUpdate then
							return Roact.createElement(Foundation.View, {
								tag = "row align-x-right align-y-center gap-xsmall auto-xy"
							}, {
								filter = if not topBarShowSearch then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 1,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.MagnifyingGlass,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("search"),
									onActivated = v98
								}),
								createNewChat = if not topBarShowCreateChatGroup then nil else Roact.createElement(Foundation.IconButton, {
									isCircular = true,
									LayoutOrder = 2,
									size = Foundation.Enums.InputSize.Medium,
									icon = Foundation.Enums.IconName.PlusLarge,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("createChat"),
									onActivated = v99
								}),
								notifications = if not v95 then nil else Roact.createElement(StreamNotificationsBellIcon, {
									layoutOrder = 3,
									notificationCount = notificationCount,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat,
									testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
								}),
								snoozeChatNotifications = if not topBarShowSnoozeNotifications then nil else Roact.createElement(SnoozeToastNotificationsButton, {
									layoutOrder = 4,
									size = UDim2.new(0, IconButtonWidth, 1, 0)
								})
							})
						end

						return Roact.createFragment({
							filter = topBarShowSearch and if not FFlagDebugAppChatEnableDomLocators then Roact.createElement(IconButton, {
								layoutOrder = 1,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = Images["icons/common/search"],
								onActivated = v98
							}) else Roact.createElement(Foundation.IconButton, {
								isCircular = true,
								LayoutOrder = 1,
								size = Foundation.Enums.InputSize.Medium,
								icon = Foundation.Enums.IconName.MagnifyingGlass,
								testId = DomLocators.chatLandingTopBarIconButton("search"),
								onActivated = v98
							}),
							createNewChat = topBarShowCreateChatGroup and if not FFlagDebugAppChatEnableDomLocators then Roact.createElement(IconButton, {
								layoutOrder = 2,
								size = UDim2.new(0, IconButtonWidth, 1, 0),
								icon = if not GetFFlagIsSquadEnabled() then Images["icons/actions/compose"] else Images["icons/common/plus"],
								onActivated = v99
							}) else Roact.createElement(Foundation.IconButton, {
								isCircular = true,
								LayoutOrder = 2,
								size = Foundation.Enums.InputSize.Medium,
								icon = Foundation.Enums.IconName.PlusLarge,
								testId = DomLocators.chatLandingTopBarIconButton("createChat"),
								onActivated = v99
							}),
							notifications = v95 and if not FFlagDebugAppChatEnableDomLocators then Roact.createElement(StreamNotificationsBellIcon, {
								layoutOrder = 3,
								notificationCount = notificationCount,
								compactWidth = not v80,
								entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
							}) else Roact.createElement(Foundation.View, {
								tag = "row align-x-center align-y-center radius-circle",
								Size = UDim2.new(0, IconButtonWidth, 0, IconButtonWidth),
								testId = DomLocators.chatLandingTopBarIconButton("notifications")
							}, {
								BellIcon = Roact.createElement(StreamNotificationsBellIcon, {
									notificationCount = notificationCount,
									compactWidth = not v80,
									entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
								})
							}),
							snoozeChatNotifications = if not topBarShowSnoozeNotifications then nil else Roact.createElement(SnoozeToastNotificationsButton, {
								layoutOrder = 4,
								size = UDim2.new(0, IconButtonWidth, 1, 0)
							})
						})
					end)
				end
			})
		end

		benchmark("Legacy: createChatTopBar + telemetry + experiments + icon row", function() -- line: 406
			-- upvalues: render (copy), wrapWithProviders (copy), React (copy), LegacyLandingWithVisibility (copy), v45 (copy), t1 (copy)
			render(wrapWithProviders(React.createElement(LegacyLandingWithVisibility, {
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
		benchmark("Config-driven: ChatLandingTopBar", function() -- line: 416
			-- upvalues: EnumScreens (copy), GetTopBarStore (copy), render (copy), wrapWithProviders (copy), React (copy), ChatLandingTopBar (copy), v45 (copy), t1 (copy)
			local ChatLanding = EnumScreens.ChatLanding
			local t5 = {
				isTitleLeftAligned = true,
				shouldBoldHeader = true,
				isRoot = true,
				headerText = {
					raw = "Feature.Chat.Label.ChatTitle",
					shouldLocalize = true
				}
			}
			local v85 = GetTopBarStore(false)

			v85.resetStore()
			v85.setScreenTopBar(ChatLanding, t5)
			render(wrapWithProviders(React.createElement(ChatLandingTopBar, {
				screenName = EnumScreens.ChatLanding,
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			})):unmount()
		end)
	end)
	describe("Rerender with title change", function() -- line: 439
		-- upvalues: createChatTopBar (copy), benchmark (copy), render (copy), wrapWithProviders (copy), React (copy), v45 (copy), t1 (copy), act (copy), GetTopBarStore (copy), ChatTopBarBase (copy)
		local function LegacyRerenderHeader(p8) -- line: 440
			-- upvalues: createChatTopBar (copy)
			return createChatTopBar({
				backButtonEnabled = true,
				navigation = p8.navigation,
				headerText = {
					shouldLocalize = false,
					raw = p8.title
				}
			})
		end

		benchmark("Legacy: rerender via new props", function() -- line: 448
			-- upvalues: render (copy), wrapWithProviders (copy), React (copy), LegacyRerenderHeader (copy), v45 (copy), t1 (copy), act (copy)
			local v87 = render(wrapWithProviders(React.createElement(LegacyRerenderHeader, {
				title = "Title A",
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			}))

			act(function() -- line: 456
				-- upvalues: v87 (copy), wrapWithProviders (copy), React (copy), LegacyRerenderHeader (copy), v45 (copy), t1 (copy)
				v87:rerender(wrapWithProviders(React.createElement(LegacyRerenderHeader, {
					title = "Title B",
					navigation = v45
				}), {
					rodux = {
						state = t1
					}
				}))
			end)
			v87:unmount()
		end)
		benchmark("Config-driven: rerender via setScreenTopBar", function() -- line: 468
			-- upvalues: GetTopBarStore (copy), render (copy), wrapWithProviders (copy), React (copy), ChatTopBarBase (copy), v45 (copy), t1 (copy), act (copy)
			local t6 = {
				backButtonEnabled = true,
				headerText = {
					raw = "Title A",
					shouldLocalize = false
				}
			}
			local v89 = GetTopBarStore(false)

			v89.resetStore()
			v89.setScreenTopBar("BenchRerender", t6)

			local v90 = render(wrapWithProviders(React.createElement(ChatTopBarBase, {
				screenName = "BenchRerender",
				navigation = v45
			}), {
				rodux = {
					state = t1
				}
			}))

			act(function() -- line: 480
				-- upvalues: GetTopBarStore (copy)
				GetTopBarStore(false).setScreenTopBar("BenchRerender", {
					headerText = {
						raw = "Title B",
						shouldLocalize = false
					}
				})
			end)
			v90:unmount()
		end)
	end)
	describe("Mount scaling", function() -- line: 494
		-- upvalues: createChatTopBar (copy), React (copy), v45 (copy), wrapWithProviders (copy), t1 (copy), EnumScreens (copy), GetTopBarStore (copy), ChatTopBarBase (copy), mountComponentTimes (copy)
		local function LegacySimpleHeaderForMount(p9) -- line: 495
			-- upvalues: createChatTopBar (copy)
			return createChatTopBar({
				backButtonEnabled = true,
				navigation = p9.navigation,
				headerText = {
					raw = "Feature.Chat.Label.Details",
					shouldLocalize = true
				}
			})
		end

		local v59 = React.createElement(LegacySimpleHeaderForMount, {
			navigation = v45
		})
		local v60 = wrapWithProviders(v59, {
			rodux = {
				state = t1
			}
		})
		local ChatDetails = EnumScreens.ChatDetails
		local t7 = {
			backButtonEnabled = true,
			headerText = {
				raw = "Feature.Chat.Label.Details",
				shouldLocalize = true
			}
		}
		local v63 = GetTopBarStore(false)

		v63.resetStore()
		v63.setScreenTopBar(ChatDetails, t7)

		local v64 = React.createElement(ChatTopBarBase, {
			screenName = EnumScreens.ChatDetails,
			navigation = v45
		})
		local v65 = wrapWithProviders(v64, {
			rodux = {
				state = t1
			}
		})

		mountComponentTimes(v60, "Legacy simple header", 25)
		mountComponentTimes(v65, "Config-driven simple header", 25)
		mountComponentTimes(v60, "Legacy simple header", 50)
		mountComponentTimes(v65, "Config-driven simple header", 50)
		mountComponentTimes(v60, "Legacy simple header", 100)
		mountComponentTimes(v65, "Config-driven simple header", 100)
	end)
end)

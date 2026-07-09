local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local Constants = require(AppChat.Constants)
local EnumScreens = require(AppChat.EnumScreens)
local ChatTopBarBase = require(script.Parent.ChatTopBarBase)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local SearchTopBar = require(AppChat.Components.ChatLanding.SearchTopBar)
local SnoozeToastNotificationsButton = require(AppChat.Components.ChatLanding.SnoozeToastNotificationsButton)
local useChatLandingVisibility = require(AppChat.Hooks.useChatLandingVisibility)
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)
local StreamNotificationsBellIcon = require(AppChatParent.StreamNotifications).StreamNotificationsBellIcon
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local DomLocators = require(AppChat.Utils.DomLocators)
local SharedFlags = require(AppChatParent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local FlyoutLeftHeader = require(AppChatParent.FlyoutSidePanel).Components.FlyoutLeftHeader
local FlyoutSidePanelIXP = require(AppChatParent.SharedExperimentDefinition).FlyoutSidePanelIXP

local function SearchTopBarWrapper() -- line: 52
	-- upvalues: GetTopBarStore (copy), EnumScreens (copy), useLocalization (copy), React (copy), SearchTopBar (copy)
	local v35 = GetTopBarStore(false)
	local setScreenTopBar = v35.setScreenTopBar
	local v37 = v35.getScreenTopBar(EnumScreens.ChatLanding)(false)
	local v38 = useLocalization({
		searchPlaceholderText = "Feature.Chat.Label.SearchWord",
		cancelText = "Feature.Chat.Action.Cancel"
	})
	local v39 = React.useCallback(function() -- line: 62
		-- upvalues: v37 (copy)
		local closeInputBar = v37.closeInputBar

		if closeInputBar then
			closeInputBar()
		end
	end, { v37.closeInputBar })
	local v40 = React.useCallback(function() -- line: 69
		-- upvalues: setScreenTopBar (copy), EnumScreens (copy)
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldAutoFocusCenter = false
		})
	end, { setScreenTopBar })
	local v41 = React.useCallback(function() -- line: 75
		-- upvalues: setScreenTopBar (copy), EnumScreens (copy)
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldRenderCenter = false,
			filterText = ""
		})
	end, { setScreenTopBar })
	local v42 = React.useCallback(function(p1) -- line: 82
		-- upvalues: setScreenTopBar (copy), EnumScreens (copy)
		setScreenTopBar(EnumScreens.ChatLanding, {
			filterText = p1
		})
	end, { setScreenTopBar })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		filterBox = React.createElement(SearchTopBar, {
			initialInputText = v37.filterText,
			cancelText = v38.cancelText,
			searchPlaceholderText = v38.searchPlaceholderText,
			captureFocusOnMount = v37.shouldAutoFocusCenter,
			onSelectCallback = v39,
			resetOnMount = v40,
			cancelCallback = v41,
			textChangedCallback = v42
		})
	})
end
local function v33() -- line: 106
	-- upvalues: React (copy), SearchTopBarWrapper (copy)
	return React.createElement(SearchTopBarWrapper)
end
local function ChatLandingTopBar(t1: {[any]: any}) -- line: 110
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), Constants (copy), GetTopBarStore (copy), useSignalState (copy), useChatLandingVisibility (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), useLocalization (copy), v33 (copy), React (copy), EnumScreens (copy), ChatLandingTelemetryEvents (copy), FlyoutLeftHeader (copy), FlyoutSidePanelIXP (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ArgoPartyExperimentation (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), ChatTopBarBase (copy)
	if not FFlagAppChatTopBarConfigDriven() then
		return nil
	end

	local screenName = t1.screenName
	local navigation = t1.navigation
	local v46 = navigation.getScreenProps("isInExperience", false)
	local v47 = navigation.getScreenProps("wideMode", false)
	local IconButtonWidth = Constants:GetIconButtonWidth(v47)
	local v49 = GetTopBarStore(false)
	local setScreenTopBar = v49.setScreenTopBar
	local v51 = v49.getScreenTopBar(screenName)
	local v52 = useSignalState(v51)
	local v53 = useChatLandingVisibility()
	local v54 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local shouldRenderCenter = v52.shouldRenderCenter
	local rightHidden = v52.rightHidden
	local v57 = v52.headerText or {
		raw = "",
		shouldLocalize = false
	}
	local v58 = useLocalization({
		headerText = v57.shouldLocalize and v57.raw or nil
	})
	local v59 = v57.shouldLocalize and v58.headerText or (v57.raw or "")
	local v60 = if not shouldRenderCenter then nil else v33
	local v61 = React.useCallback(function() -- line: 140
		-- upvalues: setScreenTopBar (copy), EnumScreens (copy), v54 (copy), ChatLandingTelemetryEvents (copy)
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldRenderCenter = true,
			shouldAutoFocusCenter = true,
			isSecondary = true
		})
		v54.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, {
		v54,
		setScreenTopBar
	})
	local v62 = React.useCallback(function() -- line: 149
		-- upvalues: navigation (copy), EnumScreens (copy), v54 (copy), ChatLandingTelemetryEvents (copy)
		navigation.navigate(EnumScreens.CreateNewChat)
		v54.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
	end, {
		v54,
		navigation
	})
	local v63 = nil

	if not shouldRenderCenter then
		function v63() -- line: 164
			-- upvalues: rightHidden (copy), v53 (copy), FFlagEnableHeaderBarButtonsUpdate (copy), React (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), v61 (copy), ArgoPartyExperimentation (copy), v62 (copy), StreamNotificationsBellIcon (copy), FFlagStreamNotificationBellEntryPoint (copy), AppPage (copy), SnoozeToastNotificationsButton (copy), IconButtonWidth (copy), IconButton (copy), Images (copy), GetFFlagIsSquadEnabled (copy), v47 (copy)
			if rightHidden then
				return nil
			end

			local topBarShowSearch = v53.topBarShowSearch
			local topBarShowCreateChatGroup = v53.topBarShowCreateChatGroup
			local topBarShowNotifications = v53.topBarShowNotifications
			local topBarShowSnoozeNotifications = v53.topBarShowSnoozeNotifications
			local notificationCount = v53.notificationCount

			if FFlagEnableHeaderBarButtonsUpdate then
				return React.createElement(Foundation.View, {
					tag = "row align-x-right align-y-center gap-xsmall auto-xy"
				}, {
					filter = if not topBarShowSearch then nil else React.createElement(Foundation.IconButton, {
						isCircular = true,
						LayoutOrder = 1,
						size = Foundation.Enums.InputSize.Medium,
						icon = Foundation.Enums.IconName.MagnifyingGlass,
						testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("search"),
						onActivated = v61
					}),
					createNewChat = if not topBarShowCreateChatGroup then nil else React.createElement(Foundation.IconButton, {
						isCircular = true,
						LayoutOrder = 2,
						size = Foundation.Enums.InputSize.Medium,
						icon = if not ArgoPartyExperimentation.getIsRenameEnabled() then Foundation.Enums.IconName.PlusLarge else Foundation.Enums.IconName.PencilSquare,
						testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("createChat"),
						onActivated = v62
					}),
					notifications = if not topBarShowNotifications then nil else React.createElement(StreamNotificationsBellIcon, {
						layoutOrder = 3,
						notificationCount = notificationCount,
						entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat,
						testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingTopBarIconButton("notifications")
					}),
					snoozeChatNotifications = if not topBarShowSnoozeNotifications then nil else React.createElement(SnoozeToastNotificationsButton, {
						layoutOrder = 4,
						size = UDim2.new(0, IconButtonWidth, 1, 0)
					})
				})
			end

			return React.createElement(React.Fragment, nil, {
				filter = topBarShowSearch and if not FFlagDebugAppChatEnableDomLocators then React.createElement(IconButton, {
					layoutOrder = 1,
					size = UDim2.new(0, IconButtonWidth, 1, 0),
					icon = Images["icons/common/search"],
					onActivated = v61
				}) else React.createElement(Foundation.IconButton, {
					isCircular = true,
					LayoutOrder = 1,
					size = Foundation.Enums.InputSize.Medium,
					icon = Foundation.Enums.IconName.MagnifyingGlass,
					testId = DomLocators.chatLandingTopBarIconButton("search"),
					onActivated = v61
				}),
				createNewChat = topBarShowCreateChatGroup and if not FFlagDebugAppChatEnableDomLocators then React.createElement(IconButton, {
					layoutOrder = 2,
					size = UDim2.new(0, IconButtonWidth, 1, 0),
					icon = if not GetFFlagIsSquadEnabled() then Images["icons/actions/compose"] else Images["icons/common/plus"],
					onActivated = v62
				}) else React.createElement(Foundation.IconButton, {
					isCircular = true,
					LayoutOrder = 2,
					size = Foundation.Enums.InputSize.Medium,
					icon = Foundation.Enums.IconName.PlusLarge,
					testId = DomLocators.chatLandingTopBarIconButton("createChat"),
					onActivated = v62
				}),
				notifications = topBarShowNotifications and if not FFlagDebugAppChatEnableDomLocators then React.createElement(StreamNotificationsBellIcon, {
					layoutOrder = 3,
					notificationCount = notificationCount,
					compactWidth = not v47,
					entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
				}) else React.createElement(Foundation.View, {
					tag = "row align-x-center align-y-center radius-circle",
					Size = UDim2.new(0, IconButtonWidth, 0, IconButtonWidth),
					testId = DomLocators.chatLandingTopBarIconButton("notifications")
				}, {
					BellIcon = React.createElement(StreamNotificationsBellIcon, {
						notificationCount = notificationCount,
						compactWidth = not v47,
						entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else AppPage.Chat
					})
				}),
				snoozeChatNotifications = if not topBarShowSnoozeNotifications then nil else React.createElement(SnoozeToastNotificationsButton, {
					layoutOrder = 4,
					size = UDim2.new(0, IconButtonWidth, 1, 0)
				})
			})
		end
	end

	local v64 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() and not v46

	return React.createElement(ChatTopBarBase, {
		screenName = screenName,
		navigation = navigation,
		renderRight = v63,
		renderCenter = v60,
		renderLeft = if not v64 then nil else function() -- line: 154
			-- upvalues: React (copy), FlyoutLeftHeader (copy), v59 (copy), FlyoutSidePanelIXP (copy)
			return React.createElement(FlyoutLeftHeader, {
				titleText = v59,
				isFlyoutEntrypointEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
				isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
			})
		end,
		hideTitle = v64
	})
end

return ChatLandingTopBar

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ChatTopBarBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatTopBarBase")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local SearchTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SearchTopBar")
local ChatLandingSearchRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatLandingSearchRow")
local SnoozeToastNotificationsButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SnoozeToastNotificationsButton")
local useChatLandingVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatLandingVisibility")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local streamNotificationsBellIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/StreamNotifications").StreamNotificationsBellIcon

local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatFoundationSearchInput = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFoundationSearchInput")
local FFlagAppChatWideAlwaysVisibleSearchBox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatWideAlwaysVisibleSearchBox")
local fFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local fFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatLandingNotifBtnTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatLandingNotifBtnTelemetry")
local flyoutLeftHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FlyoutSidePanel").Components.FlyoutLeftHeader
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedExperimentDefinition").FlyoutSidePanelIXP

local function SearchTopBarWrapper()
	local v5 = GetTopBarStore(false)
	local setScreenTopBar = v5.setScreenTopBar
	local v6 = v5.getScreenTopBar(EnumScreens.ChatLanding)(false)

	local v7 = useLocalization({
		searchPlaceholderText = "Feature.Chat.Label.SearchWord",
		cancelText = "Feature.Chat.Action.Cancel"
	})

	local v8 = React.useCallback(function()
		local closeInputBar = v6.closeInputBar

		if closeInputBar then
			closeInputBar()
		end
	end, { v6.closeInputBar })

	local v9 = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, { shouldAutoFocusCenter = false })
	end, { setScreenTopBar })

	local v10 = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldRenderCenter = false,
			filterText = ""
		})
	end, { setScreenTopBar })

	local v11 = React.useCallback(function(p2)
		setScreenTopBar(EnumScreens.ChatLanding, { filterText = p2 })
	end, { setScreenTopBar })

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		filterBox = React.createElement(SearchTopBar, {
			initialInputText = v6.filterText,
			cancelText = v7.cancelText,
			searchPlaceholderText = v7.searchPlaceholderText,
			captureFocusOnMount = v6.shouldAutoFocusCenter,
			onSelectCallback = v8,
			resetOnMount = v9,
			cancelCallback = v10,
			textChangedCallback = v11
		})
	})
end

local function fn()
	return React.createElement(SearchTopBarWrapper)
end

local function ChatLandingTopBar(p2)
	local screenName = p2.screenName
	local navigation = p2.navigation
	local screenProps = navigation.getScreenProps("isInExperience", false)
	local screenProps2 = navigation.getScreenProps("wideMode", false)
	local iconButtonWidth = Constants:GetIconButtonWidth(screenProps2)

	local v5 = GetTopBarStore(false)
	local setScreenTopBar = v5.setScreenTopBar
	local v6 = useSignalState((v5.getScreenTopBar(screenName)))

	local v7 = useChatLandingVisibility()
	local v8 = useTelemetry(ChatConversationTelemetryLayer.Context)

	local shouldRenderCenter = v6.shouldRenderCenter
	local rightHidden = v6.rightHidden
	local headerText = v6.headerText or { raw = "", shouldLocalize = false }

	local v11 = if headerText.shouldLocalize then headerText.raw or nil else nil
	local v12 = useLocalization({ headerText = v11 })

	local headerText2 = headerText.shouldLocalize and v12.headerText or headerText.raw or ""

	local v13 = React.useCallback(function()
		return React.createElement(ChatLandingSearchRow, {
			exitVariant = screenProps2 and "Cancel" or "Chevron"
		})
	end, { screenProps2 })

	if shouldRenderCenter then
		if not FFlagAppChatFoundationSearchInput then
			v13 = fn
		end
	else
		v13 = nil
	end

	local v14 = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldRenderCenter = true,
			shouldAutoFocusCenter = true,
			isSecondary = true
		})

		v8.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, { v8, setScreenTopBar })

	local v15 = React.useCallback(function()
		navigation.navigate(EnumScreens.CreateNewChat)
		v8.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
	end, { v8, navigation })

	local v16 = React.useCallback(function()
		v8.emit(ChatLandingTelemetryEvents.ChatLandingNotifBtnClicked, {})
	end, { v8 })

	local v17 = React.useCallback(function()
		return React.createElement(flyoutLeftHeader, {
			titleText = headerText2,
			isFlyoutEntrypointEnabled = flyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
			isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled()
		})
	end, { headerText2 })

	local v18 = v7.topBarShowSearch

	if FFlagAppChatWideAlwaysVisibleSearchBox and screenProps2 then
		v18 = false
	end

	local topBarShowCreateChatGroup = v7.topBarShowCreateChatGroup
	local topBarShowNotifications = v7.topBarShowNotifications
	local topBarShowSnoozeNotifications = v7.topBarShowSnoozeNotifications
	local notificationCount = v7.notificationCount

	local function fn2()
		if rightHidden then
			return nil
		end

		if fFlagEnableHeaderBarButtonsUpdate then
			local createElement = React.createElement
			local view = Foundation.View
			local v21

			if v18 then
				local createElement2 = React.createElement
				local iconButton2 = Foundation.IconButton
				local v22 = {
					size = Foundation.Enums.InputSize.Medium,
					isCircular = true,
					icon = Foundation.Enums.IconName.MagnifyingGlass,
					testId = 0,
					LayoutOrder = 1,
					onActivated = 0
				}

				local v23 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingTopBarIconButton("search") else nil
				v22.testId = v23

				v22.onActivated = v14
				v21 = createElement2(iconButton2, v22)
			end

			local v22

			if topBarShowCreateChatGroup then
				local createElement2 = React.createElement
				local iconButton2 = Foundation.IconButton
				local v23 = {
					size = Foundation.Enums.InputSize.Medium,
					isCircular = true,
					icon = Foundation.Enums.IconName.PencilSquare,
					testId = 0,
					LayoutOrder = 2,
					onActivated = 0
				}

				local v24 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingTopBarIconButton("createChat") else nil
				v23.testId = v24

				v23.onActivated = v15
				v22 = createElement2(iconButton2, v23)
			end

			local v23

			if topBarShowNotifications then
				local createElement2 = React.createElement
				local v25 = {
					notificationCount = notificationCount,
					layoutOrder = 3,
					entryPoint = 0,
					onActivated = 0,
					testId = 0
				}

				local v26 = if fFlagStreamNotificationBellEntryPoint then appPage.Chat else nil
				v25.entryPoint = v26
				v25.onActivated = if FFlagAppChatLandingNotifBtnTelemetry then v16 else nil

				local v28 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingTopBarIconButton("notifications") else nil
				v25.testId = v28
				v23 = createElement2(streamNotificationsBellIcon, v25)
			end

			local v24 = if topBarShowSnoozeNotifications then React.createElement(SnoozeToastNotificationsButton, {
				layoutOrder = 4,
				size = UDim2.new(0, iconButtonWidth, 1, 0)
			}) else nil
			return createElement(view, {
				tag = "row align-x-right align-y-center gap-xsmall auto-xy"
			}, {
				filter = v21,
				createNewChat = v22,
				notifications = v23,
				snoozeChatNotifications = v24
			})
		else
			local createElement = React.createElement
			local fragment = React.Fragment
			local v21 = v18

			if v21 then
				if FFlagDebugAppChatEnableDomLocators then
					v21 = React.createElement(Foundation.IconButton, {
						size = Foundation.Enums.InputSize.Medium,
						isCircular = true,
						icon = Foundation.Enums.IconName.MagnifyingGlass,
						testId = DomLocators.chatLandingTopBarIconButton("search"),
						LayoutOrder = 1,
						onActivated = v14
					})
				else
					v21 = React.createElement(iconButton, {
						size = UDim2.new(0, iconButtonWidth, 1, 0),
						icon = images["icons/common/search"],
						layoutOrder = 1,
						onActivated = v14
					})
				end
			end

			local v22 = topBarShowCreateChatGroup

			if v22 then
				if FFlagDebugAppChatEnableDomLocators then
					v22 = React.createElement(Foundation.IconButton, {
						size = Foundation.Enums.InputSize.Medium,
						isCircular = true,
						icon = Foundation.Enums.IconName.PlusLarge,
						testId = DomLocators.chatLandingTopBarIconButton("createChat"),
						LayoutOrder = 2,
						onActivated = v15
					})
				else
					local createElement2 = React.createElement
					local v24 = {
						size = UDim2.new(0, iconButtonWidth, 1, 0),
						icon = 0,
						layoutOrder = 2,
						onActivated = 0
					}
					local v25 = if getFFlagIsSquadEnabled() then images["icons/common/plus"] else images["icons/actions/compose"]
					v24.icon = v25

					v24.onActivated = v15
					v22 = createElement2(iconButton, v24)
				end
			end

			local v23 = topBarShowNotifications

			if v23 then
				if FFlagDebugAppChatEnableDomLocators then
					local createElement2 = React.createElement
					local view = Foundation.View
					local v24 = {
						Size = UDim2.new(0, iconButtonWidth, 0, iconButtonWidth),
						tag = "row align-x-center align-y-center radius-circle",
						testId = DomLocators.chatLandingTopBarIconButton("notifications")
					}

					local createElement3 = React.createElement
					local v27 = {
						notificationCount = notificationCount,
						compactWidth = not screenProps2,
						entryPoint = 0,
						onActivated = 0
					}

					local v28 = if fFlagStreamNotificationBellEntryPoint then appPage.Chat else nil
					v27.entryPoint = v28
					v27.onActivated = if FFlagAppChatLandingNotifBtnTelemetry then v16 else nil
					v23 = createElement2(view, v24, {
						BellIcon = createElement3(streamNotificationsBellIcon, v27)
					})
				else
					local createElement2 = React.createElement
					local v25 = {
						notificationCount = notificationCount,
						compactWidth = not screenProps2,
						layoutOrder = 3,
						entryPoint = 0,
						onActivated = 0
					}

					local v26 = if fFlagStreamNotificationBellEntryPoint then appPage.Chat else nil
					v25.entryPoint = v26
					v25.onActivated = if FFlagAppChatLandingNotifBtnTelemetry then v16 else nil
					v23 = createElement2(streamNotificationsBellIcon, v25)
				end
			end

			local v24 = if topBarShowSnoozeNotifications then React.createElement(SnoozeToastNotificationsButton, {
				layoutOrder = 4,
				size = UDim2.new(0, iconButtonWidth, 1, 0)
			}) else nil
			return createElement(fragment, nil, {
				filter = v21,
				createNewChat = v22,
				notifications = v23,
				snoozeChatNotifications = v24
			})
		end
	end

	local v21 = React.useCallback(fn2, {
		iconButtonWidth,
		notificationCount,
		v15,
		v14,
		if FFlagAppChatLandingNotifBtnTelemetry then v16 else false,
		rightHidden,
		topBarShowCreateChatGroup,
		topBarShowNotifications,
		v18,
		topBarShowSnoozeNotifications,
		screenProps2
	})

	local v22 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled() and not screenProps

	local createElement = React.createElement
	local v24 = {
		screenName = screenName,
		navigation = navigation,
		renderRight = nil,
		renderCenter = nil,
		renderLeft = nil,
		hideTitle = nil
	}

	if shouldRenderCenter then
		v21 = nil
	end

	v24.renderRight = v21
	v24.renderCenter = v13

	if not v22 then
		v17 = nil
	end

	v24.renderLeft = v17
	v24.hideTitle = v22
	return createElement(ChatTopBarBase, v24)
end

return ChatLandingTopBar

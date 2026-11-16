local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Constants = require(AppChat.Constants)
local EnumScreens = require(AppChat.EnumScreens)
local ChatTopBarBase = require(script.Parent.ChatTopBarBase)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local SearchTopBar = require(AppChat.Components.ChatLanding.SearchTopBar)
local ChatLandingSearchRow = require(script.Parent.ChatLandingSearchRow)
local SnoozeToastNotificationsButton = require(AppChat.Components.ChatLanding.SnoozeToastNotificationsButton)
local useChatLandingVisibility = require(AppChat.Hooks.useChatLandingVisibility)

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)
local StreamNotifications = require(parent.StreamNotifications)
local StreamNotificationsBellIcon = StreamNotifications.StreamNotificationsBellIcon

local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local DomLocators = require(AppChat.Utils.DomLocators)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatFoundationSearchInput = require(AppChat.Flags.FFlagAppChatFoundationSearchInput)
local FFlagAppChatWideAlwaysVisibleSearchBox = require(AppChat.Flags.FFlagAppChatWideAlwaysVisibleSearchBox)
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatLandingNotifBtnTelemetry = require(AppChat.Flags.FFlagAppChatLandingNotifBtnTelemetry)
local FlyoutSidePanel = require(parent.FlyoutSidePanel)
local FlyoutLeftHeader = FlyoutSidePanel.Components.FlyoutLeftHeader
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP

local function SearchTopBarWrapper()
	local topBarStore = GetTopBarStore(false)
	local setScreenTopBar = topBarStore.setScreenTopBar
	local v = topBarStore.getScreenTopBar(EnumScreens.ChatLanding)(false)

	local v2 = useLocalization({
		searchPlaceholderText = "Feature.Chat.Label.SearchWord",
		cancelText = "Feature.Chat.Action.Cancel"
	})

	local onSelectCallback = React.useCallback(function()
		local closeInputBar = v.closeInputBar

		if closeInputBar then
			closeInputBar()
		end
	end, { v.closeInputBar })

	local resetOnMount = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, { shouldAutoFocusCenter = false })
	end, { setScreenTopBar })

	local cancelCallback = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, { shouldRenderCenter = false, filterText = "" })
	end, { setScreenTopBar })

	local textChangedCallback = React.useCallback(function(filterText)
		setScreenTopBar(EnumScreens.ChatLanding, { filterText = filterText })
	end, { setScreenTopBar })

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		filterBox = React.createElement(SearchTopBar, {
			initialInputText = v.filterText,
			cancelText = v2.cancelText,
			searchPlaceholderText = v2.searchPlaceholderText,
			captureFocusOnMount = v.shouldAutoFocusCenter,
			onSelectCallback = onSelectCallback,
			resetOnMount = resetOnMount,
			cancelCallback = cancelCallback,
			textChangedCallback = textChangedCallback
		})
	})
end

local function fn()
	return React.createElement(SearchTopBarWrapper)
end

local function ChatLandingTopBar(p)
	local screenName = p.screenName
	local navigation = p.navigation
	local screenProps = navigation.getScreenProps("isInExperience", false)
	local screenProps2 = navigation.getScreenProps("wideMode", false)
	local iconButtonWidth = Constants:GetIconButtonWidth(screenProps2)

	local topBarStore = GetTopBarStore(false)
	local setScreenTopBar = topBarStore.setScreenTopBar
	local v = useSignalState((topBarStore.getScreenTopBar(screenName)))

	local v2 = useChatLandingVisibility()
	local v3 = useTelemetry(ChatLandingTelemetryLayer.Context)

	local shouldRenderCenter = v.shouldRenderCenter
	local rightHidden = v.rightHidden
	local headerText = v.headerText or { raw = "", shouldLocalize = false }
	local headerText3

	if headerText.shouldLocalize then
		headerText3 = headerText.raw or nil
	end

	local v4 = useLocalization({ headerText = headerText3 })

	local headerText2 = headerText.shouldLocalize and v4.headerText or headerText.raw or ""

	local renderCenter = React.useCallback(function()
		return React.createElement(ChatLandingSearchRow, {
			exitVariant = screenProps2 and "Cancel" or "Chevron"
		})
	end, { screenProps2 })

	if shouldRenderCenter then
		if not FFlagAppChatFoundationSearchInput then
			renderCenter = fn
		end
	else
		renderCenter = nil
	end

	local onActivated = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldRenderCenter = true,
			shouldAutoFocusCenter = true,
			isSecondary = true
		})

		v3.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, { v3, setScreenTopBar })

	local onActivated2 = React.useCallback(function()
		navigation.navigate(EnumScreens.CreateNewChat)
		v3.emit(ChatLandingTelemetryEvents.ChatLandingComposeBtnClicked, {})
	end, { v3, navigation })

	local v5 = React.useCallback(function()
		v3.emit(ChatLandingTelemetryEvents.ChatLandingNotifBtnClicked, {})
	end, { v3 })

	local renderLeft = React.useCallback(function()
		return React.createElement(FlyoutLeftHeader, {
			titleText = headerText2,
			isFlyoutEntrypointEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
			isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
		})
	end, { headerText2 })

	local v6 = v2.topBarShowSearch

	if FFlagAppChatWideAlwaysVisibleSearchBox and screenProps2 then
		v6 = false
	end

	local topBarShowCreateChatGroup = v2.topBarShowCreateChatGroup
	local topBarShowNotifications = v2.topBarShowNotifications
	local topBarShowSnoozeNotifications = v2.topBarShowSnoozeNotifications
	local notificationCount = v2.notificationCount

	local useCallback = React.useCallback
	local function fn2()
		if rightHidden then
			return nil
		end

		if FFlagEnableHeaderBarButtonsUpdate then
			local createElement = React.createElement
			local view = Foundation.View
			local filter

			if v6 then
				local createElement2 = React.createElement
				local iconButton = Foundation.IconButton
				local v7 = {
					size = Foundation.Enums.InputSize.Medium,
					isCircular = true,
					icon = Foundation.Enums.IconName.MagnifyingGlass,
					testId = 0,
					LayoutOrder = 1,
					onActivated = 0
				}
				local testId

				if FFlagDebugAppChatEnableDomLocators then
					testId = DomLocators.chatLandingTopBarIconButton("search")
				end

				v7.testId = testId

				v7.onActivated = onActivated
				filter = createElement2(iconButton, v7)
			end

			local createNewChat

			if topBarShowCreateChatGroup then
				local createElement2 = React.createElement
				local iconButton = Foundation.IconButton
				local v7 = {
					size = Foundation.Enums.InputSize.Medium,
					isCircular = true,
					icon = Foundation.Enums.IconName.PencilSquare,
					testId = 0,
					LayoutOrder = 2,
					onActivated = 0
				}
				local testId

				if FFlagDebugAppChatEnableDomLocators then
					testId = DomLocators.chatLandingTopBarIconButton("createChat")
				end

				v7.testId = testId

				v7.onActivated = onActivated2
				createNewChat = createElement2(iconButton, v7)
			end

			local notifications

			if topBarShowNotifications then
				local createElement2 = React.createElement
				local v7 = {
					notificationCount = notificationCount,
					layoutOrder = 3,
					entryPoint = 0,
					onActivated = 0,
					testId = 0
				}
				local entryPoint

				if FFlagStreamNotificationBellEntryPoint then
					entryPoint = AppPage.Chat
				end

				v7.entryPoint = entryPoint
				local onActivated3

				if FFlagAppChatLandingNotifBtnTelemetry then
					onActivated3 = v5
				end

				v7.onActivated = onActivated3
				local testId

				if FFlagDebugAppChatEnableDomLocators then
					testId = DomLocators.chatLandingTopBarIconButton("notifications")
				end

				v7.testId = testId
				notifications = createElement2(StreamNotificationsBellIcon, v7)
			end

			local snoozeChatNotifications

			if topBarShowSnoozeNotifications then
				snoozeChatNotifications = React.createElement(SnoozeToastNotificationsButton, {
					layoutOrder = 4,
					size = UDim2.new(0, iconButtonWidth, 1, 0)
				})
			end

			return createElement(view, {
				tag = "row align-x-right align-y-center gap-xsmall auto-xy"
			}, {
				filter = filter,
				createNewChat = createNewChat,
				notifications = notifications,
				snoozeChatNotifications = snoozeChatNotifications
			})
		else
			local createElement = React.createElement
			local fragment = React.Fragment
			local filter = v6

			if filter then
				if FFlagDebugAppChatEnableDomLocators then
					filter = React.createElement(Foundation.IconButton, {
						size = Foundation.Enums.InputSize.Medium,
						isCircular = true,
						icon = Foundation.Enums.IconName.MagnifyingGlass,
						testId = DomLocators.chatLandingTopBarIconButton("search"),
						LayoutOrder = 1,
						onActivated = onActivated
					})
				else
					filter = React.createElement(IconButton, {
						size = UDim2.new(0, iconButtonWidth, 1, 0),
						icon = Images["icons/common/search"],
						layoutOrder = 1,
						onActivated = onActivated
					})
				end
			end

			local createNewChat = topBarShowCreateChatGroup

			if createNewChat then
				if FFlagDebugAppChatEnableDomLocators then
					createNewChat = React.createElement(Foundation.IconButton, {
						size = Foundation.Enums.InputSize.Medium,
						isCircular = true,
						icon = Foundation.Enums.IconName.PlusLarge,
						testId = DomLocators.chatLandingTopBarIconButton("createChat"),
						LayoutOrder = 2,
						onActivated = onActivated2
					})
				else
					local createElement2 = React.createElement
					local v7 = {
						size = UDim2.new(0, iconButtonWidth, 1, 0),
						icon = 0,
						layoutOrder = 2,
						onActivated = 0
					}
					local icon

					if GetFFlagIsSquadEnabled() then
						icon = Images["icons/common/plus"]
					else
						icon = Images["icons/actions/compose"]
					end

					v7.icon = icon

					v7.onActivated = onActivated2
					createNewChat = createElement2(IconButton, v7)
				end
			end

			local notifications = topBarShowNotifications

			if notifications then
				if FFlagDebugAppChatEnableDomLocators then
					local createElement2 = React.createElement
					local view = Foundation.View
					local v7 = {
						Size = UDim2.new(0, iconButtonWidth, 0, iconButtonWidth),
						tag = "row align-x-center align-y-center radius-circle",
						testId = DomLocators.chatLandingTopBarIconButton("notifications")
					}

					local createElement3 = React.createElement
					local v8 = {
						notificationCount = notificationCount,
						compactWidth = not screenProps2,
						entryPoint = 0,
						onActivated = 0
					}
					local entryPoint

					if FFlagStreamNotificationBellEntryPoint then
						entryPoint = AppPage.Chat
					end

					v8.entryPoint = entryPoint
					local onActivated3

					if FFlagAppChatLandingNotifBtnTelemetry then
						onActivated3 = v5
					end

					v8.onActivated = onActivated3
					notifications = createElement2(view, v7, {
						BellIcon = createElement3(StreamNotificationsBellIcon, v8)
					})
				else
					local createElement2 = React.createElement
					local v7 = {
						notificationCount = notificationCount,
						compactWidth = not screenProps2,
						layoutOrder = 3,
						entryPoint = 0,
						onActivated = 0
					}
					local entryPoint

					if FFlagStreamNotificationBellEntryPoint then
						entryPoint = AppPage.Chat
					end

					v7.entryPoint = entryPoint
					local onActivated3

					if FFlagAppChatLandingNotifBtnTelemetry then
						onActivated3 = v5
					end

					v7.onActivated = onActivated3
					notifications = createElement2(StreamNotificationsBellIcon, v7)
				end
			end

			local snoozeChatNotifications

			if topBarShowSnoozeNotifications then
				snoozeChatNotifications = React.createElement(SnoozeToastNotificationsButton, {
					layoutOrder = 4,
					size = UDim2.new(0, iconButtonWidth, 1, 0)
				})
			end

			return createElement(fragment, nil, {
				filter = filter,
				createNewChat = createNewChat,
				notifications = notifications,
				snoozeChatNotifications = snoozeChatNotifications
			})
		end
	end

	local v7

	if FFlagAppChatLandingNotifBtnTelemetry then
		v7 = v5
	else
		v7 = false
	end

	local renderRight = useCallback(fn2, {
		iconButtonWidth,
		notificationCount,
		onActivated2,
		onActivated,
		v7,
		rightHidden,
		topBarShowCreateChatGroup,
		topBarShowNotifications,
		v6,
		topBarShowSnoozeNotifications,
		screenProps2
	})

	local hideTitle = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() and not screenProps

	local createElement = React.createElement
	local v8 = {
		screenName = screenName,
		navigation = navigation,
		renderRight = nil,
		renderCenter = nil,
		renderLeft = nil,
		hideTitle = nil
	}

	if shouldRenderCenter then
		renderRight = nil
	end

	v8.renderRight = renderRight
	v8.renderCenter = renderCenter

	if not hideTitle then
		renderLeft = nil
	end

	v8.renderLeft = renderLeft
	v8.hideTitle = hideTitle
	return createElement(ChatTopBarBase, v8)
end

return ChatLandingTopBar

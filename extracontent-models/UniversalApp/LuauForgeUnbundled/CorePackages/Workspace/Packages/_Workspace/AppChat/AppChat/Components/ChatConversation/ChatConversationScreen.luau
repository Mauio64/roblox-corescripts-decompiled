local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local readingMessagesIsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/readingMessagesIsEnabled")

local ChatConversationContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Logger")

local fFlagAppChatMomentShareCardNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatMomentShareCardNavigation
local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")
local FFlagAppChatIxpParallelScreenLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpParallelScreenLayers")
local FStringAppChatConversationComposerIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatConversationComposerIxpLayer")

local FStringAppChatConversationPerformanceIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatConversationPerformanceIxpLayer")
local FStringAppChatConversationMessagesIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatConversationMessagesIxpLayer")
local FFlagAppChatMomentShareCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCard")

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local FFlagAppChatFixBackButtonOnRotation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFixBackButtonOnRotation")
local canPopParentStack = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/canPopParentStack")

local function getBackButtonConfig(p2)
	local screenProps = p2.getScreenProps("wideMode", false)

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(p2) then
		return true, false
	end

	return not screenProps, screenProps
end

local extended = Roact.PureComponent:extend("ChatConversationScreen")
extended.defaultProps = { navigation = nil }

function extended.navigationOptions(p2)
	local navigation = p2.navigation
	local v5 = navigation.getScreenProps("wideMode", false)
	local v6

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
		v6 = true
		v5 = false
	else
		v6 = not v5
	end

	return {
		tabBarVisible = false,
		lockIconEnabled = true,
		absorbInput = false,
		backButtonEnabled = v6,
		isRoot = v5
	}
end

function extended:init()
	local v5 = if FFlagAppChatIxpScreenExposure then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		"Party.ConversationPage"
	) else nil
	self.ixpSubscription = v5

	local v6 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatConversationComposerIxpLayer
	) else nil
	self.composerIxpSubscription = v6

	local v7 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatConversationPerformanceIxpLayer
	) else nil
	self.performanceIxpSubscription = v7

	local v8 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatConversationMessagesIxpLayer
	) else nil
	self.messagesIxpSubscription = v8

	self.toastProps = nil
	self.inputBoxRef = Roact.createRef()

	self.lastHeaderText = nil
	self.lastIsPrivateConversation = nil

	local navigation = self.props.navigation
	local v9 = navigation.getParam and navigation.getParam("conversationId", nil)

	function self.navigateToConversationOverlay()
		Logger:info("Navigate To ConversationOverlay: {} from {screen}", v9)
		local v10 = self.props.navigation.getParam and self.props.navigation.getParam("conversationId", nil)
		navigation.navigate(EnumScreens.ConversationOverlay, {
			conversationId = v10,
			isOverlay = true
		})
	end

	function self.navigateToChatDetails()
		local v10 = self.props.navigation.getParam and self.props.navigation.getParam("conversationId", nil)
		Logger:info("Navigate To ChatDetails: {} from {screen}", v10)
		navigation.navigate(EnumScreens.ChatDetails, {
			conversationId = v10,
			isRooted = self.props.navigation.getParam("isRooted", false)
		})
	end

	local screenProps = navigation.getScreenProps("wideMode", false)
	local v10 = navigation.getScreenProps("wideMode", false)
	local v11

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
		v11 = true
		v10 = false
	else
		v11 = not v10
	end

	local setScreenTopBar = GetTopBarStore(false).setScreenTopBar
	local chatConversation = EnumScreens.ChatConversation
	local v12 = {
		navigateToChatDetails = self.navigateToChatDetails,
		conversationId = v9,
		backButtonEnabled = v11,
		isRoot = v10,
		leftPaddingOverride = 0,
		rightPaddingOverride = 0
	}

	local v13 = if screenProps then navigation.getScreenProps("appChatInnerPadding", 12) else navigation.getScreenProps("appChatOuterPadding", 12)
	v12.leftPaddingOverride = v13

	v12.rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	setScreenTopBar(chatConversation, v12)

	function self.writeScreenTopBar()
		local v14

		if self.props.navigation.getParam then
			v14 = self.props.navigation.getParam("conversationId", nil)
		end

		local screenProps2 = self.props.navigation.getScreenProps("wideMode", false)
		local navigation2 = self.props.navigation
		local v15 = navigation2.getScreenProps("wideMode", false)
		local v16

		if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation2) then
			v16 = true
			v15 = false
		else
			v16 = not v15
		end

		local v17 = {
			navigateToChatDetails = self.navigateToChatDetails,
			conversationId = v14,
			backButtonEnabled = v16,
			isRoot = v15,
			leftPaddingOverride = 0,
			rightPaddingOverride = 0
		}

		local v18 = if screenProps2 then self.props.navigation.getScreenProps("appChatInnerPadding", 12) else self.props.navigation.getScreenProps(
			"appChatOuterPadding",
			12
		)
		v17.leftPaddingOverride = v18

		v17.rightPaddingOverride = self.props.navigation.getScreenProps("appChatOuterPadding", 12)

		if self.lastHeaderText ~= nil then
			v17.headerText = self.lastHeaderText
		end

		if self.lastIsPrivateConversation ~= nil then
			v17.isPrivateConversation = self.lastIsPrivateConversation
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, v17)
	end

	function self.queueNavigationToToast(toastProps)
		if not self.props.navigation.isFocused() then
			self.toastProps = toastProps

			return
		end

		self.navigateToToast(toastProps)

		self.toastProps = nil
	end

	function self.onDidFocus()
		self.writeScreenTopBar()

		self.setInputBarCloseCallback(self.releaseFocus)

		if self.toastProps then
			self.navigateToToast(self.toastProps)
			self.toastProps = nil
		end
	end

	function self.releaseFocus()
		if self.inputBoxRef and self.inputBoxRef:getValue() then
			self.inputBoxRef:getValue():ReleaseFocus()
		end
	end

	function self.onWillBlur()
		self.releaseFocus()

		self.setInputBarCloseCallback()
	end

	function self.navigateToToast(p2)
		Logger:info("Navigate To Toast from {screen}")

		self.props.navigation.navigate(
			EnumScreens.RoactChatToast,
			Cryo.Dictionary.union(p2, { isOverlay = true })
		)
	end

	function self.openViewProfile(p2)
		local v14 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if not v14 then
			Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To UserProfile from {screen}")

		v14(p2, {})
	end

	function self.openGameDetailsPage(p2, p3)
		local v14 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.GameDetail]

		if not v14 then
			Logger:warning("GameDetail page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To GameDetail from " .. tostring(p3))

		v14(p2, p3)
	end

	function self.getOpenMomentsImmersive()
		return self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.MomentsImmersive]
	end

	function self.navigateToChatConversation(p2)
		Logger:info("Navigate To Conversation: {} from {screen}", p2)
		self.props.navigation.navigate(EnumScreens.ChatConversation, { conversationId = p2 })
	end

	function self.navigateToScreen(p2, p3, p4)
		Logger:info("Navigate To Screen: {} from {screen}", p2)
		local navigation2 = self.props.navigation
		local v14 = navigation2 and navigation2.getParam and navigation2.getParam("conversationId", nil)

		if p3 then
			self.props.navigation.navigate(
				p2,
				Cryo.Dictionary.union({ conversationId = v14, isOverlay = p4 }, p3)
			)
		else
			self.props.navigation.navigate(p2, { conversationId = v14 })
		end
	end

	function self.navigateBack()
		if self.props.navigation.isFocused() then
			self.props.navigation.goBack()
		end
	end

	function self.navigateToChatLanding()
		Logger:info("Navigate To ChatLanding from {screen}")

		if self.props.navigation.getScreenProps("wideMode", false) then
			self.props.navigation.navigate(EnumScreens.EmptyConversation)
		else
			self.props.navigation.navigate(EnumScreens.ChatLanding)
		end
	end

	function self.navigateToSquadLobby(p2)
		Logger:info("Navigate To SquadLobby from {screen}")
		self.props.navigation.navigate(EnumScreens.SquadLobby, { conversationId = p2 })
	end

	function self.updateConversationTitle(p2)
		local v14 = p2 and { raw = p2, shouldLocalize = false }
			or { raw = "CommonUI.Features.Label.Chat", shouldLocalize = true }

		self.lastHeaderText = v14
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, { headerText = v14 })
	end

	function self.setInputBarCloseCallback(p2)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, { closeInputBar = p2 })
	end

	function self.getReadingMessagesIsEnabled()
		return readingMessagesIsEnabled(self.props.navigation)
	end

	function self.updatePrivateConversationTopBar(lastIsPrivateConversation)
		self.lastIsPrivateConversation = lastIsPrivateConversation
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
			isPrivateConversation = lastIsPrivateConversation
		})
	end
end
function extended:didUpdate(p3)
	local v5 = p3.navigation and p3.navigation.getParam and p3.navigation.getParam("conversationId", nil)
	local v6 = self.props.navigation
		and self.props.navigation.getParam
		and self.props.navigation.getParam("conversationId", nil)

	if v5 ~= v6 then
		self.lastHeaderText = nil
		self.lastIsPrivateConversation = nil
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, { conversationId = v6 })
	end
end

function extended.render(props)
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in ChatConversationScreen")
	local v5

	if FFlagAppChatMomentShareCard and fFlagAppChatMomentShareCardNavigation then
		v5 = props.getOpenMomentsImmersive()
	end

	local element = Roact.createElement(RoactNavigation.NavigationEvents, {
		onDidFocus = props.onDidFocus,
		onWillBlur = props.onWillBlur
	})

	local param = notNil.getParam("conversationId", nil)
	local v6 = param and tostring(param) or nil

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		container = Roact.createElement(ChatConversationContainer, {
			topBarHeight = notNil.getScreenProps("topBarHeight", 0),
			wideMode = notNil.getScreenProps("wideMode", false),
			openGameDetailsPage = props.openGameDetailsPage,
			openMomentsDeepLink = v5,
			getReadingMessagesIsEnabled = props.getReadingMessagesIsEnabled,
			conversationId = v6,
			inputBoxRef = props.inputBoxRef,
			updateConversationTitle = props.updateConversationTitle,
			updatePrivateConversationTopBar = props.updatePrivateConversationTopBar,
			releaseInputBarFocus = props.releaseFocus,
			navigateBack = props.navigateBack,
			navigateToToast = props.queueNavigationToToast,
			openViewProfile = props.openViewProfile,
			navigateToChatConversation = props.navigateToChatConversation,
			navigateToChatLanding = props.navigateToChatLanding,
			navigateToScreen = props.navigateToScreen,
			navigateToSquadLobby = props.navigateToSquadLobby,
			navigateToConversationOverlay = props.navigateToConversationOverlay,
			navigation = props.props.navigation
		}),
		eventsAdapter = element
	})
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")
	local navigation = p2.props.navigation
	local screenProps = navigation.getScreenProps("wideMode", false)
	local setScreenTopBar = GetTopBarStore(false).setScreenTopBar
	local chatConversation = EnumScreens.ChatConversation

	local v6 = if screenProps then navigation.getScreenProps("appChatInnerPadding", 12) else navigation.getScreenProps("appChatOuterPadding", 12)
	setScreenTopBar(chatConversation, {
		leftPaddingOverride = v6,
		rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	})
end

function extended.willUnmount(data)
	GetTopBarStore(false).clearScreenTopBar(EnumScreens.ChatConversation)

	if data.ixpSubscription then
		data.ixpSubscription.remove()
	end

	if data.composerIxpSubscription then
		data.composerIxpSubscription.remove()
	end

	if data.performanceIxpSubscription then
		data.performanceIxpSubscription.remove()
	end

	if data.messagesIxpSubscription then
		data.messagesIxpSubscription.remove()
	end
end

return extended

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(parent.ArgCheck)
local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)
local Cryo = require(parent.Cryo)

local readingMessagesIsEnabled = require(script.Parent.Utils.readingMessagesIsEnabled)

local ChatConversationContainer = require(script.Parent.ChatConversationContainer)
local Logger = require(script.Parent.Logger)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatMomentShareCardNavigation = SharedFlags.FFlagAppChatMomentShareCardNavigation
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local FFlagAppChatIxpParallelScreenLayers = require(AppChat.Flags.FFlagAppChatIxpParallelScreenLayers)
local FStringAppChatConversationComposerIxpLayer = require(AppChat.Flags.FStringAppChatConversationComposerIxpLayer)

local FStringAppChatConversationPerformanceIxpLayer = require(AppChat.Flags.FStringAppChatConversationPerformanceIxpLayer)
local FStringAppChatConversationMessagesIxpLayer = require(AppChat.Flags.FStringAppChatConversationMessagesIxpLayer)
local FFlagAppChatMomentShareCard = require(AppChat.Flags.FFlagAppChatMomentShareCard)

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local FFlagAppChatFixBackButtonOnRotation = require(AppChat.Flags.FFlagAppChatFixBackButtonOnRotation)
local canPopParentStack = require(AppChat.Utils.canPopParentStack)

local function getBackButtonConfig(navigation) -- 3 equivalent calls inferred from this helper
	local screenProps = navigation.getScreenProps("wideMode", false)

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
		return true, false
	end

	return not screenProps, screenProps
end

local extended = Roact.PureComponent:extend("ChatConversationScreen")
extended.defaultProps = { navigation = nil }

function extended.navigationOptions(p)
	local backButtonConfig, isRoot = getBackButtonConfig(p.navigation) -- inferred equivalent call

	return {
		tabBarVisible = false,
		lockIconEnabled = true,
		absorbInput = false,
		backButtonEnabled = backButtonConfig,
		isRoot = isRoot
	}
end

function extended:init()
	local ixpSubscription

	if FFlagAppChatIxpScreenExposure then
		ixpSubscription = IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.ConversationPage")
	end

	self.ixpSubscription = ixpSubscription
	local composerIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		composerIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatConversationComposerIxpLayer
		)
	end

	self.composerIxpSubscription = composerIxpSubscription
	local performanceIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		performanceIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatConversationPerformanceIxpLayer
		)
	end

	self.performanceIxpSubscription = performanceIxpSubscription
	local messagesIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		messagesIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatConversationMessagesIxpLayer
		)
	end

	self.messagesIxpSubscription = messagesIxpSubscription

	self.toastProps = nil
	self.inputBoxRef = Roact.createRef()

	self.lastHeaderText = nil
	self.lastIsPrivateConversation = nil

	local navigation = self.props.navigation
	local conversationId = navigation.getParam and navigation.getParam("conversationId", nil)

	function self.navigateToConversationOverlay()
		Logger:info("Navigate To ConversationOverlay: {} from {screen}", conversationId)
		local conversationId2 = self.props.navigation.getParam and self.props.navigation.getParam("conversationId", nil)
		navigation.navigate(EnumScreens.ConversationOverlay, {
			conversationId = conversationId2,
			isOverlay = true
		})
	end

	function self.navigateToChatDetails()
		local conversationId2 = self.props.navigation.getParam and self.props.navigation.getParam("conversationId", nil)
		Logger:info("Navigate To ChatDetails: {} from {screen}", conversationId2)
		local v = getFFlagAppChatEnableRootedNavigation()
			and {
				conversationId = conversationId2,
				isRooted = self.props.navigation.getParam("isRooted", false)
			}
			or { conversationId = conversationId2 }
		navigation.navigate(EnumScreens.ChatDetails, v)
	end

	local screenProps = navigation.getScreenProps("wideMode", false)
	local backButtonConfig, isRoot = getBackButtonConfig(navigation) -- inferred equivalent call
	local setScreenTopBar = GetTopBarStore(false).setScreenTopBar
	local chatConversation = EnumScreens.ChatConversation
	local v = {
		navigateToChatDetails = self.navigateToChatDetails,
		conversationId = conversationId,
		backButtonEnabled = backButtonConfig,
		isRoot = isRoot,
		leftPaddingOverride = 0,
		rightPaddingOverride = 0
	}
	local leftPaddingOverride

	if screenProps then
		leftPaddingOverride = navigation.getScreenProps("appChatInnerPadding", 12)
	else
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	end

	v.leftPaddingOverride = leftPaddingOverride

	v.rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	setScreenTopBar(chatConversation, v)

	function self.writeScreenTopBar()
		local conversationId2

		if self.props.navigation.getParam then
			conversationId2 = self.props.navigation.getParam("conversationId", nil)
		end

		local screenProps2 = self.props.navigation.getScreenProps("wideMode", false)
		local backButtonConfig2, isRoot2 = getBackButtonConfig(self.props.navigation) -- inferred equivalent call
		local v2 = {
			navigateToChatDetails = self.navigateToChatDetails,
			conversationId = conversationId2,
			backButtonEnabled = backButtonConfig2,
			isRoot = isRoot2,
			leftPaddingOverride = 0,
			rightPaddingOverride = 0
		}
		local leftPaddingOverride2

		if screenProps2 then
			leftPaddingOverride2 = self.props.navigation.getScreenProps("appChatInnerPadding", 12)
		else
			leftPaddingOverride2 = self.props.navigation.getScreenProps("appChatOuterPadding", 12)
		end

		v2.leftPaddingOverride = leftPaddingOverride2

		v2.rightPaddingOverride = self.props.navigation.getScreenProps("appChatOuterPadding", 12)

		if self.lastHeaderText ~= nil then
			v2.headerText = self.lastHeaderText
		end

		if self.lastIsPrivateConversation ~= nil then
			v2.isPrivateConversation = self.lastIsPrivateConversation
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, v2)
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

	function self.navigateToToast(p)
		Logger:info("Navigate To Toast from {screen}")

		self.props.navigation.navigate(EnumScreens.RoactChatToast, Cryo.Dictionary.union(p, {
			isOverlay = true
		}))
	end

	function self.openViewProfile(p)
		local v2 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if not v2 then
			Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To UserProfile from {screen}")

		v2(p, {})
	end

	function self.openGameDetailsPage(p, p2)
		local v2 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.GameDetail]

		if not v2 then
			Logger:warning("GameDetail page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To GameDetail from " .. tostring(p2))

		v2(p, p2)
	end

	function self.getOpenMomentsImmersive()
		return self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.MomentsImmersive]
	end

	function self.navigateToChatConversation(conversationId2)
		Logger:info("Navigate To Conversation: {} from {screen}", conversationId2)
		self.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = conversationId2
		})
	end

	function self.navigateToScreen(p, p2, isOverlay)
		Logger:info("Navigate To Screen: {} from {screen}", p)
		local navigation2 = self.props.navigation
		local conversationId2 = navigation2 and navigation2.getParam and navigation2.getParam("conversationId", nil)

		if p2 then
			self.props.navigation.navigate(
				p,
				Cryo.Dictionary.union({ conversationId = conversationId2, isOverlay = isOverlay }, p2)
			)
		else
			self.props.navigation.navigate(p, { conversationId = conversationId2 })
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

	function self.navigateToSquadLobby(conversationId2)
		Logger:info("Navigate To SquadLobby from {screen}")
		self.props.navigation.navigate(EnumScreens.SquadLobby, { conversationId = conversationId2 })
	end

	function self.updateConversationTitle(raw)
		local v2 = raw and { raw = raw, shouldLocalize = false }
			or { raw = "CommonUI.Features.Label.Chat", shouldLocalize = true }

		self.lastHeaderText = v2
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, { headerText = v2 })
	end

	function self.setInputBarCloseCallback(closeInputBar)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
			closeInputBar = closeInputBar
		})
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
function extended:didUpdate(p)
	local v = p.navigation and p.navigation.getParam and p.navigation.getParam("conversationId", nil)
	local conversationId = self.props.navigation
		and self.props.navigation.getParam
		and self.props.navigation.getParam("conversationId", nil)

	if v ~= conversationId then
		self.lastHeaderText = nil
		self.lastIsPrivateConversation = nil
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
			conversationId = conversationId
		})
	end
end

function extended.render(props)
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in ChatConversationScreen")
	local openMomentsDeepLink

	if FFlagAppChatMomentShareCard and FFlagAppChatMomentShareCardNavigation then
		openMomentsDeepLink = props.getOpenMomentsImmersive()
	end

	local element = Roact.createElement(RoactNavigation.NavigationEvents, {
		onDidFocus = props.onDidFocus,
		onWillBlur = props.onWillBlur
	})

	local param = notNil.getParam("conversationId", nil)
	local conversationId = param and tostring(param) or nil

	return Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		container = Roact.createElement(ChatConversationContainer, {
			topBarHeight = notNil.getScreenProps("topBarHeight", 0),
			wideMode = notNil.getScreenProps("wideMode", false),
			openGameDetailsPage = props.openGameDetailsPage,
			openMomentsDeepLink = openMomentsDeepLink,
			getReadingMessagesIsEnabled = props.getReadingMessagesIsEnabled,
			conversationId = conversationId,
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

function extended.didMount(p)
	Logger:info("{screen} mounted")
	local navigation = p.props.navigation
	local screenProps = navigation.getScreenProps("wideMode", false)
	local setScreenTopBar = GetTopBarStore(false).setScreenTopBar
	local chatConversation = EnumScreens.ChatConversation
	local leftPaddingOverride

	if screenProps then
		leftPaddingOverride = navigation.getScreenProps("appChatInnerPadding", 12)
	else
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	end

	setScreenTopBar(chatConversation, {
		leftPaddingOverride = leftPaddingOverride,
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

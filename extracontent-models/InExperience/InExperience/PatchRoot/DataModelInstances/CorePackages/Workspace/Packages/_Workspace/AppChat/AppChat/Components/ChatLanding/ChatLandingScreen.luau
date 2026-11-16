local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local TopBarProvider = require(AppChat.TopBarProvider)
local ArgCheck = require(parent.ArgCheck)
local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local ChatLandingContainer = require(script.Parent.ChatLandingContainer)
local Logger = require(script.Parent.Logger)
local getCurrentRoute = require(script.Parent.Utils.getCurrentRoute)
local ChatSearchBox = require(script.Parent.ChatSearchBox)
local CheckAndOpenChatPushUpsell = require(script.Parent.CheckAndOpenChatPushUpsell)

local resetForSquadLobbyForCompactMode = require(AppChat.Utils.resetForSquadLobbyForCompactMode)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePartyQuickStartButton = SharedFlags2.FFlagEnablePartyQuickStartButton

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnablePushNotificationsUpsellModalChat = SharedFlags3.GetFFlagEnablePushNotificationsUpsellModalChat
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags4.FFlagEnableHeaderBarButtonsUpdate
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local FFlagAppChatIxpParallelScreenLayers = require(AppChat.Flags.FFlagAppChatIxpParallelScreenLayers)

local FStringAppChatLandingConversationRowsIxpLayer = require(AppChat.Flags.FStringAppChatLandingConversationRowsIxpLayer)

local FStringAppChatLandingConversationListIxpLayer = require(AppChat.Flags.FStringAppChatLandingConversationListIxpLayer)
local FStringAppChatLandingPerformanceIxpLayer = require(AppChat.Flags.FStringAppChatLandingPerformanceIxpLayer)

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)

local extended = Roact.PureComponent:extend("ChatLandingScreen")
extended.defaultProps = { navigation = nil }

function extended.navigationOptions(p)
	local navigation = p.navigation
	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)

	local screenProps2 = navigation.getScreenProps("isInExperience", false)

	local v = GetFFlagEnableAppChatInExperience() and screenProps2
	local rightPaddingOverride

	if navigation.getScreenProps("wideMode", false) then
		rightPaddingOverride = navigation.getScreenProps("appChatInnerPadding", 12)
	else
		rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	end

	if FFlagEnableHeaderBarButtonsUpdate then
		rightPaddingOverride -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	return {
		headerText = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} or { raw = "Feature.Squads.Label.Party", shouldLocalize = true },
		backButtonEnabled = false,
		closeButtonEnabled = v and (screenProps and true or false),
		tabBarVisible = not screenProps or nil,
		isRoot = true,
		isTitleLeftAligned = true,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = rightPaddingOverride,
		shouldBoldHeader = true
	}
end

function extended:init()
	local ixpSubscription

	if FFlagAppChatIxpScreenExposure then
		ixpSubscription = IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.LandingPage")
	end

	self.ixpSubscription = ixpSubscription
	local conversationRowsIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		conversationRowsIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatLandingConversationRowsIxpLayer
		)
	end

	self.conversationRowsIxpSubscription = conversationRowsIxpSubscription
	local conversationListIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		conversationListIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatLandingConversationListIxpLayer
		)
	end

	self.conversationListIxpSubscription = conversationListIxpSubscription
	local performanceIxpSubscription

	if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then
		performanceIxpSubscription = IXPNavigationUtils.registerExposureOnFocus(
			self.props.navigation,
			FStringAppChatLandingPerformanceIxpLayer
		)
	end

	self.performanceIxpSubscription = performanceIxpSubscription

	function self.navigateToConversation(conversationId)
		Logger:info("Navigate To Conversation: {} from {screen}", conversationId)
		self.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = conversationId,
			navigatedWithFocus = false
		})

		self.resetScreenTopBar()
	end

	function self.navigateToCreateChat()
		Logger:info("Navigate To CreateNewChat from {screen}")
		self.props.navigation.push(EnumScreens.CreateNewChat)
	end

	function self.navigateToToast(p)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p)
	end

	function self.navigateToPrivacy()
		local v = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if not v then
			Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To PrivacySettings from {screen}")
		v()
	end

	function self.navigateToSquadLobby(conversationId)
		Logger:info("Navigate To SquadLobby from {screen}")
		local currentRoute = getCurrentRoute(self.props.navigation.state)

		if
			currentRoute
			and currentRoute.params
			and currentRoute.params.conversationId == conversationId
			and currentRoute.routeName == EnumScreens.ChatConversation
		then
			self.props.navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = conversationId
			})
		elseif FFlagEnablePartyQuickStartButton then
			resetForSquadLobbyForCompactMode(self.props.navigation, conversationId)
		else
			self.props.navigation.reset(
				{
					RoactNavigation.Actions.navigate({ routeName = EnumScreens.ChatLanding }),
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.ChatConversation,
						params = { conversationId = conversationId }
					}),
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.SquadLobby,
						params = { conversationId = conversationId }
					})
				},
				3
			)
		end
	end

	function self.setScreenTopBar(p)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p)
	end

	function self.resetScreenTopBar()
		local v = GetTopBarStore(false).getScreenTopBar(EnumScreens.ChatLanding)(false) or {}

		if v.filterText == "" and v.shouldRenderCenter then
			self.setScreenTopBar({ shouldRenderCenter = false, isSecondary = false })
		end
	end
end

function extended.render(props)
	Logger:info("{screen} render")
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in ChatLandingScreen")
	local v = notNil and notNil.getParam("key", "") or ""
	local screenProps = notNil.getScreenProps("showSearchRow", true)
	local screenProps2 = notNil.getScreenProps("topBarHeight", 0)

	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p)
			local screenTopBar = p.getScreenTopBar(EnumScreens.ChatLanding)
			ArgCheck.isType(screenTopBar, "table", "screenTopBar")

			local element = Roact.createElement(ChatLandingContainer, {
				isShowingFilterBox = screenTopBar.shouldRenderCenter or screenProps,
				filterText = screenTopBar.filterText,
				topBarHeight = notNil.getScreenProps("topBarHeight", 0),
				navigateToAddFriends = props.props.navigation.getScreenProps("navigateToAddFriends", {}),
				navigateToConversation = props.navigateToConversation,
				navigateToCreateChat = props.navigateToCreateChat,
				navigateToPrivacy = props.navigateToPrivacy,
				navigateToSquadLobby = props.navigateToSquadLobby,
				navigateToToast = props.navigateToToast,
				key = "ChatLanding" .. v
			})

			if screenProps then
				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						VerticalFlex = Enum.UIFlexAlignment.Fill,
						Padding = UDim.new(0, 0)
					}),
					ChatSearchBox = Roact.createElement(ChatSearchBox, {
						height = screenProps2,
						initialText = screenTopBar.filterText,
						onFilter = function(filterText)
							p.setScreenTopBar(EnumScreens.ChatLanding, { filterText = filterText })
						end
					}),
					element
				})
			end

			if GetFFlagEnablePushNotificationsUpsellModalChat() then
				return Roact.createFragment({
					element,
					CheckAndOpenChatPushUpsell = Roact.createElement(CheckAndOpenChatPushUpsell)
				})
			end

			return element
		end
	})
end

function extended.didMount(p)
	Logger:info("{screen} mounted")

	local navigation = p.props.navigation
	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)
	local screenProps2 = navigation.getScreenProps("isInExperience", false)

	local v = GetFFlagEnableAppChatInExperience() and screenProps2
	local rightPaddingOverride

	if navigation.getScreenProps("wideMode", false) then
		rightPaddingOverride = navigation.getScreenProps("appChatInnerPadding", 12)
	else
		rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	end

	if SharedFlags4.FFlagEnableHeaderBarButtonsUpdate then
		rightPaddingOverride -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local headerText = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and { raw = "CommonUI.Features.Label.Chat", shouldLocalize = true }
		or { raw = "Feature.Squads.Label.Party", shouldLocalize = true }

	p.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = "",
		headerText = headerText,
		backButtonEnabled = false,
		closeButtonEnabled = v and (screenProps and true or false),
		isRoot = true,
		isTitleLeftAligned = true,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = rightPaddingOverride,
		shouldBoldHeader = true
	})
end

function extended.willUnmount(data)
	if data.ixpSubscription then
		data.ixpSubscription.remove()
	end

	if data.conversationRowsIxpSubscription then
		data.conversationRowsIxpSubscription.remove()
	end

	if data.conversationListIxpSubscription then
		data.conversationListIxpSubscription.remove()
	end

	if data.performanceIxpSubscription then
		data.performanceIxpSubscription.remove()
	end
end

return extended

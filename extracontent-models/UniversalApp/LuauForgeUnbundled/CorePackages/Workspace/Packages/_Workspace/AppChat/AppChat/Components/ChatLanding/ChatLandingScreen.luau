local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local TopBarProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/TopBarProvider")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")

local ChatLandingContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger")
local getCurrentRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getCurrentRoute")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatSearchBox")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/CheckAndOpenChatPushUpsell")

local resetForSquadLobbyForCompactMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/resetForSquadLobbyForCompactMode")

local getFFlagEnableAppChatInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnableAppChatInExperience
local fFlagEnablePartyQuickStartButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnablePartyQuickStartButton

local getFFlagEnablePushNotificationsUpsellModalChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnablePushNotificationsUpsellModalChat
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")
local FFlagAppChatIxpParallelScreenLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpParallelScreenLayers")

local FStringAppChatLandingConversationRowsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatLandingConversationRowsIxpLayer")

local FStringAppChatLandingConversationListIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatLandingConversationListIxpLayer")
local FStringAppChatLandingPerformanceIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatLandingPerformanceIxpLayer")

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")

local extended = Roact.PureComponent:extend("ChatLandingScreen")
extended.defaultProps = { navigation = nil }

function extended.navigationOptions(p2)
	local navigation = p2.navigation
	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)

	local screenProps2 = navigation.getScreenProps("isInExperience", false)

	local v6 = getFFlagEnableAppChatInExperience() and screenProps2
	local v7

	if navigation.getScreenProps("wideMode", false) then
		v7 = navigation.getScreenProps("appChatInnerPadding", 12)
	else
		v7 = navigation.getScreenProps("appChatOuterPadding", 12)
	end

	if fFlagEnableHeaderBarButtonsUpdate then
		v7 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	return {
		headerText = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} or { raw = "Feature.Squads.Label.Party", shouldLocalize = true },
		backButtonEnabled = false,
		closeButtonEnabled = v6 and (screenProps and true or false),
		tabBarVisible = not screenProps or nil,
		isRoot = true,
		isTitleLeftAligned = true,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = v7,
		shouldBoldHeader = true
	}
end

function extended:init()
	local v5 = if FFlagAppChatIxpScreenExposure then IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.LandingPage") else nil
	self.ixpSubscription = v5

	local v6 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatLandingConversationRowsIxpLayer
	) else nil
	self.conversationRowsIxpSubscription = v6

	local v7 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatLandingConversationListIxpLayer
	) else nil
	self.conversationListIxpSubscription = v7

	local v8 = if FFlagAppChatIxpScreenExposure and FFlagAppChatIxpParallelScreenLayers then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		FStringAppChatLandingPerformanceIxpLayer
	) else nil
	self.performanceIxpSubscription = v8

	function self.navigateToConversation(p2)
		Logger:info("Navigate To Conversation: {} from {screen}", p2)
		self.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p2,
			navigatedWithFocus = false
		})

		self.resetScreenTopBar()
	end

	function self.navigateToCreateChat()
		Logger:info("Navigate To CreateNewChat from {screen}")
		self.props.navigation.push(EnumScreens.CreateNewChat)
	end

	function self.navigateToToast(p2)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p2)
	end

	function self.navigateToPrivacy()
		local v9 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.PrivacySettings]

		if not v9 then
			Logger:warning("PrivacySettings page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To PrivacySettings from {screen}")
		v9()
	end

	function self.navigateToSquadLobby(p2)
		Logger:info("Navigate To SquadLobby from {screen}")
		local v9 = getCurrentRoute(self.props.navigation.state)

		if
			v9
			and v9.params
			and v9.params.conversationId == p2
			and v9.routeName == EnumScreens.ChatConversation
		then
			self.props.navigation.navigate(EnumScreens.SquadLobby, { conversationId = p2 })
		elseif fFlagEnablePartyQuickStartButton then
			resetForSquadLobbyForCompactMode(self.props.navigation, p2)
		else
			self.props.navigation.reset(
				{
					RoactNavigation.Actions.navigate({ routeName = EnumScreens.ChatLanding }),
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.ChatConversation,
						params = { conversationId = p2 }
					}),
					RoactNavigation.Actions.navigate({
						routeName = EnumScreens.SquadLobby,
						params = { conversationId = p2 }
					})
				},
				3
			)
		end
	end

	function self.setScreenTopBar(p2)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, p2)
	end

	function self.resetScreenTopBar()
		local v9 = GetTopBarStore(false).getScreenTopBar(EnumScreens.ChatLanding)(false) or {}

		if v9.filterText == "" and v9.shouldRenderCenter then
			self.setScreenTopBar({ shouldRenderCenter = false, isSecondary = false })
		end
	end
end

function extended.render(props)
	Logger:info("{screen} render")
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in ChatLandingScreen")
	local v5 = notNil and notNil.getParam("key", "") or ""
	local screenProps = notNil.getScreenProps("showSearchRow", true)
	local screenProps2 = notNil.getScreenProps("topBarHeight", 0)

	return Roact.createElement(TopBarProvider, {
		screenName = EnumScreens.ChatLanding,
		render = function(p2)
			local screenTopBar = p2.getScreenTopBar(EnumScreens.ChatLanding)
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
				key = "ChatLanding" .. v5
			})

			if screenProps then
				return Roact.createElement(
					"Frame",
					{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
					{
						UIListLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							VerticalFlex = Enum.UIFlexAlignment.Fill,
							Padding = UDim.new(0, 0)
						}),
						ChatSearchBox = Roact.createElement(module10, {
							height = screenProps2,
							initialText = screenTopBar.filterText,
							onFilter = function(p3)
								p2.setScreenTopBar(EnumScreens.ChatLanding, {
									filterText = p3
								})
							end
						}),
						element
					}
				)
			end

			if getFFlagEnablePushNotificationsUpsellModalChat() then
				return Roact.createFragment({
					element,
					CheckAndOpenChatPushUpsell = Roact.createElement(module11)
				})
			end

			return element
		end
	})
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")

	local navigation = p2.props.navigation
	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)
	local screenProps2 = navigation.getScreenProps("isInExperience", false)

	local v6 = getFFlagEnableAppChatInExperience() and screenProps2
	local v7

	if navigation.getScreenProps("wideMode", false) then
		v7 = navigation.getScreenProps("appChatInnerPadding", 12)
	else
		v7 = navigation.getScreenProps("appChatOuterPadding", 12)
	end

	if SharedFlags.FFlagEnableHeaderBarButtonsUpdate then
		v7 -= navigation.getScreenProps("topBarUtilityIconSideMargin", 0)
	end

	local v8 = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and { raw = "CommonUI.Features.Label.Chat", shouldLocalize = true }
		or { raw = "Feature.Squads.Label.Party", shouldLocalize = true }

	p2.setScreenTopBar({
		shouldRenderCenter = false,
		filterText = "",
		headerText = v8,
		backButtonEnabled = false,
		closeButtonEnabled = v6 and (screenProps and true or false),
		isRoot = true,
		isTitleLeftAligned = true,
		leftPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12),
		rightPaddingOverride = v7,
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

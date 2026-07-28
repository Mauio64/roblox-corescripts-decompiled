local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(AppChatParent.Roact)
local ChatDetailsContainer = require(script.Parent.ChatDetailsContainer)
local ChatDetailsNavigationOptions = require(script.Parent.ChatDetailsNavigationOptions)
local Logger = require(script.Parent.Logger)
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local v16 = Roact.PureComponent:extend("ChatDetailsScreen")

v16.defaultProps = {
	navigation = nil
}

local function navigationOptions() -- line: 25
	-- upvalues: ChatDetailsNavigationOptions (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	return {
		headerText = ChatDetailsNavigationOptions.getHeaderText(),
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsTopBarActionButton("back")
	}
end

v16.navigationOptions = if not getFFlagAppChatEnableRootedNavigation() then navigationOptions else ChatDetailsNavigationOptions.getNavigationOptions

function v16.init(p1) -- line: 37
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), Logger (copy), EnumScreens (copy), getFFlagAppChatEnableRootedNavigation (copy)
	p1.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p1.props.navigation, "Party.ChatDetailsPage")

	function p1.navigateToEditChatMembers(p2) -- line: 42
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To EditChatMembers from {screen}")
		p1.props.navigation.navigate(EnumScreens.EditChatMembers, {
			conversation = p2
		})
	end
	function p1.navigateToToast(p3) -- line: 47
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p1.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end
	function p1.navigateToDialog(p4, p5) -- line: 52
		-- upvalues: Logger (copy), p1 (copy)
		Logger:info("Navigate To {} from {screen}", p4)
		p1.props.navigation.navigate(p4, p5)
	end

	if getFFlagAppChatEnableRootedNavigation() then
		function p1.closeRootedChatDetails() -- line: 58
			-- upvalues: p1 (copy)
			local v28 = p1.props.navigation.getScreenProps("navigateToRootStack", nil)

			if v28 then
				v28()

				return
			end

			if p1.props.navigation.isFocused() then
				p1.props.navigation.goBack()
			end
		end
	end

	function p1.navigateBack() -- line: 68
		-- upvalues: p1 (copy), getFFlagAppChatEnableRootedNavigation (copy)
		if p1.props.navigation.isFocused() then
			if getFFlagAppChatEnableRootedNavigation() and p1.props.navigation.getParam("isRooted", false) then
				p1.closeRootedChatDetails()

				return
			end

			p1.props.navigation.goBack()
		end
	end
	function p1.navigateToConversation(p6) -- line: 78
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation from {screen}")
		p1.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p6
		})
	end
	function p1.navigateToChatLanding() -- line: 83
		-- upvalues: Logger (copy), getFFlagAppChatEnableRootedNavigation (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To ChatLanding from {screen}")

		if getFFlagAppChatEnableRootedNavigation() and p1.props.navigation.getParam("isRooted", false) then
			p1.closeRootedChatDetails()

			return
		end

		if p1.props.navigation.getScreenProps("wideMode", false) then
			p1.props.navigation.navigate(EnumScreens.EmptyConversation)

			return
		end

		p1.props.navigation.navigate(EnumScreens.ChatLanding)
	end
end
function v16.render(p7) -- line: 99
	-- upvalues: Logger (copy), Roact (copy), ChatDetailsContainer (copy)
	local navigation = p7.props.navigation

	assert(type(navigation) ~= "nil", "ChatDetailsScreen should be wrapped with Roact Navigation")

	local v21 = navigation.getParam("conversationId", nil)

	if v21 == nil then
		Logger:warning("ConversationId is required to open {screen}")

		return nil
	end

	return Roact.createElement(ChatDetailsContainer, {
		topBarHeight = navigation.getScreenProps("topBarHeight", 0),
		wideMode = navigation.getScreenProps("wideMode", false),
		conversationId = v21,
		navigateBack = p7.navigateBack,
		navigateToEditChatMembers = p7.navigateToEditChatMembers,
		navigateToDialog = p7.navigateToDialog,
		navigateToToast = p7.navigateToToast,
		navigateToConversation = p7.navigateToConversation,
		navigateToChatLanding = p7.navigateToChatLanding
	})
end
function v16.didMount(p8) -- line: 122
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ChatDetailsNavigationOptions (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatDetails, ChatDetailsNavigationOptions.getTopBarConfig(p8.props.navigation))
	end
end
function v16.willUnmount(p9) -- line: 133
	if p9.ixpSubscription then
		p9.ixpSubscription.remove()
	end
end

return v16

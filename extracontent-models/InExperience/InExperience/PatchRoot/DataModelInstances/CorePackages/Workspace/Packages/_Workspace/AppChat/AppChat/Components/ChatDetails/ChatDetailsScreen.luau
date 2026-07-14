local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local RoactRodux = require(AppChatParent.RoactRodux)
local ChatDetailsContainer = require(script.Parent.ChatDetailsContainer)
local ChatDetailsNavigationOptions = require(script.Parent.ChatDetailsNavigationOptions)
local Logger = require(script.Parent.Logger)
local Conversation = require(AppChat.Models.Conversation)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatOpenChatIxpEnabled = require(AppChat.Flags.FFlagAppChatOpenChatIxpEnabled)
local FStringAppChatOpenChatIxpLayer = require(AppChat.Flags.FStringAppChatOpenChatIxpLayer)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local v20 = Roact.PureComponent:extend("ChatDetailsScreen")

v20.defaultProps = {
	navigation = nil
}

local function navigationOptions() -- line: 28
	-- upvalues: ChatDetailsNavigationOptions (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	return {
		headerText = ChatDetailsNavigationOptions.getHeaderText(),
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsTopBarActionButton("back")
	}
end

v20.navigationOptions = if not getFFlagAppChatEnableRootedNavigation() then navigationOptions else ChatDetailsNavigationOptions.getNavigationOptions

function v20.init(p1) -- line: 40
	-- upvalues: FFlagAppChatOpenChatIxpEnabled (copy), RoactNavigation (copy), IXPService (copy), FStringAppChatOpenChatIxpLayer (copy), Logger (copy), EnumScreens (copy), getFFlagAppChatEnableRootedNavigation (copy)
	p1.ixpSubscription = if not FFlagAppChatOpenChatIxpEnabled then nil else p1.props.navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 45
		-- upvalues: p1 (copy), IXPService (copy), FStringAppChatOpenChatIxpLayer (copy)
		if p1.props.isGroupConversation then
			IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatOpenChatIxpLayer)
		end
	end)

	function p1.navigateToEditChatMembers(p2) -- line: 52
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To EditChatMembers from {screen}")
		p1.props.navigation.navigate(EnumScreens.EditChatMembers, {
			conversation = p2
		})
	end
	function p1.navigateToToast(p3) -- line: 57
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p1.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end
	function p1.navigateToDialog(p4, p5) -- line: 62
		-- upvalues: Logger (copy), p1 (copy)
		Logger:info("Navigate To {} from {screen}", p4)
		p1.props.navigation.navigate(p4, p5)
	end

	if getFFlagAppChatEnableRootedNavigation() then
		function p1.closeRootedChatDetails() -- line: 68
			-- upvalues: p1 (copy)
			local v36 = p1.props.navigation.getScreenProps("navigateToRootStack", nil)

			if v36 then
				v36()

				return
			end

			if p1.props.navigation.isFocused() then
				p1.props.navigation.goBack()
			end
		end
	end

	function p1.navigateBack() -- line: 78
		-- upvalues: p1 (copy), getFFlagAppChatEnableRootedNavigation (copy)
		if p1.props.navigation.isFocused() then
			if getFFlagAppChatEnableRootedNavigation() and p1.props.navigation.getParam("isRooted", false) then
				p1.closeRootedChatDetails()

				return
			end

			p1.props.navigation.goBack()
		end
	end
	function p1.navigateToConversation(p6) -- line: 88
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation from {screen}")
		p1.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p6
		})
	end
	function p1.navigateToChatLanding() -- line: 93
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
function v20.render(p7) -- line: 109
	-- upvalues: Logger (copy), Roact (copy), ChatDetailsContainer (copy)
	local navigation = p7.props.navigation

	assert(type(navigation) ~= "nil", "ChatDetailsScreen should be wrapped with Roact Navigation")

	local v25 = navigation.getParam("conversationId", nil)

	if v25 == nil then
		Logger:warning("ConversationId is required to open {screen}")

		return nil
	end

	return Roact.createElement(ChatDetailsContainer, {
		topBarHeight = navigation.getScreenProps("topBarHeight", 0),
		wideMode = navigation.getScreenProps("wideMode", false),
		conversationId = v25,
		navigateBack = p7.navigateBack,
		navigateToEditChatMembers = p7.navigateToEditChatMembers,
		navigateToDialog = p7.navigateToDialog,
		navigateToToast = p7.navigateToToast,
		navigateToConversation = p7.navigateToConversation,
		navigateToChatLanding = p7.navigateToChatLanding
	})
end
function v20.didMount(p8) -- line: 132
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ChatDetailsNavigationOptions (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatDetails, ChatDetailsNavigationOptions.getTopBarConfig(p8.props.navigation))
	end
end
function v20.willUnmount(p9) -- line: 143
	-- upvalues: FFlagAppChatOpenChatIxpEnabled (copy)
	if FFlagAppChatOpenChatIxpEnabled then
		p9.ixpSubscription.remove()
	end
end

if FFlagAppChatOpenChatIxpEnabled then
	v20 = RoactRodux.connect(function(p10, p11) -- line: 153
		-- upvalues: Conversation (copy)
		local v30 = p11.navigation.getParam("conversationId")
		local v31 = p10.ChatAppReducer.Conversations[v30]

		return {
			isGroupConversation = v31 ~= nil and v31.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		}
	end)(v20)
	v20.navigationOptions = if not getFFlagAppChatEnableRootedNavigation() then navigationOptions else ChatDetailsNavigationOptions.getNavigationOptions
end

return v20

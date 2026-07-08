local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local RoactRodux = require(AppChatParent.RoactRodux)
local ChatDetailsContainer = require(script.Parent.ChatDetailsContainer)
local Logger = require(script.Parent.Logger)
local Conversation = require(AppChat.Models.Conversation)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatOpenChatIxpEnabled = require(AppChat.Flags.FFlagAppChatOpenChatIxpEnabled)
local FStringAppChatOpenChatIxpLayer = require(AppChat.Flags.FStringAppChatOpenChatIxpLayer)
local v18 = Roact.PureComponent:extend("ChatDetailsScreen")

v18.defaultProps = {
	navigation = nil
}

local function navigationOptions() -- line: 26
	-- upvalues: GetFFlagIsSquadEnabled (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	return {
		headerText = {
			shouldLocalize = true,
			raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.ChatDetails" or "Feature.Chat.Label.Details"
		},
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsTopBarActionButton("back")
	}
end

v18.navigationOptions = navigationOptions

function v18.init(p1) -- line: 39
	-- upvalues: FFlagAppChatOpenChatIxpEnabled (copy), RoactNavigation (copy), IXPService (copy), FStringAppChatOpenChatIxpLayer (copy), Logger (copy), EnumScreens (copy)
	p1.ixpSubscription = if not FFlagAppChatOpenChatIxpEnabled then nil else p1.props.navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 44
		-- upvalues: p1 (copy), IXPService (copy), FStringAppChatOpenChatIxpLayer (copy)
		if p1.props.isGroupConversation then
			IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatOpenChatIxpLayer)
		end
	end)

	function p1.navigateToEditChatMembers(p2) -- line: 51
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To EditChatMembers from {screen}")
		p1.props.navigation.navigate(EnumScreens.EditChatMembers, {
			conversation = p2
		})
	end
	function p1.navigateToToast(p3) -- line: 56
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p1.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end
	function p1.navigateToDialog(p4, p5) -- line: 61
		-- upvalues: Logger (copy), p1 (copy)
		Logger:info("Navigate To {} from {screen}", p4)
		p1.props.navigation.navigate(p4, p5)
	end
	function p1.navigateBack() -- line: 66
		-- upvalues: p1 (copy)
		if p1.props.navigation.isFocused() then
			p1.props.navigation.goBack()
		end
	end
	function p1.navigateToConversation(p6) -- line: 72
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation from {screen}")
		p1.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p6
		})
	end
	function p1.navigateToChatLanding() -- line: 77
		-- upvalues: Logger (copy), p1 (copy), EnumScreens (copy)
		Logger:info("Navigate To ChatLanding from {screen}")

		if p1.props.navigation.getScreenProps("wideMode", false) then
			p1.props.navigation.navigate(EnumScreens.EmptyConversation)

			return
		end

		p1.props.navigation.navigate(EnumScreens.ChatLanding)
	end
end
function v18.render(p7) -- line: 88
	-- upvalues: Logger (copy), Roact (copy), ChatDetailsContainer (copy)
	local navigation = p7.props.navigation

	assert(type(navigation) ~= "nil", "ChatDetailsScreen should be wrapped with Roact Navigation")

	local v23 = navigation.getParam("conversationId", nil)

	if v23 == nil then
		Logger:warning("ConversationId is required to open {screen}")

		return nil
	end

	return Roact.createElement(ChatDetailsContainer, {
		topBarHeight = navigation.getScreenProps("topBarHeight", 0),
		wideMode = navigation.getScreenProps("wideMode", false),
		conversationId = v23,
		navigateBack = p7.navigateBack,
		navigateToEditChatMembers = p7.navigateToEditChatMembers,
		navigateToDialog = p7.navigateToDialog,
		navigateToToast = p7.navigateToToast,
		navigateToConversation = p7.navigateToConversation,
		navigateToChatLanding = p7.navigateToChatLanding
	})
end
function v18.didMount(_) -- line: 111
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagIsSquadEnabled (copy), GetTopBarStore (copy), EnumScreens (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local v25 = if not GetFFlagIsSquadEnabled() then {
			raw = "Feature.Chat.Label.ChatDetails",
			shouldLocalize = true
		} else {
			raw = "Feature.Chat.Label.Details",
			shouldLocalize = true
		}

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatDetails, {
			backButtonEnabled = true,
			headerText = v25
		})
	end
end
function v18.willUnmount(p9) -- line: 132
	-- upvalues: FFlagAppChatOpenChatIxpEnabled (copy)
	if FFlagAppChatOpenChatIxpEnabled then
		p9.ixpSubscription.remove()
	end
end

if FFlagAppChatOpenChatIxpEnabled then
	v18 = RoactRodux.connect(function(p10, p11) -- line: 142
		-- upvalues: Conversation (copy)
		local v29 = p11.navigation.getParam("conversationId")
		local v30 = p10.ChatAppReducer.Conversations[v29]

		return {
			isGroupConversation = v30 ~= nil and v30.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		}
	end)(v18)
	v18.navigationOptions = navigationOptions
end

return v18

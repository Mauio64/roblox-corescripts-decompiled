local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local SocialCommon = require(parent.SocialCommon)

local GenericDialogType = require(script.Parent.Parent.Dialogs.GenericDialogType)
local Logger = require(script.Parent.Logger)
local ParticipantDialogContainerDeprecated = require(script.Parent.ParticipantDialogContainerDeprecated)
local connectAnalytics = require(AppChat.LegacyAnalytics.connectAnalytics)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local Actions = require(AppChat.Actions)
local EnteredChatFromEntryPoint = Actions.EnteredChatFromEntryPoint

local SharedFlags = require(parent.SharedFlags)
local FFlagDisableBlockAndReport = SharedFlags.FFlagDisableBlockAndReport

local extended = React.PureComponent:extend("ParticipantDialogScreenDeprecated")

extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onDismiss()
		self.props.navigation.goBack()
	end
	function self.openRemoveUserDialog(participantId, conversationId)
		Logger:info("User activated removeFromGroup | userId: {}, conversationId: {}", participantId, conversationId)
		self.props.navigation.replace(GenericDialogType.RemoveUserDialog, {
			conversationId = conversationId,
			participantId = participantId
		})
	end

	function self.openViewProfile(p)
		local v = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if not v then
			Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To UserProfile from {screen}")
		self.props.analytics:navigate(RoactChatAnalytics.NavigationEvents.ChatDetailsProfile)
		v(p, {})
	end

	function self.openChat(p)
		Logger:info("User activated openChat | userId: {}", p)
		self.props.dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.ChatDetailsParticipantDialog))
		self.props.navigation.goBack()
		self.props.dispatch(createConversation("one_to_one", { (tostring(p)) })):andThen(function(p2)
			self.props.navigation.navigate(EnumScreens.ChatConversation, { conversationId = p2.id })
		end):catch(function(p2)
			Logger:warning("Error creating 1:1 conversation for userId {}: {}", p, (tostring(p2)))
			local toastTitle = parseCreateConversationErrors(p2) == "participant_chat_disabled"
				and "Feature.Chat.Message.PartyUnavailableWithUser"
				or "Feature.Toast.NetworkingError.SomethingIsWrong"

			self.props.navigation.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = { toastTitle = toastTitle }
				}
			})
		end)
	end

	function self.openReportUser(participantId, conversationId)
		self.props.navigation.replace(EnumScreens.AppChatReportAbuse, {
			participantId = participantId,
			conversationId = conversationId
		})
	end

	function self.openBlockingModal(p, conversationId)
		local function fn()
			self.props.navigation.pop()
			self.props.navigation.navigate(EnumScreens.AppChatReportAbuse, {
				participantId = p,
				conversationId = conversationId
			})
		end

		self.props.navigation.replace(EnumScreens.BlockingModal, {
			navProps = {
				userId = p,
				openReportUser = fn,
				disableReportOption = FFlagDisableBlockAndReport
			}
		})
	end
end

function extended.render(props)
	local navigation = props.props.navigation
	assert(type(navigation) ~= "nil", "ParticipantDialogScreenDeprecated should be wrapped with navigation")

	local param = navigation.getParam("conversationId", nil)
	local param2 = navigation.getParam("participantId", nil)
	local param3 = navigation.getParam("showRemoveUserButton", false)
	local screenProps = navigation.getScreenProps("wideMode", false)

	if param ~= nil and param2 ~= nil then
		return React.createElement(ParticipantDialogContainerDeprecated, {
			conversationId = param,
			participantId = param2,
			showRemoveUserButton = param3,
			isWideMode = screenProps,
			onDismiss = props.onDismiss,
			openRemoveUserDialog = props.openRemoveUserDialog,
			openReportUser = props.openReportUser,
			openViewProfile = props.openViewProfile,
			openChat = props.openChat,
			openBlockingModal = props.openBlockingModal
		})
	end

	Logger:warning("ConversationId and participantId are required to open {screen}")
	return nil
end

function extended.didMount(_)
	Logger:info("{screen} mounted")
end

local v = connectAnalytics(function(analytics)
	return { analytics = analytics }
end)(extended)

return (RoactRodux.connect(nil, function(dispatch)
	return { dispatch = dispatch }
end)(v))

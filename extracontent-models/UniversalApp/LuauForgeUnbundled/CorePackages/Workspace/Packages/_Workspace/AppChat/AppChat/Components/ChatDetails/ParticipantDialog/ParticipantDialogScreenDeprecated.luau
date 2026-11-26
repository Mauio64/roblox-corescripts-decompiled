local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactRodux")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")

local GenericDialogType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Dialogs/GenericDialogType")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/Logger")
local ParticipantDialogContainerDeprecated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/ParticipantDialogContainerDeprecated")
local connectAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/connectAnalytics")
local RoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalytics")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local parseCreateConversationErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/parseCreateConversationErrors")
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local enteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions").EnteredChatFromEntryPoint

local fFlagDisableBlockAndReport = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagDisableBlockAndReport

local extended = React.PureComponent:extend("ParticipantDialogScreenDeprecated")

extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onDismiss()
		self.props.navigation.goBack()
	end
	function self.openRemoveUserDialog(p3, p4)
		Logger:info("User activated removeFromGroup | userId: {}, conversationId: {}", p3, p4)
		self.props.navigation.replace(GenericDialogType.RemoveUserDialog, {
			conversationId = p4,
			participantId = p3
		})
	end

	function self.openViewProfile(p3)
		local v5 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if not v5 then
			Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To UserProfile from {screen}")
		self.props.analytics:navigate(RoactChatAnalytics.NavigationEvents.ChatDetailsProfile)
		v5(p3, {})
	end

	function self.openChat(p3)
		Logger:info("User activated openChat | userId: {}", p3)
		self.props.dispatch(enteredChatFromEntryPoint(chatEntryPointNames.ChatDetailsParticipantDialog))
		self.props.navigation.goBack()
		self.props.dispatch(createConversation("one_to_one", { (tostring(p3)) })):andThen(function(p4)
			self.props.navigation.navigate(EnumScreens.ChatConversation, {
				conversationId = p4.id
			})
		end):catch(function(p4)
			Logger:warning("Error creating 1:1 conversation for userId {}: {}", p3, (tostring(p4)))
			local v5 = parseCreateConversationErrors(p4) == "participant_chat_disabled"
				and "Feature.Chat.Message.PartyUnavailableWithUser"
				or "Feature.Toast.NetworkingError.SomethingIsWrong"

			self.props.navigation.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = { toastTitle = v5 }
				}
			})
		end)
	end

	function self.openReportUser(p3, p4)
		self.props.navigation.replace(EnumScreens.AppChatReportAbuse, {
			participantId = p3,
			conversationId = p4
		})
	end

	function self.openBlockingModal(p3, p4)
		local function fn()
			self.props.navigation.pop()
			self.props.navigation.navigate(EnumScreens.AppChatReportAbuse, {
				participantId = p3,
				conversationId = p4
			})
		end

		self.props.navigation.replace(EnumScreens.BlockingModal, {
			navProps = {
				userId = p3,
				openReportUser = fn,
				disableReportOption = fFlagDisableBlockAndReport
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

function extended.didMount(p2)
	Logger:info("{screen} mounted")
end

local v5 = connectAnalytics(function(p2)
	return { analytics = p2 }
end)(extended)

return (RoactRodux.connect(nil, function(p2)
	return { dispatch = p2 }
end)(v5))

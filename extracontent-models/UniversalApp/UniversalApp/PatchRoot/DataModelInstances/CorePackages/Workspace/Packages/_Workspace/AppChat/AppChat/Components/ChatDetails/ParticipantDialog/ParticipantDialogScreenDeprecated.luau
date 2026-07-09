local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local React = require(AppChatParent.React)
local RoactRodux = require(AppChatParent.RoactRodux)
local SocialCommon = require(AppChatParent.SocialCommon)
local GenericDialogType = require(script.Parent.Parent.Dialogs.GenericDialogType)
local Logger = require(script.Parent.Logger)
local ParticipantDialogContainerDeprecated = require(script.Parent.ParticipantDialogContainerDeprecated)
local connectAnalytics = require(AppChat.LegacyAnalytics.connectAnalytics)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = require(AppChat.Actions).EnteredChatFromEntryPoint
local FFlagDisableBlockAndReport = require(AppChatParent.SharedFlags).FFlagDisableBlockAndReport
local FFlagEnableChatDetailsOpenChat = require(AppChat.Flags.FFlagEnableChatDetailsOpenChat)
local v18 = React.PureComponent:extend("ParticipantDialogScreenDeprecated")

v18.defaultProps = {
	navigation = nil
}

function v18.init(p1) -- line: 32
	-- upvalues: Logger (copy), GenericDialogType (copy), EnumScreens (copy), RoactChatAnalytics (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), createConversation (copy), parseCreateConversationErrors (copy), FFlagDisableBlockAndReport (copy)
	function p1.onDismiss() -- line: 33
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
	function p1.openRemoveUserDialog(p2, p3) -- line: 36
		-- upvalues: Logger (copy), p1 (copy), GenericDialogType (copy)
		Logger:info("User activated removeFromGroup | userId: {}, conversationId: {}", p2, p3)
		p1.props.navigation.replace(GenericDialogType.RemoveUserDialog, {
			conversationId = p3,
			participantId = p2
		})
	end
	function p1.openViewProfile(p4) -- line: 44
		-- upvalues: p1 (copy), EnumScreens (copy), Logger (copy), RoactChatAnalytics (copy)
		local v33 = p1.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v33 then
			Logger:info("Navigate To UserProfile from {screen}")
			p1.props.analytics:navigate(RoactChatAnalytics.NavigationEvents.ChatDetailsProfile)
			v33(p4, {})

			return
		end

		Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")
	end
	function p1.openChat(p5) -- line: 56
		-- upvalues: Logger (copy), p1 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), createConversation (copy), EnumScreens (copy), parseCreateConversationErrors (copy)
		Logger:info("User activated openChat | userId: {}", p5)
		p1.props.dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.ChatDetailsParticipantDialog))
		p1.props.navigation.goBack()
		p1.props.dispatch(createConversation("one_to_one", { (tostring(p5)) })):andThen(function(p6) -- line: 62
			-- upvalues: p1 (copy), EnumScreens (copy)
			p1.props.navigation.navigate(EnumScreens.ChatConversation, {
				conversationId = p6.id
			})
		end):catch(function(p7) -- line: 67
			-- upvalues: Logger (copy), p5 (copy), parseCreateConversationErrors (copy), p1 (copy), EnumScreens (copy)
			Logger:warning("Error creating 1:1 conversation for userId {}: {}", p5, (tostring(p7)))

			local v41 = parseCreateConversationErrors(p7) ~= "participant_chat_disabled" and "Feature.Toast.NetworkingError.SomethingIsWrong" or "Feature.Chat.Message.PartyUnavailableWithUser"

			p1.props.navigation.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = {
						toastTitle = v41
					}
				}
			})
		end)
	end
	function p1.openReportUser(p8, p9) -- line: 82
		-- upvalues: p1 (copy), EnumScreens (copy)
		p1.props.navigation.replace(EnumScreens.AppChatReportAbuse, {
			participantId = p8,
			conversationId = p9
		})
	end
	function p1.openBlockingModal(p10, p11) -- line: 89
		-- upvalues: p1 (copy), EnumScreens (copy), FFlagDisableBlockAndReport (copy)
		p1.props.navigation.replace(EnumScreens.BlockingModal, {
			navProps = {
				userId = p10,
				openReportUser = function() -- line: 90
					-- upvalues: p1 (copy), EnumScreens (copy), p10 (copy), p11 (copy)
					p1.props.navigation.pop()
					p1.props.navigation.navigate(EnumScreens.AppChatReportAbuse, {
						participantId = p10,
						conversationId = p11
					})
				end,
				disableReportOption = FFlagDisableBlockAndReport
			}
		})
	end
end
function v18.render(p12) -- line: 108
	-- upvalues: Logger (copy), React (copy), ParticipantDialogContainerDeprecated (copy), FFlagEnableChatDetailsOpenChat (copy)
	local navigation = p12.props.navigation

	assert(type(navigation) ~= "nil", "ParticipantDialogScreenDeprecated should be wrapped with navigation")

	local v23 = navigation.getParam("conversationId", nil)
	local v24 = navigation.getParam("participantId", nil)
	local v25 = navigation.getParam("showRemoveUserButton", false)
	local v26 = navigation.getScreenProps("wideMode", false)

	if v23 == nil or v24 == nil then
		Logger:warning("ConversationId and participantId are required to open {screen}")

		return nil
	end

	return React.createElement(ParticipantDialogContainerDeprecated, {
		conversationId = v23,
		participantId = v24,
		showRemoveUserButton = v25,
		isWideMode = v26,
		onDismiss = p12.onDismiss,
		openRemoveUserDialog = p12.openRemoveUserDialog,
		openReportUser = p12.openReportUser,
		openViewProfile = p12.openViewProfile,
		openChat = if not FFlagEnableChatDetailsOpenChat then nil else p12.openChat,
		openBlockingModal = p12.openBlockingModal
	})
end
function v18.didMount(_) -- line: 137
	-- upvalues: Logger (copy)
	Logger:info("{screen} mounted")
end

local v19 = connectAnalytics(function(p14) -- line: 141
	return {
		analytics = p14
	}
end)(v18)

return (RoactRodux.connect(nil, function(p15) -- line: 145
	return {
		dispatch = p15
	}
end)(v19))

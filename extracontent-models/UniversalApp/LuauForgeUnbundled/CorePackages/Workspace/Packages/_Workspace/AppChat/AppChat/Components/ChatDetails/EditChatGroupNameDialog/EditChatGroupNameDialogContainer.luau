require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useState = React.useState
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local responseStatus = AppChatNetworking.Constants.ResponseStatus

local responseIndicator = SocialLibraries.Components.ResponseIndicator

local EditChatGroupNameDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/EditChatGroupNameDialog/EditChatGroupNameDialog")
local InputDialogContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/InputDialog/InputDialogContainer")
local FFlagAppChatFoundationGroupNameDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFoundationGroupNameDialog")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")

local function logRenameError(p2)
	if FFlagAppChatFoundationGroupNameDialog then
		Logger:error(p2)
	else
		Logger.error(p2)
	end
end

local v5 = {
	Success = function()
		return { visible = false, isLoading = false, warningTextKey = nil }
	end,
	Moderated = function()
		return {
			visible = true,
			isLoading = false,
			warningTextKey = getFFlagIsSquadEnabled() and "Feature.Chat.Response.ChatNameFullyModerated.V2" or "Feature.Chat.Response.ChatNameFullyModerated"
		}
	end,
	Default = function(p2, p3)
		return {
			visible = true,
			isLoading = false,
			warningTextKey = {
				getFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToRenameConversation.V2" or "Feature.Chat.Message.FailedToRenameConversation",
				EXISTING_NAME = p2,
				NEW_NAME = p3
			}
		}
	end,
	Waiting = function()
		return { visible = true, isLoading = true }
	end
}

local v6 = {
	onModalClose = function() end,
	titleKey = getFFlagIsSquadEnabled() and "Feature.Chat.Label.GroupName" or "Feature.Chat.Label.ChatGroupName",
	cancelTitleKey = "Feature.Chat.Action.Cancel",
	confirmationTitleKey = "Feature.Chat.Action.Save",
	placeholderTextKey = getFFlagIsSquadEnabled() and "Feature.Chat.Description.NameGroup" or "Feature.Chat.Description.NameGroupChat"
}

function LUAUFORGE_MODULE_GLOBALS_hdB_EditChatGroupNameDialogContainer(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local state, setState = useState({ visible = true, isLoading = false })

	local v7 = useDispatch()
	local v8 = useCallback(function(p3, p4)
		return v7(AppChatNetworking.rodux.UpdateConversationTitle.API(p3, p4))
	end, { v7 })

	local v9 = useSelector(function(p3)
		local conversationId = joined.conversationId
		local conversation = p3.ChatAppReducer.Conversations[conversationId]

		return (not conversation or conversation.isDefaultTitle) and "" or conversation.title
	end)

	local v10 = useCallback(function(p3): boolean
		if joined.conversationId then
			setState({ visible = true, isLoading = true })
			v8(joined.conversationId, p3.InputBox):andThen(function(p4)
				if
					p4
					and p4.responseBody
					and p4.responseBody.conversations
					and p4.responseBody.conversations[1]
				then
					if p4.responseBody.conversations[1].status == responseStatus.SUCCESS then
						setState({
							visible = false,
							isLoading = false,
							warningTextKey = nil
						})
						joined.onModalClose()
					elseif
						p4.responseBody
						and p4.responseBody.conversations[1].status == responseStatus.MODERATED
					then
						if FFlagAppChatFoundationGroupNameDialog then
							Logger:error("Conversation rename was moderated.")
						else
							Logger.error("Conversation rename was moderated.")
						end

						setState({
							visible = true,
							isLoading = false,
							warningTextKey = getFFlagIsSquadEnabled() and "Feature.Chat.Response.ChatNameFullyModerated.V2" or "Feature.Chat.Response.ChatNameFullyModerated"
						})
					else
						if FFlagAppChatFoundationGroupNameDialog then
							Logger:error("Conversation rename request failed.")
						else
							Logger.error("Conversation rename request failed.")
						end

						setState((v5.Default(v9, p3.InputBox)))
					end
				else
					if FFlagAppChatFoundationGroupNameDialog then
						Logger:error("Conversation rename response is invalid.")
					else
						Logger.error("Conversation rename response is invalid.")
					end

					setState((v5.Default(v9, p3.InputBox)))
				end
			end):catch(function(p4)
				setState((v5.Default(v9, p3.InputBox)))
			end)
		end

		return true
	end, { joined.conversationId, v9 })

	local v11 = React.useMemo(function()
		local v12 = {}

		v12[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				joined.onModalClose()
				object:cancel()
			end)
		}

		return v12
	end, { joined.onModalClose })

	local v12 = useLocalization({
		titleText = joined.titleKey,
		placeholderText = joined.placeholderTextKey,
		cancelText = joined.cancelTitleKey,
		confirmText = joined.confirmationTitleKey,
		warningText = state.warningTextKey
	})

	if not FFlagAppChatFoundationGroupNameDialog then
		local element = React.createElement(React.Fragment, nil, {
			responseIndicator = state.isLoading and React.createElement(responseIndicator, {
				soakAreaColor3 = Color3.fromRGB(25, 25, 25),
				soakAreaTransparency = 0.8
			}),
			dialog = state.visible and React.createElement(
				EditChatGroupNameDialog,
				Cryo.Dictionary.join(joined, v12, {
					onActivated = v10,
					inputText = v9,
					conversationTitle = v9
				})
			)
		})

		return React.createElement(appFocusRoot, {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isIsolated = true,
			isAutoFocusRoot = true,
			isFocusable = true,
			customEventHandlers = v11
		}, element)
	end

	if state.visible then
		return React.createElement(InputDialogContainer, {
			titleText = v12.titleText,
			placeholderText = v12.placeholderText,
			cancelText = v12.cancelText,
			confirmText = v12.confirmText,
			warningText = v12.warningText,
			inputText = v9,
			maxCharacters = 150,
			maxUtf16Units = 300,
			isLoading = state.isLoading,
			onActivated = v10,
			onModalClose = joined.onModalClose
		})
	end

	return nil
end

return memo(LUAUFORGE_MODULE_GLOBALS_hdB_EditChatGroupNameDialogContainer)

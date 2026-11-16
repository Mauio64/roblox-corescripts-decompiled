local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SocialLibraries = require(AppChat.SocialLibraries)
local memo = React.memo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local useState = React.useState
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(parent.ReactFocusNavigation)

local AppChatNetworking = require(parent.AppChatNetworking)
local ResponseStatus = AppChatNetworking.Constants.ResponseStatus

local ResponseIndicator = SocialLibraries.Components.ResponseIndicator

local EditChatGroupNameDialog = require(script.Parent.EditChatGroupNameDialog)
local InputDialogContainer = require(AppChat.Components.Common.InputDialog.InputDialogContainer)
local FFlagAppChatFoundationGroupNameDialog = require(AppChat.Flags.FFlagAppChatFoundationGroupNameDialog)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local Logger = require(AppChat.Logger)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local function logRenameError(p: string) -- 3 equivalent calls inferred from this helper
	if FFlagAppChatFoundationGroupNameDialog then
		Logger:error(p)
	else
		Logger.error(p)
	end
end

local v = { Success = 0, Moderated = 0, Default = 0, Waiting = 0 }
local function Success() -- 1 equivalent call inferred from this helper
	return { visible = false, isLoading = false, warningTextKey = nil }
end

v.Success = Success

local function Moderated() -- 1 equivalent call inferred from this helper
	return {
		visible = true,
		isLoading = false,
		warningTextKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Response.ChatNameFullyModerated.V2" or "Feature.Chat.Response.ChatNameFullyModerated"
	}
end

v.Moderated = Moderated

function v.Default(p, p2)
	return {
		visible = true,
		isLoading = false,
		warningTextKey = {
			GetFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToRenameConversation.V2" or "Feature.Chat.Message.FailedToRenameConversation",
			EXISTING_NAME = p,
			NEW_NAME = p2
		}
	}
end

local function Waiting() -- 1 equivalent call inferred from this helper
	return { visible = true, isLoading = true }
end

v.Waiting = Waiting

local v2 = {
	onModalClose = function() end,
	titleKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Label.GroupName" or "Feature.Chat.Label.ChatGroupName",
	cancelTitleKey = "Feature.Chat.Action.Cancel",
	confirmationTitleKey = "Feature.Chat.Action.Save",
	placeholderTextKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Description.NameGroup" or "Feature.Chat.Description.NameGroupChat"
}

function EditChatGroupNameDialogContainer(p)
	local joined = Cryo.Dictionary.join(v2, p)
	local state, setState = useState({ visible = true, isLoading = false })

	local v3 = useDispatch()
	local v4 = useCallback(function(p2, p3)
		return v3(AppChatNetworking.rodux.UpdateConversationTitle.API(p2, p3))
	end, { v3 })

	local v5 = useSelector(function(p2)
		local conversationId = joined.conversationId
		local conversation = p2.ChatAppReducer.Conversations[conversationId]

		return (not conversation or conversation.isDefaultTitle) and "" or conversation.title
	end)

	local onActivated = useCallback(function(p2): boolean
		if joined.conversationId then
			setState(Waiting()) -- inferred equivalent call
			v4(joined.conversationId, p2.InputBox):andThen(function(p3)
				if p3 and p3.responseBody and p3.responseBody.conversations and p3.responseBody.conversations[1] then
					if p3.responseBody.conversations[1].status == ResponseStatus.SUCCESS then
						setState(Success()) -- inferred equivalent call
						joined.onModalClose()
					elseif p3.responseBody and p3.responseBody.conversations[1].status == ResponseStatus.MODERATED then
						logRenameError("Conversation rename was moderated.") -- inferred equivalent call
						setState(Moderated()) -- inferred equivalent call
					else
						logRenameError("Conversation rename request failed.") -- inferred equivalent call
						setState((v.Default(v5, p2.InputBox)))
					end
				else
					logRenameError("Conversation rename response is invalid.") -- inferred equivalent call
					setState((v.Default(v5, p2.InputBox)))
				end
			end):catch(function(_)
				setState((v.Default(v5, p2.InputBox)))
			end)
		end

		return true
	end, { joined.conversationId, v5 })

	local customEventHandlers = React.useMemo(function()
		local v6 = {}

		v6[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				joined.onModalClose()
				object:cancel()
			end)
		}

		return v6
	end, { joined.onModalClose })

	local v6 = useLocalization({
		titleText = joined.titleKey,
		placeholderText = joined.placeholderTextKey,
		cancelText = joined.cancelTitleKey,
		confirmText = joined.confirmationTitleKey,
		warningText = state.warningTextKey
	})

	if not FFlagAppChatFoundationGroupNameDialog then
		local element = React.createElement(React.Fragment, nil, {
			responseIndicator = state.isLoading and React.createElement(ResponseIndicator, {
				soakAreaColor3 = Color3.fromRGB(25, 25, 25),
				soakAreaTransparency = 0.8
			}),
			dialog = state.visible and React.createElement(
				EditChatGroupNameDialog,
				Cryo.Dictionary.join(joined, v6, {
					onActivated = onActivated,
					inputText = v5,
					conversationTitle = v5
				})
			)
		})

		return React.createElement(AppFocusRoot, {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			isIsolated = true,
			isAutoFocusRoot = true,
			isFocusable = true,
			customEventHandlers = customEventHandlers
		}, element)
	end

	if state.visible then
		return React.createElement(InputDialogContainer, {
			titleText = v6.titleText,
			placeholderText = v6.placeholderText,
			cancelText = v6.cancelText,
			confirmText = v6.confirmText,
			warningText = v6.warningText,
			inputText = v5,
			maxCharacters = 150,
			maxUtf16Units = 300,
			isLoading = state.isLoading,
			onActivated = onActivated,
			onModalClose = joined.onModalClose
		})
	end

	return nil
end

return memo(EditChatGroupNameDialogContainer)

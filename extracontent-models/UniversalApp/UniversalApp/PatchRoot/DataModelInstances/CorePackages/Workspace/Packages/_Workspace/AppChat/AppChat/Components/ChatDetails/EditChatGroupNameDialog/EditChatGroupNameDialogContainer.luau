local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local SocialLibraries = require(AppChat.SocialLibraries)
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useState = React.useState
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization

require(AppChatParent.ReactFocusNavigation)

local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ResponseStatus = AppChatNetworking.Constants.ResponseStatus
local ResponseIndicator = SocialLibraries.Components.ResponseIndicator
local EditChatGroupNameDialog = require(script.Parent.EditChatGroupNameDialog)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local Logger = require(AppChat.Logger)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(AppChatParent.InputHandlers)
local t1 = {
	Success = function() -- line: 42
		return {
			visible = false,
			isLoading = false,
			warningTextKey = nil
		}
	end,
	Moderated = function() -- line: 51
		-- upvalues: GetFFlagIsSquadEnabled (copy)
		return {
			visible = true,
			isLoading = false,
			warningTextKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Response.ChatNameFullyModerated" or "Feature.Chat.Response.ChatNameFullyModerated.V2"
		}
	end,
	Default = function(p1, p2) -- line: 60
		-- upvalues: GetFFlagIsSquadEnabled (copy)
		return {
			visible = true,
			isLoading = false,
			warningTextKey = {
				not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToRenameConversation" or "Feature.Chat.Message.FailedToRenameConversation.V2",
				EXISTING_NAME = p1,
				NEW_NAME = p2
			}
		}
	end,
	Waiting = function() -- line: 73
		return {
			visible = true,
			isLoading = true
		}
	end
}
local t2 = {
	cancelTitleKey = "Feature.Chat.Action.Cancel",
	confirmationTitleKey = "Feature.Chat.Action.Save",
	onModalClose = function() -- line: 92
	end,
	titleKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.ChatGroupName" or "Feature.Chat.Label.GroupName",
	placeholderTextKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Description.NameGroupChat" or "Feature.Chat.Description.NameGroup"
}

function EditChatGroupNameDialogContainer(t3: {[any]: any}) -- line: 103
	-- upvalues: Cryo (copy), t2 (copy), useState (copy), useDispatch (copy), useCallback (copy), AppChatNetworking (copy), useSelector (copy), t1 (copy), Logger (copy), ResponseStatus (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useLocalization (copy), ResponseIndicator (copy), EditChatGroupNameDialog (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v28 = Cryo.Dictionary.join(t2, t3)
	local v29, v30 = useState({
		visible = true,
		isLoading = false
	})
	local v31 = useDispatch()
	local v32 = useCallback(function(p3, p4) -- line: 111
		-- upvalues: v31 (copy), AppChatNetworking (copy)
		return v31(AppChatNetworking.rodux.UpdateConversationTitle.API(p3, p4))
	end, { v31 })
	local v33 = useSelector(function(p5) -- line: 115
		-- upvalues: v28 (copy)
		local conversationId = v28.conversationId
		local v42 = p5.ChatAppReducer.Conversations[conversationId]
		local s1 = ""

		if v42 and not v42.isDefaultTitle then
			s1 = v42.title
		end

		return s1
	end)
	local v34 = useCallback(function(p6) -- line: 130
		-- upvalues: v28 (copy), v30 (copy), t1 (copy), v32 (copy), Logger (copy), v33 (copy), ResponseStatus (copy)
		if v28.conversationId then
			v30(t1.Waiting())
			v32(v28.conversationId, p6.InputBox):andThen(function(p7) -- line: 134
				-- upvalues: Logger (copy), v30 (copy), t1 (copy), v33 (copy), p6 (copy), ResponseStatus (copy), v28 (copy)
				if not p7 or (not p7.responseBody or not p7.responseBody.conversations or not p7.responseBody.conversations[1]) then
					Logger.error("Conversation rename response is invalid.")
					v30(t1.Default(v33, p6.InputBox))

					return
				end

				if p7.responseBody.conversations[1].status == ResponseStatus.SUCCESS then
					v30(t1.Success())
					v28.onModalClose()

					return
				end

				if p7.responseBody and p7.responseBody.conversations[1].status == ResponseStatus.MODERATED then
					Logger.error("Conversation rename was moderated.")
					v30(t1.Moderated())

					return
				end

				Logger.error("Conversation rename request failed.")
				v30(t1.Default(v33, p6.InputBox))
			end):catch(function(_) -- line: 157
				-- upvalues: v30 (copy), t1 (copy), v33 (copy), p6 (copy)
				v30(t1.Default(v33, p6.InputBox))
			end)
		end

		return true
	end, {
		v28.conversationId,
		v33
	})
	local v35 = React.useMemo(function() -- line: 165
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v28 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p9) -- line: 169
					-- upvalues: v28 (copy)
					v28.onModalClose()
					p9:cancel()
				end)
			}
		}
	end, { v28.onModalClose })
	local v36 = useLocalization({
		titleText = v28.titleKey,
		placeholderText = v28.placeholderTextKey,
		cancelText = v28.cancelTitleKey,
		confirmText = v28.confirmationTitleKey,
		warningText = v29.warningTextKey
	})
	local v37 = React.createElement(React.Fragment, nil, {
		responseIndicator = v29.isLoading and React.createElement(ResponseIndicator, {
			soakAreaTransparency = 0.8,
			soakAreaColor3 = Color3.fromRGB(25, 25, 25)
		}),
		dialog = v29.visible and React.createElement(EditChatGroupNameDialog, Cryo.Dictionary.join(v28, v36, {
			onActivated = v34,
			inputText = v33,
			conversationTitle = v33
		}))
	})

	return React.createElement(AppFocusRoot, {
		isIsolated = true,
		isAutoFocusRoot = true,
		isFocusable = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		customEventHandlers = v35
	}, v37)
end

return memo(EditChatGroupNameDialogContainer)

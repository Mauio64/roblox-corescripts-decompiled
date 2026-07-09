local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)

require(AppChat.types)

local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useState = React.useState
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
local ResponseIndicator = SocialLibraries.Components.ResponseIndicator
local LeaveGroupDialog = require(script.Parent.LeaveGroupDialog)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local t1 = {
	titleKey = "Feature.Chat.Heading.LeaveGroup",
	cancelKey = "Feature.Chat.Action.Stay",
	confirmKey = "Feature.Chat.Action.Leave",
	failureTitleKey = "Feature.Chat.Heading.FailedToLeaveGroup",
	failureButtonKey = "Feature.Chat.Action.Confirm",
	onModalClose = function() -- line: 45
	end,
	onLeaveSuccess = function() -- line: 46
	end,
	bodyKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.LeaveGroup" or "Feature.Chat.Message.LeaveGroup.V2",
	failureBodyKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToLeaveGroup" or "Feature.Chat.Message.FailedToLeaveGroup.V2"
}

function LeaveGroupDialogContainer(t2: {[any]: any}) -- line: 63
	-- upvalues: Cryo (copy), t1 (copy), useState (copy), useTelemetry (copy), ChatDialogTelemetryLayer (copy), useEffectOnMount (copy), ChatDetailsTelemetryEvents (copy), useDispatch (copy), useCallback (copy), AppChatNetworking (copy), useSelector (copy), GetFFlagIsSquadEnabled (copy), useLocalization (copy), React (copy), LeaveGroupDialog (copy), ResponseIndicator (copy)
	local v22 = Cryo.Dictionary.join(t1, t2)
	local v23, v24 = useState(true)
	local v25, v26 = useState(false)
	local v27, v28 = useState(false)
	local v29 = useTelemetry(ChatDialogTelemetryLayer.Context)

	useEffectOnMount(function() -- line: 70
		-- upvalues: v29 (copy), ChatDetailsTelemetryEvents (copy)
		v29.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogRendered, {})
	end)

	local v30 = useDispatch()
	local v31 = useCallback(function(p1, p2) -- line: 75
		-- upvalues: v30 (copy), AppChatNetworking (copy)
		return v30(AppChatNetworking.rodux.RemoveUserFromConversation.API(p2, p1))
	end, { v30 })
	local v32 = useSelector(function(p3) -- line: 79
		-- upvalues: v22 (copy), GetFFlagIsSquadEnabled (copy)
		local v39 = p3.ChatAppReducer.Conversations[v22.conversationId] or {
			title = nil,
			hasGroupUp = nil
		}

		return {
			localUserId = p3.LocalUserId,
			conversationTitle = v39.title,
			hasGroupUp = if not GetFFlagIsSquadEnabled() then nil else v39.hasGroupUp
		}
	end)
	local v33 = useCallback(function() -- line: 93
		-- upvalues: v26 (copy), v24 (copy), v29 (copy), ChatDetailsTelemetryEvents (copy), v22 (copy), v31 (copy), v32 (copy), v28 (copy)
		v26(true)
		v24(false)
		v29.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogLeaveClicked, {})

		if v22.conversationId then
			v31(v32.localUserId, v22.conversationId):andThen(function() -- line: 100
				-- upvalues: v22 (copy)
				v22.onModalClose()
				v22.onLeaveSuccess()
			end):catch(function() -- line: 104
				-- upvalues: v26 (copy), v24 (copy), v28 (copy)
				v26(false)
				v24(true)
				v28(true)
			end)
		end

		return true
	end, {
		v32.localUserId,
		v32.hasGroupUp,
		v22.conversationId,
		v31,
		v29
	})
	local v34 = useCallback(function(...) -- line: 120
		-- upvalues: v29 (copy), ChatDetailsTelemetryEvents (copy), v22 (copy)
		v29.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogStayClicked, {})
		v22.onModalClose(...)
	end, {
		v22.onModalClose,
		v22.conversationId,
		v29
	})
	local v35 = useLocalization({
		titleText = v22.titleKey,
		cancelText = v22.cancelKey,
		confirmText = v22.confirmKey,
		bodyText = v22.bodyKey,
		failureTitleText = v22.failureTitleKey,
		failureBodyText = {
			v22.failureBodyKey,
			CONVERSATION_TITLE = v32.conversationTitle
		},
		failureButtonText = v22.failureButtonKey
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		LeaveGroupDialog = v23 and React.createElement(LeaveGroupDialog, Cryo.Dictionary.join(v22, v35, v32, {
			onActivated = v33,
			displayFailed = v27,
			onModalClose = v34
		})),
		ResponseIndicator = v25 and React.createElement(ResponseIndicator, {
			soakAreaTransparency = 0.8,
			soakAreaColor3 = Color3.fromRGB(25, 25, 25)
		})
	})
end

return memo(LeaveGroupDialogContainer)

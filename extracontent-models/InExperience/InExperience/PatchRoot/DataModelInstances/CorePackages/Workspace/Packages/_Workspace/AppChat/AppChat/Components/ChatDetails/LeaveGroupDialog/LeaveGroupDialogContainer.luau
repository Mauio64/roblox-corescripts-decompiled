local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLibraries = require(AppChat.SocialLibraries)
require(AppChat.types)

local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils2.Hooks.useEffectOnMount
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils3 = require(parent.RoactUtils)
local useSelector = RoactUtils3.Hooks.RoactRodux.useSelector
local useState = React.useState
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)

local ResponseIndicator = SocialLibraries.Components.ResponseIndicator

local LeaveGroupDialog = require(script.Parent.LeaveGroupDialog)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local v = {
	isRooted = false,
	onModalClose = function() end,
	onLeaveSuccess = function() end,
	titleKey = "Feature.Chat.Heading.LeaveGroup",
	cancelKey = "Feature.Chat.Action.Stay",
	confirmKey = "Feature.Chat.Action.Leave",
	bodyKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.LeaveGroup.V2" or "Feature.Chat.Message.LeaveGroup",
	failureTitleKey = "Feature.Chat.Heading.FailedToLeaveGroup",
	failureBodyKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToLeaveGroup.V2" or "Feature.Chat.Message.FailedToLeaveGroup",
	failureButtonKey = "Feature.Chat.Action.Confirm"
}

function LeaveGroupDialogContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local state, setState = useState(true)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState(false)
	local v2 = useTelemetry(ChatDialogTelemetryLayer.Context)

	useEffectOnMount(function()
		v2.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogRendered, {})
	end)

	local v3 = useDispatch()
	local v4 = useCallback(function(p2, p3)
		return v3(AppChatNetworking.rodux.RemoveUserFromConversation.API(p3, p2))
	end, { v3 })

	local v5 = useSelector(function(p2)
		local v5 = p2.ChatAppReducer.Conversations[joined.conversationId] or {
			title = nil,
			hasGroupUp = nil
		}

		local v6 = { localUserId = p2.LocalUserId, conversationTitle = v5.title, hasGroupUp = 0 }
		local hasGroupUp

		if GetFFlagIsSquadEnabled() then
			hasGroupUp = v5.hasGroupUp
		end

		v6.hasGroupUp = hasGroupUp
		return v6
	end)

	local onActivated = useCallback(function(): boolean
		setState2(true)
		setState(false)
		v2.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogLeaveClicked, {})

		if joined.conversationId then
			v4(v5.localUserId, joined.conversationId):andThen(function()
				if joined.isRooted then
					v3(RemovedConversation(joined.conversationId))
				end

				joined.onModalClose()
				joined.onLeaveSuccess()
			end):catch(function()
				setState2(false)
				setState(true)
				setState3(true)
			end)
		end

		return true
	end, {
		v5.localUserId,
		v5.hasGroupUp,
		joined.conversationId,
		joined.isRooted,
		joined.onModalClose,
		joined.onLeaveSuccess,
		v3,
		v4,
		v2
	})

	local onModalClose = useCallback(function(...)
		v2.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogStayClicked, {})
		joined.onModalClose(...)
	end, { joined.onModalClose, joined.conversationId, v2 })

	local v6 = useLocalization({
		titleText = joined.titleKey,
		cancelText = joined.cancelKey,
		confirmText = joined.confirmKey,
		bodyText = joined.bodyKey,
		failureTitleText = joined.failureTitleKey,
		failureBodyText = {
			joined.failureBodyKey,
			CONVERSATION_TITLE = v5.conversationTitle
		},
		failureButtonText = joined.failureButtonKey
	})

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		LeaveGroupDialog = state and React.createElement(
			LeaveGroupDialog,
			Cryo.Dictionary.join(joined, v6, v5, {
				onActivated = onActivated,
				displayFailed = state3,
				onModalClose = onModalClose
			})
		),
		ResponseIndicator = state2 and React.createElement(ResponseIndicator, {
			soakAreaColor3 = Color3.fromRGB(25, 25, 25),
			soakAreaTransparency = 0.8
		})
	})
end

return memo(LeaveGroupDialogContainer)

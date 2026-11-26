local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useState = React.useState
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDetailsTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsTelemetryEvents")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")

local responseIndicator = SocialLibraries.Components.ResponseIndicator

local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/LeaveGroupDialog/LeaveGroupDialog")
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled

local v5 = {
	isRooted = false,
	onModalClose = function() end,
	onLeaveSuccess = function() end,
	titleKey = "Feature.Chat.Heading.LeaveGroup",
	cancelKey = "Feature.Chat.Action.Stay",
	confirmKey = "Feature.Chat.Action.Leave",
	bodyKey = getFFlagIsSquadEnabled() and "Feature.Chat.Message.LeaveGroup.V2" or "Feature.Chat.Message.LeaveGroup",
	failureTitleKey = "Feature.Chat.Heading.FailedToLeaveGroup",
	failureBodyKey = getFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToLeaveGroup.V2" or "Feature.Chat.Message.FailedToLeaveGroup",
	failureButtonKey = "Feature.Chat.Action.Confirm"
}

function LUAUFORGE_MODULE_GLOBALS_hoy_LeaveGroupDialogContainer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local state, setState = useState(true)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState(false)
	local v6 = useTelemetry(ChatLandingTelemetryLayer.Context)

	useEffectOnMount(function()
		v6.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogRendered, {})
	end)

	local v7 = useDispatch()
	local v8 = useCallback(function(p3, p4)
		return v7(AppChatNetworking.rodux.RemoveUserFromConversation.API(p4, p3))
	end, { v7 })

	local v9 = useSelector(function(p3)
		local v10 = p3.ChatAppReducer.Conversations[joined.conversationId]
			or { title = nil, hasGroupUp = nil }

		local v11 = {
			localUserId = p3.LocalUserId,
			conversationTitle = v10.title,
			hasGroupUp = 0
		}
		local v12 = if getFFlagIsSquadEnabled() then v10.hasGroupUp else nil
		v11.hasGroupUp = v12
		return v11
	end)

	local v10 = useCallback(function(): boolean
		setState2(true)
		setState(false)
		v6.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogLeaveClicked, {})

		if joined.conversationId then
			v8(v9.localUserId, joined.conversationId):andThen(function()
				if joined.isRooted then
					v7(RemovedConversation(joined.conversationId))
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
		v9.localUserId,
		v9.hasGroupUp,
		joined.conversationId,
		joined.isRooted,
		joined.onModalClose,
		joined.onLeaveSuccess,
		v7,
		v8,
		v6
	})

	local v11 = useCallback(function(...)
		v6.emit(ChatDetailsTelemetryEvents.LeaveGroupDialogStayClicked, {})
		joined.onModalClose(...)
	end, { joined.onModalClose, joined.conversationId, v6 })

	local v12 = useLocalization({
		titleText = joined.titleKey,
		cancelText = joined.cancelKey,
		confirmText = joined.confirmKey,
		bodyText = joined.bodyKey,
		failureTitleText = joined.failureTitleKey,
		failureBodyText = {
			joined.failureBodyKey,
			CONVERSATION_TITLE = v9.conversationTitle
		},
		failureButtonText = joined.failureButtonKey
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		LeaveGroupDialog = state and React.createElement(
			module8,
			Cryo.Dictionary.join(joined, v12, v9, {
				onActivated = v10,
				displayFailed = state3,
				onModalClose = v11
			})
		),
		ResponseIndicator = state2 and React.createElement(responseIndicator, {
			soakAreaColor3 = Color3.fromRGB(25, 25, 25),
			soakAreaTransparency = 0.8
		})
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hoy_LeaveGroupDialogContainer)

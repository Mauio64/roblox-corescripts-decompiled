local parent = script.Parent.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local TextChannelWindowPerfTracker = ChatUIPrimitives.Telemetry.TextChannelWindowPerfTracker
local ChatApp = require(script.Parent.ChatApp)
require(script.Parent.Message)
local mountToTargetInstance = require(script.Parent.mountToTargetInstance)
local useTextChannelWindowProps = require(script.Parent.useTextChannelWindowProps)
local useLocalUserInTextChannel = require(script.Parent.useLocalUserInTextChannel)
local useAvailabilitySystemMessage = require(script.Parent.useAvailabilitySystemMessage)
local ChatAvailabilityContext = require(script.Parent.ChatAvailabilityContext)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local createChannelMessagesStore = require(script.Parent.createChannelMessagesStore)
local TextChatServiceBridge = require(script.Parent.TextChatServiceBridge)
local useWelcomeSystemMessage = require(script.Parent.useWelcomeSystemMessage)
local useSummarySystemMessage = require(script.Parent.useSummarySystemMessage)
local thirdPartySummaryEligibility = require(script.Parent.thirdPartySummaryEligibility)

local TextChatService = game:GetService("TextChatService")
local useLocalUserChatAvailability = ChatAvailabilityContext.useLocalUserChatAvailability

local signal = Signals.createSignal({})

local function getWindowName(p) -- 2 equivalent calls inferred from this helper
	return p.Name
end

local function getTargetName(props) -- 2 equivalent calls inferred from this helper
	local target = props.Target

	if target and target:IsA("TextChannel") then
		return target.Name
	end

	return nil
end

local function TextChannelWindowRoot(props)
	local v = useTextChannelWindowProps(props.textChannelWindow)
	local target = v.target
	local v2 = useLocalUserInTextChannel(target, props.localUserId)

	local channelState = target == nil and "no-channel" or v2 and "member" or "not-member"
	local targetChannel

	if channelState == "member" then
		targetChannel = target
	else
		targetChannel = nil
	end

	local v3 = useLocalUserChatAvailability()

	local messagesSignal = React.useMemo(function()
		if targetChannel then
			return props.getChannelMessages(targetChannel)
		end

		return signal
	end, { targetChannel, props.getChannelMessages, signal })

	useAvailabilitySystemMessage(v3, target)
	useWelcomeSystemMessage(targetChannel, props.localUserId)
	useSummarySystemMessage(targetChannel, props.getIsEligibleForSummary)

	local windowName = getWindowName(props.textChannelWindow) -- inferred equivalent call

	local ref = React.useRef(false)
	local loadStartTime = props.loadStartTime
	React.useEffect(function()
		if not ref.current then
			ref.current = true
			TextChannelWindowPerfTracker.finishMountTTI(windowName)

			if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() and loadStartTime then
				TextChatService:SendExpChatLoadSuccess(
					os.clock() - loadStartTime,
					nil,
					"text_channel_window",
					windowName
				)
			end
		end
	end, { windowName, loadStartTime })

	local ref2 = React.useRef({})
	React.useEffect(function()
		if
			TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled()
			and TextChannelWindowAnalytics.getFFlagExpChatUseUpdatedMessageRendered()
		then
			return (Signals.createEffect(function(p)
				local v4 = messagesSignal(p)

				for _, v5 in v4 do
					local messageId = v5.messageId

					if not messageId or ref2.current[messageId] then
						continue
					end

					ref2.current[messageId] = true

					if not TextChannelWindowAnalytics.shouldSendMessageRenderedTelemetry() then
						continue
					end

					local textChatMessageInstance = v5.textChatMessageInstance

					if not textChatMessageInstance then
						continue
					end

					if game:GetEngineFeature("ExpChatGlobalChatEngineTelemetryEnabled") then
						TextChatService:SendExpChatMessageClientRendered(
							textChatMessageInstance,
							"text_channel_window",
							-1,
							windowName
						)
					else
						TextChatService:SendExpChatMessageClientRendered(textChatMessageInstance, "text_channel_window")
					end
				end
			end))
		end
	end, { messagesSignal, windowName })

	return React.createElement(ChatApp, {
		messagesSignal = messagesSignal,
		localUserId = props.localUserId,
		targetChannel = targetChannel,
		channelState = channelState,
		canLocalUserChat = v3.canChat,
		backgroundColor = v.backgroundColor,
		fontFace = v.fontOverride,
		windowName = windowName,
		windowInstance = props.textChannelWindow
	})
end

local extended = React.Component:extend("TextChannelWindowErrorBoundary")

function extended:init()
	self.state = { hasError = false }
end

function extended.getDerivedStateFromError(_)
	return { hasError = true }
end

function extended.componentDidCatch(_, _, _) end

function extended.render(p)
	return if not p.state.hasError then p.props.children else nil
end

local function onScriptError(_: string, _: string?, _) end

local v = {}

local v2 = {}
local v3 = false

return {
	start = function()
		local Players = game:GetService("Players")
		local localPlayer = Players.LocalPlayer

		if not localPlayer then
			return
		end

		local userId = tostring(localPlayer.UserId)

		local channelMessagesStore = createChannelMessagesStore()
		local v4 = thirdPartySummaryEligibility.create(userId)

		local function flushWindowStatus(p)
			if not TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
				return
			end

			local v5 = v2[p]

			if v5 then
				local v6 = os.clock() - v5.lastChangeTime
				local v7 = v5.openDuration + (not v5.isOpen and 0 or v6)
				TextChatService:SendExpChatWindowStatusChange(
					v5.closedDuration + (v5.isOpen and 0 or v6),
					v7,
					0,
					0,
					"text_channel_window",
					p.Name
				)

				v2[p] = nil
			end
		end

		local function onRemoved(props) -- 1 equivalent call inferred from this helper
			local v5 = v[props]

			if v5 then
				local target = props.Target
				local name

				if target and target:IsA("TextChannel") then
					name = target.Name
				end

				if name then
					TextChannelWindowPerfTracker.cancelForChannel(name)
				end

				flushWindowStatus(props)
				v5()
				v[props] = nil
			end
		end

		local function onAdded(props)
			local function upsertMessage(p)
				local target = props.Target

				if target and target:IsA("TextChannel") then
					channelMessagesStore.upsertMessage(target, p)
				end
			end

			local function removeMessage(p: string)
				local target = props.Target

				if target and target:IsA("TextChannel") then
					channelMessagesStore.removeMessage(target, p)
				end
			end

			local loadStartTime

			if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
				loadStartTime = os.clock()
			end

			local element = React.createElement(extended, nil, {
				inner = React.createElement(
					MessageWriterContext.Provider,
					{ upsertMessage = upsertMessage, removeMessage = removeMessage },
					{
						availability = React.createElement(
							ChatAvailabilityContext.Provider,
							{ subjectPlayer = localPlayer },
							{
								root = React.createElement(TextChannelWindowRoot, {
									localUserId = userId,
									textChannelWindow = props,
									getChannelMessages = channelMessagesStore.getMessagesForChannel,
									getIsEligibleForSummary = v4.getIsEligible,
									loadStartTime = loadStartTime
								})
							}
						)
					}
				)
			})

			TextChannelWindowPerfTracker.startMountTTI(getWindowName(props)) -- inferred equivalent call

			local v5 = mountToTargetInstance(props, element)

			if v5 then
				v[props] = v5
				local targetName = getTargetName(props) -- inferred equivalent call
				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Mount, {
					result = "success",
					has_target = targetName ~= nil,
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(targetName)
				})
			else
				local targetName = getTargetName(props) -- inferred equivalent call
				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Mount, {
					result = "failed",
					has_target = targetName ~= nil,
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(targetName)
				})
			end

			if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
				v2[props] = {
					isOpen = props.IsRendering == true,
					lastChangeTime = os.clock(),
					openDuration = 0,
					closedDuration = 0
				}

				props:GetPropertyChangedSignal("IsRendering"):Connect(function()
					local v6 = v2[props]

					if v6 then
						local now = os.clock()
						local v7 = now - v6.lastChangeTime
						v2[props] = {
							isOpen = props.IsRendering == true,
							lastChangeTime = now,
							openDuration = v6.openDuration + (not v6.isOpen and 0 or v7),
							closedDuration = v6.closedDuration + (v6.isOpen and 0 or v7)
						}
					end
				end)
			end

			props.AncestryChanged:Connect(function()
				if not props:IsDescendantOf(game) then
					onRemoved(props) -- inferred equivalent call
				end
			end)
		end

		if not v3 then
			v3 = true
			local ScriptContext = game:GetService("ScriptContext")
			ScriptContext.Error:Connect(onScriptError)
		end

		local TextChatService2 = game:GetService("TextChatService")
		TextChatServiceBridge(TextChatService2, userId, channelMessagesStore)

		for _, v5 in TextChatService2:GetTextChannelWindows() do
			onAdded(v5)
		end

		TextChatService2.TextChannelWindowAdded:Connect(onAdded)
		TextChatService2.TextChannelWindowRemoved:Connect(onRemoved)

		if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
			Players.PlayerRemoving:Connect(function(player)
				if player == localPlayer then
					for k in v2 do
						flushWindowStatus(k)
					end
				end
			end)
		end
	end,
	_onScriptError = onScriptError,
	_TextChannelWindowErrorBoundary = extended
}
